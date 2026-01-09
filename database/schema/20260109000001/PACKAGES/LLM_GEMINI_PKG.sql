--------------------------------------------------------
--  DDL for Package LLM_GEMINI_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."LLM_GEMINI_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_GEMINI_PKG (Specification)
 * PURPOSE:     Google Gemini LLM Provider Integration.
 *
 * DESCRIPTION: Provides a unified interface for Google Gemini models. 
 * Features include:
 * - Hybrid configuration priority (Payload JSON > Record Fields > Defaults).
 * - Advanced JSON handling using Oracle 23ai native types.
 * - Mapping of multi-modal responses into standardized types.
 * - Support for real-time streaming (SSE) and safety setting overrides.
 *
 * AUTHOR:      AI Architecture & Oracle 23ai Engineering Team
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     2.0 (Unified Interface)
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_GEMINI_PKG'; 

    /*******************************************************************************
     * PUBLIC API - SYNCHRONOUS INVOCATION
     *******************************************************************************/

    /**
     * Function: invoke_llm
     * Primary entry point for blocking calls to the Gemini API.
     * Orchestrates payload building, authentication, and response parsing.
     *
     * @param  p_req Standardized LLM request record (llm_types.t_llm_request).
     * @return llm_types.t_llm_response Unified response structure.
     */
    FUNCTION invoke_llm(
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /*******************************************************************************
     * PUBLIC API - STREAMING INVOCATION
     *******************************************************************************/

    /**
     * Procedure: invoke_llm_stream
     * Initiates a streaming response from Gemini. Tokens are pushed via 
     * Server-Sent Events (SSE) to support modern interactive UIs.
     *
     * @param p_req      Standardized LLM request record.
     * @param p_trace_id Unique identifier for session correlation and debugging.
     */
    PROCEDURE invoke_llm_stream(
        p_req      IN llm_types.t_llm_request,
        p_trace_id IN VARCHAR2
    );

END llm_gemini_pkg;

/
