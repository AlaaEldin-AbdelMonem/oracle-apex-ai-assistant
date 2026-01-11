--------------------------------------------------------
--  DDL for Package Body LLM_ROUTER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LLM_ROUTER_PKG" AS

/*******************************************************************************
 *  
 *******************************************************************************/
FUNCTION get_default_provider(p_trace_id in varchar2)
RETURN VARCHAR2 IS
    vcaller constant varchar2(70):= c_package_name ||'.get_default_provider'; 
    v_provider VARCHAR2(50);
BEGIN
    SELECT provider_code
    INTO v_provider
    FROM llm_providers
    WHERE is_default = 'Y'
      AND ROWNUM = 1;

    RETURN v_provider;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        debug_util.error( sqlerrm,vcaller,p_trace_id );  
        RAISE_APPLICATION_ERROR(  -20100, sqlerrm );
END get_default_provider;

/*******************************************************************************
 *  PRIVATE: Get Default Model
 *******************************************************************************/
 
FUNCTION get_default_model(p_provider_code IN VARCHAR2, p_trace_id  IN VARCHAR2)
RETURN VARCHAR2 IS
    vcaller constant varchar2(70):= c_package_name ||'.get_default_model'; 
    v_model_code VARCHAR2(140);
BEGIN
    SELECT model_code
    INTO v_model_code
    FROM llm_provider_models
    WHERE is_default = 'Y'
      AND is_active = 'Y'
      AND is_production_ready = 'Y'
      AND is_embedding_model = 'N'
      AND ROWNUM = 1;

    RETURN v_model_code;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       debug_util.error( sqlerrm,vcaller);  
        SELECT model_code
        INTO v_model_code
        FROM llm_provider_models
        WHERE is_active = 'Y'
          AND is_production_ready = 'Y'
          AND is_embedding_model = 'N'
        ORDER BY display_order
        FETCH FIRST 1 ROW ONLY;

        RETURN v_model_code;
END get_default_model;


/*******************************************************************************
 *   MAIN ROUTER — New Unified Version
 *******************************************************************************/
 /*
FUNCTION invoke_llm(
    p_req IN llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_resp       llm_types.t_llm_response;

    v_start_time TIMESTAMP := SYSTIMESTAMP;
     v_req  llm_types.t_llm_request;
     v_msg varchar2(4000);

     e_unsupported_provider EXCEPTION;
     PRAGMA EXCEPTION_INIT(e_unsupported_provider, -20001);--link exc to number
BEGIN
   v_req:=p_req;

    debug_util.starting(vcaller, 'Provider: ' || v_req.provider || ' | Model: ' || v_req.model);

    if  v_req.provider is null then
          v_req.provider := get_Default_provider ;
          v_req.model := get_default_model(v_req.provider);
          debug_util.info('we will use Default Provider > '|| v_req.provider,vcaller);
    end if;

    CASE v_req.provider

        WHEN 'OPENAI' THEN
            v_resp := llm_openai_pkg.call_openai(v_req);

        WHEN 'ANTHROPIC' THEN
            v_resp := llm_anthropic_pkg.invoke_claude(v_req); 
            --
        WHEN 'GOOGLE' THEN
            v_resp := llm_gemini_pkg.invoke_gemini(v_req);

        WHEN 'LOCAL' THEN
            v_resp := llm_local_pkg.invoke_local(v_req);

      ELSE 
            -- Raise the named exception
            RAISE e_unsupported_provider;
    END CASE;

    debug_util.log_time('Execution Finished', v_start_time, vcaller);
    RETURN v_resp;

EXCEPTION
    WHEN e_unsupported_provider THEN
        v_resp.success := FALSE;
        v_resp.msg := 'The provider [' || v_req.provider || '] is not configured in this system.';
        debug_util.user_error(v_resp.msg, vcaller);
        RETURN v_resp;

 -- Handle everything else (Network issues, JSON parsing, etc) * 
    WHEN OTHERS THEN
        -- Use dbms_utility.format_error_backtrace to know WHERE it crashed
        debug_util.error(SQLERRM || CHR(10) || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, vcaller);
        v_resp.success := FALSE;
        v_resp.msg := 'A technical error occurred while contacting the AI provider.';
       -- v_resp.payload := NULL;
        --v_resp.safety_ratings := NULL;
        RETURN v_resp;
END invoke_llm;*/
 
 FUNCTION invoke_llm(
    p_req IN llm_types.t_llm_request
) RETURN llm_types.t_llm_response

IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_req        llm_types.t_llm_request := p_req;
    v_resp       llm_types.t_llm_response;
    v_PACKAGE        VARCHAR2(30);
    v_start_time TIMESTAMP := SYSTIMESTAMP;
    v_sql        VARCHAR2(500);
    v_traceid  VARCHAR2(200);
    -- Named Exception for clarity
    e_unregistered_provider EXCEPTION;
BEGIN
   v_traceid := v_req.trace_id;
    -- 1. Resolve Provider and Handler via Metadata
    BEGIN
        SELECT HANDLER_PACKAGE, PROVIDER_CODE
          INTO v_PACKAGE, v_req.provider
          FROM LLM_PROVIDERS
         WHERE (PROVIDER_CODE = v_req.provider OR (v_req.provider IS NULL AND IS_DEFAULT = 'Y'))
           AND IS_ACTIVE = 'Y';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
          RAISE e_unregistered_provider;
    END;

    -- 2. Build and Execute Dynamic Call
    -- Assumption: Every handler package has a function called 'invoke_llm'
    v_sql := 'BEGIN :res := ' || v_PACKAGE || '.invoke_llm(:req); END;';

    DEBUG_UTIL.starting(p_caller =>  vcaller,  p_message =>  'Dynamic Call to: ' || v_PACKAGE,  p_trace_id  => v_traceid  ) ;
 

    EXECUTE IMMEDIATE v_sql USING OUT v_resp, IN v_req;
  
   DEBUG_UTIL.log_time(p_message => 'Provider Response Received' ,  p_start_time =>v_start_time ,  p_caller  => vcaller ,  p_trace_id  =>v_traceid ) ;
 
    RETURN v_resp;

EXCEPTION
    WHEN e_unregistered_provider THEN
        -- 1. Log the full truth internally for security
        audit_util.log_security(
            p_event_code => 'AUTH_FAIL', -- Secondary Category: Access Denied
            p_message    => 'Security Block: Unregistered handler package for provider: ' || p_req.provider,
            p_caller     => vcaller
        );
        -- 2. Log technical details for developers
        debug_util.error('Unregistered Provider Access: Check LKP_REGISTERED_HANDLERS.', vcaller,v_traceid);
        -- 3. Prepare the Safe User Response
        v_resp.success := FALSE;
        v_resp.msg := 'The selected AI provider is not available at this time. Please contact your system administrator.';
        
        RETURN v_resp;
    WHEN OTHERS THEN
        -- 1. Technical Log: Full details for the developer to fix the ORA-06550
        debug_util.error('Critical Routing Crash: ' || SQLERRM, vcaller,v_traceid);
        -- 2. Permanent Audit: Logs a "System Health" event for Dashboard Page 721
        audit_util.log_failure(
            p_event_code => 'SYS_DEP', 
            p_reason     => 'Infrastructure Failure: ' || SUBSTR(SQLERRM, 1, 500),
            p_caller     => vcaller
        );
        -- 3. Prepare the Response for the UI (Safe and Professional)
        v_resp.success := FALSE;
        v_resp.msg     := 'An internal system error occurred. The technical team has been notified.';
        RETURN v_resp;
END invoke_llm;
 
/*******************************************************************************
 * PROCEDURE: invoke_llm_stream
 * USECASE:   Initiates a real-time streaming response from the resolved AI provider.
 * HOW TO USE: Call this from APEX AJAX processes to provide "typing" effects in the UI.
 *******************************************************************************/
PROCEDURE invoke_llm_stream(
    p_req      IN llm_types.t_llm_request,
    p_trace_id IN VARCHAR2
)
IS 
    vcaller  CONSTANT VARCHAR2(70) := c_package_name || '.invoke_llm_stream'; 
    v_req    llm_types.t_llm_request := p_req;
    v_pkg    VARCHAR2(30);
    v_sql    VARCHAR2(500);
    v_start  TIMESTAMP := SYSTIMESTAMP;
    v_traceid   VARCHAR2(200);
    -- Custom exception for metadata failures
    e_unregistered_provider EXCEPTION;
BEGIN
   v_traceid := v_req.trace_id;
    -- 1. Metadata-Driven Provider Resolution
    -- Replaces hard-coded defaults and CASE statements
    BEGIN
        SELECT HANDLER_PACKAGE, PROVIDER_CODE
          INTO v_pkg, v_req.provider
          FROM LLM_PROVIDERS
         WHERE (PROVIDER_CODE = v_req.provider OR (v_req.provider IS NULL AND IS_DEFAULT = 'Y'))
           AND IS_ACTIVE = 'Y';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
            RAISE e_unregistered_provider;
    END;

    -- 2. Performance Tracking & Lifecycle Entry
    debug_util.starting(vcaller, 'Streaming via: ' || v_pkg, v_traceid);

    -- 3. Dynamic Execution
    -- Assumption: Every streaming handler has a procedure 'invoke_llm_stream'
    v_sql := 'BEGIN ' || v_pkg || '.invoke_llm_stream(:req, :trace); END;';
    
    EXECUTE IMMEDIATE v_sql USING IN v_req, IN p_trace_id;

    -- 4. Success Telemetry
       DEBUG_UTIL.log_time(p_message => 'Streaming Connection Established',  p_start_time =>v_start ,  p_caller  => vcaller ,  p_trace_id  =>v_traceid ) ;
 

EXCEPTION
    WHEN e_unregistered_provider THEN
        debug_util.error('Unsupported/Inactive Provider: ' || p_req.provider, vcaller,v_traceid);
        LLM_STREAM_ADAPTER_UTIL.on_end('[ROUTER ERROR] Provider not registered: ' || p_req.provider);

    WHEN OTHERS THEN
        -- Handles ORA-06550 (Missing Package) as a System Health Failure
        debug_util.error('Streaming Routing Error: ' || SQLERRM, vcaller,v_traceid);
        
        -- Permanent Audit Log for System Health (FAIL Tier)
        audit_util.log_failure(
            p_event_code => 'SYS_DEP', -- Dependency Error
            p_reason     => 'Streaming Route Failed: ' || SQLERRM,
            p_caller     => vcaller,
            p_trace_id   => v_traceid
        );

        -- Notify final callback so UI does not hang
        LLM_STREAM_ADAPTER_UTIL.on_end('[ROUTER ERROR] ' || SQLERRM);
END invoke_llm_stream;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_router_pkg;

/
