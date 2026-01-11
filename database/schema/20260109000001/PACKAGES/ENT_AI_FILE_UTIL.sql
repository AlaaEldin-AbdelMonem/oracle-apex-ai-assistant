--------------------------------------------------------
--  DDL for Package ENT_AI_FILE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "ENT_AI_FILE_UTIL" AS

    c_version           CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name      CONSTANT VARCHAR2(30) := 'ENT_AI_FILE_UTIL'; 

    /**
     * Package: ENT_AI_FILE_UTIL
     * Purpose: File metadata extraction and processing utilities
     * Author: Oracle AI ChatPot Project
     * Date: 2025-10-22
     */

    -- Get MIME type from file extension
    FUNCTION get_mime_type(p_filename IN VARCHAR2) RETURN VARCHAR2;

    -- Extract file extension
    FUNCTION get_file_extension(p_filename IN VARCHAR2) RETURN VARCHAR2;

    -- Get BLOB size
    FUNCTION get_blob_size(p_blob IN BLOB) RETURN NUMBER;

    -- Validate file for upload
    FUNCTION validate_file_upload(
        p_filename IN VARCHAR2,
        p_blob IN BLOB,
        p_max_size_mb IN NUMBER DEFAULT 50
    ) RETURN VARCHAR2; -- Returns NULL if valid, error message if invalid

    -- Extract text from common formats
    FUNCTION extract_text_from_blob(
        p_blob IN BLOB,
        p_mime_type IN VARCHAR2
    ) RETURN CLOB;

    -- Populate file metadata
    PROCEDURE populate_file_metadata(
        p_doc_id IN NUMBER,
        p_filename IN VARCHAR2,
        p_blob IN BLOB
    );

END ent_ai_file_util;

/
