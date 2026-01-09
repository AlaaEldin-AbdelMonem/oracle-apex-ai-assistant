--------------------------------------------------------
--  DDL for Package TEST_DEBUG_UTIL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."TEST_DEBUG_UTIL_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      TEST_DEBUG_UTIL_PKG (Specification)
 * PURPOSE:     Unit and Integration Testing for DEBUG_UTIL.
 *
 * DESCRIPTION: Provides a comprehensive test suite to validate the 
 * hierarchical configuration logic of the debugging engine. It verifies:
 * - Scope priorities (Session vs. User vs. App vs. Global).
 * - Correct log level filtering (ERROR > INFO > DEBUG).
 * - Data integrity for large CLOBs and autonomous transactions.
 * - Performance benchmarks for "is_on" checks.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'TEST_DEBUG_UTIL_PKG'; 

    /*******************************************************************************
     * TEST ENVIRONMENT SETUP
     *******************************************************************************/

    /** * Resets DEBUG_CONFIG and DEBUG_LOG tables to a known state to ensure 
     * idempotent test results. 
     */
    PROCEDURE reset_environment;

    /*******************************************************************************
     * CORE LOGIC & FILTERING TESTS
     *******************************************************************************/

    /** Scenario: Global debug disabled => No logs should be written. */
    PROCEDURE test_global_disabled;

    /** Scenario: Global level set to INFO => Only INFO & ERROR logged, DEBUG ignored. */
    PROCEDURE test_global_info_level;

    /** Scenario: Module-specific config should override the Global default. */
    PROCEDURE test_module_scope_overrides_global;

    /** Scenario: Verifies that logs share a common Trace ID and map correctly. */
    PROCEDURE test_trace_id_grouping;

    /*******************************************************************************
     * HIERARCHICAL SCOPE PRIORITY TESTS
     *******************************************************************************/

    PROCEDURE test_session_scope_highest_priority;
    PROCEDURE test_user_scope_priority;
    PROCEDURE test_app_scope_priority;
    PROCEDURE test_no_config_defaults_disabled;

    /*******************************************************************************
     * DATA INTEGRITY & ARCHITECTURE TESTS
     *******************************************************************************/

    PROCEDURE test_log_fields_populated;
    
    /** Validates that logs persist even if the parent transaction rolls back. */
    PROCEDURE test_autonomous_transaction_persists;
    
    /** Verifies handling of 32KB+ payloads in the extra_data columns. */
    PROCEDURE test_large_clob_extra_data;
    PROCEDURE test_large_clob_extra_data2;
    
    PROCEDURE test_module_name_field_populated;
    PROCEDURE test_procedure_name_derived;
    PROCEDURE test_log_timestamp_accurate;
    PROCEDURE test_null_vs_empty_clob;
    PROCEDURE test_multiple_modules_same_session;

    /*******************************************************************************
     * PERFORMANCE BENCHMARKING
     *******************************************************************************/

    /** Measures CPU cycles for repeated 'is_on' checks to ensure zero-lag production use. */
    PROCEDURE test_is_on_performance_overhead;

END test_debug_util_pkg;

/
