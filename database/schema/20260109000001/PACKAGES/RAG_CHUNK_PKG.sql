--------------------------------------------------------
--  DDL for Package RAG_CHUNK_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."RAG_CHUNK_PKG" AS
/*******************************************************************************
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_CHUNK_PKG (Specification)
 * PURPOSE:     Advanced Text Chunking Strategies for Oracle 23ai/32ai.
 * * DESCRIPTION:
 * Provides a robust suite of chunking methods to prepare text for LLM grounding.
 * Supports:
 * - Fixed-size & Token-based splitting.
 * - Boundary-aware (Sentence/Paragraph) logic.
 * - Multi-language support (English/Arabic).
 * - Hierarchical and Semantic Sliding Window techniques.
 *
 * AUTHOR:      Alaaeldin Abdelmonem
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 *******************************************************************************/

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_CHUNK_PKG';

    /***************************************************************************
     * TYPE DEFINITIONS & CONSTANTS
     ***************************************************************************/

    -- Supported chunking strategies
    SUBTYPE t_chunk_strategy IS VARCHAR2(50);
    c_fixed_size            CONSTANT t_chunk_strategy := 'FIXED_SIZE';
    c_sentence_boundary     CONSTANT t_chunk_strategy := 'SENTENCE_BOUNDARY';
    c_paragraph_boundary    CONSTANT t_chunk_strategy := 'PARAGRAPH_BOUNDARY';
    c_semantic_sliding      CONSTANT t_chunk_strategy := 'SEMANTIC_SLIDING_WINDOW';
    c_hierarchical          CONSTANT t_chunk_strategy := 'HIERARCHICAL';
    c_token_based           CONSTANT t_chunk_strategy := 'TOKEN_BASED';

    -- Supported language identifiers
    SUBTYPE t_language IS VARCHAR2(10);
    c_lang_en               CONSTANT t_language := 'EN';
    c_lang_ar               CONSTANT t_language := 'AR';
    c_lang_auto             CONSTANT t_language := 'AUTO';

    /***************************************************************************
     * MAIN UNIVERSAL ENTRY POINT
     ***************************************************************************/

    /**
     * Function: chunk_text
     * Universal dispatcher for selecting and executing a chunking strategy.
     *
     * @param p_text            Source text (CLOB).
     * @param p_strategy        Target strategy (e.g., c_sentence_boundary).
     * @param p_chunk_size      Target size in characters or tokens.
     * @param p_overlap_size    Character overlap for context continuity.
     * @param p_language        EN, AR, or AUTO (for detection).
     * @param p_normalize       Clean whitespace/special chars before processing.
     * @return t_chunk_tab      Collection of chunks with position metadata.
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
        p_preserve_format   IN BOOLEAN DEFAULT FALSE,
        p_metadata          IN JSON DEFAULT NULL
    ) RETURN chunk_types.t_chunk_tab;

    /***************************************************************************
     * STRATEGY-SPECIFIC METHODS
     ***************************************************************************/

    FUNCTION chunk_by_fixed_size(
        p_text          IN CLOB,
        p_chunk_size    IN NUMBER DEFAULT 512,
        p_overlap       IN NUMBER DEFAULT 50
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_by_sentence(
        p_text              IN CLOB,
        p_target_size       IN NUMBER DEFAULT 512,
        p_max_chunk_size    IN NUMBER DEFAULT 1024,
        p_overlap_pct       IN NUMBER DEFAULT 15,
        p_language          IN t_language DEFAULT c_lang_auto
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_by_paragraph(
        p_text              IN CLOB,
        p_max_chunk_size    IN NUMBER DEFAULT 1024,
        p_min_chunk_size    IN NUMBER DEFAULT 100,
        p_overlap_pct       IN NUMBER DEFAULT 15
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_semantic_sliding(
        p_text              IN CLOB,
        p_chunk_size        IN NUMBER DEFAULT 512,
        p_overlap_pct       IN NUMBER DEFAULT 30,
        p_language          IN t_language DEFAULT c_lang_auto
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_hierarchical(
        p_text              IN CLOB,
        p_level0_size       IN NUMBER DEFAULT 3072,
        p_level1_size       IN NUMBER DEFAULT 1536,
        p_level2_size       IN NUMBER DEFAULT 768
    ) RETURN chunk_types.t_chunk_tab;

    FUNCTION chunk_by_tokens(
        p_text              IN CLOB,
        p_max_tokens        IN NUMBER DEFAULT 512,
        p_overlap_tokens    IN NUMBER DEFAULT 50,
        p_model_type        IN VARCHAR2 DEFAULT 'GPT'
    ) RETURN chunk_types.t_chunk_tab;

    /***************************************************************************
     * UTILITY FUNCTIONS
     ***************************************************************************/

    FUNCTION normalize_text(
        p_text              IN CLOB,
        p_remove_special    IN BOOLEAN DEFAULT FALSE,
        p_lowercase         IN BOOLEAN DEFAULT FALSE
    ) RETURN CLOB;

    FUNCTION estimate_tokens(
        p_text              IN CLOB,
        p_model_type        IN VARCHAR2 DEFAULT 'GPT'
    ) RETURN NUMBER;

    FUNCTION detect_language(
        p_text              IN CLOB
    ) RETURN t_language;

    FUNCTION get_chunk_statistics(
        p_chunks            IN chunk_types.t_chunk_tab
    ) RETURN CLOB;

    FUNCTION validate_chunk_quality(
        p_chunks            IN chunk_types.t_chunk_tab
    ) RETURN CLOB;

    /***************************************************************************
     * BATCH & COMPOSITE OPERATIONS
     ***************************************************************************/

    FUNCTION chunk_document_batch(
        p_doc_ids           IN SYS.ODCINUMBERLIST,
        p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
        p_chunk_size        IN NUMBER DEFAULT 512,
        p_overlap_pct       IN NUMBER DEFAULT 20,
        p_commit_batch      IN NUMBER DEFAULT 10
    ) RETURN NUMBER;

    FUNCTION chunk_and_embed_document(
        p_doc_id            IN NUMBER,
        p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
        p_chunk_size        IN NUMBER DEFAULT 512,
        p_embedding_model   IN VARCHAR2 DEFAULT 'all-MiniLM-L6-v2'
    ) RETURN NUMBER;

END rag_chunk_pkg;

/
