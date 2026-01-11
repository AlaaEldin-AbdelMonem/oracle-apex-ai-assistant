--------------------------------------------------------
--  DDL for Package RAG_PROCESSING_PKG_LEGACY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "RAG_PROCESSING_PKG_LEGACY" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_PROCESSING_PKG_LEGACY (Specification)
 * PURPOSE:     Legacy Orchestrator for RAG Document Processing.
 *
 * DESCRIPTION: Handles the transformation of raw document BLOBs into searchable 
 * text segments. This legacy version contains direct text extraction logic 
 * and specific record types for chunk arrays. It is designed to support 
 * environments where text extraction is performed natively within the package.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_PROCESSING_PKG_LEGACY'; 

    /*******************************************************************************
     * DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_chunk_rec
     * Represents a single segment of text extracted from a larger document.
     */
    TYPE t_chunk_rec IS RECORD (
        chunk_text      CLOB,           -- The actual text content
        chunk_sequence  NUMBER,         -- Order of the chunk in the document
        metadata_json   CLOB            -- Metadata (page numbers, headers, etc.)
    );

    /** Collection of chunks for bulk processing. */
    TYPE t_chunk_array IS TABLE OF t_chunk_rec;

    /*******************************************************************************
     * MAIN PIPELINE OPERATIONS
     *******************************************************************************/

    /**
     * Procedure: process_document
     * Orchestrates the full lifecycle: Text Extraction -> Chunking -> Vectorizing.
     */
    PROCEDURE process_document(
        p_doc_id             IN NUMBER,
        p_chunking_strategy  IN VARCHAR2 DEFAULT 'SEMANTIC',
        p_create_embeddings  IN BOOLEAN  DEFAULT TRUE,
        p_user_name          IN VARCHAR2 DEFAULT v('APP_USER'),
        p_user_id            IN NUMBER   DEFAULT v('G_USER_ID'),
        p_app_session_id     IN NUMBER   DEFAULT v('APP_SESSION'),
        p_app_id             IN NUMBER   DEFAULT v('APP_ID'),
        p_app_page_id        IN NUMBER   DEFAULT v('APP_PAGE_ID'),
        p_tenant_id          IN NUMBER   DEFAULT v('G_TENANT_ID')
    );

    /**
     * Procedure: refresh_embeddings
     * Updates vectors for existing chunks without re-chunking the document.
     */
    PROCEDURE refresh_embeddings(
        p_doc_id         IN NUMBER  DEFAULT NULL,
        p_force_refresh  IN BOOLEAN DEFAULT FALSE
    );

    /**
     * Procedure: delete_document_chunks
     * Removes all fragments associated with a document.
     */
    PROCEDURE delete_document_chunks(
        p_doc_id IN NUMBER
    );

    /*******************************************************************************
     * TEXT EXTRACTION UTILITIES
     *******************************************************************************/

    /** Converts a BLOB (PDF, Docx, etc.) into plain text CLOB. */
    FUNCTION doc_to_text( p_blob_doc BLOB ) RETURN CLOB;

    /** Generates and persists text for a document record. */
    PROCEDURE generate_doc_text( p_doc_id IN NUMBER, p_commit_flag CHAR DEFAULT 'Y' );

    /** Generates and returns text for a document record. */
    FUNCTION generate_doc_text( p_doc_id IN NUMBER, p_commit_flag CHAR DEFAULT 'Y' ) RETURN CLOB;

    /** Checks if a document has already been processed into text. */
    FUNCTION is_doc_texted( p_doc_id IN NUMBER ) RETURN VARCHAR2;

END rag_processing_pkg_legacy;

/
