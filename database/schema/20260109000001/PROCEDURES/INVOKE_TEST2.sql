--------------------------------------------------------
--  DDL for Procedure INVOKE_TEST2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "INVOKE_TEST2" IS
   
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------
    -- REQUEST & RESPONSE RECORDS
    ----------------------------------------------------------------------
    l_req  llm_types.t_llm_request;
    l_resp llm_types.t_llm_response;

    ----------------------------------------------------------------------
    -- TEST PARAMETERS (SIMULATED PAGE ITEMS)
    ----------------------------------------------------------------------
    P100_USER_PROMPT          CLOB := 'Can you give me more details?';
    P100_SYSTEM_INSTRUCTIONS  VARCHAR2(32767) := 'You are a helpful HR assistant.';
    P100_CONVERSATION_HISTORY CLOB := 'User: What is my salary?' || CHR(10) ||
                                      'Assistant: Your current salary is $75,000 per year.';
    P100_CHAT_SESSION_ID      NUMBER := 12345;

    l_user_name   VARCHAR2(100) := 'AI';
    l_app_session NUMBER := 123456;
    l_tenant_id   NUMBER := 1;

BEGIN
    
--EXEC DBMS_SESSION.MODIFY_PACKAGE_STATE(DBMS_SESSION.FREE_ALL_RESOURCES);
--EXEC DBMS_SESSION.MODIFY_PACKAGE_STATE(DBMS_SESSION.REINITIALIZE);

DBMS_SESSION.MODIFY_PACKAGE_STATE(DBMS_SESSION.FREE_ALL_RESOURCES);
    DBMS_OUTPUT.PUT_LINE('========================================');
    DBMS_OUTPUT.PUT_LINE('TEST 2: Multi-turn Conversation (Record API)');
    DBMS_OUTPUT.PUT_LINE('========================================');

    ----------------------------------------------------------------------
    -- POPULATE REQUEST RECORD (IN)
    ----------------------------------------------------------------------
    l_req.provider             := 'OPENAI';
    l_req.model                := 'gpt-4o-mini';

    l_req.user_prompt          := P100_USER_PROMPT;
    l_req.system_instructions  := P100_SYSTEM_INSTRUCTIONS;
    l_req.conversation_history := P100_CONVERSATION_HISTORY;

    l_req.response_schema      := NULL;
    l_req.response_format      := NULL;

    l_req.temperature          := 0.7;
    l_req.max_tokens           := 2048;
    l_req.top_p                := 1.0;
    l_req.top_k                := NULL;
    l_req.seed                 := NULL;
    l_req.stop                 := NULL;

    l_req.frequency_penalty    := 0;
    l_req.presence_penalty     := 0;

    l_req.stream_enabled       := FALSE;

    l_req.chat_session_id      := P100_CHAT_SESSION_ID;
    l_req.app_session_id       := l_app_session;
    l_req.tenant_id            := l_tenant_id;
    l_req.user_name            := l_user_name;

    l_req.context_domain_id    := NULL;  -- optional
    l_req.payload              := NULL;  -- extensibility container

    ----------------------------------------------------------------------
    -- EXECUTE USING NEW INVOKE SIGNATURE
    ----------------------------------------------------------------------
    APP_INVOKE_PKG.invoke_llm(
        p_req  => l_req,
        p_resp => l_resp
    );

    ----------------------------------------------------------------------
    -- OUTPUT TEST RESULTS
    ----------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('RESULT:');
    DBMS_OUTPUT.PUT_LINE('  Success: ' || CASE WHEN l_resp.success THEN 'YES' ELSE 'NO' END);

    IF l_resp.success THEN
        DBMS_OUTPUT.PUT_LINE('  Response: ' || SUBSTR(l_resp.response_text, 1, 300));
        DBMS_OUTPUT.PUT_LINE('  Tokens: ' || l_resp.tokens_total);
        DBMS_OUTPUT.PUT_LINE('  Cost: $' || l_resp.cost_usd);
        DBMS_OUTPUT.PUT_LINE('  Processing MS: ' || l_resp.processing_ms);
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ERROR: ' || l_resp.msg);
    END IF;

    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('TEST 2 COMPLETED');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ ERROR: ' || SQLERRM);
        RAISE;
END invoke_test2;

/
