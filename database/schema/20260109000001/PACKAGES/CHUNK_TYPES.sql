--------------------------------------------------------
--  DDL for Package CHUNK_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHUNK_TYPES" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_TYPES (Specification)
 * PURPOSE:     Common type definitions and constants for all chunking modules.
 *
 * DESCRIPTION: This is the central source of truth for chunk structures. 
 * It ensures consistency across custom implementations, native wrappers, 
 * and routing proxies.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_TYPES';

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/

    /**
     * Record: t_chunk_rec
     * Unified record structure representing a single text chunk with metadata.
     */
    TYPE t_chunk_rec IS RECORD (
        chunk_id           NUMBER,       -- Unique tracking ID
        chunk_sequence     NUMBER,       -- Order in document (1-based)
        chunk_text         CLOB,         -- Actual content
        start_pos          NUMBER,       -- 0-indexed start in source
        end_pos            NUMBER,       -- Inclusive end in source
        char_count         NUMBER,       -- LENGTH(chunk_text)
        word_count         NUMBER,       -- For token estimation
        chunk_level        NUMBER,       -- Hierarchical depth
        chunk_tokens_count NUMBER,       -- Estimated LLM tokens
        strategy_used      VARCHAR2(50), -- Strategy code
        quality_score      NUMBER,       -- Metric (0.0 to 1.0)
        chunk_size         NUMBER,       -- Requested size
        chunk_metadata     JSON          -- Extensible metadata
    );

    /**
     * Table: t_chunk_tab
     * Collection type for bulk processing of chunks.
     */
    TYPE t_chunk_tab IS TABLE OF t_chunk_rec;

    /*******************************************************************************
     * CHUNKING STRATEGY CONSTANTS
     *******************************************************************************/
    SUBTYPE t_chunk_strategy IS VARCHAR2(50);

    c_fixed_size            CONSTANT t_chunk_strategy := 'FIXED_SIZE';
    c_sentence_boundary     CONSTANT t_chunk_strategy := 'SENTENCE_BOUNDARY';
    c_paragraph_boundary    CONSTANT t_chunk_strategy := 'PARAGRAPH_BOUNDARY';
    c_token_based           CONSTANT t_chunk_strategy := 'TOKEN_BASED';
    c_semantic_sliding      CONSTANT t_chunk_strategy := 'SEMANTIC_SLIDING';
    c_hierarchical          CONSTANT t_chunk_strategy := 'HIERARCHICAL';

    /*******************************************************************************
     * LANGUAGE CONSTANTS
     *******************************************************************************/
    SUBTYPE t_language IS VARCHAR2(10);

    c_lang_auto             CONSTANT t_language := 'AUTO';
    c_lang_english          CONSTANT t_language := 'EN';
    c_lang_arabic           CONSTANT t_language := 'AR';

    /*******************************************************************************
     * UTILITY FUNCTIONS
     *******************************************************************************/

    /**
     * Function: calculate_quality_score
     * Evaluates chunking results based on density and strategy rules.
     */
    FUNCTION calculate_quality_score(
        p_char_count IN NUMBER,
        p_word_count IN NUMBER,
        p_strategy   IN VARCHAR2
    ) RETURN NUMBER;

    /**
     * Function: estimate_token_count
     * Heuristic-based token estimation for budget-aware chunking.
     */
    FUNCTION estimate_token_count(
        p_char_count IN NUMBER,
        p_word_count IN NUMBER
    ) RETURN NUMBER;

    /**
     * Function: build_metadata
     * Constructs a structured JSON object for chunk persistence.
     */
    FUNCTION build_metadata(
        p_strategy            IN VARCHAR2,
        p_chunk_level         IN NUMBER DEFAULT 0,
        p_parent_seq          IN NUMBER DEFAULT NULL,
        p_additional_metadata IN JSON DEFAULT NULL
    ) RETURN JSON;

    FUNCTION is_valid_chunk(p_chunk IN t_chunk_rec) RETURN BOOLEAN;

    /*******************************************************************************
     * DEBUGGING & OUTPUT
     *******************************************************************************/

    PROCEDURE print_chunks(p_chunks IN chunk_types.t_chunk_tab);

    PROCEDURE print_chunk_text(p_chunks IN chunk_types.t_chunk_tab);

END chunk_types;

/
