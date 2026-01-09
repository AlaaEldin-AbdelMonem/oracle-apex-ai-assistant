--------------------------------------------------------
--  DDL for Package LLM_ANTHROPIC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."LLM_ANTHROPIC_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_ANTHROPIC_PKG (Specification)
 * PURPOSE:     Anthropic Claude API Integration Utility.
 *
 * DESCRIPTION: Provides enterprise-grade integration with Anthropic Claude models 
 * (Claude 3.5 Sonnet, Claude 3 Opus, etc.). Features include:
 * - Multi-model support and dynamic endpoint configuration.
 * - Token usage tracking and cost calculation logic.
 * - Integration with AI_LOG_UTIL for comprehensive audit trails.
 * - Support for both synchronous and streaming (SSE) response modes.
 *
 * AUTHOR:      AI8P Development Team / Alaa Abdelmoneim
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DOCS:        https://docs.anthropic.com/claude/reference/messages_post
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_ANTHROPIC_PKG'; 

    /*******************************************************************************
     * PUBLIC API - CORE INVOCATION
     *******************************************************************************/

    /**
     * Function: invoke_llm
     * Synchronous call to the Anthropic Messages API. 
     * Waits for the full model response before returning.
     *
     * @param  p_req Standardized LLM request object containing prompt and parameters.
     * @return llm_types.t_llm_response Structured response with content and usage stats.
     */
    FUNCTION invoke_llm(
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /*******************************************************************************
     * PUBLIC API - REAL-TIME STREAMING
     *******************************************************************************/

    /**
     * Procedure: invoke_llm_stream
     * Asynchronous/Streaming interface for Claude. 
     * Uses Server-Sent Events (SSE) logic to push tokens to the UI as they are generated.
     *
     * @param p_req      Standardized LLM request object.
     * @param p_trace_id Unique identifier to link stream chunks to the parent session.
     */
    PROCEDURE invoke_llm_stream(
        p_req      IN llm_types.t_llm_request,
        p_trace_id IN VARCHAR2
    );

END llm_anthropic_pkg;

/
