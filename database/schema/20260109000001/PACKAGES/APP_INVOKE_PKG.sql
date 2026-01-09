--------------------------------------------------------
--  DDL for Package APP_INVOKE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."APP_INVOKE_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      APP_INVOKE_PKG (Specification)
 * PURPOSE:     Core execution engine for Large Language Model (LLM) calls.
 * * DESCRIPTION: Acts as the primary interface for sending requests and 
 * receiving responses from configured LLM providers. 
 * Utilizes standardized record types for unified handling.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 * DEPENDENCY:  LLM_TYPES (Record Type Definitions)
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'APP_INVOKE_PKG';

    /*******************************************************************************
     * PROCEDURE: invoke_llm
     * PURPOSE:   Executes a call to the LLM engine using standardized input/output.
     * * @param:    p_req  (IN)  - llm_types.t_llm_request (Prompt, Model, Temp, etc.)
     * @param:    p_resp (OUT) - llm_types.t_llm_response (Result text, tokens, status)
     *
     * NOTES:     This is the new version utilizing the unified LM_TYPES system.
     *******************************************************************************/
    PROCEDURE invoke_llm(
        p_req  IN  llm_types.t_llm_request,
        p_resp OUT llm_types.t_llm_response
    );

END app_invoke_pkg;

/
