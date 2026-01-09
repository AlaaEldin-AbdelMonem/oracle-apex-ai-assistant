--------------------------------------------------------
--  DDL for Package Body ENT_AI_FILE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."ENT_AI_FILE_UTIL" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Get MIME type from file extension
    FUNCTION get_mime_type(p_filename IN VARCHAR2) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_mime_type'; 
        v_extension VARCHAR2(50);
        v_mime_type VARCHAR2(255);
    BEGIN
        v_extension := UPPER(get_file_extension(p_filename));

        v_mime_type := CASE v_extension
            -- Documents
            WHEN 'PDF' THEN 'application/pdf'
            WHEN 'DOC' THEN 'application/msword'
            WHEN 'DOCX' THEN 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
            WHEN 'XLS' THEN 'application/vnd.ms-excel'
            WHEN 'XLSX' THEN 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
            WHEN 'PPT' THEN 'application/vnd.ms-powerpoint'
            WHEN 'PPTX' THEN 'application/vnd.openxmlformats-officedocument.presentationml.presentation'

            -- Text formats
            WHEN 'TXT' THEN 'text/plain'
            WHEN 'CSV' THEN 'text/csv'
            WHEN 'JSON' THEN 'application/json'
            WHEN 'XML' THEN 'application/xml'
            WHEN 'HTML' THEN 'text/html'
            WHEN 'HTM' THEN 'text/html'
            WHEN 'MD' THEN 'text/markdown'

            -- Images
            WHEN 'JPG' THEN 'image/jpeg'
            WHEN 'JPEG' THEN 'image/jpeg'
            WHEN 'PNG' THEN 'image/png'
            WHEN 'GIF' THEN 'image/gif'
            WHEN 'BMP' THEN 'image/bmp'

            -- Archives
            WHEN 'ZIP' THEN 'application/zip'
            WHEN 'RAR' THEN 'application/x-rar-compressed'

            -- Default
            ELSE 'application/octet-stream'
        END;

        RETURN v_mime_type;
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RETURN 'application/octet-stream';
    END get_mime_type;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Extract file extension
    FUNCTION get_file_extension(p_filename IN VARCHAR2) RETURN VARCHAR2 IS
         vcaller constant varchar2(70):= c_package_name ||'.get_file_extension'; 
        v_pos NUMBER;
    BEGIN
        IF p_filename IS NULL THEN
            RETURN NULL;
        END IF;

        v_pos := INSTR(p_filename, '.', -1);

        IF v_pos > 0 THEN
            RETURN UPPER(SUBSTR(p_filename, v_pos + 1));
        ELSE
            RETURN NULL;
        END IF;
    END get_file_extension;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Get BLOB size
    FUNCTION get_blob_size(p_blob IN BLOB) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.get_blob_size'; 
    BEGIN
        IF p_blob IS NULL THEN
            RETURN 0;
        END IF;

        RETURN DBMS_LOB.GETLENGTH(p_blob);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END get_blob_size;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Validate file for upload
    FUNCTION validate_file_upload(
        p_filename IN VARCHAR2,
        p_blob IN BLOB,
        p_max_size_mb IN NUMBER DEFAULT 50
    ) RETURN VARCHAR2 IS 
        vcaller constant varchar2(70):= c_package_name ||'.validate_file_upload'; 
        v_file_size NUMBER;
        v_max_size_bytes NUMBER;
        v_extension VARCHAR2(50);
        v_allowed_extensions VARCHAR2(500) := 'PDF,DOC,DOCX,XLS,XLSX,TXT,CSV,JSON,XML,HTML,MD';
    BEGIN
        -- Check filename
        IF p_filename IS NULL OR LENGTH(TRIM(p_filename)) = 0 THEN
            RETURN 'Filename is required';
        END IF;

        -- Check BLOB
        IF p_blob IS NULL THEN
            RETURN 'File content is required';
        END IF;

        -- Check file size
        v_file_size := get_blob_size(p_blob);
        v_max_size_bytes := p_max_size_mb * 1024 * 1024;

        IF v_file_size = 0 THEN
            RETURN 'File is empty';
        END IF;

        IF v_file_size > v_max_size_bytes THEN
            RETURN 'File size (' || ROUND(v_file_size/1024/1024, 2) || ' MB) exceeds maximum allowed (' || p_max_size_mb || ' MB)';
        END IF;

        -- Check file extension
        v_extension := get_file_extension(p_filename);
        IF v_extension IS NULL THEN
            RETURN 'File must have a valid extension';
        END IF;

        IF INSTR(',' || v_allowed_extensions || ',', ',' || v_extension || ',') = 0 THEN
            RETURN 'File type .' || v_extension || ' is not allowed. Allowed types: ' || v_allowed_extensions;
        END IF;

        -- All validations passed
        RETURN NULL;
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RETURN 'Validation error: ' || SQLERRM;
    END validate_file_upload;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Extract text from common formats
    FUNCTION extract_text_from_blob(
        p_blob IN BLOB,
        p_mime_type IN VARCHAR2
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.extract_text_from_blob'; 
        v_text CLOB;
    BEGIN
        -- For now, basic implementation for text files
        -- Production version would use Oracle Text, DBMS_TEXT, or external tools

        IF p_mime_type LIKE 'text/%' THEN
            -- Convert BLOB to CLOB for text files
            v_text := UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(p_blob, 32767, 1));
        ELSE
            -- Placeholder for other formats (PDF, DOCX, etc.)
            -- Would require DBMS_TEXT or external extraction
            v_text := '-- Text extraction not yet implemented for ' || p_mime_type || ' --';
        END IF;

        RETURN v_text;
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RETURN '-- Text extraction error: ' || SQLERRM || ' --';
    END extract_text_from_blob;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Populate file metadata
    PROCEDURE populate_file_metadata(
        p_doc_id IN NUMBER,
        p_filename IN VARCHAR2,
        p_blob IN BLOB
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.populate_file_metadata'; 
        v_mime_type VARCHAR2(255);
        v_file_size NUMBER;
        v_extension VARCHAR2(50);
    BEGIN
        -- Extract metadata
        v_mime_type := get_mime_type(p_filename);
        v_file_size := get_blob_size(p_blob);
        v_extension := get_file_extension(p_filename);

        -- Update record
        UPDATE docs
        SET file_name = p_filename,
            file_mime_type = v_mime_type,
            file_size = v_file_size,
            file_version_no = NVL(file_version_no, 1),
            updated_at = SYSTIMESTAMP,
            updated_by = COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER),
            -- Set default status if not already set
            doc_status = COALESCE(doc_status, 'DRAFT'),
            -- Set RAG_READY_FLAG based on file type
            rag_ready_flag = CASE 
                WHEN v_extension IN ('TXT', 'MD', 'CSV') THEN 'Y'
                ELSE 'N'
            END
        WHERE doc_id = p_doc_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RAISE_APPLICATION_ERROR(-20001, 
                'Error populating file metadata: ' || SQLERRM);
    END populate_file_metadata;
/*******************************************************************************
 *  
 *******************************************************************************/
END ent_ai_file_util;

/
