--------------------------------------------------------
--  DDL for Package Body CXD_FAILURE_ACTIONS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CXD_FAILURE_ACTIONS_PKG" AS

 
    /***************************************************************************
     * Fetch default lookup action
     ***************************************************************************/
    FUNCTION get_default_action(p_trace_id in VARCHAR2)
        RETURN t_failure_action IS
        v_action t_failure_action;
        vcaller      CONSTANT VARCHAR2(70) := c_package_name || '.get_default_action';      
    BEGIN
        SELECT
            failure_action_code,
            failure_action,
            user_response,
            action_type,
            is_default
        INTO
             v_action.failure_action_code,
             v_action.failure_action,
             v_action.user_response,
             v_action.action_type,
             v_action.is_default
        FROM lkp_cxd_failure_action_options
        WHERE is_active  = 'Y'
          AND is_default = 'Y'
        ORDER BY display_order
        FETCH FIRST 1 ROW ONLY;

         DEBUG_UTIL.info( p_message => 'Default Action:'|| v_action.failure_action_code , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;

        RETURN v_action;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DEBUG_UTIL.error( p_message => 'NoDataFound' , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;
            v_action.failure_action_code := 'RAISE-ERROR';
            v_action.failure_action      := 'Fallback system error';
            v_action.user_response       := 'We were unable to process your request.';
            v_action.action_type         := 'SYSTEM';
            v_action.is_default          := 'Y';
            RETURN v_action;
    END get_default_action;
    /***************************************************************************
     * Get action by code (lookup table)
     ***************************************************************************/
 
    FUNCTION get_action(
        p_action_code IN VARCHAR2,
        p_trace_id in VARCHAR2
    ) RETURN t_failure_action IS
        vcaller      CONSTANT VARCHAR2(70) := c_package_name || '.get_action'; 
        v_action t_failure_action;
    BEGIN
        SELECT
            failure_action_code,
            failure_action,
            user_response,
            action_type,
            is_default
        INTO
             v_action.failure_action_code,
             v_action.failure_action,
             v_action.user_response,
             v_action.action_type,
             v_action.is_default
        FROM lkp_cxd_failure_action_options
        WHERE failure_action_code = UPPER(p_action_code)
          AND is_active = 'Y';

        RETURN v_action;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
        DEBUG_UTIL.error( p_message => 'NoDataFound' , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;
            RETURN get_default_action(p_trace_id );
    END get_action;
    /***************************************************************************
     *  NEW: Resolve action using CFG_PARAMETERS
     ***************************************************************************/
 
    FUNCTION resolve_action(
        p_tenant_id IN NUMBER,
        p_app_id    IN NUMBER,
        p_trace_id in VARCHAR2
    ) RETURN t_failure_action IS
        vcaller      CONSTANT VARCHAR2(70) := c_package_name || '.resolve_action'; 
        v_action_code  VARCHAR2(50);
    BEGIN
        -- 1️⃣ Try CFG_PARAMETERS
        BEGIN
            SELECT param_value
            INTO   v_action_code
            FROM   cfg_parameters
            WHERE  param_key   = 'CXD_FAILURE_ACTION'
            AND    tenant_id   = p_tenant_id
            AND    app_id      = p_app_id
            AND    is_active   = 'Y';

        EXCEPTION
            WHEN NO_DATA_FOUND THEN
            DEBUG_UTIL.error( p_message => 'NoDataFound' , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;
                v_action_code := NULL;
        END;
            
        -- 2️⃣ Resolve via lookup or fallback
        IF v_action_code IS NOT NULL THEN
           DEBUG_UTIL.info( p_message => 'Action:'|| v_action_code , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;
            RETURN get_action(v_action_code,p_trace_id);
        END IF;

        -- 3️⃣ Absolute fallback
        RETURN get_default_action(p_trace_id );

    END resolve_action;
    /***************************************************************************
     * Format user response message
     ***************************************************************************/
 
    FUNCTION format_user_response(
        p_action        IN t_failure_action,
        p_user_prompt   IN CLOB,
        p_domains_list  IN CLOB,
        p_confidence    IN NUMBER,
        p_trace_id in VARCHAR2
    ) RETURN CLOB IS
         vcaller      CONSTANT VARCHAR2(70) := c_package_name || '.format_user_response'; 
        v_msg CLOB;
    BEGIN
       DEBUG_UTIL.starting(p_caller => vcaller ,  p_message => '',  p_trace_id  =>  p_trace_id ) ;
        v_msg := p_action.user_response;

        IF v_msg IS NULL THEN
            RETURN NULL;
        END IF;

        v_msg := REPLACE(v_msg, '{USER_PROMPT}', NVL(p_user_prompt, ''));
        v_msg := REPLACE(v_msg, '{AVAILABLE_DOMAINS}', NVL(p_domains_list, ''));
        v_msg := REPLACE(
            v_msg,
            '{CONFIDENCE}',
            CASE
                WHEN p_confidence IS NOT NULL
                THEN TO_CHAR(ROUND(p_confidence * 100, 2)) || '%'
                ELSE ''
            END
        );
       
        RETURN v_msg;
        exception
        when others then
        DEBUG_UTIL.error( p_message => sqlerrm , p_caller => vcaller ,  p_trace_id  =>  p_trace_id ) ;
        return v_msg;
    END format_user_response;
    /***************************************************************************
     *  
     ***************************************************************************/
END cxd_failure_actions_pkg;

/
