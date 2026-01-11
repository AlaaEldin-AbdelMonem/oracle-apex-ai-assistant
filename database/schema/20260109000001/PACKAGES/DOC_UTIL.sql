--------------------------------------------------------
--  DDL for Package DOC_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "DOC_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      DOC_UTIL (Specification)
 * PURPOSE:     High-level Document Lifecycle and AI Activity Management.
 *
 * DESCRIPTION: Acts as the primary API for document operations. Orchestrates 
 * creation, status tracking, text extraction, and RAG (Retrieval-Augmented 
 * Generation) readiness. Includes telemetry for logging AI interactions 
 * and model performance.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'DOC_UTIL'; 

    /*******************************************************************************
     * DOCUMENT CREATION (CRUD)
     *******************************************************************************/

    /**
     * Function: create_doc
     * Main entry point for registering a new document in the repository.
     * @return NUMBER The newly generated doc_id.
     */
    FUNCTION create_doc(
        p_title          IN VARCHAR2,
        p_category       IN VARCHAR2,
        p_description    IN CLOB     DEFAULT NULL,
        p_file_name      IN VARCHAR2 DEFAULT NULL,
        p_mime_type      IN VARCHAR2 DEFAULT NULL,
        p_file_blob      IN BLOB     DEFAULT NULL,
        p_language_code  IN VARCHAR2 DEFAULT 'EN',
        p_classification IN VARCHAR2 DEFAULT 'INTERNAL',
        p_sensitivity    IN VARCHAR2 DEFAULT 'MEDIUM',
        p_created_by     IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;

    /**
     * Function: create_doc (Overloaded)
     * Version maintained for backward compatibility with legacy ingestion scripts.
     */
    FUNCTION create_doc(
        p_title       IN VARCHAR2,
        p_category    IN VARCHAR2,
        p_description IN VARCHAR2,
        p_file_name   IN VARCHAR2,
        p_mime_type   IN VARCHAR2,
        p_file_blob   IN BLOB,
        p_created_by  IN VARCHAR2
    ) RETURN NUMBER;

    /*******************************************************************************
     * STATUS & WORKFLOW MANAGEMENT
     *******************************************************************************/

    /**
     * Procedure: update_status
     * Moves a document through the workflow (e.g., UPLOADED -> EXTRACTED -> READY).
     */
    PROCEDURE update_status(
        p_doc_id      IN NUMBER,
        p_status      IN VARCHAR2,
        p_updated_by  IN VARCHAR2 DEFAULT NULL
    );

    /**
     * Procedure: mark_rag_ready
     * Finalizes the ingestion process, flagging the document as available for 
     * AI context retrieval after vector embeddings are verified.
     */
    PROCEDURE mark_rag_ready(
        p_doc_id           IN NUMBER,
        p_embedding_count  IN NUMBER DEFAULT 0
    );

    /**
     * Procedure: soft_delete
     * Flags a document as inactive without removing physical records, 
     * preserving audit trails.
     */
    PROCEDURE soft_delete(p_doc_id IN NUMBER);

    /*******************************************************************************
     * CONTENT & AI TELEMETRY
     *******************************************************************************/

    /**
     * Function: extract_text
     * Wrapper for the doc_extract_pkg logic to simplify text retrieval.
     */
    FUNCTION extract_text(p_blob IN BLOB) RETURN CLOB;

    /**
     * Procedure: log_ai_activity
     * Records telemetry for AI interactions, including performance metrics 
     * and token consumption for cost tracking.
     */
    PROCEDURE log_ai_activity(
        p_action             IN VARCHAR2,
        p_model_name         IN VARCHAR2 DEFAULT NULL,
        p_doc_id             IN NUMBER   DEFAULT NULL,
        p_user_query         IN CLOB     DEFAULT NULL,
        p_ai_response        IN CLOB     DEFAULT NULL,
        p_execution_time_ms  IN NUMBER   DEFAULT NULL,
        p_token_count        IN NUMBER   DEFAULT NULL
    );

    /*******************************************************************************
     * RETRIEVAL
     *******************************************************************************/

    /**
     * Function: get_doc
     * Returns the full row record from the docs table for a specific ID.
     */
    FUNCTION get_doc(p_doc_id IN NUMBER) RETURN docs%ROWTYPE;

END doc_util;

/
