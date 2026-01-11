--------------------------------------------------------
--  DDL for Package Body APP_CHUNK_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APP_CHUNK_PKG" AS
 
    /*----------------------------------------- 
     * Function: validate_document_for_chunking
     * 
     * Purpose: Comprehensive document validation before chunking
     ------------------------------------------*/
    FUNCTION validate_document_for_chunking(
        p_doc_id IN NUMBER
    ) RETURN t_validation_result IS
       vcaller constant varchar2(70):= c_package_name ||'.validate_document_for_chunking'; 
        v_result t_validation_result;
        v_extracted_Doc_text CLOB;
        v_start_time TIMESTAMP := SYSTIMESTAMP;
        v_end_time TIMESTAMP;
        v_processing_time_ms NUMBER;
    BEGIN
        -- Initialize result
        v_result.is_valid := FALSE;
        v_result.existing_chunks := 0;
        
        -- Validation 1: Document ID provided
        IF p_doc_id IS NULL THEN
            v_result.error_code := 'NULL_DOC_ID';
            v_result.error_message := 'Document ID is required. Please select a document first.';
            RETURN v_result;
        END IF;
        
        -- Validation 2: Document ID is positive number
        IF p_doc_id <= 0 THEN
            v_result.error_code := 'INVALID_DOC_ID';
            v_result.error_message := 'Invalid Document ID: ' || p_doc_id || '. Must be a positive number.';
            RETURN v_result;
        END IF;
        
        -- Validation 3: Document exists and retrieve details
        BEGIN
            SELECT 
                doc_title,
                text_Extracted,
                DBMS_LOB.GETLENGTH(text_Extracted),
                doc_status
            INTO 
                v_result.doc_title,
                v_extracted_Doc_text,
                v_result.doc_size,
                v_result.doc_status
            FROM docs
            WHERE doc_id = p_doc_id;
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_result.error_code := 'DOC_NOT_FOUND';
                v_result.error_message := 'Document ID ' || p_doc_id || ' not found. The document may have been deleted.';
                RETURN v_result;
                
            WHEN OTHERS THEN
                v_result.error_code := 'DOC_RETRIEVAL_ERROR';
                v_result.error_message := 'Error retrieving document: ' || SUBSTR(SQLERRM, 1, 500);
                RETURN v_result;
        END;
        
        -- Validation 4: Document has content
        IF v_extracted_Doc_text IS NULL OR v_result.doc_size = 0 THEN
            v_result.error_code := 'EMPTY_CONTENT';
            v_result.error_message := 'Document "' || v_result.doc_title || '" has no content. Cannot generate chunks from empty document.';
            RETURN v_result;
        END IF;
        
        -- Validation 5: Document size within minimum limit
        IF v_result.doc_size < c_min_doc_size THEN
            v_result.error_code := 'DOC_TOO_SMALL';
            v_result.error_message := 'Document "' || v_result.doc_title || '" is too small (' || 
                                     v_result.doc_size || ' characters). Minimum ' || 
                                     c_min_doc_size || ' characters required.';
            RETURN v_result;
        END IF;
        
        -- Validation 6: Document size within maximum limit
        IF v_result.doc_size > c_max_doc_size THEN
            v_result.error_code := 'DOC_TOO_LARGE';
            v_result.error_message := 'Document "' || v_result.doc_title || '" is too large (' || 
                                     format_doc_size(v_result.doc_size) || '). Maximum ' ||
                                     format_doc_size(c_max_doc_size) || ' supported. ' ||
                                     'Please split document or contact administrator.';
            RETURN v_result;
        END IF;
        
        -- Validation 7: Document status is valid
        IF v_result.doc_status NOT IN (c_valid_status_1, c_valid_status_2) THEN
            v_result.error_code := 'INVALID_STATUS';
            v_result.error_message := 'Document "' || v_result.doc_title || '" has status "' || 
                                     v_result.doc_status || '". Only ' || c_valid_status_1 || 
                                     ' or ' || c_valid_status_2 || ' documents can be chunked.';
            RETURN v_result;
        END IF;
        
        -- Validation 8: Check existing chunks (informational)
        v_result.existing_chunks := check_existing_chunks(p_doc_id);
        
        -- All validations passed
        v_result.is_valid := TRUE;
        v_result.error_code := NULL;
        v_result.error_message := NULL;
        
        RETURN v_result;
        
    EXCEPTION
        WHEN OTHERS THEN
            v_result.is_valid := FALSE;
            v_result.error_code := 'VALIDATION_ERROR';
            v_result.error_message := 'Unexpected validation error: ' || SUBSTR(SQLERRM, 1, 500);
            RETURN v_result;
    END validate_document_for_chunking;

    /*--------------------------------------------------------------------------
     * Function: check_existing_chunks
     * 
     * Purpose: Count existing chunks for a document
     --------------------------------------------------------------------------*/
    FUNCTION check_existing_chunks(
        p_doc_id IN NUMBER
    ) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.check_existing_chunks'; 
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM DOC_CHUNKS
        WHERE doc_id = p_doc_id;
        
        RETURN v_count;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Return 0 on error (assume no chunks)
            RETURN 0;
    END check_existing_chunks;

    /*-------------------------------------
     * CHUNK MANAGEMENT FUNCTIONS IMPLEMENTATION
     ------------------------------------*/

    /*---------------------------------
     * Function: delete_existing_chunks
     * 
     * Purpose: Delete all chunks and embeddings for a document
     ------------------------------------------*/
    FUNCTION delete_existing_chunks(
        p_doc_id IN NUMBER
    ) RETURN NUMBER IS
     vcaller constant varchar2(70):= c_package_name ||'.delete_existing_chunks'; 
        v_deleted NUMBER := 0;
        v_start_time TIMESTAMP := SYSTIMESTAMP;
       v_end_time TIMESTAMP;
       v_processing_time_ms NUMBER;
    BEGIN
        -- Get count before deletion
        v_deleted := check_existing_chunks(p_doc_id);
        
    
        -- Delete chunks
        DELETE FROM DOC_CHUNKS WHERE doc_id = p_doc_id;
        
        -- Do NOT commit - caller controls transaction
        
        RETURN v_deleted;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Log error but don't fail entire operation
            DBMS_OUTPUT.PUT_LINE('Error deleting chunks: ' || SQLERRM);
            RETURN 0;
    END delete_existing_chunks;

    /*--------------------------------------------------------------------------
     * Function: generate_chunks_internal
     * 
     * Purpose: Internal chunk generation with error handling
     --------------------------------------------------------------------------*/
    FUNCTION generate_chunks_internal(
        p_doc_id IN NUMBER

    ) RETURN t_chunk_result IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_chunks_internal'; 
       v_result t_chunk_result;
       v_start_time TIMESTAMP := SYSTIMESTAMP;
       v_end_time TIMESTAMP;
       v_processing_time_ms NUMBER;
       v_event varchar2(32000);
    BEGIN
        -- Initialize result
        v_result.success := FALSE;
        v_result.chunk_count := 0;
        
        -- Call   chunking package
        
   chunk_proxy_util.run_chunk(
                    p_doc_id              =>p_doc_id ,
                    p_recommend_strategy  => 'N',
                    p_force_rechunk      => TRUE,--default FALSE
                    p_commit_after      =>TRUE
                ) ;
v_processing_time_ms :=
   EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        -- JSON Logging
     v_event:=
            '{
               "pipeline": "DOC",
               "base": {
                  "event_type_id": 512,
                  "user_name": "'||NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'),USER)||'",
                  "user_id": '||NVL(v('G_USER_ID'),0)||',
                  "tenant_id": '||NVL(v('G_TENANT_ID'),0)||',
                  "app_session_id": '||NVL(v('APP_SESSION'),0)||',
                  "pipeline_stage": "CHUNK",
                  "is_error": "N"
               },
               "payload": {
                  "doc_id": '||p_doc_id||',
                  "stage_name": "CHUNK",
                  "stage_status": "COMPLETED",
                  "chunk_count": '||v_result.chunk_count||',
                  "chunk_strategy_code": '|| v_result.strategy_used ||',
                  "processing_time_ms": '||v_processing_time_ms||'
               }
            }' ;

            debug_util.info(v_event,vcaller);

        -- Validate chunk generation succeeded
        IF v_result.chunk_count IS NULL THEN
            v_result.error_code := 'NULL_RESULT';
            v_result.error_message := 'Chunk generation returned NULL. No chunks were created.';
            RETURN v_result;
        END IF;
        
        IF v_result.chunk_count = 0 THEN
            v_result.error_code := 'ZERO_CHUNKS';
            v_result.error_message := 'No chunks were generated. Document content may be unsuitable for chunking.';
            RETURN v_result;
        END IF;
        
        -- Get strategy used
        BEGIN
            SELECT last_chunking_strategy
            INTO v_result.strategy_used
            FROM docs
            WHERE doc_id = p_doc_id;
            
        EXCEPTION
            WHEN OTHERS THEN
                v_result.strategy_used := 'UNKNOWN';
        END;
        
        -- Success
        v_result.success := TRUE;
        v_result.error_code := NULL;
        v_result.error_message := NULL;
        
        RETURN v_result;
        
    EXCEPTION
        WHEN OTHERS THEN
            v_result.success := FALSE;
            v_result.error_code := SQLCODE;
            v_result.error_message := SUBSTR(SQLERRM, 1, 4000);
            RETURN v_result;
    END generate_chunks_internal;

    /*-------------------------------------
     * AUDIT AND LOGGING FUNCTIONS IMPLEMENTATION
     ------------------------------------*/

    /*--------------------------------------------------------------------------
     * Procedure: log_chunk_generation
     * 
     * Purpose: Log chunk generation event to audit table
     --------------------------------------------------------------------------*/
   /*--------------------------------------------------------------------------
 * Procedure: log_chunk_generation
 * 
 * Purpose: Log chunk generation event to audit table
 --------------------------------------------------------------------------*/
PROCEDURE log_chunk_generation_json(
    p_doc_id          IN NUMBER,
    p_doc_title       IN VARCHAR2,
    p_user_name       IN VARCHAR2,
    p_strategy        IN VARCHAR2,
    p_chunk_count     IN NUMBER,
    p_processing_time IN NUMBER
) IS
 vcaller constant varchar2(70):= c_package_name ||'.log_chunk_generation_json'; 
 v_event varchar2(32000);       
BEGIN
  v_event:=
        '{
           "pipeline": "DOC",
           "base": {
              "event_type_id": 510,
              "user_name": "'||p_user_name||'",
              "user_id": '||NVL(v('G_USER_ID'),0)||',
              "tenant_id": '||NVL(v('G_TENANT_ID'),0)||',
              "app_session_id": '||NVL(v('APP_SESSION'),0)||',
              "pipeline_stage": "CHUNK",
              "is_error": "N"
           },
           "payload": {
              "doc_id": '||p_doc_id||',
              "doc_title": '||  p_doc_title  ||',
              "stage_name": "CHUNK",
              "stage_status": "COMPLETED",
              "chunk_strategy_code": '|| ( p_strategy) ||',
              "chunk_count": '||p_chunk_count||',
              "chunks_per_second": '||CASE WHEN p_processing_time > 0 THEN ROUND(p_chunk_count/(p_processing_time/1000),2) ELSE 'null' END||',
              "processing_time_ms": '||p_processing_time||'
           }
        }' ;
   debug_util.info(v_event,vcaller);
END;

 /*--------------------------------------------------------------------------
 * Procedure: log_chunk_deletion
 * 
 * Purpose: Log chunk deletion event to audit table
 --------------------------------------------------------------------------*/
PROCEDURE log_chunk_deletion_json(
    p_doc_id      IN NUMBER,
    p_doc_title   IN VARCHAR2,
    p_user_name   IN VARCHAR2,
    p_chunk_count IN NUMBER
) IS
   vcaller constant varchar2(70):= c_package_name ||'.log_chunk_deletion_json'; 
   v_event varchar2(32000);  
BEGIN
  v_event:=
        '{
           "pipeline": "DOC",
           "base": {
              "event_type_id": 511,
              "user_name": "'||p_user_name||'",
              "user_id": '||NVL(v('G_USER_ID'),0)||',
              "tenant_id": '||NVL(v('G_TENANT_ID'),0)||',
              "app_session_id": '||NVL(v('APP_SESSION'),0)||',
              "pipeline_stage": "CHUNK",
              "is_error": "N"
           },
           "payload": {
              "doc_id": '||p_doc_id||',
              "doc_title": '|| ( p_doc_title ) ||',
              "stage_name": "CHUNK",
              "stage_status": "DELETED",
              "chunk_count": '||p_chunk_count||'
           }
        }'
     ;
   debug_util.info(v_event,vcaller);
END;
    /*----------------------------------- 
     * UTILITY FUNCTIONS IMPLEMENTATION
     -------------------------------- */

    /*--------------------------------------------------------------------------
     * Function: format_doc_size
     * 
     * Purpose: Format size in human-readable format
     --------------------------------------------------------------------------*/
    FUNCTION format_doc_size(
        p_size_bytes IN NUMBER
    ) RETURN VARCHAR2 IS
      vcaller constant varchar2(70):= c_package_name ||'.format_doc_size'; 
    BEGIN
        IF p_size_bytes IS NULL THEN
            RETURN 'N/A';
        ELSIF p_size_bytes < 1024 THEN
            RETURN p_size_bytes || ' bytes';
        ELSIF p_size_bytes < 1048576 THEN
            RETURN ROUND(p_size_bytes/1024, 1) || ' KB';
        ELSE
            RETURN ROUND(p_size_bytes/1048576, 2) || ' MB';
        END IF;
    END format_doc_size;

    /*--------------------------------------------------------------------------
     * Function: format_processing_time
     * 
     * Purpose: Format time in human-readable format
     --------------------------------------------------------------------------*/
    FUNCTION format_processing_time(
        p_time_ms IN NUMBER
    ) RETURN VARCHAR2 IS
    BEGIN
        IF p_time_ms IS NULL THEN
            RETURN 'N/A';
        ELSIF p_time_ms < 1000 THEN
            RETURN ROUND(p_time_ms) || ' ms';
        ELSE
            RETURN ROUND(p_time_ms/1000, 2) || ' seconds';
        END IF;
    END format_processing_time;

    /*--------------------------------------------------------------------------
     * Function: build_success_message
     * 
     * Purpose: Build rich HTML success message for APEX
     --------------------------------------------------------------------------*/
    FUNCTION build_success_message(
        p_doc_title       IN VARCHAR2,
        p_chunk_count     IN NUMBER,
        p_strategy        IN VARCHAR2,
        p_doc_size        IN NUMBER,
        p_processing_time IN NUMBER,
        p_replaced_count  IN NUMBER DEFAULT 0
    ) RETURN VARCHAR2 IS
       vcaller constant varchar2(70):= c_package_name ||'.build_success_message'; 
        v_message VARCHAR2(4000);
    BEGIN
        v_message := 
            '<div style="padding: 10px;">' ||
            '<strong>✓ Chunks Generated Successfully!</strong><br/>' ||
            '<div style="margin-top: 8px; margin-left: 15px;">' ||
            '📄 <strong>Document:</strong> ' || SUBSTR(p_doc_title, 1, 100) || '<br/>' ||
            '📊 <strong>Chunks Created:</strong> ' || p_chunk_count || '<br/>' ||
            '🎯 <strong>Strategy:</strong> ' || p_strategy || '<br/>' ||
            '📏 <strong>Document Size:</strong> ' || format_doc_size(p_doc_size) || '<br/>' ||
            '⏱️ <strong>Processing Time:</strong> ' || format_processing_time(p_processing_time) || '<br/>';
        
        -- Add replaced count if chunks were replaced
        IF p_replaced_count > 0 THEN
            v_message := v_message ||
                '🔄 <strong>Previous chunks replaced:</strong> ' || p_replaced_count || '<br/>';
        END IF;
        
        v_message := v_message ||
            '</div>' ||
            '<div style="margin-top: 8px; font-size: 0.9em; color: #666;">' ||
            'Tip: You can now generate embeddings for these chunks to enable semantic search.' ||
            '</div>' ||
            '</div>';
        
        RETURN v_message;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Fallback to simple message
            RETURN 'Successfully created ' || p_chunk_count || ' chunks using ' || p_strategy || ' strategy!';
    END build_success_message;

    /*--------------------------------------------------------------------------
     * Function: build_error_message
     * 
     * Purpose: Build formatted error message for APEX
     --------------------------------------------------------------------------*/
    FUNCTION build_error_message(
        p_error_title   IN VARCHAR2,
        p_error_message IN VARCHAR2,
        p_error_code    IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.build_error_message'; 
        v_message VARCHAR2(4000);
    BEGIN
        v_message := 
            '<div style="padding: 10px;">' ||
            '<strong>❌ ' || p_error_title || '</strong><br/>' ||
            '<div style="margin-top: 8px;">' ||
            p_error_message;
        
        IF p_error_code IS NOT NULL THEN
            v_message := v_message ||
                '<div style="margin-top: 8px; font-size: 0.9em;">' ||
                'Error Code: ' || p_error_code ||
                '</div>';
        END IF;
        
        v_message := v_message || '</div></div>';
        
        RETURN v_message;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Fallback to simple message
            RETURN p_error_title || ': ' || p_error_message;
    END build_error_message;

    /*------------------------------------- 
     * MAIN APEX INTEGRATION PROCEDURE IMPLEMENTATION
     -------------------------------------*/

    /*----------------------------------------------
     * Procedure: generate_chunks_for_apex
     * 
     * Purpose: Main APEX entry point with complete workflow
     --------------------------------------------------- -*/
    PROCEDURE generate_chunks_for_apex(
        p_doc_id              IN NUMBER,
        p_app_user            IN VARCHAR2 DEFAULT NULL,
        p_auto_replace_chunks IN BOOLEAN DEFAULT TRUE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_chunks_for_apex'; 
        v_validation t_validation_result;
        v_chunk_result t_chunk_result;
        v_user VARCHAR2(100);
        v_deleted_count NUMBER := 0;
         v_msg varchar2(32000);   
  
    BEGIN
        -- Get user (from parameter or current user)
        v_user := NVL(p_app_user, NVL(SYS_CONTEXT('APEX$SESSION','APP_USER'), USER));
        
       -------------------------------------- 
        -- * STEP 1: VALIDATE DOCUMENT
         ------------------------------------- 
        v_validation := validate_document_for_chunking(p_doc_id);
        
        IF NOT v_validation.is_valid THEN
            debug_util.error(v_validation.error_code||' , '||v_validation.error_message ,vcaller);      
            apex_error.add_error(
                p_message => build_error_message(
                    p_error_title => 'Validation Error',
                    p_error_message => v_validation.error_message,
                    p_error_code => v_validation.error_code
                ),
                p_display_location => apex_error.c_inline_in_notification
            );
            RETURN; -- Exit early
        END IF;
        
        /*-------------------------
         * STEP 2: HANDLE EXISTING CHUNKS
         -------------------------------------*/
        IF v_validation.existing_chunks > 0 THEN
            IF p_auto_replace_chunks THEN
                -- Delete existing chunks
                v_deleted_count := delete_existing_chunks(p_doc_id);
                
                -- Log deletion
                log_chunk_deletion_json(
                                        p_doc_id      => p_doc_id,
                                        p_doc_title   => v_validation.doc_title,
                                        p_user_name   => v_user,
                                        p_chunk_count => v_deleted_count
                                    );
                -- Commit deletion before chunking
                COMMIT;
                
            ELSE
                v_msg:= 'Document "' || v_validation.doc_title || 
                                          '" already has ' || v_validation.existing_chunks || 
                                          ' chunks. Please delete existing chunks first or enable auto-replace.';
                debug_util.error(v_msg ,vcaller);      

                -- Error: chunks already exist and auto-replace disabled
                apex_error.add_error(
                    p_message => build_error_message(
                        p_error_title => 'Chunks Already Exist',
                        p_error_message => v_msg ),
                    p_display_location => apex_error.c_inline_in_notification
                );
                RETURN; -- Exit early
            END IF;
        END IF;
        
        /*---------------------------
         * STEP 3: GENERATE CHUNKS
         ----------------------------*/
        v_chunk_result := generate_chunks_internal(p_doc_id);
        
        IF NOT v_chunk_result.success THEN
        v_msg:= 'Error generating chunks for document "' || 
                  v_validation.doc_title || '": ' || v_chunk_result.error_message  ;
            debug_util.error(v_msg ,vcaller);           
            ROLLBACK; -- Rollback any partial changes
            
            apex_error.add_error(
                p_message => build_error_message(
                    p_error_title => 'Chunk Generation Failed',
                    p_error_message => v_msg, p_error_code => v_chunk_result.error_code
                ),
                p_display_location => apex_error.c_inline_in_notification
            );
            RETURN; -- Exit early
        END IF;
        
        /**-----------------------------
         * STEP 4: LOG AUDIT TRAIL
         ---------------------------*/
            log_chunk_generation_json(
            p_doc_id          => p_doc_id,
            p_doc_title       => v_validation.doc_title,
            p_user_name       => v_user,
            p_strategy        => v_chunk_result.strategy_used,
            p_chunk_count     => v_chunk_result.chunk_count,
            p_processing_time => v_chunk_result.processing_time_ms
        );
        
         /*---------------------------
         * STEP 5: COMMIT SUCCESSFUL OPERATION
          ---------------------------*/
        COMMIT;
        
        /*---------------------------
         * STEP 6: DISPLAY SUCCESS MESSAGE
         ---------------------------*/
        apex_application.g_print_success_message := build_success_message(
            p_doc_title => v_validation.doc_title,
            p_chunk_count => v_chunk_result.chunk_count,
            p_strategy => v_chunk_result.strategy_used,
            p_doc_size => v_validation.doc_size,
            p_processing_time => v_chunk_result.processing_time_ms,
            p_replaced_count => v_deleted_count
        );
        
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error('UNEXPECTED ERROR IN CHUNK GENERATION',vcaller);
           debug_util.error('Document ID: ' || p_doc_id,vcaller);
           debug_util.error('Error: ' || SQLERRM,vcaller);
           debug_util.error('Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK,vcaller);
           debug_util.error('Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,vcaller);
            ROLLBACK; -- Ensure rollback 
            -- Display error to user
          
            apex_error.add_error(
                p_message => build_error_message(
                    p_error_title => 'Unexpected Error',
                    p_error_message => 'An unexpected error occurred while generating chunks. ' ||
                                      'Please contact your system administrator if this problem persists.<br/>' ||
                                      '<code style="background: #f5f5f5; padding: 5px; display: block; margin-top: 5px;">' ||
                                      SUBSTR(SQLERRM, 1, 500) ||
                                      '</code>',
                    p_error_code => SQLCODE
                ),
                p_display_location => apex_error.c_inline_in_notification
            );
    END generate_chunks_for_apex;

END App_chunk_pkg;

/
