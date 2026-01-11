--------------------------------------------------------
--  DDL for Package RAG_API_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "RAG_API_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_API_PKG (Specification)
 * PURPOSE:     External API Facade for RAG Operations.
 *
 * DESCRIPTION: Provides a standardized REST-ready interface for managing the 
 * RAG lifecycle. This package handles the parsing of JSON request bodies, 
 * orchestrates the underlying document processing/embedding logic, and 
 * returns standardized JSON responses suitable for ORDS or APEX REST services.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * INTERFACE:   JSON / REST
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_API_PKG'; 

    /*******************************************************************************
     * DOCUMENT PROCESSING API
     *******************************************************************************/

    /**
     * Function: process_document_api
     * Endpoint: POST /rag/processDocument
     * Triggers the full extraction, chunking, and embedding pipeline for a document.
     * * @param p_body JSON CLOB containing doc_id and processing options.
     * @return CLOB  JSON Response status (Success/Error/Job ID).
     */
    FUNCTION process_document_api(
        p_body CLOB
    ) RETURN CLOB;

    /*******************************************************************************
     * EMBEDDING MAINTENANCE API
     *******************************************************************************/

    /**
     * Function: refresh_embeddings_api
     * Endpoint: POST /rag/refreshEmbeddings
     * Triggers a refresh of vector embeddings, potentially for a whole domain.
     * * @param p_body JSON CLOB containing filters (domain_id, force_refresh).
     * @return CLOB  JSON Response with count of records queued for refresh.
     */
    FUNCTION refresh_embeddings_api(
        p_body CLOB
    ) RETURN CLOB;

    /*******************************************************************************
     * CLEANUP API
     *******************************************************************************/

    /**
     * Function: delete_document_chunks_api
     * Endpoint: DELETE /rag/documentChunks/{doc_id}
     * Safely removes all vector chunks and metadata associated with a document ID.
     * * @param p_doc_id The primary key of the document.
     * @return CLOB    JSON Result confirmation.
     */
    FUNCTION delete_document_chunks_api(
        p_doc_id NUMBER
    ) RETURN CLOB;

END rag_api_pkg;

/
