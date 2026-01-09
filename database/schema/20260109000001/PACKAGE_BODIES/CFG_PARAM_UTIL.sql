--------------------------------------------------------
--  DDL for Package Body CFG_PARAM_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CFG_PARAM_UTIL" AS
  ------------------------------------------------------------------------------
  --  Package: CFG_PARAM_UTIL
  --  Author : Alaaeldin Abdelmonem
  --  Version: 2.0  (Developer-Commented Edition)
  --
  --  PURPOSE
  --  =======
  --  Provides a complete API for managing configuration parameters in a
  --  multi-tenant SaaS environment using Oracle Database.
  --
  --  Supports:
  --    • Reading parameter values by resolving overrides in priority order:
  --        SESSION → USER → ROLE → DEFAULT (App/Tenant)
  --    • Writing or updating parameters and overrides
  --    • Audit trail recording
  --    • In-session caching for performance
  --    • Type-safe wrappers (Number, Boolean, Date, JSON)
  --    • Bulk retrieval for APEX or admin reports
  --
  --  DEPENDENCIES
  --  ============
  --    • CFG_PARAMETERS
  --    • CFG_PARAM_OVERRIDES
  --    • CFG_PARAM_AUDIT
  --
  --  NOTE
  --  ====
  --  This package is schema-agnostic. If used from another schema (e.g. APEX),
  --  ensure synonyms or grants exist for the three core tables.
  ------------------------------------------------------------------------------

  ------------------------------------------------------------------------------
  -- Internal cache: associative array keyed by (tenant|app|param|user)
  -- Used to avoid repetitive lookups for the same parameter during one session.
  -- Cache resets when package state is cleared or CLEAR_CACHE is called.
  ------------------------------------------------------------------------------
  TYPE t_cache IS TABLE OF VARCHAR2(4000) INDEX BY VARCHAR2(2000);
  g_cache t_cache;

 
  ------------------------------------------------------------------------------
  -- GET_VALUE : Core retrieval function
  -- Resolves a parameter value using the configured hierarchy:
  --   1. SESSION override
  --   2. USER override
  --   3. ROLE override(s)
  --   4. Default APP / TENANT value
  --
  -- Caching : results are stored in associative array "g_cache" for reuse.
  -- Security: values flagged as IS_SECRET='Y' return masked '****'.
  ------------------------------------------------------------------------------
  FUNCTION get_value(
      p_param_key IN VARCHAR2,
      p_tenant_id  IN VARCHAR2,
      p_app_id     IN NUMBER,
      p_user_name  IN VARCHAR2 DEFAULT USER,
      p_roles      IN SYS.ODCIVARCHAR2LIST DEFAULT NULL,
      p_session_id IN VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','SESSIONID')
  ) RETURN VARCHAR2
  IS  
      vcaller constant varchar2(70):= c_package_name ||'.get_value'; 
      v_value    VARCHAR2(4000);   -- final value to return
      v_param_id NUMBER;           -- id of the parameter in CFG_PARAMETERS
      v_key      VARCHAR2(2000);   -- composite cache key
  BEGIN
      --------------------------------------------------------------------------
      -- Step 1 : Compute cache key and return cached value if available
      --------------------------------------------------------------------------
      v_key := p_tenant_id||'|'||p_app_id||'|'||p_param_key||'|'||NVL(p_user_name,'?');
      IF g_cache.EXISTS(v_key) THEN
        RETURN g_cache(v_key);
      END IF;

      --------------------------------------------------------------------------
      -- Step 2 : Identify parameter record in CFG_PARAMETERS
      --------------------------------------------------------------------------
      SELECT param_id
        INTO v_param_id
        FROM cfg_parameters
       WHERE param_key = p_param_key
         AND tenant_id  = p_tenant_id
         AND app_id     = p_app_id
         AND is_active  = 'Y'
       FETCH FIRST 1 ROWS ONLY;

      --------------------------------------------------------------------------
      -- Step 3 : Resolve overrides in descending priority
      --------------------------------------------------------------------------
      -- 3.1 SESSION override
      BEGIN
        SELECT override_value
          INTO v_value
          FROM cfg_param_overrides
         WHERE param_id    = v_param_id
           AND scope_type  = 'SESSION'
           AND scope_value = p_session_id
           AND is_active   = 'Y'
           AND (expiry_date IS NULL OR expiry_date > SYSDATE)
         FETCH FIRST 1 ROWS ONLY;

        g_cache(v_key) := v_value;
        RETURN v_value;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

      -- 3.2 USER override
      BEGIN
        SELECT override_value
          INTO v_value
          FROM cfg_param_overrides
         WHERE param_id    = v_param_id
           AND scope_type  = 'USER'
           AND scope_value = p_user_name
           AND is_active   = 'Y'
           AND (expiry_date IS NULL OR expiry_date > SYSDATE)
         FETCH FIRST 1 ROWS ONLY;

        g_cache(v_key) := v_value;
        RETURN v_value;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

      -- 3.3 ROLE override(s)
      IF p_roles IS NOT NULL THEN
        FOR i IN 1 .. p_roles.COUNT LOOP
          BEGIN
            SELECT override_value
              INTO v_value
              FROM cfg_param_overrides
             WHERE param_id    = v_param_id
               AND scope_type  = 'ROLE'
               AND scope_value = p_roles(i)
               AND is_active   = 'Y'
               AND (expiry_date IS NULL OR expiry_date > SYSDATE)
             FETCH FIRST 1 ROWS ONLY;

            g_cache(v_key) := v_value;
            RETURN v_value;
          EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
        END LOOP;
      END IF;

      --------------------------------------------------------------------------
      -- Step 4 : Default parameter value (no override found)
      --------------------------------------------------------------------------
      SELECT CASE WHEN is_secret='Y' THEN '****' ELSE param_value END
        INTO v_value
        FROM cfg_parameters
       WHERE param_id = v_param_id;

      g_cache(v_key) := v_value;
      RETURN v_value;

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Parameter not found or inactive
      RETURN NULL;
    WHEN OTHERS THEN
      -- Generic fail-safe
      RETURN NULL;
  END get_value;

  ------------------------------------------------------------------------------
  -- TYPE-SAFE WRAPPERS : Convert the VARCHAR2 base value to typed outputs
  ------------------------------------------------------------------------------

  -- Returns numeric configuration values; NULL if not convertible.
  FUNCTION get_number(p_param_key IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER)
    RETURN NUMBER
  IS
   vcaller constant varchar2(70):= c_package_name ||'.get_number'; 
  BEGIN
    RETURN TO_NUMBER(get_value(p_param_key, p_tenant_id, p_app_id));
  EXCEPTION WHEN VALUE_ERROR THEN
    RETURN NULL;
  END get_number;

  -- Returns BOOLEAN configuration; truthy if 1/Y/TRUE/T/ON.
  FUNCTION get_boolean(p_param_key IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER)
    RETURN BOOLEAN
  IS  vcaller constant varchar2(70):= c_package_name ||'.get_boolean'; 
      v VARCHAR2(10);
  BEGIN
    v := UPPER(get_value(p_param_key, p_tenant_id, p_app_id));
    RETURN (v IN ('1','Y','TRUE','T','ON'));
  END get_boolean;

  -- Returns DATE configuration; expects ISO-like 'YYYY-MM-DD HH24:MI:SS'.
  FUNCTION get_date(p_param_key IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER)
    RETURN DATE
  IS  vcaller constant varchar2(70):= c_package_name ||'.get_date'; 
      v VARCHAR2(100);
  BEGIN
    v := get_value(p_param_key, p_tenant_id, p_app_id);
    RETURN TO_DATE(v,'YYYY-MM-DD HH24:MI:SS');
  EXCEPTION WHEN OTHERS THEN
    RETURN NULL;
  END get_date;

  -- Parses JSON-formatted parameter values into JSON_OBJECT_T.
  FUNCTION get_json(p_param_key IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER)
    RETURN JSON_OBJECT_T
  IS   vcaller constant varchar2(70):= c_package_name ||'.p_param_key'; 
      v VARCHAR2(4000);
  BEGIN
    v := get_value(p_param_key, p_tenant_id, p_app_id);
    RETURN JSON_OBJECT_T.PARSE(v);
  EXCEPTION WHEN OTHERS THEN
    RETURN JSON_OBJECT_T();
  END get_json;

  ------------------------------------------------------------------------------
  -- GET_ALL : Returns a result set of all parameters for a tenant/app.
  -- Useful for APEX interactive reports or admin dashboards.
  ------------------------------------------------------------------------------
  FUNCTION get_all(p_tenant_id IN VARCHAR2, p_app_id IN NUMBER)
    RETURN SYS_REFCURSOR
  IS   vcaller constant varchar2(70):= c_package_name ||'.get_all'; 
      rc SYS_REFCURSOR;
  BEGIN
    OPEN rc FOR
      SELECT param_key,
             CASE WHEN is_secret='Y' THEN '****' ELSE param_value END AS param_value,
             category_code,
             value_type,
             description,
             last_updated_by,
             last_updated
        FROM cfg_parameters
       WHERE tenant_id = p_tenant_id
         AND app_id    = p_app_id
         AND is_active = 'Y';
    RETURN rc;
  END get_all;

  ------------------------------------------------------------------------------
  -- SET_VALUE : Inserts or updates a parameter (and audit trail).
  -- Behavior :
  --   • If parameter doesn’t exist → inserts new CFG_PARAMETERS row.
  --   • If p_scope_type='APP'      → updates base parameter.
  --   • Else (USER / ROLE / SESSION) → inserts/updates CFG_PARAM_OVERRIDES.
  ------------------------------------------------------------------------------
  PROCEDURE set_value(
      p_param_key  IN VARCHAR2,
      p_tenant_id   IN VARCHAR2,
      p_app_id      IN NUMBER,
      p_value       IN VARCHAR2,
      p_scope_type  IN VARCHAR2 DEFAULT 'APP',
      p_scope_value IN VARCHAR2 DEFAULT NULL,
      p_user        IN VARCHAR2 DEFAULT USER,
      p_is_secret   IN CHAR DEFAULT 'N'
  ) IS  vcaller constant varchar2(70):= c_package_name ||'.set_value'; 
      v_param_id NUMBER;          -- parameter id (created or existing)
      v_old      VARCHAR2(4000);  -- old value for audit
  BEGIN
      --------------------------------------------------------------------------
      -- Step 1 : Locate parameter or create if new
      --------------------------------------------------------------------------
      BEGIN
        SELECT param_id INTO v_param_id
          FROM cfg_parameters
         WHERE param_key = p_param_key
           AND tenant_id  = p_tenant_id
           AND app_id     = p_app_id;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          INSERT INTO cfg_parameters(
              param_key, tenant_id, app_id, param_value,
              is_secret, is_active, last_updated_by, last_updated
          ) VALUES (
              p_param_key, p_tenant_id, p_app_id, p_value,
              p_is_secret, 'Y', p_user, SYSDATE
          )
          RETURNING param_id INTO v_param_id;

         --- log_audit 
          RETURN;
      END;

      --------------------------------------------------------------------------
      -- Step 2 : Apply update according to scope type
      --------------------------------------------------------------------------
      IF p_scope_type <> 'APP' THEN
        -- Handle USER/ROLE/SESSION overrides separately
        BEGIN
          SELECT override_value
            INTO v_old
            FROM cfg_param_overrides
           WHERE param_id    = v_param_id
             AND scope_type  = p_scope_type
             AND scope_value = p_scope_value
             AND is_active   = 'Y'
           FETCH FIRST 1 ROWS ONLY;

          UPDATE cfg_param_overrides
             SET override_value = p_value,
                 created_by     = p_user,
                 created_on     = SYSDATE
           WHERE param_id    = v_param_id
             AND scope_type  = p_scope_type
             AND scope_value = p_scope_value;

            --- log_audit 
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            -- Create new override
            INSERT INTO cfg_param_overrides(
                param_id, tenant_id, app_id, scope_type, scope_value,
                override_value, is_active, created_by, created_on
            ) VALUES (
                v_param_id, p_tenant_id, p_app_id, p_scope_type, p_scope_value,
                p_value, 'Y', p_user, SYSDATE
            );
             --- log_audit 
        END;
      ELSE
        -- Update base parameter value directly
        SELECT param_value INTO v_old
          FROM cfg_parameters
         WHERE param_id = v_param_id;

        UPDATE cfg_parameters
           SET param_value     = p_value,
               is_secret       = p_is_secret,
               last_updated_by = p_user,
               last_updated = SYSDATE
         WHERE param_id = v_param_id;

          --- log_audit 
      END IF;

      --------------------------------------------------------------------------
      -- Step 3 : Invalidate cache for the modified key
      --------------------------------------------------------------------------
      g_cache.DELETE(p_tenant_id||'|'||p_app_id||'|'||p_param_key||'|'||NVL(p_user,'?'));
  END set_value;

  ------------------------------------------------------------------------------
  -- PARAM_EXISTS : Returns TRUE if parameter defined for tenant/app.
  ------------------------------------------------------------------------------
  FUNCTION param_exists(
      p_param_key IN VARCHAR2,
      p_tenant_id  IN VARCHAR2,
      p_app_id     IN NUMBER
  ) RETURN BOOLEAN
  IS  vcaller constant varchar2(70):= c_package_name ||'.param_exists'; 
      v_dummy NUMBER;
  BEGIN
      SELECT 1 INTO v_dummy
        FROM cfg_parameters
       WHERE param_key = p_param_key
         AND tenant_id  = p_tenant_id
         AND app_id     = p_app_id;
      RETURN TRUE;
  EXCEPTION WHEN NO_DATA_FOUND THEN
      RETURN FALSE;
  END param_exists;

  ------------------------------------------------------------------------------
  -- CLEAR_CACHE : Manually flush in-session cache.
  -- Useful during testing, debugging, or after large config updates.
  ------------------------------------------------------------------------------
  PROCEDURE clear_cache IS
  BEGIN
      g_cache.DELETE;
  END clear_cache;

END cfg_param_util;

/
