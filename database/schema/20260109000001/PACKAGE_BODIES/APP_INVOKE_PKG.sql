--------------------------------------------------------
--  DDL for Package Body APP_INVOKE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APP_INVOKE_PKG" AS

FUNCTION is_valid_user_prompt(p_prompt CLOB) RETURN BOOLEAN IS
   vcaller constant varchar2(70):= c_package_name ||'.is_valid_user_prompt'; 
BEGIN
    IF p_prompt IS NULL OR LENGTH(TRIM(p_prompt)) < 3 THEN
        debug_util.info('Prompt is empty or length<3 Char > '||p_prompt,vcaller);
        apex_error.add_error(
            p_message => 'Please enter a valid message.',
            p_display_location => apex_error.c_inline_in_notification
        );
        RETURN FALSE;
    END IF;
    RETURN TRUE;
END;

function get_user_id(p_user_name varchar2) return number
is 
v_user_id number;
begin
    SELECT user_id INTO v_user_id
    FROM users
    WHERE user_name =p_user_name;
    return v_user_id;
exception
    when others then 
    v_user_id:=-1;
    return v_user_id;
end get_user_id;

PROCEDURE invoke_llm(
    p_req  IN  llm_types.t_llm_request,
    p_resp OUT llm_types.t_llm_response
)
IS  vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_context_domain_id      NUMBER;
    v_user_msg_id            NUMBER;
    v_call_id                NUMBER;
    v_start_time             TIMESTAMP;
    v_proc_ms                NUMBER;
    v_stop_sequences         VARCHAR2(4000);
    v_response               llm_types.t_llm_response;
    v_llm_req                llm_types.t_llm_request;
    v_msg                    VARCHAR2(4000);
    v_domain_detect_req      CXD_TYPES.t_cxd_classifier_req;
    v_detect_resp_Domain     CXD_TYPES.t_cxd_classifier_resp;
    v_detect_resp_Intent     CXD_TYPES.t_intent_classifier_resp;
    v_chat_session_id        NUMBER;
    vTraceId  VARCHAR2(200);
BEGIN
    v_llm_req:=p_req;
    v_start_time := SYSTIMESTAMP;

    -- Initialize OUT parameter object types
    p_resp.success := FALSE;
    p_resp.payload := NULL;
    p_resp.safety_ratings := NULL;

    v_msg:= 'Strating Invoke.........';
    dbms_output.put_line(v_msg);

    IF NOT is_valid_user_prompt(p_req.user_prompt) THEN
        p_resp.success           := FALSE;
        p_resp.processing_status := '❌ Validation Failed';
        RETURN;
    END IF;

    if v_llm_req.user_id  is null then
       v_msg:= 'STEP 0.1: getting User ID for>>'||v_llm_req.user_name;
        debug_util.info('v_llm_req.user_id  is null' ,vcaller ,vTraceId);
       v_llm_req.user_id := get_user_id(p_user_name=> v_llm_req.user_name);
    end if;

    v_chat_session_id := v_llm_req.chat_session_id;

    IF v_chat_session_id IS NULL THEN
        v_msg:= 'STEP 1: create New session..';
            debug_util.info('There is no Session, create new one' ,vcaller );
            v_chat_session_id := chat_session_pkg.new_session(
                        p_provider         => v_llm_req.provider,
                        p_model            => v_llm_req.model,
                        p_session_title    => v_llm_req.session_title,
                        p_user_id          => v_llm_req.user_id,
                        p_app_id           => v_llm_req.APP_ID ,
                        p_app_page_id      => v_llm_req.APP_PAGE_ID,
                        p_project_id       => v_llm_req.project_id,
                        p_app_session_id   => v_llm_req.app_session_id,
                        p_tenant_id        => v_llm_req.tenant_id,
                         p_trace_id        => vTraceId
    )  ;
      
        v_llm_req.chat_session_id := v_chat_session_id;
        p_resp.request_id := 'SESSION-' || v_chat_session_id;
        debug_util.info('sessionId>'||v_llm_req.chat_session_id||' - REQUESTID>'||p_resp.request_id  ,vcaller,vTraceId );
    ELSE 
        v_msg:= 'STEP 1: resume_session..'||v_chat_session_id;
        debug_util.info(v_msg, vcaller,vTraceId); 
    END IF;

 
    v_msg:= 'STEP 3: Parse Stop Sequences.';

    dbms_output.put_line(v_msg);
    IF p_req.stop IS NOT NULL THEN
        BEGIN
            v_stop_sequences := JSON_ARRAY_T(p_req.stop).to_string();
        EXCEPTION
            WHEN OTHERS THEN
                 debug_util.warn(v_msg, vcaller); 
                v_stop_sequences := NULL;
        END;
    END IF;

    v_msg:= 'STEP 4: detect domain.';
     debug_util.info(v_msg, vcaller,vTraceId); 

    v_domain_detect_req.trace_id         :=vTraceId;
    v_domain_detect_req.cxd_required     :='Y';
    v_domain_detect_req.detection_Method_code:='AUTO';
    v_domain_detect_req.context_domain_id :=v_llm_req.context_domain_id;
    v_domain_detect_req.provider         := v_llm_req.provider;
    v_domain_detect_req.model            := v_llm_req.model;
    v_domain_detect_req.user_prompt       := v_llm_req.user_prompt;
    v_domain_detect_req.chat_session_id  := v_llm_req.chat_session_id;
    v_domain_detect_req.user_id          := v_llm_req.user_id;
    v_domain_detect_req.user_name        := v_llm_req.user_name;
    v_domain_detect_req.app_session_id   := v_llm_req.app_session_id;
    v_domain_detect_req.tenant_id        := v_llm_req.tenant_id;
    v_domain_detect_req.chat_project_id  := v_llm_req.project_id;
    v_domain_detect_req.app_id := v_llm_req.app_id;
    v_domain_detect_req.app_page_id := v_llm_req.app_page_id; 

    cxd_classifier_pkg.detect( 
        p_req         => v_domain_detect_req,
        P_resp_Domain => v_detect_resp_Domain,
        P_resp_Intent => v_detect_resp_Intent
    );

    v_context_domain_id:= v_detect_resp_Domain.context_domain_id;
    v_llm_req.context_domain_id :=v_context_domain_id;

    v_msg:= 'STEP 5: CALL LLM_ROUTER_PKG (Unified Router).';
     debug_util.info(v_msg, vcaller,vTraceId); 

    v_response := llm_router_pkg.invoke_llm(v_llm_req);

    v_msg:= 'STEP 6: Save Assistant Response.';
    debug_util.info(v_msg, vcaller,vTraceId); 

    IF v_response.response_text IS NOT NULL THEN
        v_call_id := chat_call_pkg.add_call( p_request => p_req, 
                                             p_response  => v_response );
 
        
    END IF;

    v_msg:= 'STEP 7: Update Session Totals.';
     debug_util.info(v_msg, vcaller,vTraceId); 
    chat_session_pkg.update_session_totals(p_session_id => v_chat_session_id, p_trace_id => vTraceId);

    v_msg:= 'STEP 8: Fill Response';
     debug_util.info(v_msg, vcaller,vTraceId); 

    -- 🔍 DEBUG: Test v_response fields BEFORE calling safe_copy
    BEGIN
        v_msg := 'STEP 8.1: Testing v_response.payload';
         debug_util.info(v_msg, vcaller); 
        IF v_response.payload IS NULL THEN
            debug_util.info('  payload is NULL (safe)', vcaller,vTraceId); 
        ELSE
            debug_util.info('  payload is NOT NULL', vcaller,vTraceId); 
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('testing payload: ' || SQLERRM, vcaller,vTraceId); 
    END;

    BEGIN
        v_msg := 'STEP 8.2: Testing v_response.safety_ratings';
        debug_util.info(v_msg ,vcaller);
        IF v_response.safety_ratings IS NULL THEN
            debug_util.info(' safety_ratings is NULL (safe)',vcaller,vTraceId);
        ELSE
            debug_util.info('safety_ratings is NOT NULL',vcaller,vTraceId);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('testing safety_ratings: ' || SQLERRM,vcaller,vTraceId);
    END;

    -- Now try the copy
    v_msg := 'STEP 8.3: Calling safe_copy_response';
    debug_util.info(v_msg,vcaller);

    BEGIN
        p_resp := llm_types.safe_copy_response(v_response);
        debug_util.info('safe_copy_response succeeded',vcaller,vTraceId);
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error(' safe_copy_response FAILED: ' || SQLERRM,vcaller,vTraceId);
            -- Manual field-by-field copy as fallback
            p_resp.success := v_response.success;
            p_resp.msg := 'Copy failed: ' || SQLERRM;
            p_resp.payload := NULL;
            p_resp.safety_ratings := NULL;
    END;

    p_resp.processing_status := CASE
        WHEN v_response.is_refusal THEN '❌ Request Refused'
        WHEN v_response.is_blocked THEN '❌ Blocked by Safety Filter'
        WHEN v_response.success    THEN '✓ Success'
        ELSE '❌ Failed'
    END;

    p_resp.processing_ms := 
        EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

    v_msg:= 'processing_ms>'||p_resp.processing_ms;
    debug_util.ending(vcaller,v_msg, vTraceId);

EXCEPTION
    WHEN OTHERS THEN
        v_msg:=  sqlerrm;
        debug_util.error(v_msg, vcaller,vTraceId);
        p_resp.success           := FALSE;
        p_resp.processing_status := '❌ LLM Call,Critical Error';
        p_resp.msg     := SQLERRM;
        p_resp.payload := NULL;
        p_resp.safety_ratings := NULL;
END invoke_llm;

END app_invoke_pkg;

/
