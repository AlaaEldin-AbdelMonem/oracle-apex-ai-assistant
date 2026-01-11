--------------------------------------------------------
--  DDL for Package POLICY_ENFORCER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "POLICY_ENFORCER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      POLICY_ENFORCER_PKG (Specification)
 * PURPOSE:     Security Policy Enforcement and Data Redaction.
 *
 * DESCRIPTION: Acts as a mandatory security gateway for the RAG pipeline. 
 * Before any data is sent to an LLM, this package validates the user's 
 * clearance level, applies row-level security (VPD-style filters), 
 * and redacts sensitive information based on the user's organization 
 * and department context.
 *
 * AUTHOR:      Enterprise AI Architect / Alaa Abdelmoneim
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'POLICY_ENFORCER_PKG'; 

    /*******************************************************************************
     * SECURITY EXCEPTION CODES
     *******************************************************************************/
    c_err_unauthorized_user CONSTANT NUMBER := -20001; -- User not registered in AI system
    c_err_clearance_denied  CONSTANT NUMBER := -20002; -- Level mismatch for data source
    c_err_blocked_source    CONSTANT NUMBER := -20003; -- Source blacklisted for domain

    /*******************************************************************************
     * PUBLIC DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_source_rec
     * Encapsulates the configuration and security constraints for a data source
     * that has passed the initial policy check.
     */
    TYPE t_source_rec IS RECORD (
        context_registry_id   NUMBER,
        source_type           VARCHAR2(30),   -- TABLE, VIEW, API
        source_name           VARCHAR2(200),  -- Actual DB Object Name
        security_levelx       NUMBER,         -- Clearance level (1-Public, 5-Secret)
        mandatory_filters     CLOB,           -- Global hard-coded filters
        filter_template       CLOB,           -- Dynamic role-based filter placeholders
        max_records           NUMBER          -- Throttling limit for AI context
    );

    /** Table of source records for bulk processing of domain resources. */
    TYPE t_sources_tab IS TABLE OF t_source_rec;

    /*******************************************************************************
     * POLICY ENFORCEMENT API
     *******************************************************************************/

    /**
     * Function: get_authorized_context
     * The primary entry point for context retrieval. Orchestrates:
     * 1. User identification and Role validation.
     * 2. Source registry lookup for the requested Domain.
     * 3. Application of dynamic SQL filters based on Org/Dept ID.
     * 4. Aggregation of data into a safe, redacted JSON CLOB.
     *
     * @param p_user_id           The application user ID (APEX or Auth identifier).
     * @param p_role_id           Active security role of the user.
     * @param p_context_domain_id The knowledge domain silo being queried.
     * @param p_user_org_id       Organization ID for horizontal data isolation.
     * @param p_user_dept_id      Department ID for vertical data isolation.
     * @return CLOB               A consolidated, policy-compliant JSON context block.
     */
    FUNCTION get_authorized_context (
        p_user_id           IN VARCHAR2,
        p_role_id           IN NUMBER,
        p_context_domain_id IN NUMBER,
        p_user_org_id       IN NUMBER,
        p_user_dept_id      IN NUMBER
    ) RETURN CLOB;

END policy_enforcer_pkg;

/
