--------------------------------------------------------
--  DDL for Package CHUNK_PROXY_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHUNK_PROXY_UTIL" AS
/**
 * PROJECT:     Enterprise AI Assistant
 * MODULE:      CHUNK_PROXY_UTIL (Specification)
 * PURPOSE:     Smart proxy for routing chunking methods between custom 
 * implementations (RAG_CHUNK_PKG) and Oracle native (VECTOR_CHUNKING).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 *
 * MINIMUM DB:  Oracle Database 23ai
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_PROXY_UTIL';
    c_pkg           CONSTANT VARCHAR2(30) := 'CHUNK_PROXY_UTIL';

    /*******************************************************************************
     * EXECUTION & ORCHESTRATION
     *******************************************************************************/

    /**
     * Procedure: run_chunk
     * Higher-level orchestration procedure to process a document.
     * @param p_doc_id             Target document ID.
     * @param p_recommend_strategy If 'Y', analyze text to suggest best strategy.
     * @param p_force_rechunk      If TRUE, delete existing chunks before starting.
     * @param p_commit_after       Control transaction commit behavior.
     */
    PROCEDURE run_chunk(
        p_doc_id               IN NUMBER,
        p_recommend_strategy   IN CHAR DEFAULT 'N',
        p_force_rechunk        IN BOOLEAN DEFAULT FALSE,
        p_commit_after         IN BOOLEAN DEFAULT TRUE
    );

    /*******************************************************************************
     * MAIN API - PROXY ROUTING FUNCTIONS
     *******************************************************************************/

    /**
     * Function: chunk_text
     * Routes chunking to appropriate implementation based on strategy support.
     * @param p_text                 Source text.
     * @param p_strategy             Method (Sentence, Fixed, Semantic, etc.).
     * @param p_force_implementation Override automatic routing (Custom vs. Native).
     * @return chunk_types.t_chunk_tab Table collection of segments.
     */
    FUNCTION chunk_text(
        p_text                  IN CLOB,
        p_strategy              IN VARCHAR2 DEFAULT chunk_types.c_sentence_boundary,
        p_chunk_size            IN NUMBER   DEFAULT 512,
        p_overlap_size          IN NUMBER   DEFAULT 50,
        p_overlap_pct           IN NUMBER   DEFAULT NULL,
        p_language              IN VARCHAR2 DEFAULT 'AUTO',
        p_max_chunk_size        IN NUMBER   DEFAULT 2048,
        p_min_chunk_size        IN NUMBER   DEFAULT 50,
        p_normalize             IN BOOLEAN  DEFAULT TRUE,
        p_preserve_format       IN BOOLEAN  DEFAULT FALSE,
        p_metadata              IN JSON     DEFAULT NULL,
        p_force_implementation  IN VARCHAR2 DEFAULT NULL
    ) RETURN chunk_types.t_chunk_tab;

    /*******************************************************************************
     * CONFIGURATION & TELEMETRY
     *******************************************************************************/

    /**
     * Function: get_strategy_config
     * Returns the effective configuration including overrides and defaults.
     * @return JSON object with parameters for the chunking engine.
     */
    FUNCTION get_strategy_config( 
        p_doc_id        IN NUMBER, 
        p_strategy_code IN VARCHAR2
    ) RETURN JSON;

    /**
     * Function: chunks_count
     * Quick utility to check existing chunk count for a document via the proxy.
     */
    FUNCTION chunks_count(p_doc_id IN NUMBER) RETURN NUMBER;

END chunk_proxy_util;

/
