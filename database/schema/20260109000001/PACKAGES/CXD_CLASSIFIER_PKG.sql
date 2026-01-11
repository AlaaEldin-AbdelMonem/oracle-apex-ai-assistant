--------------------------------------------------------
--  DDL for Package CXD_CLASSIFIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CXD_CLASSIFIER_PKG" 
AUTHID CURRENT_USER AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_CLASSIFIER_PKG (Specification)
 * PURPOSE:     Main Orchestrator for Context Domain and Intent Detection.
 *
 * DESCRIPTION: Acts as the primary entry point for classifying user queries.
 * Integrates multiple detection strategies (LLM, Heuristics, or Vector)
 * to return structured domain and intent metadata.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_CLASSIFIER_PKG';

    /*******************************************************************************
     * PRIMARY DETECTION INTERFACE
     *******************************************************************************/

    /**
     * Procedure: detect
     * Analyzes a user query to identify the specific knowledge domain (HR, IT, etc.)
     * and the underlying user intent (Question, Action, Navigation).
     *
     * @param p_req          Input record with prompt and session state.
     * @param p_resp_domain  Outbound record containing detected domain ID and confidence.
     * @param p_resp_intent  Outbound record containing intent classification.
     */
    PROCEDURE detect(
        p_req           IN  CXD_TYPES.t_cxd_classifier_req,
        p_resp_domain   OUT CXD_TYPES.t_cxd_classifier_resp,
        p_resp_intent   OUT CXD_TYPES.t_intent_classifier_resp
    );

END cxd_classifier_pkg;

/
