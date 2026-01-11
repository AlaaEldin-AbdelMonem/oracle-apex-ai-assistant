--------------------------------------------------------
--  DDL for Package LLM_OPENAI_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_OPENAI_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_OPENAI_PKG (Specification)
 * PURPOSE:     OpenAI LLM Provider Adapter and Integration.
 *
 * DESCRIPTION: Provides enterprise-grade integration with OpenAI's Chat Completions 
 * API. Features include:
 * - Conversion of standardized requests to OpenAI JSON format.
 * - Support for synchronous and Server-Sent Events (SSE) streaming.
 * - Native handling of system, user, and assistant message roles.
 * - Integration with the unified t_llm_request/response types.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * API:         v1/chat/completions
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_OPENAI_PKG'; 

    /*******************************************************************************
     * INTERNAL ORCHESTRATION (EXPOSED FOR TESTING)
     *******************************************************************************/

    /**
     * Function: build_payload
     * Transforms the unified request record into the OpenAI-specific JSON schema.
     * Handles temperature, top_p, frequency_penalty, and message history.
     */
    FUNCTION build_payload(
        p_req IN llm_types.t_llm_request,
        p_cfg IN llm_provider_models%ROWTYPE
    ) RETURN CLOB;

    /**
     * Function: send_http
     * Manages the low-level HTTP communication with OpenAI endpoints.
     * @param p_api_key The bearer token retrieved by the model util.
     */
    FUNCTION send_http(
        p_cfg      IN llm_provider_models%ROWTYPE,
        p_api_key  IN VARCHAR2,
        p_payload  IN CLOB,
        p_trace_id IN VARCHAR2
    ) RETURN CLOB;

    /**
     * Function: parse_response
     * Extracts text, token usage, and finish reasons from the OpenAI JSON response
     * and maps them into the standardized response record.
     */
    FUNCTION parse_response(
        p_raw    IN CLOB,
        p_model  IN VARCHAR2,
        p_trace_id IN VARCHAR2
    ) RETURN llm_types.t_llm_response;

    /*******************************************************************************
     * PUBLIC API - UNIFIED ENTRYPOINTS
     *******************************************************************************/

    /**
     * Function: invoke_llm
     * Synchronous entry point. Blocks execution until the full completion is received.
     * @return llm_types.t_llm_response Unified response object.
     */
    FUNCTION invoke_llm(
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /**
     * Procedure: invoke_llm_stream
     * Streaming entry point. Pushes partial message deltas to the UI in real-time
     * via Server-Sent Events (SSE).
     * @param p_trace_id Correlation ID for log and session tracking.
     */
    PROCEDURE invoke_llm_stream(
        p_req      IN llm_types.t_llm_request,
        p_trace_id IN VARCHAR2
    );

END llm_openai_pkg;

/
