--------------------------------------------------------
--  DDL for Procedure TEST_FRONTEND_RESPONSE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."TEST_FRONTEND_RESPONSE" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    l_req  llm_types.t_llm_request;
    l_resp llm_types.t_llm_response;

    l_json JSON_OBJECT_T;
BEGIN
    -- Setup APEX session
    APEX_SESSION.CREATE_SESSION(
        p_app_id   => 119,
        p_page_id  => 100,
        p_username => 'AI',
        p_call_post_authentication => FALSE
    );

    APEX_UTIL.SET_SESSION_STATE('G_USER_ID', 4);
    APEX_UTIL.SET_SESSION_STATE('G_TENANT_ID', -1);
    COMMIT;

    -- Build request
    l_req.provider := 'OPENAI';
    l_req.model := 'gpt-4o-mini';
    l_req.user_prompt := 'What is my current salary?';
    l_req.temperature := 0.7;
    l_req.max_tokens := 2048;
    l_req.user_name := 'AI';
    l_req.user_id := 4;
    l_req.app_id := 119;
    l_req.tenant_id := 0;

    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('FRONTEND RESPONSE TEST');
    DBMS_OUTPUT.PUT_LINE('========================================');

    -- Call LLM
    APP_INVOKE_PKG.invoke_llm(p_req => l_req, p_resp => l_resp);

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== RESPONSE OBJECT (Frontend will receive) ===');
    DBMS_OUTPUT.PUT_LINE('');

    -- Build JSON response (as frontend would receive it)
    l_json := JSON_OBJECT_T();
    l_json.put('success', CASE WHEN l_resp.success THEN 'true' ELSE 'false' END);
    l_json.put('processing_status', l_resp.processing_status);
    l_json.put('response_text', l_resp.response_text);
    l_json.put('error_message', l_resp.msg);
    l_json.put('is_refusal', CASE WHEN l_resp.is_refusal THEN 'true' ELSE 'false' END);
    l_json.put('refusal_text', l_resp.refusal_text);
    l_json.put('input_tokens', l_resp.tokens_input);
    l_json.put('output_tokens', l_resp.tokens_output);
    l_json.put('total_tokens', l_resp.tokens_total);
    l_json.put('cost_usd', l_resp.cost_usd);
    l_json.put('processing_ms', l_resp.processing_ms);
    l_json.put('provider_used', l_resp.provider_used);
    l_json.put('model_used', l_resp.model_used);

    DBMS_OUTPUT.PUT_LINE('JSON Response:');
    DBMS_OUTPUT.PUT_LINE(l_json.to_string);
    DBMS_OUTPUT.PUT_LINE('');

    DBMS_OUTPUT.PUT_LINE('=== FORMATTED OUTPUT ===');
    DBMS_OUTPUT.PUT_LINE('Success: ' || CASE WHEN l_resp.success THEN 'YES' ELSE 'NO' END);
    DBMS_OUTPUT.PUT_LINE('Status: ' || l_resp.processing_status);
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Response Text:');
    DBMS_OUTPUT.PUT_LINE('---');
    DBMS_OUTPUT.PUT_LINE(NVL(l_resp.response_text, '(empty)'));
    DBMS_OUTPUT.PUT_LINE('---');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Tokens: ' || l_resp.tokens_total || ' (' || 
                         l_resp.tokens_input || ' in, ' || 
                         l_resp.tokens_output || ' out)');
    DBMS_OUTPUT.PUT_LINE('Cost: $' || ROUND(l_resp.cost_usd, 6));
    DBMS_OUTPUT.PUT_LINE('Time: ' || ROUND(l_resp.processing_ms, 2) || 'ms');
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('========================================');

END test_frontend_response;

/
