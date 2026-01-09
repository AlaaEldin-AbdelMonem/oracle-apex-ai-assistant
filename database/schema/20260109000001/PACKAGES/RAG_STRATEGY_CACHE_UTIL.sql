--------------------------------------------------------
--  DDL for Package RAG_STRATEGY_CACHE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."RAG_STRATEGY_CACHE_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_STRATEGY_CACHE_UTIL (Specification)
 * PURPOSE:     Caching and Management of Document Processing Strategies.
 *
 * DESCRIPTION: Provides high-speed access to cached chunking and embedding 
 * recommendations. By storing the results of the Strategy Advisor, this 
 * utility allows the APEX UI and background processors to retrieve 
 * "Best Fit" strategies without the overhead of repetitive heuristic 
 * or LLM-based document analysis.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_STRATEGY_CACHE_UTIL'; 

    /*******************************************************************************
     * CACHE SYNCHRONIZATION
     *******************************************************************************/

    /**
     * Procedure: refresh_recommendation
     * Triggers the RAG Strategy Advisor to re-analyze a specific document 
     * and updates the cached recommendation, reasoning, and confidence score.
     */
    PROCEDURE refresh_recommendation(
        p_doc_id IN NUMBER
    );
    
    /**
     * Procedure: refresh_all_recommendations
     * Performs a bulk refresh of the strategy cache for all documents.
     * Useful after system-wide updates to chunking logic or model definitions.
     */
    PROCEDURE refresh_all_recommendations;
    
    /*******************************************************************************
     * CACHE ACCESSORS
     *******************************************************************************/

    /**
     * Function: get_cached_strategy
     * Retrieves the recommended strategy code (e.g., 'SEMANTIC_V2') from the cache.
     * @param p_auto_refresh If TRUE and no cache exists, it triggers a refresh.
     */
    FUNCTION get_cached_strategy(
        p_doc_id        IN NUMBER,
        p_auto_refresh  IN BOOLEAN DEFAULT FALSE
    ) RETURN VARCHAR2;
    
    /**
     * Function: get_cached_reason
     * Returns the human-readable explanation for why a specific strategy 
     * was recommended (e.g., "High technical density detected").
     */
    FUNCTION get_cached_reason(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2;
    
    /**
     * Function: get_cached_confidence
     * Returns the confidence score (0.0 - 1.0) of the recommendation.
     */
    FUNCTION get_cached_confidence(
        p_doc_id IN NUMBER
    ) RETURN NUMBER;
    
    /**
     * Function: get_strategy_display_name
     * Translates a raw strategy code into a user-friendly label 
     * suitable for display in APEX reports or dashboards.
     */
    FUNCTION get_strategy_display_name(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2;
    
END rag_strategy_cache_util;

/
