--------------------------------------------------------
--  DDL for Package LLM_LOCAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_LOCAL_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_LOCAL_PKG (Specification)
 * PURPOSE:     Local Provider Adapter for On-Premise LLMs (Ollama).
 *
 * DESCRIPTION: Provides a unified interface for locally hosted models using 
 * the Ollama API. Supports full prompt construction (System + History + User),
 * native payload generation, and both synchronous and streaming responses.
 * Designed for low-latency, private, and cost-free inference.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * PROVIDER:    Native Ollama Mode
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_LOCAL_PKG'; 

    /*******************************************************************************
     * INTERNAL ORCHESTRATION (EXPOSED FOR TESTING)
     *******************************************************************************/

    /**
     * Procedure: validate_request
     * Checks the request record for fields unsupported by local providers.
     */
    PROCEDURE validate_request(p_req llm_types.t_llm_request);

    /**
     * Function: build_full_prompt
     * Merges SYSTEM instructions, conversation HISTORY, and the current USER prompt
     * into a single formatted CLOB according to model templates.
     */
    FUNCTION build_full_prompt(p_req llm_types.t_llm_request) RETURN CLOB;

    /**
     * Function: build_payload
     * Constructs the native Ollama JSON payload including model parameters 
     * like temperature, top_k, and seed.
     */
    FUNCTION build_payload(
        p_req IN llm_types.t_llm_request,
        p_cfg IN llm_provider_models%ROWTYPE
    ) RETURN CLOB;

    /**
     * Function: send_http
     * Manages the low-level UTL_HTTP or APEX_WEB_SERVICE call to the local endpoint.
     */
    FUNCTION send_http(
        p_payload  IN CLOB,
        p_base_url IN VARCHAR2
    ) RETURN CLOB;

    /**
     * Function: parse_response
     * Maps the Ollama JSON response back into the unified t_llm_response record.
     */
    FUNCTION parse_response(
        p_raw IN CLOB,
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /*******************************************************************************
     * PUBLIC API - UNIFIED ENTRYPOINTS
     *******************************************************************************/

    /**
     * Function: invoke_llm
     * Standard blocking call for local LLM inference.
     * @return llm_types.t_llm_response Standardized response object.
     */
    FUNCTION invoke_llm(
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /**
     * Procedure: invoke_llm_stream
     * Non-blocking streaming interface for Ollama.
     * Pushes tokens to the UI via Server-Sent Events (SSE).
     */
    PROCEDURE invoke_llm_stream(
        p_req      IN llm_types.t_llm_request,
        p_trace_id IN VARCHAR2
    );

END llm_local_pkg;

/
