--------------------------------------------------------
--  DDL for Package APP_CHUNK_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."APP_CHUNK_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      APP_CHUNK_PKG (Specification)
 * PURPOSE:     APEX Integration Layer for RAG Chunk Generation.
 * * DESCRIPTION: Provides APEX-specific wrapper functions for chunk generation 
 * with comprehensive validation, transaction management, and 
 * user feedback (apex_error/apex_application).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'APP_CHUNK_PKG';

    -- Configuration Constants
    c_min_doc_size  CONSTANT NUMBER       := 50;        -- Min bytes
    c_max_doc_size  CONSTANT NUMBER       := 10485760;  -- Max 10MB
    c_valid_status_1 CONSTANT VARCHAR2(20) := 'ACTIVE';
    c_valid_status_2 CONSTANT VARCHAR2(20) := 'PUBLISHED';

    /***************************************************************************
     * TYPE DEFINITIONS
     ***************************************************************************/

    /**
     * Type: t_validation_result
     * Structured result for pre-chunking document validation checks.
     */
    TYPE t_validation_result IS RECORD (
        is_valid        BOOLEAN,
        error_code      VARCHAR2(100),
        error_message   VARCHAR2(4000),
        doc_title       VARCHAR2(500),
        doc_size        NUMBER,
        doc_status      VARCHAR2(50),
        existing_chunks NUMBER
    );

    /**
     * Type: t_chunk_result
     * Structured result from the core chunking execution engine.
     */
    TYPE t_chunk_result IS RECORD (
        success            BOOLEAN,
        chunk_count        NUMBER,
        strategy_used      VARCHAR2(100),
        processing_time_ms NUMBER,
        error_code         VARCHAR2(100),
        error_message      VARCHAR2(4000)
    );

    /***************************************************************************
     * MAIN APEX INTEGRATION
     ***************************************************************************/

    /**
     * Procedure: generate_chunks_for_apex
     * Entry point for APEX Page Processes (e.g., Page 630).
     * * @param p_doc_id              ID of document in ENT_AI_DOCS
     * @param p_app_user            Defaults to V('APP_USER')
     * @param p_auto_replace_chunks If TRUE, deletes old chunks before starting
     */
    PROCEDURE generate_chunks_for_apex(
        p_doc_id              IN NUMBER,
        p_app_user            IN VARCHAR2 DEFAULT NULL,
        p_auto_replace_chunks IN BOOLEAN DEFAULT TRUE
    );

    /***************************************************************************
     * VALIDATION & MANAGEMENT
     ***************************************************************************/

    /**
     * Function: validate_document_for_chunking
     * Runs 5+ point check (Existence, Content, Size, Status).
     */
    FUNCTION validate_document_for_chunking(
        p_doc_id IN NUMBER
    ) RETURN t_validation_result;

    FUNCTION check_existing_chunks(p_doc_id IN NUMBER) RETURN NUMBER;

    FUNCTION delete_existing_chunks(p_doc_id IN NUMBER) RETURN NUMBER;

    FUNCTION generate_chunks_internal(p_doc_id IN NUMBER) RETURN t_chunk_result;

    /***************************************************************************
     * AUDIT & LOGGING (JSON FORMAT)
     ***************************************************************************/

    PROCEDURE log_chunk_generation_json(
        p_doc_id          IN NUMBER,
        p_doc_title       IN VARCHAR2,
        p_user_name       IN VARCHAR2,
        p_strategy        IN VARCHAR2,
        p_chunk_count     IN NUMBER,
        p_processing_time IN NUMBER
    );

    PROCEDURE log_chunk_deletion_json(
        p_doc_id      IN NUMBER,
        p_doc_title   IN VARCHAR2,
        p_user_name   IN VARCHAR2,
        p_chunk_count IN NUMBER
    );

    /***************************************************************************
     * UTILITIES & UI FEEDBACK
     ***************************************************************************/

    FUNCTION format_doc_size(p_size_bytes IN NUMBER) RETURN VARCHAR2;

    FUNCTION format_processing_time(p_time_ms IN NUMBER) RETURN VARCHAR2;

    /**
     * Function: build_success_message
     * Returns HTML formatted string for APEX Success Message area.
     */
    FUNCTION build_success_message(
        p_doc_title       IN VARCHAR2,
        p_chunk_count     IN NUMBER,
        p_strategy        IN VARCHAR2,
        p_doc_size        IN NUMBER,
        p_processing_time IN NUMBER,
        p_replaced_count  IN NUMBER DEFAULT 0
    ) RETURN VARCHAR2;

    FUNCTION build_error_message(
        p_error_title   IN VARCHAR2,
        p_error_message IN VARCHAR2,
        p_error_code    IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

END app_chunk_pkg;

/
