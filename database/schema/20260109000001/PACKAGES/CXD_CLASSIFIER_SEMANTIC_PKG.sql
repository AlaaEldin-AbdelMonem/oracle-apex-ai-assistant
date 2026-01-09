--------------------------------------------------------
--  DDL for Package CXD_CLASSIFIER_SEMANTIC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CXD_CLASSIFIER_SEMANTIC_PKG" 
AUTHID CURRENT_USER
AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_CLASSIFIER_SEMANTIC_PKG (Specification)
 * PURPOSE:     Vector similarity-based context domain classification.
 *
 * DESCRIPTION: Provides high-speed (<50ms), zero-cost semantic classification 
 * using Oracle 23ai VECTOR functions. Matches user prompts against 
 * pre-computed domain embeddings using Cosine similarity.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 * DATABASE:    Oracle Database 23ai
 * DEPENDENCY:  AI_VECTOR_UTX, CXD_TYPES
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_CLASSIFIER_SEMANTIC_PKG';

    /*******************************************************************************
     * CONFIGURATION CONSTANTS
     *******************************************************************************/

    /** * Minimum similarity threshold (0.0 to 1.0) 
     * 0.70+ is recommended for strict matching.
     */
    c_min_similarity_threshold CONSTANT NUMBER := 0.60;
    
    /** Dimension size for the vector embeddings (e.g., 384, 768, 1024) */
    c_vector_dimension         CONSTANT NUMBER := ai_vector_utx.c_vector_dimensions;
    
    /** Standard distance metric for text embeddings */
    c_distance_metric          CONSTANT VARCHAR2(20) := 'COSINE';

    /*******************************************************************************
     * CORE CLASSIFICATION API
     *******************************************************************************/

    /**
     * Procedure: detect
     * Core classification engine using vector similarity.
     * 1. Generates embedding for user prompt.
     * 2. Calculates distance against all active domain embeddings.
     * 3. Selects best match exceeding threshold.
     *
     * @param p_req              Input request containing the user prompt.
     * @param p_response_domain  Output record with detected domain metadata.
     * @param p_response_intent  Output record with intent mapping (Vector-fallback version).
     */
    PROCEDURE detect (
        p_req              IN  CXD_TYPES.t_cxd_classifier_req,
        p_response_domain  OUT CXD_TYPES.t_cxd_classifier_resp,
        p_response_intent  OUT CXD_TYPES.t_intent_classifier_resp 
    );

    /*******************************************************************************
     * UTILITY & DEBUGGING FUNCTIONS
     *******************************************************************************/

    /**
     * Function: get_all_similarities
     * Returns a Ref Cursor with similarity scores for ALL active domains.
     * Useful for debugging "near misses" in classification.
     */
    FUNCTION get_all_similarities(
        p_user_query IN CLOB,    p_trace_id  IN VARCHAR2 default NULL
    ) RETURN SYS_REFCURSOR;

    /**
     * Function: calculate_similarity
     * Low-level helper to compute the Cosine similarity between two vectors.
     * @return NUMBER (0.0 to 1.0, where 1.0 is identical)
     */
    FUNCTION calculate_similarity(
        p_query_embedding  IN VECTOR,
        p_domain_embedding IN VECTOR,
        p_trace_id IN VARCHAR2 default NULL
    ) RETURN NUMBER;

END cxd_classifier_semantic_pkg;

/
