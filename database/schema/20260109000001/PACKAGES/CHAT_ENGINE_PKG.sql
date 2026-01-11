--------------------------------------------------------
--  DDL for Package CHAT_ENGINE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHAT_ENGINE_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_ENGINE_PKG (Specification)
 * PURPOSE:     Enterprise AI Orchestration Engine.
 * * DESCRIPTION: Manages the end-to-end AI pipeline including:
 * - Context & Domain Detection
 * - RAG (Document/Data Injection)
 * - Governance Enforcement & Safety Filtering
 * - Multi-provider LLM Routing
 * - Response Assembly & Observability Metrics
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  LLM_TYPES, LLM_ROUTER_PKG, CXD_TYPES
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHAT_ENGINE_PKG';

    /*******************************************************************************
     * PRIMARY EXECUTION ENTRYPOINTS
     *******************************************************************************/

    /**
     * Function: invoke_chat
     * Full pipeline orchestration: Prompt -> RAG -> Governance -> LLM -> Finalize.
     * @param  p_req Standardized LLM request object.
     * @return llm_types.t_llm_response containing result and metadata.
     */
    FUNCTION invoke_chat (
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /**
     * Procedure: invoke_chat_stream
     * Real-time token emission for streaming-enabled UI components.
     * @param p_req          Standardized LLM request object.
     * @param p_response_out CLOB output for session-based token retrieval.
     */
    PROCEDURE invoke_chat_stream(
        p_req          IN  llm_types.t_llm_request,
        p_response_out OUT CLOB
    );

    /*******************************************************************************
     * SECONDARY PIPELINE ACTIONS
     *******************************************************************************/

    /**
     * Function: invoke_regenerate
     * Re-triggers the last assistant response with optional parameter overrides.
     */
    FUNCTION invoke_regenerate (
        p_req        IN llm_types.t_llm_request,
        p_new_params IN JSON DEFAULT NULL
    ) RETURN llm_types.t_llm_response;

    /**
     * Function: invoke_llm_only
     * Bypass RAG and Governance for direct, raw LLM interaction.
     */
    FUNCTION invoke_llm_only (
        p_req IN llm_types.t_llm_request
    ) RETURN CLOB;

    /**
     * Function: invoke_rag_only
     * Utility to test retrieval results without sending data to an LLM.
     */
    FUNCTION invoke_rag_only (
        p_req IN llm_types.t_llm_request
    ) RETURN CLOB;

    /*******************************************************************************
     * CONTEXT & PROMPT ENGINEERING
     *******************************************************************************/

    /**
     * Function: detect_context_domain
     * Identifies the query domain to apply specific RAG or System logic.
     * Fallback chain: Manual Input -> LLM Analysis -> Vector Similarity.
     */
    FUNCTION detect_context_domain (
        p_req IN CXD_TYPES.t_cxd_classifier_req
    ) RETURN NUMBER;

    /**
     * Function: build_full_system_prompt
     * Dynamically assembles the system instructions via cx_builder_pkg.
     */
    FUNCTION build_full_system_prompt (
        p_req                IN llm_types.t_llm_request,
        p_behavior_code      IN VARCHAR2 DEFAULT 'STANDARD',
        p_output_format_code IN VARCHAR2 DEFAULT 'DEFAULT'
    ) RETURN CLOB;

    /*******************************************************************************
     * FINALIZATION & OBSERVABILITY
     *******************************************************************************/

    /**
     * Function: assemble_final_response
     * Transforms raw LLM output into a human-ready format with citations/metadata.
     */
    FUNCTION assemble_final_response(
        p_raw_llm_response IN llm_types.t_llm_response,
        p_req              IN llm_types.t_llm_request,
        p_rag_context      IN CLOB
    ) RETURN CLOB;

    /**
     * Function: get_trace_id
     * Generates a unique UUID for cross-package observability and logging.
     */
    FUNCTION get_trace_id RETURN VARCHAR2;

END chat_engine_pkg;

/
