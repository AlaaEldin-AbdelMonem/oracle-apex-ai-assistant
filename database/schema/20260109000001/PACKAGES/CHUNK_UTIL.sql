--------------------------------------------------------
--  DDL for Package CHUNK_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHUNK_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_UTIL (Specification)
 * PURPOSE:     Oracle Native Text Chunking API (DBMS_VECTOR_CHAIN).
 *
 * DESCRIPTION: Provides a high-performance interface for native text chunking. 
 * Supports character, word, sentence, and semantic recursive splitting 
 * optimized for Oracle 23ai.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DATABASE:    Oracle Database 23ai or higher
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_UTIL';

    /*******************************************************************************
     * STRATEGY CONSTANTS & SUBTYPES
     *******************************************************************************/
    SUBTYPE t_chunk_strategy IS VARCHAR2(50);
    
    /** character-based fixed-size (fastest, ~3000 chunks/sec) */
    c_fixed_size            CONSTANT t_chunk_strategy := 'FIXED_SIZE';
    /** sentence-aware (best for Q&A, ~2500 chunks/sec) */
    c_sentence_boundary     CONSTANT t_chunk_strategy := 'SENTENCE_BOUNDARY';
    /** paragraph-aware (double newline splitting) */
    c_paragraph_boundary    CONSTANT t_chunk_strategy := 'PARAGRAPH_BOUNDARY';
    /** word-based (token approximation) */
    c_token_based           CONSTANT t_chunk_strategy := 'TOKEN_BASED';
    /** recursive semantic (highest quality context preservation) */
    c_semantic_sliding      CONSTANT t_chunk_strategy := 'SEMANTIC_SLIDING_WINDOW';
    /** multi-level (requires RAG_CHUNK_PKG fallback) */
    c_hierarchical          CONSTANT t_chunk_strategy := 'HIERARCHICAL';

    /*******************************************************************************
     * LANGUAGE CONSTANTS
     *******************************************************************************/
    SUBTYPE t_language IS VARCHAR2(10);

    c_lang_en               CONSTANT t_language := 'EN';
    c_lang_ar               CONSTANT t_language := 'AR';
    c_lang_auto             CONSTANT t_language := 'AUTO';

    /*******************************************************************************
     * PERFORMANCE TRACKING TYPES
     *******************************************************************************/
    TYPE t_perf_stats IS RECORD (
        strategy            VARCHAR2(50), 
        chunk_count         NUMBER,       
        processing_time_ms  NUMBER,       
        avg_chunk_size      NUMBER        
    );

    /*******************************************************************************
     * MAIN UNIVERSAL ENTRY POINT
     *******************************************************************************/

    /**
     * Function: chunk_text
     * Recommended entry point for all chunking operations.
     * @param p_text            The document CLOB to be processed.
     * @param p_strategy        Selected strategy code (default: c_sentence_boundary).
     * @param p_chunk_size      Target size in characters.
     * @param p_overlap_pct     Percentage overlap (e.g., 20 for Q&A, 40+ for Semantic).
     * @param p_language        NLS Context (default: AUTO).
     * @return chunk_types.t_chunk_tab Collection of records.
     */
    FUNCTION chunk_text(
        p_text              IN CLOB,
        p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
        p_chunk_size        IN NUMBER DEFAULT 512,
        p_overlap_size      IN NUMBER DEFAULT 50,
        p_overlap_pct       IN NUMBER DEFAULT NULL,
        p_language          IN t_language DEFAULT c_lang_auto,
        p_max_chunk_size    IN NUMBER DEFAULT 2048,
        p_min_chunk_size    IN NUMBER DEFAULT 50,
        p_normalize         IN BOOLEAN DEFAULT TRUE,
        p_preserve_format    IN BOOLEAN DEFAULT FALSE,
        p_metadata          IN JSON DEFAULT NULL
    ) RETURN chunk_types.t_chunk_tab;

    /*******************************************************************************
     * NATIVE IMPLEMENTATION WRAPPERS
     *******************************************************************************/

    FUNCTION chunk_by_chars(
        p_text          IN CLOB,
        p_chunk_size    IN NUMBER DEFAULT 512,
        p_overlap       IN NUMBER DEFAULT 50,
        p_normalize     IN VARCHAR2 DEFAULT 'all'
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_by_words(
        p_text          IN CLOB,
        p_max_words     IN NUMBER DEFAULT 128,
        p_overlap       IN NUMBER DEFAULT 10,
        p_normalize     IN VARCHAR2 DEFAULT 'all'
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_by_vocabulary(
        p_text          IN CLOB,
        p_vocabulary    IN VARCHAR2 DEFAULT 'sentence',
        p_max_size      IN NUMBER DEFAULT 512,
        p_overlap       IN NUMBER DEFAULT 20,
        p_language      IN VARCHAR2 DEFAULT 'AMERICAN'
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_recursively(
        p_text          IN CLOB,
        p_max_size      IN NUMBER DEFAULT 512,
        p_overlap       IN NUMBER DEFAULT 40,
        p_split         IN VARCHAR2 DEFAULT 'sentence',
        p_language      IN VARCHAR2 DEFAULT 'AMERICAN'
    ) RETURN chunk_types.t_chunk_tab;

    /*******************************************************************************
     * BATCH OPERATIONS
     *******************************************************************************/

    /**
     * Function: chunk_batch
     * Bulk process multiple documents with automatic transaction/commit control.
     * @param p_doc_ids      Array of Document IDs (SYS.ODCINUMBERLIST).
     * @param p_commit_batch Frequency of COMMIT (e.g., every 10 documents).
     * @return Total number of chunks generated across the batch.
     */
    FUNCTION chunk_batch(
        p_doc_ids           IN SYS.ODCINUMBERLIST,
        p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
        p_chunk_size        IN NUMBER DEFAULT 512,
        p_overlap_pct       IN NUMBER DEFAULT 20,
        p_commit_batch      IN NUMBER DEFAULT 10
    ) RETURN NUMBER;

    /*******************************************************************************
     * TRANSLATION LAYER
     *******************************************************************************/

    /**
     * Function: get_params_json
     * Builds the DBMS_VECTOR_CHAIN specific JSON parameter object.
     */
    FUNCTION get_params_json(
        p_strategy          IN t_chunk_strategy,
        p_chunk_size        IN NUMBER,
        p_overlap_size      IN NUMBER,
        p_language          IN t_language,
        p_normalize         IN BOOLEAN
    ) RETURN JSON_OBJECT_T;

END chunk_util;

/
