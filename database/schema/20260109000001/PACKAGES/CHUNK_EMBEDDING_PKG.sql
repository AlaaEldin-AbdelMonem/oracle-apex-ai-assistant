--------------------------------------------------------
--  DDL for Package CHUNK_EMBEDDING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CHUNK_EMBEDDING_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_EMBEDDING_PKG (Specification)
 * PURPOSE:     Generate and manage vector embeddings for RAG chunks.
 *
 * DESCRIPTION: Refactored v3.0 logic for Oracle 23ai. Handles modular embedding 
 * generation, batch processing, and database persistence for 
 * vector search operations.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0 (Refactored 3.0 Logic)
 * DATABASE:    Oracle Database 23ai
 */

    -- Global Constants
    c_version            CONSTANT VARCHAR2(10)  := '1.0.0';
    c_package_name       CONSTANT VARCHAR2(30)  := 'CHUNK_EMBEDDING_PKG';

    -- Configuration Defaults
    c_default_model      CONSTANT VARCHAR2(100) := 'E5_MULTILINGUAL';
    c_batch_commit_size  CONSTANT NUMBER        := 50;
    c_max_text_length    CONSTANT NUMBER        := 8000;

    -- Processing Status Codes
    c_status_success     CONSTANT VARCHAR2(20)  := 'SUCCESS';
    c_status_failed      CONSTANT VARCHAR2(20)  := 'FAILED';
    c_status_skipped     CONSTANT VARCHAR2(20)  := 'SKIPPED';

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/

    -- Processing Result for a Single Chunk
    TYPE t_chunk_result IS RECORD (
        doc_chunk_id        NUMBER,
        status              VARCHAR2(20),
        embedding_id        NUMBER,
        processing_time_ms  NUMBER,
        error_message       VARCHAR2(4000)
    );

    TYPE t_chunk_results_tab IS TABLE OF t_chunk_result;

    -- Aggregate Result for Document-Level Processing
    TYPE t_embedding_result IS RECORD (
        doc_id              NUMBER,
        success_count       NUMBER,
        failed_count        NUMBER,
        skipped_count       NUMBER,
        total_chunks        NUMBER,
        processing_time_ms  NUMBER,
        model_used          VARCHAR2(100),
        error_message       CLOB
    );

    -- Intermediate Chunk Data Structure
    TYPE t_chunk_data IS RECORD (
        doc_chunk_id        NUMBER,
        doc_id              NUMBER,
        chunk_text          CLOB,
        chunk_sequence      NUMBER,
        has_embedding       BOOLEAN
    );

    TYPE t_chunk_data_tab IS TABLE OF t_chunk_data;

    /*******************************************************************************
     * CORE EMBEDDING GENERATION
     *******************************************************************************/

    /**
     * Function: generate_embedding
     * Converts raw text into a VECTOR data type.
     */
    FUNCTION generate_embedding(
        p_text  IN CLOB,
        p_model IN VARCHAR2 DEFAULT NULL,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) RETURN VECTOR;

    /**
     * Procedure: generate_chunk_embedding
     * Processes a single identified chunk.
     */
    PROCEDURE generate_chunk_embedding(
        p_doc_chunk_id      IN NUMBER,
        p_model             IN VARCHAR2 DEFAULT NULL,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE,
        p_commit_work       IN BOOLEAN DEFAULT TRUE,
        p_user_id           IN NUMBER  DEFAULT v('G_USER_ID'),
        p_trace_id          IN VARCHAR2 DEFAULT NULL
    );

    /*******************************************************************************
     * DOCUMENT-LEVEL ORCHESTRATION
     *******************************************************************************/

    /**
     * Procedure: generate_document_embeddings
     * Master entrypoint for processing all chunks associated with a document.
     */
    PROCEDURE generate_document_embeddings(
        p_doc_id            IN NUMBER,
        p_model             IN VARCHAR2 DEFAULT NULL,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE,
        p_batch_commit_size IN NUMBER DEFAULT c_batch_commit_size,
        p_result            OUT t_embedding_result,
        p_user_id           IN NUMBER  DEFAULT v('G_USER_ID'),
         p_trace_id          IN VARCHAR2 DEFAULT NULL
    );

    /*******************************************************************************
     * PIPELINE SUB-FUNCTIONS (Modularized for v3.0)
     *******************************************************************************/

    FUNCTION validate_document(p_doc_id IN NUMBER) RETURN VARCHAR2;

    FUNCTION get_document_chunks(
        p_doc_id            IN NUMBER,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE
    ) RETURN t_chunk_data_tab;

    FUNCTION is_chunk_valid(p_chunk IN t_chunk_data) RETURN BOOLEAN;

    FUNCTION process_single_chunk_embedding(
        p_chunk             IN t_chunk_data,
        p_model             IN VARCHAR2,
        p_force_regenerate  IN BOOLEAN,
        p_user_id           IN NUMBER DEFAULT v('G_USER_ID')
    ) RETURN t_chunk_result;

    FUNCTION save_embedding(
        p_doc_chunk_id      IN NUMBER,
        p_doc_id            IN NUMBER,
        p_embedding_vector  IN VECTOR,
        p_model             IN VARCHAR2,
        p_user_id           IN NUMBER DEFAULT v('G_USER_ID')
    ) RETURN NUMBER;

    FUNCTION process_chunks_batch(
        p_chunks            IN t_chunk_data_tab,
        p_model             IN VARCHAR2,
        p_force_regenerate  IN BOOLEAN,
        p_batch_size        IN NUMBER,
        p_user_id           IN NUMBER DEFAULT v('G_USER_ID')
    ) RETURN t_chunk_results_tab;

    FUNCTION aggregate_batch_results(
        p_doc_id            IN NUMBER,
        p_chunk_results     IN t_chunk_results_tab,
        p_model             IN VARCHAR2,
        p_total_time_ms     IN NUMBER
    ) RETURN t_embedding_result;

    PROCEDURE log_document_embedding_completion(
        p_result            IN t_embedding_result,
        p_user_id           IN NUMBER DEFAULT v('G_USER_ID')
    );

    /*******************************************************************************
     * UTILITY & TELEMETRY
     *******************************************************************************/

    FUNCTION get_default_model RETURN VARCHAR2;

    FUNCTION embedding_exists(p_doc_chunk_id IN NUMBER) RETURN BOOLEAN;

    FUNCTION get_chunk_count(p_doc_id IN NUMBER) RETURN NUMBER;

    FUNCTION get_embedding_count(p_doc_id IN NUMBER) RETURN NUMBER;

    PROCEDURE enable_debug;

    PROCEDURE disable_debug;

END chunk_embedding_pkg;

/
