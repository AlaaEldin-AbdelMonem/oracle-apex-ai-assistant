--------------------------------------------------------
--  DDL for Package Body TEST_DEBUG_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."TEST_DEBUG_UTIL_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE reset_environment IS
            vcaller constant varchar2(70) := c_package_name||'.'||'reset_environment';

    BEGIN
        -- KEY FIX: Reset state BEFORE clearing data
        debug_util.reset_state;

        DELETE FROM debug_config;
        DELETE FROM debug_log;
        COMMIT;

        DBMS_OUTPUT.put_line('Environment reset: DEBUG_CONFIG and DEBUG_LOG cleared.');
    END reset_environment;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE test_global_disabled IS
        v_cnt NUMBER;
            vcaller constant varchar2(70) := c_package_name||'.'||'test_global_disabled';
       BEGIN
        reset_environment;

        INSERT INTO debug_config (
            is_enabled, scope_level, min_debug_level, created_by
        ) VALUES (
            'N', 'GLOBAL', 3, 'TEST'
        );
        COMMIT;

        -- KEY FIX: Use p_force_reinit => TRUE
        debug_util.init(
            p_app_id       => 100,
            p_user_id      => 1,
            p_session_id   => 12345,
            p_module_name  => 'TEST_MODULE',
            p_force_reinit => TRUE
        );

        debug_util.info('This should NOT be logged',vcaller);
        debug_util.error('This should also NOT be logged',vcaller);

        SELECT COUNT(*) INTO v_cnt FROM debug_log;

        DBMS_OUTPUT.put_line('test_global_disabled: rows in DEBUG_LOG = ' || v_cnt || ' (expected: 0)');
    END test_global_disabled;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE test_global_info_level IS
        vcaller constant varchar2(70) := c_package_name||'.'||'test_global_info_level';
        v_total   NUMBER;
        v_info    NUMBER;
        v_debug   NUMBER;
    BEGIN
        reset_environment;

        INSERT INTO debug_config (
            is_enabled, scope_level, min_debug_level, created_by
        ) VALUES (
            'Y', 'GLOBAL', 3, 'TEST'
        );
        COMMIT;

        debug_util.init(
            p_app_id       => 100,
            p_user_id      => 1,
            p_session_id   => 12345,
            p_module_name  => 'TEST_MODULE',
            p_force_reinit => TRUE
        );

        debug_util.error('Global INFO test - ERROR message',vcaller);
        debug_util.warn('Global INFO test - WARN message',vcaller);
        debug_util.info('Global INFO test - INFO message',vcaller);
      --  debug_util.debug('Global INFO test - DEBUG message (should be filtered)');

        SELECT COUNT(*) INTO v_total FROM debug_log;
        SELECT COUNT(*) INTO v_info FROM debug_log WHERE debug_level IN (1,2,3);
        SELECT COUNT(*) INTO v_debug FROM debug_log WHERE debug_level = 4;

        DBMS_OUTPUT.put_line('test_global_info_level: total=' || v_total || ', info-block=' || v_info || ', debug=' || v_debug);
        DBMS_OUTPUT.put_line('  (expected: total=3, info-block=3, debug=0)');
    END test_global_info_level;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE test_module_scope_overrides_global IS
        vcaller constant varchar2(70) := c_package_name||'.'||'test_module_scope_overrides_global';
        v_total NUMBER;
    BEGIN
        reset_environment;

        INSERT INTO debug_config (
            is_enabled, scope_level, min_debug_level, created_by
        ) VALUES (
            'Y', 'GLOBAL', 1, 'TEST'
        );

        INSERT INTO debug_config (
            is_enabled, scope_level, module_name, min_debug_level, created_by
        ) VALUES (
            'Y', 'MODULE', 'TEST_MODULE2', 4, 'TEST'
        );
        COMMIT;

        debug_util.init(
            p_app_id       => 200,
            p_user_id      => 2,
            p_session_id   => 54321,
            p_module_name  => 'TEST_MODULE2',
            p_force_reinit => TRUE
        );

        debug_util.info('Module scope test - INFO should be logged', 'TRACE-MODULE-1');
       -- debug_util.debug('Module scope test - DEBUG should be logged', 'TRACE-MODULE-1');

        SELECT COUNT(*) INTO v_total FROM debug_log;

        DBMS_OUTPUT.put_line('test_module_scope_overrides_global: rows=' || v_total || ' (expected: 2)');
    END test_module_scope_overrides_global;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE test_trace_id_grouping IS
        vcaller constant varchar2(70) := c_package_name||'.'||'test_trace_id_grouping';
        v_trace_id1 VARCHAR2(100) := 'TRACE-001';
        v_trace_id2 VARCHAR2(100) := 'TRACE-002';
        v_cnt1      NUMBER;
        v_cnt2      NUMBER;
    BEGIN
        reset_environment;

        INSERT INTO debug_config (
            is_enabled, scope_level, min_debug_level, created_by
        ) VALUES (
            'Y', 'GLOBAL', 4, 'TEST'
        );
        COMMIT;

        debug_util.init(
            p_app_id       => 300,
            p_user_id      => 3,
            p_session_id   => 99999,
            p_module_name  => 'TRACE_TEST',
            p_force_reinit => TRUE
        );

        debug_util.info('Message A1', v_trace_id1);
        debug_util.debug('Message A2', v_trace_id1);

        debug_util.info('Message B1', v_trace_id2);
        debug_util.error('Message B2', v_trace_id2);

        SELECT COUNT(*) INTO v_cnt1 FROM debug_log WHERE trace_id = v_trace_id1;
        SELECT COUNT(*) INTO v_cnt2 FROM debug_log WHERE trace_id = v_trace_id2;

        DBMS_OUTPUT.put_line('test_trace_id_grouping: TRACE-001=' || v_cnt1 || ', TRACE-002=' || v_cnt2);
        DBMS_OUTPUT.put_line('  (expected: TRACE-001=2, TRACE-002=2)');
    END test_trace_id_grouping;
/*******************************************************************************
 *  
 *******************************************************************************/

   PROCEDURE test_session_scope_highest_priority IS
    vcaller constant varchar2(70) := c_package_name||'.'||'test_session_scope_highest_priority';
    v_total NUMBER;
BEGIN
    reset_environment;

    -- GLOBAL: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );

    -- MODULE: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, module_name, min_debug_level, created_by
    ) VALUES (
        'Y', 'MODULE', 'TEST_MODULE', 4, 'TEST'
    );

    -- APP: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, app_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'APP', 100, 4, 'TEST'
    );

    -- SESSION: ERROR (1) - should WIN over all others
    INSERT INTO debug_config (
        is_enabled, scope_level, session_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'SESSION', 12345, 1, 'TEST'
    );
    COMMIT;

    debug_util.init(
        p_app_id       => 100,
        p_user_id      => 1,
        p_session_id   => 12345,
        p_module_name  => 'TEST_MODULE',
        p_force_reinit => TRUE
    );

    -- Only ERROR should be logged (SESSION scope = ERROR)
    debug_util.error('SESSION test - ERROR (should log)',vcaller);
    debug_util.warn('SESSION test - WARN (should NOT log)',vcaller);
    debug_util.info('SESSION test - INFO (should NOT log)',vcaller);
    debug_util.debug('SESSION test - DEBUG (should NOT log)',vcaller);

    SELECT COUNT(*) INTO v_total FROM debug_log;

    DBMS_OUTPUT.put_line('test_session_scope_highest_priority: rows=' || v_total || ' (expected: 1)');
    
    -- Verify scope_level stored correctly
    DECLARE
        v_scope VARCHAR2(30);
    BEGIN
        SELECT scope_level INTO v_scope 
        FROM debug_log 
        WHERE ROWNUM = 1;
        
        IF v_scope = 'SESSION' THEN
            DBMS_OUTPUT.put_line('  ✓ scope_level=SESSION correctly stored');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: scope_level=' || v_scope || ' (expected: SESSION)');
        END IF;
    END;
END test_session_scope_highest_priority;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 6: USER scope overrides MODULE/APP/GLOBAL
------------------------------------------------------------------------------
PROCEDURE test_user_scope_priority IS
    vcaller constant varchar2(70) := c_package_name||'.'||'test_user_scope_priority';
    v_total NUMBER;
BEGIN
    reset_environment;

    -- GLOBAL: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );

    -- MODULE: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, module_name, min_debug_level, created_by
    ) VALUES (
        'Y', 'MODULE', 'TEST_MODULE', 4, 'TEST'
    );

    -- APP: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, app_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'APP', 100, 4, 'TEST'
    );

    -- USER: WARN (2) - should override MODULE, APP, GLOBAL
    INSERT INTO debug_config (
        is_enabled, scope_level, user_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'USER', 1, 2, 'TEST'
    );
    COMMIT;

    debug_util.init(
        p_app_id       => 100,
        p_user_id      => 1,
        p_session_id   => 12345,
        p_module_name  => 'TEST_MODULE',
        p_force_reinit => TRUE
    );

    -- Only ERROR and WARN should be logged (USER scope = WARN)
    debug_util.error('USER test - ERROR (should log)',vcaller);
    debug_util.warn('USER test - WARN (should log)',vcaller);
    debug_util.info('USER test - INFO (should NOT log)',vcaller);
    debug_util.debug('USER test - DEBUG (should NOT log)',vcaller);

    SELECT COUNT(*) INTO v_total FROM debug_log;

    DBMS_OUTPUT.put_line('test_user_scope_priority: rows=' || v_total || ' (expected: 2)');
END test_user_scope_priority;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 7: APP scope overrides GLOBAL
------------------------------------------------------------------------------
PROCEDURE test_app_scope_priority IS
    vcaller constant varchar2(70) := c_package_name||'.'||'test_app_scope_priority';
    v_total NUMBER;
BEGIN
    reset_environment;

    -- GLOBAL: DEBUG (4)
    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );

    -- APP: ERROR (1) - should override GLOBAL
    INSERT INTO debug_config (
        is_enabled, scope_level, app_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'APP', 100, 1, 'TEST'
    );
    COMMIT;

    debug_util.init(
        p_app_id       => 100,
        p_user_id      => 1,
        p_session_id   => 12345,
        p_force_reinit => TRUE
    );

    -- Only ERROR should be logged (APP scope = ERROR)
    debug_util.error('APP test - ERROR (should log)',vcaller);
    debug_util.warn('APP test - WARN (should NOT log)',vcaller);
    debug_util.info('APP test - INFO (should NOT log)',vcaller);

    SELECT COUNT(*) INTO v_total FROM debug_log;

    DBMS_OUTPUT.put_line('test_app_scope_priority: rows=' || v_total || ' (expected: 1)');
END test_app_scope_priority;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 8: No configuration = defaults to disabled
------------------------------------------------------------------------------
PROCEDURE test_no_config_defaults_disabled IS
     vcaller constant varchar2(70) := c_package_name||'.'||'test_no_config_defaults_disabled';
    v_total NUMBER;
BEGIN
    reset_environment;

    -- No INSERT - config table is empty

    debug_util.init(
        p_app_id       => 100,
        p_user_id      => 1,
        p_session_id   => 12345,
        p_force_reinit => TRUE
    );

    -- Nothing should be logged
    debug_util.error('No config - ERROR (should NOT log)',vcaller);
    debug_util.info('No config - INFO (should NOT log)',vcaller);

    SELECT COUNT(*) INTO v_total FROM debug_log;

    DBMS_OUTPUT.put_line('test_no_config_defaults_disabled: rows=' || v_total || ' (expected: 0)');
END test_no_config_defaults_disabled;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 9: Verify log fields are populated correctly
------------------------------------------------------------------------------
PROCEDURE test_log_fields_populated IS
     vcaller constant varchar2(70) := c_package_name||'.'||'test_log_fields_populated';
    v_app_id      NUMBER;
    v_user_id     NUMBER;
    v_session_id  NUMBER;
    v_scope       VARCHAR2(30);
    v_module      VARCHAR2(100);
    v_trace       VARCHAR2(100);
    v_success     BOOLEAN := TRUE;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(
        p_app_id       => 999,
        p_user_id      => 888,
        p_session_id   => 777,
        p_module_name  => 'FIELD_TEST',
        p_force_reinit => TRUE
    );

    debug_util.info('Field validation test', 'TRACE-FIELD-001');

    -- Verify all fields
    BEGIN
        SELECT app_id, user_id, session_id, scope_level, module_name, trace_id
          INTO v_app_id, v_user_id, v_session_id, v_scope, v_module, v_trace
          FROM debug_log
         WHERE ROWNUM = 1;

        DBMS_OUTPUT.put_line('test_log_fields_populated:');
        
        IF v_app_id = 999 THEN
            DBMS_OUTPUT.put_line('  ✓ app_id=999');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: app_id=' || v_app_id);
            v_success := FALSE;
        END IF;

        IF v_user_id = 888 THEN
            DBMS_OUTPUT.put_line('  ✓ user_id=888');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: user_id=' || v_user_id);
            v_success := FALSE;
        END IF;

        IF v_session_id = 777 THEN
            DBMS_OUTPUT.put_line('  ✓ session_id=777');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: session_id=' || v_session_id);
            v_success := FALSE;
        END IF;

        IF v_scope = 'GLOBAL' THEN
            DBMS_OUTPUT.put_line('  ✓ scope_level=GLOBAL');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: scope_level=' || v_scope);
            v_success := FALSE;
        END IF;

        IF v_trace = 'TRACE-FIELD-001' THEN
            DBMS_OUTPUT.put_line('  ✓ trace_id=TRACE-FIELD-001');
        ELSE
            DBMS_OUTPUT.put_line('  ✗ FAIL: trace_id=' || v_trace);
            v_success := FALSE;
        END IF;

        IF v_success THEN
            DBMS_OUTPUT.put_line('  ✓ PASS: All fields populated correctly');
        END IF;
    END;
END test_log_fields_populated;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 10: Autonomous transaction - logs persist after rollback
------------------------------------------------------------------------------
PROCEDURE test_autonomous_transaction_persists IS
    vcaller constant varchar2(70) := c_package_name||'.'||'test_autonomous_transaction_persists';
    v_before NUMBER;
    v_after  NUMBER;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    SELECT COUNT(*) INTO v_before FROM debug_log;

    -- Start a transaction that we'll rollback
    INSERT INTO debug_config (
        is_enabled, scope_level, app_id, min_debug_level, created_by
    ) VALUES (
        'Y', 'APP', 999, 4, 'TEMP'
    );

    -- Log something (should use AUTONOMOUS_TRANSACTION)
    debug_util.info('Autonomous transaction test', 'TRACE-AUTO-001');

    -- Rollback the main transaction
    ROLLBACK;

    -- Verify the config insert was rolled back
    DECLARE
        v_cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_cnt 
        FROM debug_config 
        WHERE app_id = 999;
        
        IF v_cnt = 0 THEN
            DBMS_OUTPUT.put_line('test_autonomous_transaction_persists:');
            DBMS_OUTPUT.put_line('  ✓ Config rollback successful');
        END IF;
    END;

    -- But the log should persist (autonomous transaction)
    SELECT COUNT(*) INTO v_after FROM debug_log;

    IF v_after > v_before THEN
        DBMS_OUTPUT.put_line('  ✓ PASS: Log persisted despite rollback (before=' || v_before || ', after=' || v_after || ')');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: Log was rolled back (before=' || v_before || ', after=' || v_after || ')');
    END IF;
END test_autonomous_transaction_persists;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 11: Large CLOB handling in extra_data
------------------------------------------------------------------------------
PROCEDURE test_large_clob_extra_data IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_large_clob_extra_data';
    v_large_clob CLOB;
    v_retrieved  CLOB;
    v_size       NUMBER;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    -- Build large CLOB (>10KB)
    v_large_clob := RPAD('X', 10000, 'X');

    -- Log with large CLOB
    debug_util.log(
        p_message    => 'Large CLOB test',
        p_level      => debug_util.c_info,
        p_extra_data => v_large_clob,
        p_trace_id   => 'TRACE-CLOB-001'
    ,p_caller => vcaller);

    -- Verify it was stored
    SELECT extra_data INTO v_retrieved 
    FROM debug_log 
    WHERE trace_id = 'TRACE-CLOB-001';

    v_size := DBMS_LOB.GETLENGTH(v_retrieved);

    IF v_size = 10000 THEN
        DBMS_OUTPUT.put_line('test_large_clob_extra_data: ✓ PASS (CLOB size=' || v_size || ')');
    ELSE
        DBMS_OUTPUT.put_line('test_large_clob_extra_data: ✗ FAIL (expected 10000, got ' || v_size || ')');
    END IF;
END test_large_clob_extra_data;
/*******************************************************************************
 *  
 *******************************************************************************/
 
-- TEST 16: Verify module_name field is populated correctly
------------------------------------------------------------------------------
PROCEDURE test_module_name_field_populated IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_module_name_field_populated';
    v_module VARCHAR2(100);
    v_success BOOLEAN := TRUE;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    -- Test 1: Explicit module name via init()
    debug_util.init(
        p_app_id       => 100,
        p_module_name  => 'EXPLICIT_MODULE',
        p_force_reinit => TRUE
    );

    debug_util.info('Test explicit module', 'TRACE-MOD-001');

    SELECT module_name INTO v_module 
    FROM debug_log 
    WHERE trace_id = 'TRACE-MOD-001';

    DBMS_OUTPUT.put_line('test_module_name_field_populated:');
    IF v_module = 'TEST_DEBUG_UTIL_PKG' THEN  -- Should be calling package name
        DBMS_OUTPUT.put_line('  ✓ module_name=' || v_module);
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: module_name=' || v_module);
        v_success := FALSE;
    END IF;

    -- Test 2: Override module name via log()
    debug_util.log(
        p_message     => 'Test module override',
        p_level       => debug_util.c_info,
        p_caller => 'OVERRIDE_MODULE',
        p_trace_id    => 'TRACE-MOD-002'
    );

    SELECT module_name INTO v_module 
    FROM debug_log 
    WHERE trace_id = 'TRACE-MOD-002';

    IF v_module = 'OVERRIDE_MODULE' THEN
        DBMS_OUTPUT.put_line('  ✓ module_name override works: ' || v_module);
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: module_name=' || v_module);
        v_success := FALSE;
    END IF;

    IF v_success THEN
        DBMS_OUTPUT.put_line('  ✓ PASS: module_name field validated');
    END IF;
END test_module_name_field_populated;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 17: Verify procedure_name is derived from call stack
------------------------------------------------------------------------------
PROCEDURE test_procedure_name_derived IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_procedure_name_derived';
    v_proc VARCHAR2(4000);
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    -- Call from this procedure - should capture procedure name
    debug_util.info('Test procedure name derivation', 'TRACE-PROC-001');

    SELECT procedure_name INTO v_proc 
    FROM debug_log 
    WHERE trace_id = 'TRACE-PROC-001';

    DBMS_OUTPUT.put_line('test_procedure_name_derived:');
    IF v_proc IS NOT NULL THEN
        DBMS_OUTPUT.put_line('  ✓ procedure_name derived: ' || v_proc);
        DBMS_OUTPUT.put_line('  ✓ PASS: procedure_name field populated');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: procedure_name is NULL');
    END IF;

    -- Test explicit override
    debug_util.log(
        p_message   => 'Test explicit procedure',
        p_level     => debug_util.c_info,
        p_caller => 'EXPLICIT_PROCEDURE_NAME',
        p_trace_id  => 'TRACE-PROC-002'
    );

    SELECT procedure_name INTO v_proc 
    FROM debug_log 
    WHERE trace_id = 'TRACE-PROC-002';

    IF v_proc = 'EXPLICIT_PROCEDURE_NAME' THEN
        DBMS_OUTPUT.put_line('  ✓ explicit procedure_name works: ' || v_proc);
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: procedure_name=' || v_proc);
    END IF;
END test_procedure_name_derived;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 18: Verify log_timestamp is accurate
------------------------------------------------------------------------------
PROCEDURE test_log_timestamp_accurate IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_log_timestamp_accurate';
    v_before    TIMESTAMP;
    v_log_ts    TIMESTAMP;
    v_after     TIMESTAMP;
    v_diff_ms   NUMBER;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    -- Capture time before logging
    v_before := SYSTIMESTAMP;
    
    -- Log something
    debug_util.info('Timestamp accuracy test', 'TRACE-TS-001');
    
    -- Capture time after logging
    v_after := SYSTIMESTAMP;

    -- Retrieve log timestamp
    SELECT LOG_TS INTO v_log_ts 
    FROM debug_log 
    WHERE trace_id = 'TRACE-TS-001';

    -- Calculate difference in milliseconds
    v_diff_ms := EXTRACT(SECOND FROM (v_log_ts - v_before)) * 1000;

    DBMS_OUTPUT.put_line('test_log_timestamp_accurate:');
    DBMS_OUTPUT.put_line('  Before: ' || TO_CHAR(v_before, 'HH24:MI:SS.FF3'));
    DBMS_OUTPUT.put_line('  Logged: ' || TO_CHAR(v_log_ts, 'HH24:MI:SS.FF3'));
    DBMS_OUTPUT.put_line('  After:  ' || TO_CHAR(v_after, 'HH24:MI:SS.FF3'));
    
    -- Timestamp should be between before and after (within 5 seconds tolerance)
    IF v_log_ts BETWEEN v_before AND v_after + INTERVAL '5' SECOND THEN
        DBMS_OUTPUT.put_line('  ✓ PASS: Timestamp is accurate (within tolerance)');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: Timestamp outside expected range');
    END IF;
END test_log_timestamp_accurate;
/*******************************************************************************
 *  
 *******************************************************************************/
-- ============================================================================
-- SECTION 2: CLOB HANDLING
-- Add to: TEST_DEBUG_UTIL_PKG
-- ============================================================================

------------------------------------------------------------------------------
-- TEST 19: Large CLOB handling (already provided, but enhanced version)
------------------------------------------------------------------------------
PROCEDURE test_large_clob_extra_data2 IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_large_clob_extra_data2';
    v_large_clob CLOB;
    v_retrieved  CLOB;
    v_size       NUMBER;
    v_chunk_size NUMBER := 50000; -- 50KB
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    -- Build large CLOB (50KB of JSON-like data)
    DBMS_LOB.CREATETEMPORARY(v_large_clob, TRUE);
    FOR i IN 1..1000 LOOP
        DBMS_LOB.APPEND(v_large_clob, RPAD('{"field":"' || i || '",', 50, 'x') || '"}');
    END LOOP;

    v_size := DBMS_LOB.GETLENGTH(v_large_clob);
    DBMS_OUTPUT.put_line('test_large_clob_extra_data: Created CLOB of ' || v_size || ' bytes');

    -- Log with large CLOB
    debug_util.log(
        p_message    => 'Large CLOB test',
        p_level      => debug_util.c_info,
        p_extra_data => v_large_clob,
        p_trace_id   => 'TRACE-CLOB-001',
        p_caller=> vcaller);
   

    -- Verify it was stored completely
    SELECT extra_data INTO v_retrieved 
    FROM debug_log 
    WHERE trace_id = 'TRACE-CLOB-001';

    v_size := DBMS_LOB.GETLENGTH(v_retrieved);

    IF v_size > 40000 THEN  -- Should be around 50KB
        DBMS_OUTPUT.put_line('  ✓ PASS: Large CLOB stored (size=' || v_size || ' bytes)');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: CLOB truncated (expected ~50000, got ' || v_size || ')');
    END IF;

    DBMS_LOB.FREETEMPORARY(v_large_clob);
END test_large_clob_extra_data2;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 20: NULL vs empty CLOB handling
------------------------------------------------------------------------------
PROCEDURE test_null_vs_empty_clob IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_null_vs_empty_clob';
    v_data_null  CLOB;
    v_data_empty CLOB;
    v_null_count NUMBER;
    v_empty_size NUMBER;
BEGIN
    reset_environment;

    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 4, 'TEST'
    );
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    -- Test 1: NULL extra_data
    debug_util.log(
        p_message    => 'NULL CLOB test',
        p_level      => debug_util.c_info,
        p_extra_data => NULL,
        p_trace_id   => 'TRACE-NULL-001'  , p_caller=> vcaller
    );

    SELECT COUNT(*) INTO v_null_count
    FROM debug_log 
    WHERE trace_id = 'TRACE-NULL-001' 
      AND extra_data IS NULL;

    -- Test 2: Empty CLOB
    DBMS_LOB.CREATETEMPORARY(v_data_empty, TRUE);
    -- Leave it empty

    debug_util.log(
        p_message    => 'Empty CLOB test',
        p_level      => debug_util.c_info,
        p_extra_data => v_data_empty,
        p_trace_id   => 'TRACE-EMPTY-001', p_caller=> vcaller
    );

    SELECT NVL(DBMS_LOB.GETLENGTH(extra_data), 0) INTO v_empty_size
    FROM debug_log 
    WHERE trace_id = 'TRACE-EMPTY-001';

    DBMS_OUTPUT.put_line('test_null_vs_empty_clob:');
    IF v_null_count = 1 THEN
        DBMS_OUTPUT.put_line('  ✓ NULL CLOB handled correctly');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: NULL CLOB not stored as NULL');
    END IF;

    IF v_empty_size = 0 THEN
        DBMS_OUTPUT.put_line('  ✓ Empty CLOB handled correctly');
        DBMS_OUTPUT.put_line('  ✓ PASS: Both NULL and empty CLOBs work');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: Empty CLOB has unexpected size: ' || v_empty_size);
    END IF;

    DBMS_LOB.FREETEMPORARY(v_data_empty);
END test_null_vs_empty_clob;
/*******************************************************************************
 *  
 *******************************************************************************/
-- ============================================================================
-- SECTION 3: CONTEXT SWITCHING & MULTI-MODULE
-- Add to: TEST_DEBUG_UTIL_PKG
-- ============================================================================

------------------------------------------------------------------------------
-- TEST 21: Multiple modules in same session with different debug levels
------------------------------------------------------------------------------
PROCEDURE test_multiple_modules_same_session IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_multiple_modules_same_session';
    v_module1_count NUMBER;
    v_module2_count NUMBER;
    v_total_count   NUMBER;
BEGIN
    reset_environment;

    -- GLOBAL: ERROR only
    INSERT INTO debug_config (
        is_enabled, scope_level, min_debug_level, created_by
    ) VALUES (
        'Y', 'GLOBAL', 1, 'TEST'
    );

    -- MODULE1: DEBUG level
    INSERT INTO debug_config (
        is_enabled, scope_level, module_name, min_debug_level, created_by
    ) VALUES (
        'Y', 'MODULE', 'MODULE_A', 4, 'TEST'
    );

    -- MODULE2: INFO level
    INSERT INTO debug_config (
        is_enabled, scope_level, module_name, min_debug_level, created_by
    ) VALUES (
        'Y', 'MODULE', 'MODULE_B', 3, 'TEST'
    );
    COMMIT;

    DBMS_OUTPUT.put_line('test_multiple_modules_same_session:');

    -- Simulate MODULE_A logging (DEBUG enabled)
    debug_util.reset_state;
    debug_util.init(
        p_app_id       => 100,
        p_session_id   => 88888,
        p_module_name  => 'MODULE_A',
        p_force_reinit => TRUE
    );

    debug_util.error('MODULE_A: ERROR log', 'TRACE-MULTI-A');
    debug_util.info('MODULE_A: INFO log', 'TRACE-MULTI-A');
    debug_util.debug('MODULE_A: DEBUG log', 'TRACE-MULTI-A');

    -- Simulate MODULE_B logging (INFO enabled)
    debug_util.reset_state;
    debug_util.init(
        p_app_id       => 100,
        p_session_id   => 88888,
        p_module_name  => 'MODULE_B',
        p_force_reinit => TRUE
    );

    debug_util.error('MODULE_B: ERROR log', 'TRACE-MULTI-B');
    debug_util.info('MODULE_B: INFO log', 'TRACE-MULTI-B');
    debug_util.debug('MODULE_B: DEBUG log (should NOT log)', 'TRACE-MULTI-B');

    -- Count logs per module
    SELECT COUNT(*) INTO v_module1_count
    FROM debug_log
    WHERE trace_id = 'TRACE-MULTI-A';

    SELECT COUNT(*) INTO v_module2_count
    FROM debug_log
    WHERE trace_id = 'TRACE-MULTI-B';

    SELECT COUNT(*) INTO v_total_count
    FROM debug_log;

    DBMS_OUTPUT.put_line('  MODULE_A logs (DEBUG enabled): ' || v_module1_count || ' (expected: 3)');
    DBMS_OUTPUT.put_line('  MODULE_B logs (INFO enabled):  ' || v_module2_count || ' (expected: 2)');
    DBMS_OUTPUT.put_line('  Total logs: ' || v_total_count || ' (expected: 5)');

    IF v_module1_count = 3 AND v_module2_count = 2 AND v_total_count = 5 THEN
        DBMS_OUTPUT.put_line('  ✓ PASS: Multiple modules with different levels work correctly');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: Module context switching failed');
    END IF;
END test_multiple_modules_same_session;

/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- TEST 22: is_on() performance overhead when disabled
------------------------------------------------------------------------------
PROCEDURE test_is_on_performance_overhead IS
            vcaller constant varchar2(70) := c_package_name||'.'||'test_is_on_performance_overhead';
    v_start     TIMESTAMP;
    v_end       TIMESTAMP;
    v_elapsed_ms NUMBER;
    v_iterations NUMBER := 10000;
BEGIN
    reset_environment;

    -- No config = disabled
    COMMIT;

    debug_util.init(p_force_reinit => TRUE);

    DBMS_OUTPUT.put_line('test_is_on_performance_overhead:');
    DBMS_OUTPUT.put_line('  Testing ' || v_iterations || ' iterations...');

    v_start := SYSTIMESTAMP;

    -- Call is_on() many times (should be fast when disabled)
    FOR i IN 1..v_iterations LOOP
        IF debug_util.is_on(debug_util.c_debug) THEN
            NULL; -- Won't execute since debug is disabled
        END IF;
    END LOOP;

    v_end := SYSTIMESTAMP;
    v_elapsed_ms := EXTRACT(SECOND FROM (v_end - v_start)) * 1000;

    DBMS_OUTPUT.put_line('  Elapsed time: ' || ROUND(v_elapsed_ms, 2) || ' ms');
    DBMS_OUTPUT.put_line('  Per call: ' || ROUND(v_elapsed_ms / v_iterations, 4) || ' ms');

    -- Should be very fast (< 1 second for 10,000 calls)
    IF v_elapsed_ms < 1000 THEN
        DBMS_OUTPUT.put_line('  ✓ PASS: is_on() has minimal overhead when disabled');
    ELSE
        DBMS_OUTPUT.put_line('  ✗ FAIL: is_on() overhead is too high: ' || v_elapsed_ms || ' ms');
    END IF;
END test_is_on_performance_overhead;
/*******************************************************************************
 *  
 *******************************************************************************/
END test_debug_util_pkg;

/
