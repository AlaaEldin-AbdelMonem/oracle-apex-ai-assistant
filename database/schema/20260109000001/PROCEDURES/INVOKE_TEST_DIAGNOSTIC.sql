--------------------------------------------------------
--  DDL for Procedure INVOKE_TEST_DIAGNOSTIC
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "INVOKE_TEST_DIAGNOSTIC" AS
BEGIN
/*******************************************************************************
 *  
 *******************************************************************************/
    DECLARE
        l_req  llm_types.t_llm_request;
        l_resp llm_types.t_llm_response;

        P100_USER_PROMPT           CLOB := 'What is my current salary?';
        P100_SYSTEM_INSTRUCTIONS   VARCHAR2(32767) := NULL;
        P100_CONVERSATION_HISTORY  CLOB := NULL;
        P100_VENDOR                VARCHAR2(100) := 'OPENAI';
        P100_MODEL                 VARCHAR2(100) := 'gpt-4o-mini';
        P100_TEMPERATURE           NUMBER := 0.7;
        P100_MAX_TOKENS            NUMBER := 2048;
        P100_TOP_P                 NUMBER := 1.0;
        P100_TOP_K                 NUMBER := NULL;
        P100_SEED                  NUMBER := NULL;
        P100_STOP                  VARCHAR2(4000) := NULL;
        P100_RESPONSE_FORMAT       VARCHAR2(100) := NULL;
        P100_RESPONSE_SCHEMA       CLOB := NULL;
        P100_FREQUENCY_PENALTY     NUMBER := 0.0;
        P100_PRESENCE_PENALTY      NUMBER := 0.0;
        P100_STREAM_ENABLED        BOOLEAN := FALSE;
        P100_CHAT_SESSION_ID       NUMBER := NULL;

        l_app_id   NUMBER := 119;
        l_page_id  NUMBER := 100;
        l_username VARCHAR2(255) := 'AI';
        l_user_id number:=4;
        l_tenant_id  number:=-1;
        l_chat_project_id  number:=-2;

    BEGIN
        -- Initialize response object types
        l_resp.success := FALSE;
        l_resp.payload := NULL;
        l_resp.safety_ratings := NULL;

        APEX_SESSION.CREATE_SESSION(
            p_app_id   => l_app_id,
            p_page_id  => l_page_id,
            p_username => l_username,
            p_call_post_authentication => FALSE
        );

        APEX_UTIL.SET_SESSION_STATE('G_TENANT_ID', l_tenant_id);
        APEX_UTIL.SET_SESSION_STATE('G_USER_ID',   l_user_id);
        APEX_UTIL.SET_SESSION_STATE('G_CHAT_PROJECT_ID', l_chat_project_id);
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('DIAGNOSTIC TEST');
        DBMS_OUTPUT.PUT_LINE('========================================');

        -- Build request
        l_req.provider             := P100_VENDOR;
        l_req.model                := P100_MODEL;
        l_req.user_prompt          := P100_USER_PROMPT;
        l_req.system_instructions  := P100_SYSTEM_INSTRUCTIONS;
        l_req.conversation_history := P100_CONVERSATION_HISTORY;
        l_req.temperature          := P100_TEMPERATURE;
        l_req.max_tokens           := P100_MAX_TOKENS;
        l_req.top_p                := P100_TOP_P;
        l_req.top_k                := P100_TOP_K;
        l_req.seed                 := P100_SEED;
        l_req.stop                 := P100_STOP;
        l_req.response_format      := P100_RESPONSE_FORMAT;
        l_req.response_schema      := P100_RESPONSE_SCHEMA;
        l_req.frequency_penalty    := P100_FREQUENCY_PENALTY;
        l_req.presence_penalty     := P100_PRESENCE_PENALTY;
        l_req.stream_enabled       := P100_STREAM_ENABLED;
        l_req.chat_session_id      := P100_CHAT_SESSION_ID;
        l_req.app_session_id       := v('APP_SESSION');
        l_req.app_page_id          := l_page_id;
        l_req.app_id               := l_app_id;
        l_req.tenant_id            := 0;
        l_req.user_name            := l_username;
        l_req.user_id              := l_user_id;
        l_req.context_domain_id    := NULL;
        l_req.payload              := NULL;

        DBMS_OUTPUT.PUT_LINE('Calling invoke_llm...');

        -- Call LLM
        APP_INVOKE_PKG.invoke_llm(p_req => l_req, p_resp => l_resp);

        DBMS_OUTPUT.PUT_LINE('Returned from invoke_llm');
        DBMS_OUTPUT.PUT_LINE('');

        -- Now test each field access one by one
        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.success');
            IF l_resp.success IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('  Result: success is NULL');
            ELSIF l_resp.success THEN
                DBMS_OUTPUT.PUT_LINE('  Result: success = TRUE');
            ELSE
                DBMS_OUTPUT.PUT_LINE('  Result: success = FALSE');
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing success: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.processing_status');
            DBMS_OUTPUT.PUT_LINE('  Result: ' || NVL(l_resp.processing_status, 'NULL'));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing processing_status: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.error_message');
            DBMS_OUTPUT.PUT_LINE('  Result: ' || NVL(l_resp.msg, 'NULL'));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing error_message: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.is_refusal');
            IF l_resp.is_refusal IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('  Result: is_refusal is NULL');
            ELSIF l_resp.is_refusal THEN
                DBMS_OUTPUT.PUT_LINE('  Result: is_refusal = TRUE');
            ELSE
                DBMS_OUTPUT.PUT_LINE('  Result: is_refusal = FALSE');
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing is_refusal: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.response_text');
            DBMS_OUTPUT.PUT_LINE('  Length: ' || NVL(LENGTH(l_resp.response_text), 0));
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing response_text: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.payload');
            IF l_resp.payload IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('  Result: payload is NULL');
            ELSE
                DBMS_OUTPUT.PUT_LINE('  Result: payload is NOT NULL');
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing payload: ' || SQLERRM);
        END;

        BEGIN
            DBMS_OUTPUT.PUT_LINE('TEST: Reading l_resp.safety_ratings');
            IF l_resp.safety_ratings IS NULL THEN
                DBMS_OUTPUT.PUT_LINE('  Result: safety_ratings is NULL');
            ELSE
                DBMS_OUTPUT.PUT_LINE('  Result: safety_ratings is NOT NULL');
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('  ❌ ERROR accessing safety_ratings: ' || SQLERRM);
        END;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('All field access tests completed');
        DBMS_OUTPUT.PUT_LINE('========================================');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✗ EXCEPTION in outer block: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Error Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
            DBMS_OUTPUT.PUT_LINE('Error Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END;

END invoke_test_diagnostic;

/
