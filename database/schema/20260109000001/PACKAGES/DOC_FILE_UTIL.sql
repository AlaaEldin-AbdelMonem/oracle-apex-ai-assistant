--------------------------------------------------------
--  DDL for Package DOC_FILE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."DOC_FILE_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      DOC_FILE_UTIL (Specification)
 * PURPOSE:     File Metadata Extraction and Processing Utilities.
 *
 * DESCRIPTION: Provides helper functions for managing binary files within 
 * the database. Handles MIME type detection, file validation, 
 * size calculations, and metadata synchronization for the document store.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DATE:        2025-10-22
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'DOC_FILE_UTIL'; 

    /*******************************************************************************
     * FILE ATTRIBUTE UTILITIES
     *******************************************************************************/

    /**
     * Function: get_mime_type
     * Maps a filename extension to its standard Internet Media Type (MIME).
     */
    FUNCTION get_mime_type(p_filename IN VARCHAR2) RETURN VARCHAR2;

    /**
     * Function: get_file_extension
     * Extracts the extension from a given filename (e.g., 'report.pdf' -> 'pdf').
     */
    FUNCTION get_file_extension(p_filename IN VARCHAR2) RETURN VARCHAR2;

    /**
     * Function: get_blob_size
     * Returns the size of a binary object in bytes.
     */
    FUNCTION get_blob_size(p_blob IN BLOB) RETURN NUMBER;

    /*******************************************************************************
     * VALIDATION & PROCESSING
     *******************************************************************************/

    /**
     * Function: validate_file_upload
     * Performs security and size checks on uploaded content.
     * @param p_max_size_mb Maximum allowed size (default 50MB).
     * @return VARCHAR2     NULL if valid, or a descriptive error message.
     */
    FUNCTION validate_file_upload(
        p_filename     IN VARCHAR2,
        p_blob         IN BLOB,
        p_max_size_mb  IN NUMBER DEFAULT 50
    ) RETURN VARCHAR2;

    /**
     * Function: extract_text_from_blob
     * High-level wrapper to convert binary content into searchable text.
     */
    FUNCTION extract_text_from_blob(
        p_blob       IN BLOB,
        p_mime_type  IN VARCHAR2
    ) RETURN CLOB;

    /*******************************************************************************
     * METADATA SYNCHRONIZATION
     *******************************************************************************/

    /**
     * Procedure: populate_file_metadata
     * Updates the central document table with size, type, and extension info.
     * @param p_doc_id   The primary key of the document record.
     */
    PROCEDURE populate_file_metadata(
        p_doc_id    IN NUMBER,
        p_filename  IN VARCHAR2,
        p_blob      IN BLOB
    );

END doc_file_util;

/
