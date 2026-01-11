--------------------------------------------------------
--  DDL for Package Body DEBUG_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DEBUG_UTIL" AS

    /***************************************************************************
     * PRIVATE PACKAGE STATE VARIABLES
     ***************************************************************************/
    g_initialized  BOOLEAN := FALSE;
    g_enabled      BOOLEAN := FALSE;
    g_min_level    NUMBER  := c_error;
    g_scope_level  NUMBER;
    g_app_id       NUMBER;
    g_user_id      NUMBER;
    g_session_id   NUMBER;
    g_page_id      NUMBER;

    /***************************************************************************
     * PROCEDURE: reset_state
     * PURPOSE: Reset all package state variables to initial values
     ***************************************************************************/
    PROCEDURE reset_state IS
    BEGIN
        g_initialized  := FALSE;
        g_enabled      := FALSE;
        g_min_level    := c_error;
        g_scope_level  := NULL;
        g_app_id       := NULL;
        g_user_id      := NULL;
        g_session_id   := NULL;
        g_page_id      := NULL;
    END reset_state;

    /***************************************************************************
     * PROCEDURE: resolve_context (INTERNAL)
     * PURPOSE: Resolve APEX context (app_id, user_id, session_id)
     * NOTES: Tries explicit parameters first, then APEX session context
     ***************************************************************************/
    PROCEDURE resolve_context(
        p_app_id      IN NUMBER,
        p_page_id     IN NUMBER,
        p_user_id     IN NUMBER,
        p_session_id  IN NUMBER,
        o_user_id     OUT NUMBER,
        o_session_id  OUT NUMBER,
        O_page_id     OUT NUMBER,
        O_app_id      OUT NUMBER   
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.resolve_context';
        v_apex_app_id  NUMBER;
    BEGIN
        -- Try to get APEX app ID from session context
        BEGIN
            v_apex_app_id :=  SYS_CONTEXT('APEX$SESSION', 'APP_ID');
        EXCEPTION
            WHEN OTHERS THEN
                v_apex_app_id := NULL;
        END;
         
        IF p_page_id is not null then
           O_page_id:= p_page_id;
        ELSIF  V('APP_PAGE_ID') is not null then
           O_page_id:= to_number(V('APP_PAGE_ID') );
        end if;

        -- Resolve APP_ID (explicit parameter takes priority)
        IF p_app_id IS NOT NULL THEN
            o_app_id := p_app_id;
        ELSIF v_apex_app_id IS NOT NULL AND v_apex_app_id != 0 THEN
            o_app_id := v_apex_app_id;
        ELSE
            o_app_id := NULL;
        END IF;

        -- Resolve USER_ID (explicit parameter takes priority)
        IF p_user_id IS NOT NULL THEN
            o_user_id := p_user_id;
        ELSIF V('APP_USER') IS NOT NULL THEN
            
            BEGIN
               SELECT user_id INTO o_user_id 
                FROM users 
                WHERE user_name = V('APP_USER');
             EXCEPTION 
                WHEN NO_DATA_FOUND THEN
                o_user_id := NULL;
            END;
            
        ELSE
            o_user_id := NULL;
        END IF;

        -- Resolve SESSION_ID (explicit parameter takes priority)
        IF p_session_id IS NOT NULL THEN
            o_session_id := p_session_id;
        ELSIF V('APP_SESSION') IS NOT NULL AND V('APP_SESSION') != '0' THEN
            o_session_id := TO_NUMBER(V('APP_SESSION'));
        ELSE
            o_session_id := NULL;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('DEBUG_UTIL>>resolve_context>' || SQLERRM);
            o_app_id     := NULL;
            o_user_id    := NULL;
            o_session_id := NULL;
    END resolve_context;

    /***************************************************************************
     * PROCEDURE: init
     * PURPOSE: Initialize debug framework with context and load configuration
     * PARAMETERS:
     *   p_app_id       - APEX Application ID (optional, auto-detected)
     *   p_user_id      - User ID (optional)
     *   p_session_id   - APEX Session ID (optional, auto-detected)
     *   p_module_name  - Module name for module-scope config (optional)
     *   p_force_reinit - Force re-initialization even if already initialized
     * NOTES:
     *   - Configuration priority: SESSION > USER > MODULE > APP > GLOBAL
     *   - If no config found, debug is disabled by default
     ***************************************************************************/
   PROCEDURE init(
    p_app_id       IN NUMBER   DEFAULT NULL,
    p_page_id      IN NUMBER   DEFAULT NULL,
    p_user_id      IN NUMBER   DEFAULT NULL,
    p_session_id   IN NUMBER   DEFAULT NULL,
    p_module_name  IN VARCHAR2 DEFAULT NULL,
    p_force_reinit IN BOOLEAN  DEFAULT FALSE
) IS
    vcaller CONSTANT VARCHAR2(70) := c_package_name || '.init';
    v_app_id      NUMBER;
    v_user_id     NUMBER;
    v_session_id  NUMBER;
    v_min_level   NUMBER;
    v_page_id     NUMBER;
    v_scope       NUMBER; -- Changed to NUMBER to match table
BEGIN
    -- Skip if already initialized (unless forced)
    IF g_initialized AND NOT NVL(p_force_reinit, FALSE) THEN
        RETURN;
    END IF;

    -- Resolve context (app, user, session, page)
    resolve_context(
        p_app_id     => p_app_id,
        p_page_id    => p_page_id,
        p_user_id    => p_user_id,
        p_session_id => p_session_id,
        o_app_id     => v_app_id,
        o_page_id    => v_page_id,
        o_user_id    => v_user_id,
        o_session_id => v_session_id
    );

    -- Store resolved context in package state
    g_app_id     := v_app_id;
    g_page_id    := v_page_id;
    g_user_id    := v_user_id;
    g_session_id := v_session_id;

    /*
     * Load debug configuration.
     * Since scope_level is now a NUMBER, we sort by it directly.
     * Lower number = Higher Priority (Specific -> General)
     */
    SELECT min_debug_level, scope_level
      INTO v_min_level, v_scope
      FROM (
            SELECT min_debug_level, 
                   scope_level
              FROM debug_config
             WHERE is_enabled = 'Y'
               AND (
                   scope_level = 6 -- GLOBAL (Least specific)
                   OR (scope_level = 5 AND app_id     = v_app_id)
                   OR (scope_level = 4 AND module_name = p_module_name)
                   OR (scope_level = 3 AND user_id    = v_user_id)
                   OR (scope_level = 2 AND page_id    = v_page_id)
                   OR (scope_level = 1 AND session_id = v_session_id) -- Most Specific
               )
             ORDER BY scope_level ASC -- 1 comes before 6
          )
     WHERE ROWNUM = 1;

    -- Apply configuration
    g_enabled     := TRUE;
    g_min_level   := v_min_level;
    g_scope_level := v_scope;
    g_initialized := TRUE;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        g_enabled     := FALSE;
        g_min_level   := c_error;
        g_scope_level := NULL;
        g_initialized := TRUE;
    WHEN OTHERS THEN
        g_enabled     := FALSE;
        g_min_level   := c_error;
        g_scope_level := NULL;
        g_initialized := TRUE;
END init;

    /***************************************************************************
     * FUNCTION: is_on
     * PURPOSE: Check if debug logging is enabled for given level
     * PARAMETERS:
     *   p_level       - Debug level to check (c_error, c_warn, c_info, c_debug)
     *   p_module_name - Module name (optional, for module-scope config)
     * RETURNS: TRUE if logging enabled for this level, FALSE otherwise
     * NOTES:
     *   - Auto-initializes if not already initialized
     *   - Lower level numbers = higher priority (ERROR=1 is highest)
     ***************************************************************************/
    FUNCTION is_on(
        p_level       IN NUMBER,
        p_module_name IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN IS
       vcaller constant varchar2(70):= c_package_name ||'.is_on';
    BEGIN
        -- Auto-initialize if needed
        IF NOT g_initialized THEN
            init(
                p_app_id      => v('APP_ID'),
                p_user_id     => v('G_USER_ID'),
                p_session_id  => v('APP_SESSION'),
                p_module_name => p_module_name,
                p_page_id    => v('APP_PAGE_ID') 
            );
        END IF;

        -- Check if debug is enabled
        IF NOT g_enabled THEN
            RETURN FALSE;
        END IF;

        -- Check if requested level is within threshold
        RETURN (p_level <= g_min_level);
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN FALSE;
    END is_on;

  

    /***************************************************************************
     * PROCEDURE: log
     * PURPOSE: Main logging procedure - insert log entry to DEBUG_LOG table
     * PARAMETERS:
     *   p_message    - Log message (required)
     *   p_level      - Log level (default: c_info)
     *   p_extra_data - Additional data as CLOB (optional)
     *   p_caller     - Caller in "MODULE.PROCEDURE" format (optional)
     *                  Examples: 'PKG_NAME.FUNC_NAME' or 'APEX_PROCESS.MAIN'
     *                  If NULL, auto-detects using call stack
     *   p_trace_id   - Trace/correlation ID (optional)
     * NOTES:
     *   - Uses AUTONOMOUS_TRANSACTION for independent commit
     *   - Fast exit if debug disabled or below threshold level
     *   - p_caller format options:
     *     * "MODULE.PROCEDURE" - Both module and procedure specified
     *     * "MODULE"           - Module only, procedure = '__main'
     *     * NULL               - Auto-detect from call stack
     ***************************************************************************/
    PROCEDURE log(
        p_message    IN VARCHAR2,
        p_level      IN NUMBER   DEFAULT c_info,
        p_extra_data IN CLOB     DEFAULT NULL,
        p_caller     IN VARCHAR2,
        p_trace_id   IN VARCHAR2 DEFAULT NULL ,
        p_log_type       IN VARCHAR2 DEFAULT 'TECH' )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
        
        l_proc_name       VARCHAR2(4000);
        l_module          VARCHAR2(4000);
        l_detected_module VARCHAR2(4000);
        l_dot_pos         NUMBER;
    BEGIN
        -- Fast exit: if debug OFF or below level threshold
        IF NOT is_on(p_level) THEN
            RETURN;
        END IF;

       
            l_dot_pos := INSTR(p_caller, '.');
            
            IF l_dot_pos > 0 THEN
                -- Format: "MODULE.PROCEDURE"
                l_module    := SUBSTR(p_caller, 1, l_dot_pos - 1);
                l_proc_name := SUBSTR(p_caller, l_dot_pos + 1);
            ELSE
                -- Format: "MODULE" only
                l_module    := p_caller;
                l_proc_name := '';
            END IF;
 
        -- Insert log entry
        INSERT INTO debug_log (
            debug_level,
            app_id,
            user_id,
            session_id,
            scope_level,
            module_name,
            procedure_name,
            trace_id,
            message,
            extra_data,
            page_id,
            log_type
        )
        VALUES (
            p_level,
            g_app_id,
            g_user_id,
            g_session_id,
            g_scope_level,
            upper(l_module),
            upper(l_proc_name),
            p_trace_id,
            p_message,
            p_extra_data,
            g_page_id,
            p_log_type
        );
     
        -- Commit in autonomous transaction
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Rollback autonomous transaction on error
            ROLLBACK;
            -- Don't propagate errors from logging
            NULL;
    END log;

    /***************************************************************************
     * CONVENIENCE WRAPPER PROCEDURES
     * PURPOSE: Simplified logging with predefined levels
     * NOTES: All wrappers delegate to main log() procedure
     ***************************************************************************/
PROCEDURE user_error(
    p_message    IN VARCHAR2,
    p_caller     IN VARCHAR2,
    p_user_label IN VARCHAR2 DEFAULT 'System Notification',
    p_trace_id   IN VARCHAR2
            ) IS
            BEGIN
                -- Log it as a WARN or ERROR with a special prefix
                log(
                    p_message => '👤 [USER_VISIBLE]: ' || p_user_label || ' - ' || p_message,
                    p_level   => c_error, -- Still an error, but tagged for the user
                    p_caller  => p_caller,
                    p_log_type   => 'USER' ,
                    p_trace_id   => p_trace_Id
                );
            END user_error;
 
  /***************************************************************************
 
   ***************************************************************************/
    PROCEDURE error(
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2 ,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        log(
            p_message  => '❌'||p_message||'💥',
            p_level    => c_error,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'TECH'  -- Trace is always technical
        );
    END error;
  /***************************************************************************
 
   ***************************************************************************/
    PROCEDURE warn(
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2  ,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        log(
            p_message  => '⚠️'||p_message,
            p_level    => c_warn,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'TECH'  -- Trace is always technical
        );
    END warn;
  /***************************************************************************
 
   ***************************************************************************/
    PROCEDURE info(
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2 ,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        log(
            p_message  => p_message,
            p_level    => c_info,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'TECH'  -- Trace is always technical
        );
    END info;
  /***************************************************************************
 
   ***************************************************************************/
    PROCEDURE debug(
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2 ,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        log(
            p_message  => p_message,
            p_level    => c_debug,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'TECH'  -- Trace is always technical
        );
    END debug;

    /***************************************************************************
     * PROCEDURE: reset_environment
     * PURPOSE: Reset debug framework state and clear all logs
     * NOTES:
     *   - Clears package state
     *   - Deletes all entries from DEBUG_LOG table
     *   - Commits changes
     *   - Use with caution in production
     ***************************************************************************/
    PROCEDURE reset_environment IS
       vcaller constant varchar2(70):= c_package_name ||'.reset_environment';
    BEGIN
        -- Reset package state
        reset_state;

        -- Clear all log entries
        DELETE FROM debug_log;
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('✓ Environment reset: All DEBUG_LOG entries cleared.');
        
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('✗ Error resetting environment: ' || SQLERRM);
            RAISE;
    END reset_environment;
  /***************************************************************************
 
   ***************************************************************************/
 PROCEDURE starting(
         p_caller   IN VARCHAR2 ,
         p_message  IN VARCHAR2 DEFAULT NULL, 
         p_trace_id IN VARCHAR2 DEFAULT NULL 
    ) IS
    BEGIN
        log(p_message  =>'📍 '|| p_message,
            p_level    => c_info,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'FLOW'  --Trace the path of execution.
        );
    END starting;
  /***************************************************************************
 
   ***************************************************************************/
 PROCEDURE Ending(
         p_caller   IN VARCHAR2 ,
         p_message  IN VARCHAR2 DEFAULT NULL, 
         p_trace_id IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        log(p_message  =>'🏁End '|| p_message,
            p_level    => c_info,
            p_caller   => p_caller,
            p_trace_id => p_trace_id,
            p_log_type   => 'FLOW'  --Trace the path of execution.
        );
    END Ending;
  /***************************************************************************
 
   ***************************************************************************/
    PROCEDURE trace(
    p_message  IN VARCHAR2,
    p_caller   IN VARCHAR2,
    p_trace_id IN VARCHAR2 DEFAULT NULL,
    p_extra_data IN CLOB DEFAULT NULL ) IS
        BEGIN
            log(
                p_message    => '🔡'||p_message,
                p_level      => c_trace,
                p_caller     => p_caller,
                p_log_type   => 'TECH', -- Trace is always technical
                p_extra_data => p_extra_data,
                p_trace_id => p_trace_id 
            );
        END trace;
  /***************************************************************************
 
   ***************************************************************************/

    PROCEDURE log_time(
        p_message    IN VARCHAR2,
        p_start_time IN TIMESTAMP,
        p_caller     IN VARCHAR2 ,
         p_trace_id IN VARCHAR2 
    ) IS
        l_duration INTERVAL DAY TO SECOND;
        l_seconds  NUMBER;
    BEGIN
        -- Calculate difference
        l_duration := SYSTIMESTAMP - p_start_time;

        -- Extract total seconds + milliseconds
        -- We multiply Minutes, Hours, and Days to get the total cumulative seconds
        l_seconds := EXTRACT(DAY    FROM l_duration) * 86400
                   + EXTRACT(HOUR   FROM l_duration) * 3600
                   + EXTRACT(MINUTE FROM l_duration) * 60
                   + EXTRACT(SECOND FROM l_duration);

        log(
            p_message  => '⏱️ ' || p_message || ' [Elapsed: ' || TO_CHAR(l_seconds, 'FM999990.000') || 's]',
            p_level    => c_info,
            p_caller   => p_caller,
            p_log_type => 'TIME' ,
            p_trace_id => p_trace_id
        );
    END log_time;
  /***************************************************************************
 
   ***************************************************************************/
END debug_util;

/
