--------------------------------------------------------
--  DDL for Procedure INVOKE_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."INVOKE_TEST" AS
BEGIN
/*******************************************************************************
 *  
 *******************************************************************************/
    DECLARE
        ----------------------------------------------------------------------
        -- REQUEST / RESPONSE RECORDS
        ----------------------------------------------------------------------
        l_req  llm_types.t_llm_request;
        l_resp llm_types.t_llm_response;

        ----------------------------------------------------------------------
        -- Simulated Page 100 Inputs
        ----------------------------------------------------------------------
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

        ----------------------------------------------------------------------
        -- APEX Session Context
        ----------------------------------------------------------------------
        l_app_id   NUMBER := 119;
        l_page_id  NUMBER := 100;
        l_username VARCHAR2(255) := 'AI';
        l_user_id number:=4;
        l_tenant_id  number:=-1;
        l_chat_project_id  number:=-2;
        
    BEGIN
        -- ✅ CRITICAL FIX: Initialize response record object types
        l_resp.success := FALSE;
        l_resp.payload := NULL;
        l_resp.safety_ratings := NULL;
        
        ----------------------------------------------------------------------
        -- 1) INITIALIZE APEX SESSION
        ----------------------------------------------------------------------
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
        DBMS_OUTPUT.PUT_LINE('TEST 1: Basic Chat Query (Record API)');
        DBMS_OUTPUT.PUT_LINE('========================================');

        ----------------------------------------------------------------------
        -- 2) BUILD REQUEST RECORD
        ----------------------------------------------------------------------
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

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling invoke_llm using record format...');
        DBMS_OUTPUT.PUT_LINE('');
          
        DBMS_OUTPUT.PUT_LINE('USER_NAME>'|| v('APP_USER')||'>USERID>'||v('G_USER_ID'));  
        
        ----------------------------------------------------------------------
        -- 3) CALL THE LLM
        ----------------------------------------------------------------------
        APP_INVOKE_PKG.invoke_llm(
            p_req  => l_req,
            p_resp => l_resp
        );
        
        DBMS_OUTPUT.PUT_LINE('end calling APP_INVOKE_PKG.invoke_llm');
        
        ----------------------------------------------------------------------
        -- 4) DISPLAY OUTPUTS (with NULL-safe checks)
        ----------------------------------------------------------------------
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('OUTPUT RESULTS (Record API)');
        DBMS_OUTPUT.PUT_LINE('========================================');

        -- ✅ NULL-safe boolean check
        IF l_resp.success IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('Success: NULL (ERROR)');
        ELSIF l_resp.success THEN
            DBMS_OUTPUT.PUT_LINE('Success: YES');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Success: NO');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('Processing Status: ' || NVL(l_resp.processing_status, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('');

        IF l_resp.success = TRUE THEN
            DBMS_OUTPUT.PUT_LINE('RESPONSE TEXT:');
            DBMS_OUTPUT.PUT_LINE(SUBSTR(l_resp.response_text, 1, 500));
            IF LENGTH(l_resp.response_text) > 500 THEN
                DBMS_OUTPUT.PUT_LINE('... (truncated)');
            END IF;

            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('TOKENS / COST:');
            DBMS_OUTPUT.PUT_LINE('  Input: '  || l_resp.tokens_input);
            DBMS_OUTPUT.PUT_LINE('  Output: ' || l_resp.tokens_output);
            DBMS_OUTPUT.PUT_LINE('  Total: '  || l_resp.tokens_total);
            DBMS_OUTPUT.PUT_LINE('  Cost: $'  || ROUND(l_resp.cost_usd, 6));
            DBMS_OUTPUT.PUT_LINE('');

        ELSE
            DBMS_OUTPUT.PUT_LINE('ERROR: ' || NVL(l_resp.msg, 'Unknown error'));
            IF l_resp.is_refusal = TRUE THEN
                DBMS_OUTPUT.PUT_LINE('REFUSAL: ' || SUBSTR(l_resp.refusal_text, 1, 300));
            END IF;
        END IF;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('TEST 1 COMPLETED');
        DBMS_OUTPUT.PUT_LINE('========================================');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('✗ ERROR in test procedure: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Error Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
            DBMS_OUTPUT.PUT_LINE('Error Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;
    END;

END invoke_test;

/
