--------------------------------------------------------
--  DDL for View CFG_PARAM_EFFECTIVE_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CFG_PARAM_EFFECTIVE_V" ("PARAM_KEY", "CATEGORY_CODE", "PARAM_NAME", "EFFECTIVE_VALUE", "DEFAULT_VALUE", "OVERRIDE_VALUE", "PARAM_SCOPE", "IS_ACTIVE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    p.param_key,
    p.CATEGORY_CODE,
    p.param_name,
    COALESCE(po.override_value, p.param_value) as effective_value,
    p.param_value as default_value,
    po.override_value,
    p.PARAM_SCOPE,
   
    --p.user_id,
    --p.is_sensitive,
    p.is_active
FROM cfg_parameters p
    LEFT JOIN cfg_param_overrides po 
        ON p.PARAM_ID = po.PARAM_ID 
       AND po.is_active = 'Y'
       AND (po.EXPIRY_DATE IS NULL OR po.EXPIRY_DATE >= SYSDATE)
WHERE p.is_active = 'Y'
;
