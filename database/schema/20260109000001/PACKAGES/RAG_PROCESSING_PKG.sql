--------------------------------------------------------
--  DDL for Package RAG_PROCESSING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."RAG_PROCESSING_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_PROCESSING_PKG (Specification)
 * PURPOSE:     Main Orchestrator for RAG Document Processing.
 *
 * DESCRIPTION: This package acts as the central coordinator for the RAG 
 * lifecycle. It manages the sequence of operations required to turn 
 * unstructured files into searchable vector data. Key responsibilities:
 * - Coordinating text extraction from BLOBs.
 * - Triggering the chunking engine with selected strategies.
 * - Calling embedding models to generate vector representations.
 * - Handling document deletion and embedding maintenance.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_PROCESSING_PKG'; 

    /*******************************************************************************
     * CORE PIPELINE OPERATIONS
     *******************************************************************************/

    /**
     * Procedure: process_document
     * The primary entry point for document ingestion. 
     * Orchestrates: Extraction -> Chunking -> Embedding -> Logging.
     * * @param p_doc_id           The ID of the document in the source table.
     * @param p_chunking_strategy The algorithm to use (e.g., 'SEMANTIC', 'FIXED').
     * @param p_create_embeddings If TRUE, generates vectors after chunking.
     * @param p_user_name         Contextual user from APEX session.
     * @param p_tenant_id         Multi-tenant isolation ID.
     */
    PROCEDURE process_document(
        p_doc_id            IN NUMBER,
        p_chunking_strategy IN VARCHAR2 DEFAULT 'SEMANTIC',
        p_create_embeddings IN BOOLEAN  DEFAULT TRUE,
        p_user_name         IN VARCHAR2 DEFAULT v('APP_USER'),
        p_user_id           IN NUMBER   DEFAULT v('G_USER_ID'),
        p_app_session_id    IN NUMBER   DEFAULT v('APP_SESSION'),
        p_app_id            IN NUMBER   DEFAULT v('APP_ID'),
        p_app_page_id       IN NUMBER   DEFAULT v('APP_PAGE_ID'),
        p_tenant_id         IN NUMBER   DEFAULT v('G_TENANT_ID')
    );

    /*******************************************************************************
     * MAINTENANCE & CLEANUP
     *******************************************************************************/

    /**
     * Procedure: delete_document_chunks
     * Safely removes all fragments and associated vectors for a document.
     * Essential for maintaining index hygiene when files are deleted or updated.
     */
    PROCEDURE delete_document_chunks(p_doc_id NUMBER);

    /**
     * Procedure: refresh_embeddings
     * Re-generates vectors for existing chunks. 
     * Useful when switching embedding models or correcting processing errors.
     * * @param p_doc_id        If provided, refreshes only one document; else, all.
     * @param p_force_refresh If TRUE, ignores existing vectors and overwrites.
     */
    PROCEDURE refresh_embeddings(
        p_doc_id        IN NUMBER  DEFAULT NULL,
        p_force_refresh IN BOOLEAN DEFAULT FALSE
    );

END rag_processing_pkg;

/
