--------------------------------------------------------
--  DDL for Package RAG_SEARCH_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."RAG_SEARCH_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_SEARCH_UTIL (Specification)
 * PURPOSE:     Semantic Discovery and Search Utilities for APEX.
 *
 * DESCRIPTION: Provides high-level search functions for the RAG platform. 
 * Orchestrates vector similarity searches using Oracle 23ai Vector types 
 * and provides specialized UI utilities for highlighting and metadata 
 * retrieval. Designed to be consumed by APEX Classic/Interactive Reports.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DATE:        November 1, 2025
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_SEARCH_UTIL'; 

    /*******************************************************************************
     * SEARCH DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_search_result
     * Consolidated result set containing semantic score and document metadata.
     */
    TYPE t_search_result IS RECORD (
        chunk_id         NUMBER,
        doc_id           NUMBER,
        doc_title        VARCHAR2(500),
        chunk_sequence   NUMBER,
        chunk_text       CLOB,
        relevance_score  NUMBER,        -- Raw vector distance (Cosine/Euclidean)
        relevance_pct    NUMBER,        -- Normalized 0-100% confidence score
        embedding_model  VARCHAR2(100)
    );

    /** Pipelined collection for high-efficiency SQL interaction. */
    TYPE t_search_results_tab IS TABLE OF t_search_result;

    /*******************************************************************************
     * SEMANTIC SEARCH API
     *******************************************************************************/

    /**
     * Function: smart_search
     * Performs a semantic vector search against the knowledge base. 
     * Uses Pipelined output to allow direct usage in APEX report queries.
     *
     * @param p_query        The natural language search query.
     * @param p_doc_id       Optional filter to search within a specific file.
     * @param p_max_results  Limit for the Top-K results.
     * @param p_threshold    Minimum similarity score to include in results.
     * @return t_search_results_tab (Pipelined Table)
     */
    FUNCTION smart_search(
        p_query         IN CLOB,
        p_doc_id        IN NUMBER DEFAULT NULL,
        p_max_results   IN NUMBER DEFAULT 10,
        p_threshold     IN NUMBER DEFAULT 0.5
    ) RETURN t_search_results_tab PIPELINED;

    /*******************************************************************************
     * METADATA & UI UTILITIES
     *******************************************************************************/

    /**
     * Function: get_searchable_documents
     * Returns a cursor of all documents that have successfully completed 
     * the embedding phase and are available for search.
     */
    FUNCTION get_searchable_documents
    RETURN SYS_REFCURSOR;

    /**
     * Function: highlight_search_terms
     * Wraps matching terms in HTML tags for UI display.
     * * @param p_text             The source text chunk.
     * @param p_search_terms     The keywords to emphasize.
     * @param p_highlight_class  The CSS class for styling (e.g., 'u-warning').
     * @param p_match_strategy   EXACT, PARTIAL, or STEMMED matching.
     */
    FUNCTION highlight_search_terms(
        p_text               IN CLOB,
        p_search_terms       IN VARCHAR2,
        p_highlight_class    IN VARCHAR2 DEFAULT 'highlight-term',
        p_match_strategy     IN VARCHAR2 DEFAULT 'PARTIAL'
    ) RETURN CLOB;

END rag_search_util;

/
