--------------------------------------------------------
--  DDL for Package CXD_FAILURE_ACTIONS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CXD_FAILURE_ACTIONS_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      cxd_failure_actions_pkg (Specification)
 * PURPOSE:     Handle failure of context domain failures
 *
 * DESCRIPTION:  
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 * DATABASE:    Oracle Database 26ai
 * DEPENDENCY: 
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'cxd_failure_actions_pkg';

    TYPE t_failure_action IS RECORD (
        trace_id             VARCHAR2(100),
        failure_action_code  VARCHAR2(20),
        failure_action       VARCHAR2(100),
        user_response        VARCHAR2(4000),
        action_type          VARCHAR2(30),
        is_default           CHAR(1) 
    );

    -- NEW: Resolve action using CFG_PARAMETERS → fallback to LKP default
    FUNCTION resolve_action(
        p_tenant_id IN NUMBER,
        p_app_id    IN NUMBER,
        p_trace_id in VARCHAR2
    ) RETURN t_failure_action;

    FUNCTION get_action(
        p_action_code IN VARCHAR2,
        p_trace_id in VARCHAR2
    ) RETURN t_failure_action;

    FUNCTION get_default_action  (p_trace_id in VARCHAR2)
        RETURN t_failure_action;

    FUNCTION format_user_response(
        p_action        IN t_failure_action,
        p_user_prompt   IN CLOB    DEFAULT NULL,
        p_domains_list  IN CLOB    DEFAULT NULL,
        p_confidence    IN NUMBER  DEFAULT NULL,
        p_trace_id in VARCHAR2
    ) RETURN CLOB;

END cxd_failure_actions_pkg;

/
