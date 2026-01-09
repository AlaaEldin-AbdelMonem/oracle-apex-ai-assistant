--------------------------------------------------------
--  DDL for Package CXD_CLASSIFIER_LLM_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CXD_CLASSIFIER_LLM_PKG" 
AUTHID CURRENT_USER AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_CLASSIFIER_LLM_PKG (Specification)
 * PURPOSE:     LLM-powered Context and Intent Classification.
 *
 * DESCRIPTION: Leverages Large Language Models to analyze user prompts 
 * and accurately determine the target context domain and user intent.
 * This ensures the RAG engine retrieves data from the correct corpus.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 * DEPENDENCY:  CXD_TYPES
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_CLASSIFIER_LLM_PKG';

    /*******************************************************************************
     * CORE CLASSIFICATION API
     *******************************************************************************/

    /**
     * Procedure: detect
     * Orchestrates the LLM call to perform dual classification: 
     * 1. Context Domain (The 'Where' - HR, Legal, IT, etc.)
     * 2. User Intent (The 'What' - Search, Summarize, Action, etc.)
     *
     * @param p_req             Input request containing user prompt and session context.
     * @param p_response_domain Output record containing detected domain ID and confidence.
     * @param p_response_intent Output record containing detected intent and action mapping.
     */
    PROCEDURE detect (
        p_req              IN  CXD_TYPES.t_cxd_classifier_req,
        p_response_domain  OUT CXD_TYPES.t_cxd_classifier_resp,
        p_response_intent  OUT CXD_TYPES.t_intent_classifier_resp 
    );

 /*******************************************************************************
 *  
 *******************************************************************************/
END cxd_classifier_llm_pkg;

/
