--------------------------------------------------------
--  DDL for Procedure PURGE_ALL_LOGS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "PURGE_ALL_LOGS" (
    p_owner IN VARCHAR2 DEFAULT USER
)
IS
/*******************************************************************************
 *  
 *******************************************************************************/
    v_log_core_table     VARCHAR2(128) := p_owner || '.LOG_CORE';
BEGIN
    -- Ensure server output is enabled for logging the steps
    DBMS_OUTPUT.ENABLE(NULL);
    DBMS_OUTPUT.PUT_LINE('--- Starting LOG PURGE (TRUNCATE CASCADE) for ' || v_log_core_table || ' ---');

    -- TRUNCATE TABLE ... CASCADE automatically truncates all dependent child tables,
    -- bypassing the complex restrictions imposed by Reference Partitioning.
    DBMS_OUTPUT.PUT_LINE('1. Executing TRUNCATE TABLE ' || v_log_core_table || ' CASCADE...');

    EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || v_log_core_table || ' CASCADE';

    DBMS_OUTPUT.PUT_LINE('-> Table ' || v_log_core_table || ' and all child log tables truncated successfully.');
    DBMS_OUTPUT.PUT_LINE('--- Log Purge Complete. All database constraints remain enabled. ---');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '!!! ERROR: Purge failed unexpectedly. SQLERRM: ' || SQLERRM);
        RAISE;

END purge_all_logs;

/
