--------------------------------------------------------
--  DDL for Package Body DOC_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."DOC_UTIL" AS

    FUNCTION create_doc(
        p_title VARCHAR2,
        p_category VARCHAR2,
        p_description CLOB DEFAULT NULL,
        p_file_name VARCHAR2 DEFAULT NULL,
        p_mime_type VARCHAR2 DEFAULT NULL,
        p_file_blob BLOB DEFAULT NULL,
        p_language_code VARCHAR2 DEFAULT 'EN',
        p_classification VARCHAR2 DEFAULT 'INTERNAL',
        p_sensitivity VARCHAR2 DEFAULT 'MEDIUM',
        p_created_by VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.create_doc'; 
        v_doc_id NUMBER;
        v_file_size NUMBER := 0;
        v_user VARCHAR2(100);
        v_classification_num NUMBER;
    BEGIN
        v_user := COALESCE(p_created_by, SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);

        IF p_file_blob IS NOT NULL THEN
            v_file_size := DBMS_LOB.GETLENGTH(p_file_blob);
        END IF;

        -- Map classification string to number
        -- Default classifications: 1=Public, 2=Internal, 3=Confidential, 4=Restricted, 5=Secret
        v_classification_num := CASE UPPER(p_classification)
            WHEN 'PUBLIC' THEN 1
            WHEN 'INTERNAL' THEN 2
            WHEN 'CONFIDENTIAL' THEN 3
            WHEN 'RESTRICTED' THEN 4
            WHEN 'SECRET' THEN 5
            ELSE 2 -- Default to INTERNAL
        END;

        INSERT INTO docs (
            doc_title,
            doc_category,
            doc_description,
            file_name,
            file_mime_type,
            file_blob,
            file_size,
            language_code,
            classification_level,
            sensitivity_level,
            doc_status,
            rag_ready_flag,
            created_by,
            created_at,
            is_active
        ) VALUES (
            p_title,
            p_category,
            p_description,
            p_file_name,
            p_mime_type,
            p_file_blob,
            v_file_size,
            p_language_code,
            v_classification_num,
            p_sensitivity,
            'DRAFT',
            'N',
            v_user,
            SYSTIMESTAMP,
            'Y'
        ) RETURNING doc_id INTO v_doc_id;

        COMMIT;
        RETURN v_doc_id;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            ROLLBACK;
            RAISE;
    END create_doc;
 /*******************************************************************************/
    -- Backward compatibility version
    FUNCTION create_doc(
        p_title VARCHAR2,
        p_category VARCHAR2,
        p_description VARCHAR2,
        p_file_name VARCHAR2,
        p_mime_type VARCHAR2,
        p_file_blob BLOB,
        p_created_by VARCHAR2
    ) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.create_doc'; 
    BEGIN
        RETURN create_doc(
            p_title => p_title,
            p_category => p_category,
            p_description => TO_CLOB(p_description),
            p_file_name => p_file_name,
            p_mime_type => p_mime_type,
            p_file_blob => p_file_blob,
            p_created_by => p_created_by
        );
    END create_doc;
 /*******************************************************************************/
    PROCEDURE update_status(
        p_doc_id NUMBER,
        p_status VARCHAR2,
        p_updated_by VARCHAR2 DEFAULT NULL
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.update_status'; 
        v_user VARCHAR2(100);
    BEGIN
        v_user := COALESCE(p_updated_by, SYS_CONTEXT('APEX$SESSION','APP_USER'), USER);

        UPDATE docs
        SET doc_status = p_status,
            updated_by = v_user,
            updated_at = SYSTIMESTAMP
        WHERE doc_id = p_doc_id;

        COMMIT;
    END update_status;

    /*******************************************************************************
  FUNCTION extract_text(  p_blob       BLOB,  p_mime_type  VARCHAR2 ) RETURN CLOB 
 
 * Purpose:
 *   Extracts plain text content from a binary document (BLOB) using Oracle 23ai’s
 *   built-in AI text extraction engine. This function can handle various MIME
 *   types (PDF, DOCX, XLSX, PPTX, TXT, HTML, etc.) and returns the extracted
 *   text as a CLOB for downstream processing (e.g., RAG ingestion, summarization,
 *   or embedding generation).
 *
 * Dependencies:
 *   - Requires Oracle Database 23ai or later.
 *   - Requires EXECUTE privilege on DBMS_CLOUD_AI.
 *
 * Parameters:
 *   p_blob        IN  BLOB
 *       The binary content of the uploaded file (e.g., from APEX file browse item).
 *
 *   p_mime_type   IN  VARCHAR2
 *       The MIME type of the file (e.g., 'application/pdf', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document').
 *
 * Return:
 *   CLOB – The extracted plain text content.
 *
 * Exceptions:
 *   - Returns an error message (as text) if extraction fails or unsupported MIME type is passed.
 *   - Catches unexpected errors using WHEN OTHERS and includes SQLERRM for debugging.
 *
 * Example Usage:
 * ---------- 
 *   DECLARE
 *       v_text  CLOB;
 *   BEGIN
 *       v_text := extract_text(
 *                     p_blob       => :P10_FILE_BLOB,
 *                     p_mime_type  => :P10_FILE_MIMETYPE
 *                 );
 *       DBMS_OUTPUT.PUT_LINE(SUBSTR(v_text, 1, 500)); -- print first 500 chars
 *   END;
 * --------- 
 *
 * Notes:
- The documentation states:  
   "Oracle Text supports around 150 file types." : 
- It also indicates this function uses the Oracle Text `CONTEXT` engine under the covers 
- Although you might expect more parameters (e.g., for layout preservation, OCR, image-handling, page-ranges, etc.), none are documented in the official guide for `UTL_TO_TEXT` as of now.
.
 *******************************************************************************/
 FUNCTION extract_text(
    p_blob       BLOB 
) RETURN CLOB IS
   vcaller constant varchar2(70):= c_package_name ||'.extract_text'; 
    v_text  CLOB;
BEGIN
 
 
    IF p_blob IS NULL THEN
        RETURN 'Error: Input BLOB is NULL. Please upload a valid document.';
    END IF;
 
    --   Extract Text Using Oracle 23ai AI Text Extraction Engine
    v_text := DBMS_VECTOR_CHAIN.UTL_TO_TEXT(  p_blob,  JSON('{"plaintext":"true","charset":"UTF8"}') ) ;
 
    RETURN v_text;

EXCEPTION
 
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        RETURN 'Text extraction failed: ' || SQLERRM;
END extract_text;
 /*******************************************************************************/
    PROCEDURE mark_rag_ready(
        p_doc_id NUMBER,
        p_embedding_count NUMBER DEFAULT 0
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.mark_rag_ready'; 
    BEGIN
        UPDATE docs
        SET rag_ready_flag = 'Y',
            embedding_count = p_embedding_count,
            updated_at = SYSTIMESTAMP,
            updated_by = COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER)
        WHERE doc_id = p_doc_id;

        COMMIT;
    END mark_rag_ready;

    PROCEDURE log_ai_activity(  p_action VARCHAR2,
                                p_model_name VARCHAR2 DEFAULT NULL,
                                p_doc_id NUMBER DEFAULT NULL,
                                p_user_query CLOB DEFAULT NULL,
                                p_ai_response CLOB DEFAULT NULL,
                                p_execution_time_ms NUMBER DEFAULT NULL,
                                p_token_count NUMBER DEFAULT NULL
                            ) IS
    vcaller constant varchar2(70):= c_package_name ||'.log_ai_activity'; 
    PRAGMA AUTONOMOUS_TRANSACTION;
    v_context_json CLOB;
BEGIN
    -- Build JSON context
    v_context_json := JSON_OBJECT(
        'action' VALUE p_action,
        'doc_id' VALUE p_doc_id,
        'model_name' VALUE p_model_name,
        'execution_time_ms' VALUE p_execution_time_ms,
        'token_count' VALUE p_token_count
    );

    -- Route to appropriate AI_LOG_UTIL procedure based on action type
    /*  IF p_action LIKE 'DOCUMENT%' THEN
        -- Use log_document_operation for document-related actions
        ai_log_util.log_document_operation(
            p_user_id            => COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER),
            p_doc_id             => p_doc_id,
            p_stage_name         => 'PROCESSING',
            p_stage_status       => 'COMPLETED',
            p_processing_time_ms => p_execution_time_ms,
            p_apex_session_id    => NVL(V('APP_SESSION'), NULL),
            p_is_error           => 'N'
        );
    ELSE
        -- Use generic log_event for other action types
        ai_log_util.log_event(
            p_event_type_id   => ai_log_util.get_event_type_id('SYSTEM_GENERAL'),
            p_user_id         => COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER),
            p_context_json    => v_context_json,
            p_apex_session_id => NVL(V('APP_SESSION'), NULL)
        );
    END IF;*/

    
EXCEPTION
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        -- Don't fail main transaction if logging fails
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('WARNING: log_ai_activity failed: ' || SQLERRM);
END log_ai_activity;
 /*******************************************************************************/
    PROCEDURE soft_delete(p_doc_id NUMBER) IS
     vcaller constant varchar2(70):= c_package_name ||'.soft_delete'; 
    BEGIN
        UPDATE docs 
        SET is_active = 'N', 
            updated_at = SYSTIMESTAMP,
            updated_by = COALESCE(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER)
        WHERE doc_id = p_doc_id;
        COMMIT;
    END soft_delete;
 /*******************************************************************************/
    FUNCTION get_doc(p_doc_id NUMBER) RETURN docs%ROWTYPE IS
       vcaller constant varchar2(70):= c_package_name ||'.get_doc'; 
        v_rec docs%ROWTYPE;
    BEGIN
        SELECT * INTO v_rec 
        FROM docs 
        WHERE doc_id = p_doc_id;
        RETURN v_rec;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           debug_util.error(sqlerrm,vcaller);  
            RAISE_APPLICATION_ERROR(-20001, 'Document ID ' || p_doc_id || ' not found');
    END get_doc;
 /*******************************************************************************/
END doc_util;

/
