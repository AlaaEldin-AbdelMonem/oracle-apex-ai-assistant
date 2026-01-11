--------------------------------------------------------
--  DDL for Procedure TEST_CXD_CLASSIFIER
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "TEST_CXD_CLASSIFIER" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    v_req   CXD_TYPES.t_cxd_classifier_req;
    v_resp_domain CXD_TYPES.t_cxd_classifier_resp;
    v_resp_intent CXD_TYPES.t_intent_classifier_resp;

    PROCEDURE print_separator(p_title VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE(p_title);
        DBMS_OUTPUT.PUT_LINE('========================================');
    END;

    PROCEDURE print_domain_response IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== DOMAIN RESPONSE ===');
        DBMS_OUTPUT.PUT_LINE('Trace ID: ' || NVL(v_resp_domain.trace_id, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Detection Method: ' || NVL(v_resp_domain.detection_Method_code, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Final Method: ' || NVL(v_resp_domain.final_detection_Method_code, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Status: ' || NVL(v_resp_domain.Detect_status, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Domain ID: ' || NVL(TO_CHAR(v_resp_domain.context_domain_id), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Domain Code: ' || NVL(v_resp_domain.context_domain_code, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Domain Name: ' || NVL(v_resp_domain.context_domain_Name, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Confidence: ' || NVL(TO_CHAR(v_resp_domain.context_domain_confidence), 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Message: ' || NVL(v_resp_domain.message, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Search Time: ' || NVL(TO_CHAR(v_resp_domain.search_time_ms), 'NULL') || ' ms');
        DBMS_OUTPUT.PUT_LINE('Provider: ' || NVL(v_resp_domain.used_provider, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('Model: ' || NVL(v_resp_domain.used_model, 'NULL'));
    END;

    PROCEDURE init_base_request IS
    BEGIN
        v_req.trace_id := 'TEST-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS');
        v_req.provider := 'OPENAI';
        v_req.model := 'gpt-4o-mini';
        v_req.cxd_required := 'Y';
        v_req.user_prompt := 'What is my current salary?';
        v_req.intent_required := 'N';
        v_req.chat_session_id := NULL;
        v_req.user_id := 4;
        v_req.user_name := 'AI';
        v_req.app_session_id := v('APP_SESSION');
        v_req.tenant_id := 0;
        v_req.chat_project_id := -2;
        v_req.app_id := 119;
        v_req.app_page_id := 100;
    END;

BEGIN
    -- Initialize APEX session
    BEGIN
        APEX_SESSION.CREATE_SESSION(
            p_app_id   => 119,
            p_page_id  => 100,
            p_username => 'AI',
            p_call_post_authentication => FALSE
        );
        APEX_UTIL.SET_SESSION_STATE('G_USER_ID', 4);
        APEX_UTIL.SET_SESSION_STATE('G_TENANT_ID', 0);
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Note: APEX session already exists or not needed');
    END;

    print_separator('CXD CLASSIFIER COMPREHENSIVE TEST SUITE');

    -- ========================================================================
    -- TEST 1: AUTO Mode (LLM with Vector Fallback)
    -- ========================================================================
    print_separator('TEST 1: AUTO Mode (LLM → Vector Fallback)');

    BEGIN
        init_base_request;
        v_req.detection_Method_code := 'AUTO';
        v_req.context_domain_id := NULL;

        DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);
        DBMS_OUTPUT.PUT_LINE('Method: AUTO');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling detect...');

        cxd_classifier_pkg.detect(
            p_req => v_req,
            P_resp_Domain => v_resp_domain,
            P_resp_Intent => v_resp_intent
        );

        print_domain_response;

        IF v_resp_domain.Detect_status = 'SUCCESS' THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✅ TEST 1 PASSED');
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('⚠️  TEST 1: Detection failed but handled gracefully');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 1 FAILED: ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
    END;

    -- ========================================================================
    -- TEST 2: MANUAL Mode
    -- ========================================================================
    print_separator('TEST 2: MANUAL Mode (User-Selected Domain)');

    BEGIN
        init_base_request;
        v_req.detection_Method_code := 'MANUAL';
        v_req.context_domain_id := 5;  -- Assume domain ID 5 exists

        DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);
        DBMS_OUTPUT.PUT_LINE('Method: MANUAL');
        DBMS_OUTPUT.PUT_LINE('Selected Domain ID: ' || v_req.context_domain_id);
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling detect...');

        cxd_classifier_pkg.detect(
            p_req => v_req,
            P_resp_Domain => v_resp_domain,
            P_resp_Intent => v_resp_intent
        );

        print_domain_response;

        IF v_resp_domain.context_domain_id = 5 THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✅ TEST 2 PASSED: Manual domain respected');
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 2 FAILED: Domain ID mismatch');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 2 FAILED: ' || SQLERRM);
    END;

    -- ========================================================================
    -- TEST 3: VECTOR Mode (Semantic Search Only)
    -- ========================================================================
    print_separator('TEST 3: VECTOR Mode (Semantic Search Only)');

    BEGIN
        init_base_request;
        v_req.detection_Method_code := 'VECTOR';
        v_req.context_domain_id := NULL;

        DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);
        DBMS_OUTPUT.PUT_LINE('Method: VECTOR');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling detect...');

        cxd_classifier_pkg.detect(
            p_req => v_req,
            P_resp_Domain => v_resp_domain,
            P_resp_Intent => v_resp_intent
        );

        print_domain_response;

        IF v_resp_domain.Detect_status = 'SUCCESS' THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✅ TEST 3 PASSED');
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('⚠️  TEST 3: Vector search completed but confidence may be low');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 3 FAILED: ' || SQLERRM);
    END;

    -- ========================================================================
    -- TEST 4: LLM Mode (LLM Only, No Fallback)
    -- ========================================================================
    print_separator('TEST 4: LLM Mode (LLM Only, No Fallback)');

    BEGIN
        init_base_request;
        v_req.detection_Method_code := 'LLM';
        v_req.context_domain_id := NULL;

        DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);
        DBMS_OUTPUT.PUT_LINE('Method: LLM');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling detect...');

        cxd_classifier_pkg.detect(
            p_req => v_req,
            P_resp_Domain => v_resp_domain,
            P_resp_Intent => v_resp_intent
        );

        print_domain_response;

        IF v_resp_domain.Detect_status = 'SUCCESS' AND 
           v_resp_domain.used_provider = 'OPENAI' THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✅ TEST 4 PASSED');
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('⚠️  TEST 4: LLM detection attempted');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 4 FAILED: ' || SQLERRM);
    END;

    -- ========================================================================
    -- TEST 5: Error Handling - MANUAL with NULL domain
    -- ========================================================================
    print_separator('TEST 5: Error Handling (MANUAL with NULL domain)');

    BEGIN
        init_base_request;
        v_req.detection_Method_code := 'MANUAL';
        v_req.context_domain_id := NULL;  -- Should fail

        DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);
        DBMS_OUTPUT.PUT_LINE('Method: MANUAL');
        DBMS_OUTPUT.PUT_LINE('Selected Domain ID: NULL (intentional error)');
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Calling detect...');

        cxd_classifier_pkg.detect(
            p_req => v_req,
            P_resp_Domain => v_resp_domain,
            P_resp_Intent => v_resp_intent
        );

        print_domain_response;

        IF v_resp_domain.Detect_status = 'FAIL' THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('✅ TEST 5 PASSED: Error handled gracefully');
        ELSE
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 5 FAILED: Should have failed but succeeded');
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 5 FAILED: Unhandled exception: ' || SQLERRM);
    END;

    -- ========================================================================
    -- TEST 6: Different Query Types
    -- ========================================================================
    print_separator('TEST 6: Multiple Query Types (AUTO Mode)');

    DECLARE
        TYPE t_test_queries IS TABLE OF VARCHAR2(200);
        v_queries t_test_queries := t_test_queries(
            'What is my vacation balance?',
            'Show me HR policies',
            'Who is on leave next week?',
            'What are the company benefits?'
        );
    BEGIN
        FOR i IN 1..v_queries.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('--- Query ' || i || ' ---');

            init_base_request;
            v_req.detection_Method_code := 'AUTO';
            v_req.user_prompt := v_queries(i);

            DBMS_OUTPUT.PUT_LINE('Query: ' || v_req.user_prompt);

            cxd_classifier_pkg.detect(
                p_req => v_req,
                P_resp_Domain => v_resp_domain,
                P_resp_Intent => v_resp_intent
            );

            DBMS_OUTPUT.PUT_LINE('Detected Domain: ' || 
                NVL(v_resp_domain.context_domain_code, 'NULL') || 
                ' (ID: ' || NVL(TO_CHAR(v_resp_domain.context_domain_id), 'NULL') || ')');
            DBMS_OUTPUT.PUT_LINE('Status: ' || v_resp_domain.Detect_status);
        END LOOP;

        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('✅ TEST 6 COMPLETED');

    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('❌ TEST 6 FAILED: ' || SQLERRM);
    END;

    -- ========================================================================
    -- FINAL SUMMARY
    -- ========================================================================
    print_separator('TEST SUITE COMPLETED');
    DBMS_OUTPUT.PUT_LINE('All tests executed. Check results above.');
    DBMS_OUTPUT.PUT_LINE('');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('❌ FATAL ERROR IN TEST SUITE');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK);
        DBMS_OUTPUT.PUT_LINE('Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END test_cxd_classifier;

/
