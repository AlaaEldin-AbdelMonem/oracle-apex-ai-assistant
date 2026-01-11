--------------------------------------------------------
--  DDL for Package AUDIT_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AUDIT_UTIL" AS
/*****************************************************************************
 * PROJECT:      Oracle AI ChatPot - Enterprise RAG System
 * MODULE:       AUDIT_UTIL (Specification)
 * PURPOSE:      Permanent Business Auditing and KPI Tracking.
 *
 * DESCRIPTION: Handles high-integrity logging for security, business milestones,
 * and process failures. Routes data to permanent storage for long-term compliance.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 *
 ****************************************************************************/
    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'AUDIT_UTIL';

    -- Top-Tier Constants for AUDIT_EVENT_TYPE_CODE
    c_type_security CONSTANT VARCHAR2(10) := 'SEC';   -- Security/Access
    c_type_event    CONSTANT VARCHAR2(10) := 'EVNT';  -- Business Milestone
    c_type_fail     CONSTANT VARCHAR2(10) := 'FAIL';  -- Process/System Failure (Updated from KPI_F)
    c_type_data     CONSTANT VARCHAR2(10) := 'DATA';  -- Data Integrity
    c_type_config   CONSTANT VARCHAR2(10) := 'CONF';  -- System Config Changes

/*******************************************************************************
 * PROCEDURE: log_audit
 * USECASE:   Low-level entry point for direct auditing when custom types are needed.
 * HOW TO USE: Use this when a log entry doesn't fit the specialized wrappers.
 * EXAMPLE:   audit_util.log_audit(p_event_type => 'CONF', p_event_code => 'SYS_CFG', 
 * p_message => 'Changed LLM temperature settings');
 *******************************************************************************/
    PROCEDURE log_audit(
        p_event_type   IN VARCHAR2, -- e.g., 'FAIL', 'SEC'
        p_event_code   IN VARCHAR2, -- e.g., 'SYS_DEP', 'LLM_TO'
        p_message      IN VARCHAR2,
        p_extra_data   IN CLOB     DEFAULT NULL,
        p_caller       IN VARCHAR2 DEFAULT NULL,
        p_trace_id     IN VARCHAR2 DEFAULT NULL
    );

/*******************************************************************************
 * PROCEDURE: log_event
 * USECASE:   Tracking successful business milestones for "AI KPI" or "Process" dashboards.
 * HOW TO USE: Call this at the end of a successful transaction or AI pipeline stage.
 * EXAMPLE:   audit_util.log_event('PROC_OK', 'Vector embedding generation complete');
 *******************************************************************************/
    PROCEDURE log_event(
        p_event_code IN VARCHAR2, -- e.g., 'PROC_OK'
        p_message    IN VARCHAR2,
        p_trace_id   IN VARCHAR2 DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL
    );

/*******************************************************************************
 * PROCEDURE: log_security
 * USECASE:   Compliance and Access Management (Auth successes/failures, permission changes).
 * HOW TO USE: Call during login logic or whenever user permissions are modified.
 * EXAMPLE:   audit_util.log_security('AUTH_OK', 'User alaa.guru logged in successfully');
 *******************************************************************************/
    PROCEDURE log_security(
        p_event_code IN VARCHAR2, -- e.g., 'AUTH_OK'
        p_message    IN VARCHAR2,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT NULL 
    );

/*******************************************************************************
 * PROCEDURE: log_failure
 * USECASE:   System Health monitoring (ORA errors, missing packages) and AI Provider timeouts.
 * HOW TO USE: Use in EXCEPTION blocks for "System Health" tracking.
 * EXAMPLE:   audit_util.log_failure('SYS_DEP', 'Dependency error: ORA-06550 package missing');
 *******************************************************************************/
    PROCEDURE log_failure(
        p_event_code IN VARCHAR2, -- e.g., 'SYS_DEP' for ORA-06550
        p_reason     IN VARCHAR2,
        p_context    IN CLOB     DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT NULL 
    );

/*******************************************************************************
 * PROCEDURE: log_data_change
 * USECASE:   Forensic tracking and Data Integrity audits for sensitive record changes.
 * HOW TO USE: Use when capturing "Old vs New" data values for audit trails.
 * EXAMPLE:   audit_util.log_data_change('FLD_CHG', 'Modified AI System prompt', v_old, v_new);
 *******************************************************************************/
    PROCEDURE log_data_change(
        p_event_code IN VARCHAR2, -- e.g., 'FLD_CHG'
        p_message    IN VARCHAR2,
        p_old_data   IN CLOB     DEFAULT NULL,
        p_new_data   IN CLOB     DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT NULL 
    );

END audit_util;

/
