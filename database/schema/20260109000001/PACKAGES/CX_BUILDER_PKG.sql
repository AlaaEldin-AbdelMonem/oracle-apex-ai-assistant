--------------------------------------------------------
--  DDL for Package CX_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CX_BUILDER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_BUILDER_PKG (Specification)
 * PURPOSE:     Master System Prompt Orchestrator and Injector.
 *
 * DESCRIPTION: Assembles the final unified system prompt by aggregating components:
 * Domain Context + Behavior + Output Format + Governance + Safety.
 * This package centralizes the "Enterprise Voice" and ensures 
 * consistent LLM steering across all chat sessions.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  Oracle APEX (v function), CXD_PKG, CX_BEHAVIOR_PKG
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_BUILDER_PKG';

    /*******************************************************************************
     * PRIMARY PROMPT ASSEMBLY
     *******************************************************************************/

    /**
     * Function: system_prompt_injector
     * The main entry point for building the System Instruction block.
     *
     * @param p_context_domain_id      Primary knowledge domain (e.g., HR, IT).
     * @param p_enforce_context_domain If 'Y', strictly limits LLM to the domain corpus.
     * @param p_user_prompt            The raw user query (used for dynamic steering).
     * @param p_top_k                  RAG chunk limit influence.
     * @param p_behavior_code          The persona/style code from CX_BEHAVIOR_PKG.
     * @param p_output_format_code     The structure code (JSON, Markdown, etc.).
     * @param p_user_id                Current user context for personalization.
     * @return CLOB                    The fully assembled system prompt.
     */
       FUNCTION system_prompt_Injector (
        p_context_Domain_id        IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_enforce_context_domain   IN VARCHAR2 default 'Y',--enforce intent determination
        p_user_prompt              IN clob ,
        p_top_k                    IN NUMBER  DEFAULT 5,
        p_behavior_code            IN VARCHAR2 DEFAULT 'STANDARD',
        p_output_format_code       IN VARCHAR2 DEFAULT 'DEFAULT',
        p_user_id                  IN NUMBER   DEFAULT v('G_USER_ID') ,
        p_trace_Id                 IN VARCHAR2

    )RETURN CLOB;

    /*******************************************************************************
     * COMPONENT FRAGMENT RETRIEVAL
     *******************************************************************************/

    /**
     * Function: get_governance_block
     * Returns standard enterprise instructions regarding data handling and privacy.
     */
    FUNCTION get_governance_block(
        p_session_id                 IN NUMBER,
        p_context_Domain_id         IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_trace_Id                  IN VARCHAR2

    ) RETURN CLOB ;

    /**
     * Function: get_safety_block
     * Returns the strict guardrails to prevent hallucinations and prohibited topics.
     */
 FUNCTION get_safety_block (
        p_session_id                 IN NUMBER,
        p_context_Domain_id         IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_trace_Id                  IN VARCHAR2)RETURN CLOB;

END cx_builder_pkg;

/
