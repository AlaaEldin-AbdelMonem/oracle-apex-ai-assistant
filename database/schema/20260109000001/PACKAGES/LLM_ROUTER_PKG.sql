--------------------------------------------------------
--  DDL for Package LLM_ROUTER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_ROUTER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_ROUTER_PKG (Specification)
 * PURPOSE:     Central Dispatcher and Multi-Provider Abstraction.
 *
 * DESCRIPTION: Acts as the intelligent gateway for all LLM interactions. 
 * Based on the request metadata, it routes calls to the appropriate 
 * provider package (OpenAI, Gemini, Anthropic, or Local). 
 * This architecture enables:
 * - Vendor neutrality (switch providers without changing business logic).
 * - Centralized auditing and trace management.
 * - Standardized error handling and fallback routing.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_ROUTER_PKG'; 

    /*******************************************************************************
     * MAIN ROUTING API
     *******************************************************************************/

    /**
     * Function: invoke_llm
     * The primary entry point for all synchronous LLM requests.
     * Evaluates p_req.provider and dispatches to the correct sub-package.
     *
     * @param  p_req Standardized LLM request (llm_types.t_llm_request).
     * @return llm_types.t_llm_response Standardized response object.
     */
    FUNCTION invoke_llm(
        p_req IN llm_types.t_llm_request
    ) RETURN llm_types.t_llm_response;

    /**
     * Procedure: invoke_llm_stream
     * Routes streaming requests to the designated provider.
     * Tokens are streamed back to the UI, enabling a real-time "typing" experience.
     *
     * @param p_req      Standardized LLM request.
     * @param p_trace_id Unique identifier for end-to-end observability.
     */
    PROCEDURE invoke_llm_stream(
        p_req      IN llm_types.t_llm_request,
        p_trace_id IN VARCHAR2
    );

END llm_router_pkg;

/
