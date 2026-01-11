--------------------------------------------------------
--  DDL for Procedure TEST_DOMAIN_DETECTION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "TEST_DOMAIN_DETECTION" 
AS
/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------
    -- TEST PROCEDURE FOR CONTEXT DOMAIN DETECTION SYSTEM
    -- Updated to reflect new cxd_classifier_llm_pkg.detect signature
    -- Date: 2025-11-26
    --------------------------------------------------------------------

    --------------------------------------------------------------------
    -- Types for LLM and Vector Test Cases
    --------------------------------------------------------------------
    TYPE test_case_rec IS RECORD (
        query_text      VARCHAR2(500),
        expected_code   VARCHAR2(50),
        description     VARCHAR2(200)
    );
    TYPE test_cases_tab IS TABLE OF test_case_rec;

    v_test_cases        test_cases_tab;
    v_domain_id         NUMBER;
    v_actual_code       VARCHAR2(50);
    v_domain_code       VARCHAR2(50);
    v_domain_name       VARCHAR2(200);

    v_llm_passed        NUMBER := 0;
    v_llm_failed        NUMBER := 0;
    v_llm_null_count    NUMBER := 0;
    v_vector_passed     NUMBER := 0;
    v_vector_failed     NUMBER := 0;

    --------------------------------------------------------------------
    -- NEW: Request and Response Records for LLM Classifier
    --------------------------------------------------------------------
    v_cxd_req           CXD_TYPES.t_cxd_classifier_req;
    v_cxd_resp_domain   CXD_TYPES.t_cxd_classifier_resp;
    v_cxd_resp_intent   CXD_TYPES.t_intent_classifier_resp;

    --------------------------------------------------------------------
    -- Performance Benchmark Variables (TEST 6)
    --------------------------------------------------------------------
    v_start_time        TIMESTAMP;
    v_end_time          TIMESTAMP;
    v_time_interval     INTERVAL DAY TO SECOND;
    v_llm_time          NUMBER;
    v_vector_time       NUMBER;

    --------------------------------------------------------------------
    -- Utility: Print Section Header
    --------------------------------------------------------------------
    PROCEDURE print_header(p_title IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
        DBMS_OUTPUT.PUT_LINE(p_title);
        DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    END;

    --------------------------------------------------------------------
    -- Utility: Print Test Result Line
    --------------------------------------------------------------------
    PROCEDURE print_result(p_test_num IN NUMBER, p_desc IN VARCHAR2, p_status IN VARCHAR2) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(
            'Test ' || p_test_num || ': ' ||
            RPAD(SUBSTR(p_desc, 1, 65), 68, '.') || ' ' || p_status
        );
    END;

    --------------------------------------------------------------------
    -- Utility: Convert Interval to Milliseconds (PL/SQL Safe)
    --------------------------------------------------------------------
    FUNCTION interval_to_ms(p_interval INTERVAL DAY TO SECOND) RETURN NUMBER IS
    BEGIN
        RETURN (
            EXTRACT(DAY    FROM p_interval) * 86400 +
            EXTRACT(HOUR   FROM p_interval) * 3600 +
            EXTRACT(MINUTE FROM p_interval) * 60 +
            EXTRACT(SECOND FROM p_interval)
        ) * 1000;
    END;

    --------------------------------------------------------------------
    -- Utility: Initialize Request Record for LLM Classifier
    --------------------------------------------------------------------
    PROCEDURE init_cxd_request(
        p_query_text    IN VARCHAR2,
        p_trace_id      IN VARCHAR2 DEFAULT NULL,
        p_req           OUT CXD_TYPES.t_cxd_classifier_req
    ) IS
    BEGIN
        p_req.trace_id               := NVL(p_trace_id, SYS_GUID());
        p_req.detection_method_code  := 'LLM';
        p_req.context_domain_id      := NULL;  -- No manual override
        p_req.provider               := 'OPENAI';  -- Default provider
        p_req.model                  := 'gpt-4o-mini';  -- Default model
        p_req.cxd_required           := 'Y';  -- Domain detection required
        p_req.user_prompt            := p_query_text;
        p_req.intent_required        := 'N';  -- Intent not required for domain tests
        p_req.intent_cxd_id          := NULL;
        p_req.chat_session_id        := 999999;  -- Test session
        p_req.user_id                := 4;  -- Test user
        p_req.user_name              := 'AI';
        p_req.app_session_id         := 88888;
        p_req.tenant_id              := 4;
        p_req.chat_project_id        := 0;
        p_req.app_id                 := 119;
        p_req.app_page_id            := 100;
    END;

BEGIN
    --------------------------------------------------------------------
    -- Main Header
    --------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    DBMS_OUTPUT.PUT_LINE('COMPREHENSIVE TESTING - CONTEXT DOMAIN DETECTION SYSTEM');
    DBMS_OUTPUT.PUT_LINE('DATE: ' || TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'));
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));

    --------------------------------------------------------------------
    -- TEST 1: Schema Validation
    --------------------------------------------------------------------
    print_header('TEST 1: Validating CONTEXT_DOMAINS table structure');

    FOR rec IN (
        SELECT
            CASE
                WHEN COUNT(*) = 5 THEN '✅ PASS'
                ELSE '❌ FAIL'
            END AS test_result,
            COUNT(*) AS columns_found
        FROM user_tab_columns
        WHERE table_name = 'CONTEXT_DOMAINS'
          AND column_name IN (
                'DOMAIN_EMBEDDING_VECTOR',
                'EMBEDDING_GENERATED_DATE',
                'EMBEDDING_MODEL_VERSION',
                'EMBEDDING_STATUS',
                'EMBEDDING_ERROR_MESSAGE'
          )
    ) LOOP
        print_result(1, 'CONTEXT_DOMAINS embedding columns', rec.test_result);
        DBMS_OUTPUT.PUT_LINE(
            '  (Found ' || rec.columns_found || ' of 5 expected metadata columns)'
        );
    END LOOP;

    --------------------------------------------------------------------
    -- TEST 2: Embedding Status
    --------------------------------------------------------------------
    print_header('TEST 2: Checking domain embeddings status');

    FOR rec IN (
        SELECT
            COUNT(*) AS total_active,
            SUM(CASE WHEN embedding_status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count
        FROM context_domains
        WHERE is_active = 'Y'
    ) LOOP
        IF rec.total_active = 0 THEN
            print_result(2, 'Domain embeddings generated', '⚠️ WARNING');
            DBMS_OUTPUT.PUT_LINE('  (No active domains found)');
        ELSIF rec.completed_count = rec.total_active THEN
            print_result(2, 'Domain embeddings generated', '✅ PASS');
        ELSIF rec.completed_count > 0 THEN
            print_result(2, 'Domain embeddings generated', '⚠️ PARTIAL');
        ELSE
            print_result(2, 'Domain embeddings generated', '❌ FAIL');
        END IF;

        DBMS_OUTPUT.PUT_LINE(
            '  Status: ' || rec.completed_count || ' of ' || rec.total_active ||
            ' completed (' ||
            ROUND(rec.completed_count * 100.0 / NULLIF(rec.total_active, 0), 1)
            || '%)'
        );
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('  Detailed Status:');
    FOR rec IN (
        SELECT context_domain_code, embedding_status
        FROM context_domains
        WHERE is_active = 'Y'
        ORDER BY embedding_status DESC, context_domain_code
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(
            '    ' || RPAD(rec.context_domain_code, 15) || ' -> ' || rec.embedding_status
        );
    END LOOP;

    --------------------------------------------------------------------
    -- TEST 3: LLM Classifier (UPDATED FOR NEW SIGNATURE)
    --------------------------------------------------------------------
    print_header('TEST 3: Testing LLM classifier (NEW SIGNATURE)');

    v_test_cases := test_cases_tab(
        test_case_rec('How many vacation days do I have?', 'HR', 'HR Query'),
        test_case_rec('What is my current salary?', 'PAYROLL', 'Payroll Query'),
        test_case_rec('Show me company policies', 'COMPLIANCE', 'Compliance Query'),
        test_case_rec('Who reports to me?', 'MANAGEMENT', 'Management Query')
    );

    DBMS_OUTPUT.PUT_LINE('Running ' || v_test_cases.COUNT || ' LLM test cases...');

    FOR i IN 1..v_test_cases.COUNT LOOP
        BEGIN
            -- Initialize request record
            init_cxd_request(
                p_query_text => v_test_cases(i).query_text,
                p_trace_id   => 'TEST_LLM_' || i,
                p_req        => v_cxd_req
            );

            -- Call NEW PROCEDURE signature (not FUNCTION)
            cxd_classifier_llm_pkg.detect(
                p_req              => v_cxd_req,
                p_response_domain  => v_cxd_resp_domain,
                p_response_intent  => v_cxd_resp_intent
            );

            -- Check if domain was detected successfully
            IF v_cxd_resp_domain.detect_status = 'SUCCESS' 
               AND v_cxd_resp_domain.context_domain_id IS NOT NULL THEN
                
                v_actual_code := v_cxd_resp_domain.context_domain_code;

                IF v_actual_code = v_test_cases(i).expected_code THEN
                    v_llm_passed := v_llm_passed + 1;
                    print_result(i, v_test_cases(i).description, '✅ PASS');
                    DBMS_OUTPUT.PUT_LINE(
                        '  (Domain: ' || v_cxd_resp_domain.context_domain_name || 
                        ' | Confidence: ' || 
                        ROUND(v_cxd_resp_domain.context_domain_confidence * 100, 1) || '%)'
                    );
                ELSE
                    v_llm_failed := v_llm_failed + 1;
                    print_result(i, v_test_cases(i).description, '⚠️ Different domain');
                    DBMS_OUTPUT.PUT_LINE(
                        '  (Expected: ' || v_test_cases(i).expected_code ||
                        ' | Actual: ' || v_actual_code || ')'
                    );
                END IF;
            ELSE
                v_llm_null_count := v_llm_null_count + 1;
                print_result(i, v_test_cases(i).description, '❌ FAIL');
                DBMS_OUTPUT.PUT_LINE(
                    '  Status: ' || v_cxd_resp_domain.detect_status ||
                    ' | Message: ' || v_cxd_resp_domain.message
                );
            END IF;

        EXCEPTION WHEN OTHERS THEN
            v_llm_failed := v_llm_failed + 1;
            print_result(i, v_test_cases(i).description, '❌ ERROR');
            DBMS_OUTPUT.PUT_LINE('  Error: ' || SQLERRM);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    DBMS_OUTPUT.PUT_LINE(
        'LLM Classifier Summary:  ' ||
        'Passed: ' || v_llm_passed ||
        ' | Failed: ' || v_llm_failed ||
        ' | Null: ' || v_llm_null_count
    );

    --------------------------------------------------------------------
    -- TEST 4: Semantic Vector Classifier
    --------------------------------------------------------------------
    print_header('TEST 4: Testing semantic vector classifier');

    v_test_cases := test_cases_tab(
        test_case_rec('Show my payslip details', NULL, 'Payroll query'),
        test_case_rec('I need to request time off', NULL, 'HR query'),
        test_case_rec('What are the compliance requirements?', NULL, 'Compliance query'),
        test_case_rec('Who are my direct reports?', NULL, 'Management query')
    );

    DBMS_OUTPUT.PUT_LINE('Running ' || v_test_cases.COUNT || ' vector test cases...');

    FOR i IN 1..v_test_cases.COUNT LOOP
        BEGIN
            -- Initialize request for semantic search
            init_cxd_request(
                p_query_text => v_test_cases(i).query_text,
                p_trace_id   => 'TEST_VECTOR_' || i,
                p_req        => v_cxd_req
            );
            
            -- Change detection method to SEMANTIC
            v_cxd_req.detection_method_code := 'SEMANTIC';

            -- Call semantic classifier (assuming similar signature pattern)
            cxd_classifier_semantic_pkg.detect(
                p_req              => v_cxd_req,
                p_response_domain  => v_cxd_resp_domain,
                p_response_intent  => v_cxd_resp_intent
            );

            IF v_cxd_resp_domain.detect_status = 'SUCCESS' 
               AND v_cxd_resp_domain.context_domain_id IS NOT NULL THEN
                
                v_vector_passed := v_vector_passed + 1;
                print_result(i, v_test_cases(i).description, '✅ PASS');
                DBMS_OUTPUT.PUT_LINE(
                    '  (Detected: ' || v_cxd_resp_domain.context_domain_code || 
                    ' - ' || v_cxd_resp_domain.context_domain_name || 
                    ' | Confidence: ' || 
                    ROUND(v_cxd_resp_domain.context_domain_confidence * 100, 1) || '%)'
                );
            ELSE
                v_vector_failed := v_vector_failed + 1;
                print_result(i, v_test_cases(i).description, '❌ FAIL');
                DBMS_OUTPUT.PUT_LINE(
                    '  Status: ' || v_cxd_resp_domain.detect_status ||
                    ' | Message: ' || v_cxd_resp_domain.message
                );
            END IF;

        EXCEPTION WHEN OTHERS THEN
            v_vector_failed := v_vector_failed + 1;
            print_result(i, v_test_cases(i).description, '❌ ERROR');
            DBMS_OUTPUT.PUT_LINE('  Error: ' || SQLERRM);
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
    DBMS_OUTPUT.PUT_LINE(
        'Vector Classifier Summary: Passed: ' || v_vector_passed ||
        ' | Failed: ' || v_vector_failed
    );

    --------------------------------------------------------------------
    -- TEST 5: Main Orchestrator
    --------------------------------------------------------------------
    print_header('TEST 5: Main Orchestrator (Full Integration)');

    v_test_cases := test_cases_tab(
        test_case_rec('How do I submit my timesheet?', NULL, 'Timesheet Query')
    );

    FOR i IN 1..v_test_cases.COUNT LOOP
        BEGIN
            -- Initialize request
            init_cxd_request(
                p_query_text => v_test_cases(i).query_text,
                p_trace_id   => 'TEST_ORCHESTRATOR_' || i,
                p_req        => v_cxd_req
            );
            
            -- Use AUTO detection method
            v_cxd_req.detection_method_code := 'AUTO';

            -- Call main orchestrator
            CXD_CLASSIFIER_PKG.detect(
                p_req              => v_cxd_req,
                p_resp_domain  => v_cxd_resp_domain,
                p_resp_intent  => v_cxd_resp_intent
            );

            IF v_cxd_resp_domain.detect_status = 'SUCCESS' 
               AND v_cxd_resp_domain.context_domain_id IS NOT NULL THEN
                
                print_result(i, v_test_cases(i).description, '✅ PASS');
                DBMS_OUTPUT.PUT_LINE(
                    '  Detected: ' || v_cxd_resp_domain.context_domain_code ||
                    ' | Method: ' || v_cxd_resp_domain.final_detection_method_code ||
                    ' | Confidence: ' || 
                    ROUND(v_cxd_resp_domain.context_domain_confidence * 100, 1) || '%'
                );
            ELSE
                print_result(i, v_test_cases(i).description, '❌ FAIL');
                DBMS_OUTPUT.PUT_LINE(
                    '  Status: ' || v_cxd_resp_domain.detect_status ||
                    ' | Message: ' || v_cxd_resp_domain.message
                );
            END IF;

        EXCEPTION WHEN OTHERS THEN
            print_result(i, v_test_cases(i).description, '❌ ERROR');
            DBMS_OUTPUT.PUT_LINE('  Error: ' || SQLERRM);
        END;
    END LOOP;

    --------------------------------------------------------------------
    -- TEST 6: Performance Benchmark
    --------------------------------------------------------------------
    print_header('TEST 6: Performance benchmark');

    v_test_cases := test_cases_tab(
        test_case_rec('What is my employee status?', NULL, 'Employee Status Query')
    );

    --------------------------------------------------------------------
    -- LLM Benchmark
    --------------------------------------------------------------------
    init_cxd_request(
        p_query_text => v_test_cases(1).query_text,
        p_trace_id   => 'BENCH_LLM',
        p_req        => v_cxd_req
    );
    v_cxd_req.detection_method_code := 'LLM';

    v_start_time := SYSTIMESTAMP;
    
    cxd_classifier_llm_pkg.detect(
        p_req              => v_cxd_req,
        p_response_domain  => v_cxd_resp_domain,
        p_response_intent  => v_cxd_resp_intent
    );
    
    v_end_time := SYSTIMESTAMP;
    v_time_interval := v_end_time - v_start_time;
    v_llm_time := interval_to_ms(v_time_interval);

    --------------------------------------------------------------------
    -- Vector Benchmark
    --------------------------------------------------------------------
    init_cxd_request(
        p_query_text => v_test_cases(1).query_text,
        p_trace_id   => 'BENCH_VECTOR',
        p_req        => v_cxd_req
    );
    v_cxd_req.detection_method_code := 'SEMANTIC';

    v_start_time := SYSTIMESTAMP;
    
    cxd_classifier_semantic_pkg.detect(
        p_req              => v_cxd_req,
        p_response_domain  => v_cxd_resp_domain,
        p_response_intent  => v_cxd_resp_intent
    );
    
    v_end_time := SYSTIMESTAMP;
    v_time_interval := v_end_time - v_start_time;
    v_vector_time := interval_to_ms(v_time_interval);

    --------------------------------------------------------------------
    -- Output Benchmark Results
    --------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE('Benchmark Query: ' || v_test_cases(1).query_text);
    DBMS_OUTPUT.PUT_LINE(
        '  LLM Classifier Time:     ' ||
        TO_CHAR(ROUND(v_llm_time, 2), '9990.99') || ' ms'
    );
    DBMS_OUTPUT.PUT_LINE(
        '  Vector Classifier Time:  ' ||
        TO_CHAR(ROUND(v_vector_time, 2), '9990.99') || ' ms'
    );

    IF v_vector_time > 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            '  Vector Speed Advantage:  ' ||
            ROUND(v_llm_time / v_vector_time, 1) || 'x faster'
        );
    END IF;

    --------------------------------------------------------------------
    -- Final Summary
    --------------------------------------------------------------------
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
    DBMS_OUTPUT.PUT_LINE('✅ COMPREHENSIVE TESTING COMPLETE');
    DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
        DBMS_OUTPUT.PUT_LINE('❌ CRITICAL ERROR IN TEST EXECUTION');
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
        DBMS_OUTPUT.PUT_LINE(RPAD('=', 80, '='));
        RAISE;
END TEST_DOMAIN_DETECTION;

/
