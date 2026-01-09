--------------------------------------------------------
--  DDL for Package DOC_EXTRACT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."DOC_EXTRACT_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      DOC_EXTRACT_PKG (Specification)
 * PURPOSE:     Document Text Extraction and Content Normalization.
 *
 * DESCRIPTION: Provides tools to convert BLOB-based documents (PDF, Office, etc.) 
 * into CLOB-based text. It serves as the initial gateway in the RAG 
 * pipeline, ensuring content is ready for chunking and embedding.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  Oracle Text (ctx_doc) or DBMS_VECTOR_CHAIN
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'DOC_EXTRACT_PKG'; 

    /*******************************************************************************
     * CORE EXTRACTION FUNCTIONS
     *******************************************************************************/

    /**
     * Function: extract_text
     * Low-level utility to convert a binary blob into plain text.
     * @param  p_blob The source document binary.
     * @return CLOB   The extracted text content.
     */
    FUNCTION extract_text(p_blob IN BLOB) RETURN CLOB;

    /**
     * Function: is_text_ready
     * Validates if a document has already undergone successful text extraction.
     * @param  p_doc_id The document identifier.
     * @return BOOLEAN  TRUE if text content exists and is valid.
     */
    FUNCTION is_text_ready(p_doc_id IN NUMBER) RETURN BOOLEAN;

    /*******************************************************************************
     * PERSISTENCE & GENERATION
     *******************************************************************************/

    /**
     * Procedure: generate_text
     * Processes a document by ID and updates the text_extracted column in the docs table.
     * @param p_doc_id      The document identifier.
     * @param p_commit_flag 'Y' to commit the transaction after extraction.
     */
    PROCEDURE generate_text(
        p_doc_id      IN NUMBER,
        p_commit_flag IN CHAR DEFAULT 'Y'
    );

    /**
     * Function: generate_text
     * Overloaded version that processes the document and returns the result directly.
     * @return CLOB extracted text.
     */
    FUNCTION generate_text(
        p_doc_id      IN NUMBER,
        p_commit_flag IN CHAR DEFAULT 'Y'
    ) RETURN CLOB;

END doc_extract_pkg;

/
