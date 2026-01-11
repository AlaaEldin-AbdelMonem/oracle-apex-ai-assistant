--------------------------------------------------------
--  DDL for Package Body CHUNK_EMBEDDING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHUNK_EMBEDDING_PKG" AS
 
 
    g_debug_enabled BOOLEAN := FALSE;
    g_last_processing_time NUMBER := 0;
 
     
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_param_value(
        p_param_key     IN VARCHAR2,
        p_default_value  IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_param_value'; 
        v_value VARCHAR2(4000);
    BEGIN
        SELECT param_value
        INTO v_value
        FROM cfg_parameters
        WHERE param_key = p_param_key
          AND is_active = 'Y';

        RETURN v_value;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN p_default_value;
        WHEN OTHERS THEN
            debug_util.error('getting param ' || p_param_key || ': ' || SQLERRM ,vcaller);
            RETURN p_default_value;
    END get_param_value;

    /***************************************************************************
     * CORE EMBEDDING GENERATION
     ***************************************************************************/

    FUNCTION generate_embedding(
        p_text  IN CLOB,
        p_model IN VARCHAR2 DEFAULT NULL,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    ) RETURN VECTOR IS
         vcaller constant varchar2(70):= c_package_name ||'.generate_embedding'; 
    BEGIN
        debug_util.info('Generating embedding for text length: ' || DBMS_LOB.GETLENGTH(p_text) ,vcaller , p_trace_id);
        RETURN ai_vector_utx.generate_embedding(p_text);
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('Error generating embedding: ' || SQLERRM, vcaller);
            RETURN NULL;
    END generate_embedding;

    /***************************************************************************
     * DOCUMENT VALIDATION
     ***************************************************************************/

    FUNCTION validate_document(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2 IS
         vcaller constant varchar2(70):= c_package_name ||'.validate_document'; 
        v_doc_title VARCHAR2(500);
        v_is_active VARCHAR2(1);
        v_msg VARCHAR2(4000);
    BEGIN
        debug_util.starting(vcaller,'Validating document ID: ' || p_doc_id );

        SELECT doc_title, is_active
        INTO v_doc_title, v_is_active
        FROM docs
        WHERE doc_id = p_doc_id;

        IF v_is_active <> 'Y' THEN
            RAISE_APPLICATION_ERROR(-20010, 
                'Document ' || p_doc_id || ' is not active');
        END IF;

        debug_util.info('Document validated: ' || v_doc_title ,vcaller);
        RETURN v_doc_title;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_msg :=  'Document ' || p_doc_id || ' not found';
            debug_util.error(v_msg ||',RAISE_APPLICATION_ERROR(-20011)', vcaller);
            RAISE_APPLICATION_ERROR(-20011,    v_msg);
        WHEN OTHERS THEN
          v_msg := sqlerrm;
          debug_util.error(v_msg , vcaller);
            RAISE;
    END validate_document;

    /***************************************************************************
     * CHUNK RETRIEVAL
     ***************************************************************************/

    FUNCTION get_document_chunks(
        p_doc_id            IN NUMBER,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE
    ) RETURN t_chunk_data_tab IS
         vcaller constant varchar2(70):= c_package_name ||'.get_document_chunks'; 
        v_chunks t_chunk_data_tab := t_chunk_data_tab();
        v_chunk t_chunk_data;

        CURSOR c_chunks IS
            SELECT 
                c.doc_chunk_id,
                c.doc_id,
                c.chunk_text,
                c.chunk_sequence,
                CASE WHEN c.embedding_vector IS NOT NULL THEN 1 ELSE 0 END as has_embedding
            FROM  doc_chunks c
            WHERE c.doc_id = p_doc_id
              AND c.is_active = 'Y'
              AND (p_force_regenerate OR c.embedding_vector IS NULL)
            ORDER BY c.chunk_sequence;
    BEGIN
        debug_util.starting(vcaller,'Retrieving chunks for doc_id: ' || p_doc_id || 
                 ', force_regenerate: ' || CASE WHEN p_force_regenerate THEN 'Y' ELSE 'N' END);

        FOR rec IN c_chunks LOOP
            v_chunk.doc_chunk_id := rec.doc_chunk_id;
            v_chunk.doc_id := rec.doc_id;
            v_chunk.chunk_text := rec.chunk_text;
            v_chunk.chunk_sequence := rec.chunk_sequence;
            v_chunk.has_embedding := (rec.has_embedding = 1);

            v_chunks.EXTEND;
            v_chunks(v_chunks.COUNT) := v_chunk;
        END LOOP;

        debug_util.ending(vcaller,'Retrieved ' || v_chunks.COUNT || ' chunks');
        RETURN v_chunks;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('Error retrieving chunks: ' || SQLERRM, vcaller);
            RAISE;
    END get_document_chunks;

    /***************************************************************************
     * CHUNK VALIDATION
     ***************************************************************************/

    FUNCTION is_chunk_valid(
        p_chunk IN t_chunk_data
    ) RETURN BOOLEAN IS
         vcaller constant varchar2(70):= c_package_name ||'.is_chunk_valid'; 
        v_text_length NUMBER;
    BEGIN
        -- Check if doc_chunk_id is valid
        IF p_chunk.doc_chunk_id IS NULL THEN
            debug_util.error('Invalid chunk: doc_chunk_id is NULL',vcaller);
            RETURN FALSE;
        END IF;

        -- Check if text exists
        IF p_chunk.chunk_text IS NULL THEN
            debug_util.error('Invalid chunk ' || p_chunk.doc_chunk_id || ': text is NULL',vcaller);
            RETURN FALSE;
        END IF;

        -- Check text length
        v_text_length := DBMS_LOB.GETLENGTH(p_chunk.chunk_text);
        IF v_text_length = 0 THEN
            debug_util.error('Invalid chunk ' || p_chunk.doc_chunk_id || ': text is empty',vcaller);
            RETURN FALSE;
        END IF;

        -- Check max length
        IF v_text_length > c_max_text_length THEN
            debug_util.error('Warning: chunk ' || p_chunk.doc_chunk_id || 
                     ' exceeds max length (' || v_text_length || ' > ' || c_max_text_length || ')' ,vcaller);
            -- Don't fail, just warn
        END IF;

        RETURN TRUE;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('Error validating chunk ' || p_chunk.doc_chunk_id || ': ' || SQLERRM,vcaller);
            RETURN FALSE;
    END is_chunk_valid;

    /***************************************************************************
     * SAVE EMBEDDING
     ***************************************************************************/

    FUNCTION save_embedding(
        p_doc_chunk_id          IN NUMBER,
        p_doc_id            IN NUMBER,
        p_embedding_vector  IN VECTOR,
        p_model             IN VARCHAR2,
        p_user_id           IN number default v('G_USER_ID')
    ) RETURN NUMBER IS
         vcaller constant varchar2(70):= c_package_name ||'.save_embedding'; 
        v_embedding_id NUMBER;
        v_rows_updated NUMBER;
    BEGIN
        debug_util.starting(vcaller,'Saving embedding for doc_chunk_id: ' || p_doc_chunk_id);

        -- Try update first
        UPDATE doc_chunks
        SET embedding_vector = p_embedding_vector,
            embedding_model = p_model,
            embedding_Date = SYSTIMESTAMP 
        WHERE doc_chunk_id = p_doc_chunk_id;

        v_rows_updated := SQL%ROWCOUNT;
 

        debug_util.ending(vcaller,'Updated existing embedding ID: ' || v_embedding_id);
     

        RETURN v_embedding_id;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('saving embedding: ' || SQLERRM,vcaller);
            RAISE;
    END save_embedding;

    /***************************************************************************
     * PROCESS SINGLE CHUNK
     ***************************************************************************/

    FUNCTION process_single_chunk_embedding(
        p_chunk             IN t_chunk_data,
        p_model             IN VARCHAR2,
        p_force_regenerate  IN BOOLEAN,
        p_user_id           IN number default v('G_USER_ID')
    ) RETURN t_chunk_result IS
         vcaller constant varchar2(70):= c_package_name ||'.process_single_chunk_embedding'; 
        v_result            t_chunk_result;
        v_start_time        TIMESTAMP := SYSTIMESTAMP;
        v_embedding_vector  VECTOR;
    BEGIN
        -- Initialize result
        v_result.doc_chunk_id := p_chunk.doc_chunk_id;
        v_result.status := c_status_failed;
        v_result.embedding_id := NULL;
        v_result.processing_time_ms := 0;
        v_result.error_message := NULL;

        debug_util.starting(vcaller,'Processing chunk ' || p_chunk.doc_chunk_id);

        -- Check if should skip
        IF NOT p_force_regenerate AND p_chunk.has_embedding THEN
            v_result.status := c_status_skipped;
            v_result.processing_time_ms := 
              EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;
            debug_util.error('Chunk ' || p_chunk.doc_chunk_id || ' skipped - embedding exists',vcaller);
            RETURN v_result;
        END IF;

        -- Validate chunk
        IF NOT is_chunk_valid(p_chunk) THEN
            v_result.error_message := 'Chunk validation failed';
             debug_util.error(v_result.error_message,vcaller||' RAISE_APPLICATION_ERROR(-20020',vcaller);
            RAISE_APPLICATION_ERROR(-20020, v_result.error_message);
        END IF;

        -- Generate embedding
        v_embedding_vector := generate_embedding(
            p_text => p_chunk.chunk_text,
            p_model => p_model
        );

        IF v_embedding_vector IS NULL THEN
            v_result.error_message := 'Embedding generation returned NULL';
            debug_util.error( v_result.error_message || ',RAISE_APPLICATION_ERROR(-20021)' , vcaller);
            RAISE_APPLICATION_ERROR(-20021, v_result.error_message);
        END IF;

        -- Save embedding
        v_result.embedding_id := save_embedding(
            p_doc_chunk_id => p_chunk.doc_chunk_id,
            p_doc_id => p_chunk.doc_id,
            p_embedding_vector => v_embedding_vector,
            p_model => p_model,
            p_user_id => p_user_id
        );

        -- Success!
        v_result.status := c_status_success;
        v_result.processing_time_ms := 
            EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        debug_util.ending(vcaller,'Successfully processed chunk ' || p_chunk.doc_chunk_id || 
                 ' in ' || v_result.processing_time_ms || ' ms');
     
        RETURN v_result;

    EXCEPTION
        WHEN OTHERS THEN
            v_result.status := c_status_failed;
            v_result.error_message := SUBSTR(SQLERRM, 1, 4000);
            v_result.processing_time_ms := 
                EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

            debug_util.error(' processing chunk ' || p_chunk.doc_chunk_id || ': ' || SQLERRM,vcaller);

            RETURN v_result;
    END process_single_chunk_embedding;

    /***************************************************************************
     * PROCESS BATCH
     ***************************************************************************/

    FUNCTION process_chunks_batch(
        p_chunks            IN t_chunk_data_tab,
        p_model             IN VARCHAR2,
        p_force_regenerate  IN BOOLEAN,
        p_batch_size        IN NUMBER,
        p_user_id           IN number default v('G_USER_ID')
    ) RETURN t_chunk_results_tab IS
         vcaller constant varchar2(70):= c_package_name ||'.process_chunks_batch'; 
        v_results           t_chunk_results_tab := t_chunk_results_tab();
        v_chunk_result      t_chunk_result;
        v_savepoint_name    VARCHAR2(30);
        v_chunks_processed  NUMBER := 0;
    BEGIN
        debug_util.starting(vcaller,'Processing batch of ' || p_chunks.COUNT || ' chunks');

        FOR i IN 1..p_chunks.COUNT LOOP
            BEGIN
                -- Create savepoint for this chunk
                v_savepoint_name := 'sp_chunk_' || p_chunks(i).doc_chunk_id;
                EXECUTE IMMEDIATE 'SAVEPOINT ' || v_savepoint_name;

                -- Process chunk
                v_chunk_result := process_single_chunk_embedding(
                    p_chunk => p_chunks(i),
                    p_model => p_model,
                    p_user_id => p_user_id,
                    p_force_regenerate => p_force_regenerate
                );


                 
                IF v_chunk_result.status = c_status_success 
                   AND v_chunk_result.embedding_id IS NOT NULL THEN
                    
                    UPDATE doc_chunks
                    SET embedding_id = v_chunk_result.embedding_id
                    WHERE doc_chunk_id = v_chunk_result.doc_chunk_id;
                    
                    debug_util.error('Updated chunk ' || v_chunk_result.doc_chunk_id || 
                             ' with embedding_id ' || v_chunk_result.embedding_id ,vcaller);
                END IF;

                -- Add result to collection
                v_results.EXTEND;
                v_results(v_results.COUNT) := v_chunk_result;

                v_chunks_processed := v_chunks_processed + 1;

                -- Batch commit
                IF MOD(v_chunks_processed, p_batch_size) = 0 THEN
                    COMMIT;
                    debug_util.ending(vcaller,'Batch committed at chunk ' || v_chunks_processed || 
                             ' of ' || p_chunks.COUNT);
                END IF;

            EXCEPTION
    WHEN OTHERS THEN
            debug_util.error( sqlerrm,vcaller);
        -- Rollback this chunk only
        EXECUTE IMMEDIATE 'ROLLBACK TO SAVEPOINT ' || v_savepoint_name;

        -- Create error result
        v_chunk_result.doc_chunk_id := p_chunks(i).doc_chunk_id;
        v_chunk_result.status := c_status_failed;
        v_chunk_result.error_message := SUBSTR(SQLERRM, 1, 4000);

        v_results.EXTEND;
        v_results(v_results.COUNT) := v_chunk_result;

        -- Log error using correct AI_LOG_UTIL signature
       DECLARE
            v_event CLOB;
        BEGIN
            v_event := JSON_OBJECT(
                'pipeline' VALUE 'ERROR',
                'payload' VALUE JSON_OBJECT(
                    'error_source'      VALUE 'EMBEDDING',
                    'error_type'        VALUE 'CHUNK_PROCESSING_ERROR',
                    'error_code'        VALUE TO_CHAR(SQLCODE),
                    'error_severity'    VALUE 'WARNING',
                    'error_message'     VALUE 'Chunk ' || p_chunks(i).doc_chunk_id || ' failed: ' || SQLERRM,
                    'error_stack'       VALUE DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
                    'failed_operation'  VALUE 'process_chunks_batch',
                    'context_json'      VALUE JSON_OBJECT(
                                              'doc_chunk_id' VALUE p_chunks(i).doc_chunk_id,
                                              'doc_id' VALUE p_chunks(i).doc_id,
                                              'batch_position' VALUE i,
                                              'batch_size' VALUE p_batch_size
                                          ) FORMAT JSON
                )
            );
                  debug_util.info(v_event, vcaller);
           
        END;

        debug_util.error('Chunk ' || p_chunks(i).doc_chunk_id || ' failed: ' || SQLERRM ,vcaller);
END;
        END LOOP;

        -- Final commit for remaining chunks
        COMMIT;
        debug_util.info('Final batch commit completed', vcaller);
        RETURN v_results;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error(sqlerrm, vcaller);
            ROLLBACK;
            RAISE;
    END process_chunks_batch;

    /***************************************************************************
     * AGGREGATE RESULTS
     ***************************************************************************/

    FUNCTION aggregate_batch_results(
        p_doc_id            IN NUMBER,
        p_chunk_results     IN t_chunk_results_tab,
        p_model             IN VARCHAR2,
        p_total_time_ms     IN NUMBER
    ) RETURN t_embedding_result IS
         vcaller constant varchar2(70):= c_package_name ||'.aggregate_batch_results'; 
        v_result t_embedding_result;
        v_error_messages CLOB;
    BEGIN
        debug_util.starting(vcaller,'Aggregating results for ' || p_chunk_results.COUNT || ' chunks');

        -- Initialize
        v_result.doc_id := p_doc_id;
        v_result.success_count := 0;
        v_result.failed_count := 0;
        v_result.skipped_count := 0;
        v_result.total_chunks := p_chunk_results.COUNT;
        v_result.processing_time_ms := p_total_time_ms;
        v_result.model_used := p_model;
        v_result.error_message := NULL;

        -- Count statuses and collect errors
        FOR i IN 1..p_chunk_results.COUNT LOOP
            CASE p_chunk_results(i).status
                WHEN c_status_success THEN
                    v_result.success_count := v_result.success_count + 1;
                WHEN c_status_failed THEN
                    v_result.failed_count := v_result.failed_count + 1;
                    -- Append error message
                    IF v_error_messages IS NULL THEN
                        v_error_messages := '';
                    END IF;
                    v_error_messages := v_error_messages || 
                        'Chunk ' || p_chunk_results(i).doc_chunk_id || ': ' || 
                        p_chunk_results(i).error_message || CHR(10);
                WHEN c_status_skipped THEN
                    v_result.skipped_count := v_result.skipped_count + 1;
            END CASE;
        END LOOP;

        v_result.error_message := v_error_messages;

        debug_util.ending(vcaller,'Results: ' || v_result.success_count || ' success, ' ||
                 v_result.failed_count || ' failed, ' ||
                 v_result.skipped_count || ' skipped');

        RETURN v_result;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('Error aggregating results: ' || SQLERRM,vcaller);
            RAISE;
    END aggregate_batch_results;

    /***************************************************************************
     * LOG COMPLETION
     ***************************************************************************/

    PROCEDURE log_document_embedding_completion(
    p_result    IN t_embedding_result,
    p_user_id           IN number default v('G_USER_ID')
) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_document_embedding_completion'; 
    v_doc_title VARCHAR2(500);
       v_event CLOB;
BEGIN
    debug_util.starting(vcaller,'Logging document embedding completion');

    -- Get document title
    BEGIN
        SELECT doc_title INTO v_doc_title
        FROM docs
        WHERE doc_id = p_result.doc_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_doc_title := 'Unknown Document';
    END;

    -- Log document operation using AI_LOG_UTIL
 
BEGIN
    v_event:=  
        'pipeline :EMBED'||
        'payload'|| 'error_source :EMBEDDING'||
            'error_type:CHUNK_PROCESSING_ERROR'   ;

    debug_util.info(v_event,vcaller);
END;
   DECLARE
    v_event CLOB;
BEGIN
    v_event :=  '';

    debug_util.info(v_event,vcaller);
END;
  /*  ai_log_util.log_document_operation(
            p_doc_id               => p_result.doc_id,
        p_doc_title            => v_doc_title,
        p_stage_name           => 'EMBED',
        p_stage_status         => CASE 
                                    WHEN p_result.failed_count > 0 THEN 'PARTIAL'
                                    WHEN p_result.success_count > 0 THEN 'COMPLETED'
                                    ELSE 'FAILED'
                                  END,
        p_chunk_strategy_code  => NULL,
        p_chunk_count          => p_result.total_chunks,
        p_chunks_per_second    => CASE 
                                    WHEN p_result.processing_time_ms > 0 
                                    THEN ROUND((p_result.total_chunks / p_result.processing_time_ms) * 1000, 2)
                                    ELSE NULL 
                                  END,
        p_embedding_model      => p_result.model_used,
        p_embeddings_generated => p_result.success_count,
        p_processing_time_ms   => p_result.processing_time_ms,
        p_file_size_bytes      => NULL,
         p_is_error             => CASE WHEN p_result.failed_count > 0 THEN 'Y' ELSE 'N' END,
        p_error_message        => CASE 
                                    WHEN p_result.failed_count > 0 
                                    THEN 'Completed with ' || p_result.failed_count || ' failures: ' || 
                                         SUBSTR(p_result.error_message, 1, 500)
                                    ELSE NULL 
                                  END
    );
*/
EXCEPTION
    WHEN OTHERS THEN
        debug_util.error('Error logging completion: ' || SQLERRM, vcaller);
        -- Don't raise - logging errors shouldn't break the main flow
END log_document_embedding_completion;

    /***************************************************************************
     * MAIN DOCUMENT PROCESSING (NOW ORCHESTRATES SUB-FUNCTIONS)
     ***************************************************************************/

    PROCEDURE generate_document_embeddings(
        p_doc_id            IN NUMBER,
        p_model             IN VARCHAR2 DEFAULT NULL,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE,
        p_batch_commit_size IN NUMBER DEFAULT c_batch_commit_size,
        p_result            OUT t_embedding_result,
        p_user_id           IN number default v('G_USER_ID'),
        p_trace_id          IN VARCHAR2 default null
    ) IS
         vcaller constant varchar2(70):= c_package_name ||'.generate_document_embeddings'; 
        v_start_time        TIMESTAMP := SYSTIMESTAMP;
        v_doc_title         VARCHAR2(500);
        v_model_name        VARCHAR2(100);
        v_chunks            t_chunk_data_tab;
        v_chunk_results     t_chunk_results_tab;
        v_processing_time   NUMBER;
    BEGIN
        debug_util.starting(vcaller,'generate _embeddings for doc_id: ' || p_doc_id  );

        -- Step 1: Validate document
        v_doc_title := validate_document(p_doc_id);

        -- Step 2: Get model name
        v_model_name := NVL(p_model, get_default_model());
        debug_util.info('Using model: ' || v_model_name,vcaller);

        -- Step 3: Retrieve chunks
        v_chunks := get_document_chunks(
            p_doc_id => p_doc_id,
            p_force_regenerate => p_force_regenerate
        );

        -- Check if any chunks to process
        IF v_chunks.COUNT = 0 THEN
            debug_util.info('No chunks to process',vcaller);

            -- Return empty result
            p_result.doc_id := p_doc_id;
            p_result.success_count := 0;
            p_result.failed_count := 0;
            p_result.skipped_count := 0;
            p_result.total_chunks := 0;
            p_result.processing_time_ms := 0;
            p_result.model_used := v_model_name;
            p_result.error_message := 'No chunks found to process for document ' || p_doc_id;

            RETURN;
        END IF;

        -- Step 4: Process chunks in batch
        v_chunk_results := process_chunks_batch(
            p_chunks => v_chunks,
            p_model => v_model_name,
            p_user_id => p_user_id,
            p_force_regenerate => p_force_regenerate,
            p_batch_size => p_batch_commit_size
        );

        -- Step 5: Calculate total processing time
        v_processing_time := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        -- Step 6: Aggregate results
        p_result := aggregate_batch_results(
            p_doc_id => p_doc_id,
            p_chunk_results => v_chunk_results,
            p_model => v_model_name,
            p_total_time_ms => v_processing_time
        );

        -- Step 7: Log completion
        log_document_embedding_completion(
            p_result => p_result,
            p_user_id => p_user_id
        );

        debug_util.ending(vcaller,'END: Document embeddings completed in ' || 
                 v_processing_time || ' ms ===');

    EXCEPTION
    WHEN OTHERS THEN
      debug_util.error('=== ERROR in generate_document_embeddings: ' || SQLERRM || ' ===',vcaller);
       ROLLBACK;

      

        -- Log catastrophic failure using correct AI_LOG_UTIL signature
/*ai_log_util.log_error(
     p_error_source    => 'EMBEDDING',
    p_error_type      => 'DOCUMENT_EMBEDDING_ERROR',
    p_error_code      => TO_CHAR(SQLCODE),
    p_error_severity  => 'CRITICAL',
    p_error_message   => 'Catastrophic failure in generate_document_embeddings: ' || SQLERRM,
    p_error_stack     => DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,
    p_retry_count     => 0,
    p_resolution_action => 'Check document data and embedding model availability',
     p_context_json    => JSON_OBJECT(
                            'doc_id' VALUE p_doc_id,
                            'model' VALUE NVL(p_model, 'DEFAULT'),
                            'force_regenerate' VALUE CASE WHEN p_force_regenerate THEN 'Y' ELSE 'N' END,
                            'batch_size' VALUE p_batch_commit_size
                         )
);*/

        -- Return error result
        p_result.doc_id := p_doc_id;
        p_result.success_count := 0;
        p_result.failed_count := 0;
        p_result.total_chunks := 0;
        p_result.processing_time_ms := 0;
        p_result.error_message := 'Catastrophic failure: ' || SQLERRM;

        RAISE;
END generate_document_embeddings;

    /***************************************************************************
     * SINGLE CHUNK PROCESSING (ORIGINAL IMPLEMENTATION)
     ***************************************************************************/

    PROCEDURE generate_chunk_embedding(
        p_doc_chunk_id          IN NUMBER,
         p_model             IN VARCHAR2 DEFAULT NULL,
        p_force_regenerate  IN BOOLEAN DEFAULT FALSE,
        p_commit_work       IN BOOLEAN DEFAULT TRUE,
        p_user_id           IN number default v('G_USER_ID'),
        p_trace_id         IN VARCHAR2 DEFAULT NULL 
    ) IS
         vcaller constant varchar2(70):= c_package_name ||'.generate_chunk_embedding'; 
        v_chunk             t_chunk_data;
        v_result            t_chunk_result;
        v_model_name        VARCHAR2(100);
        v_msg       VARCHAR2(4000);
    BEGIN
        debug_util.starting(vcaller,'Single chunk embedding for doc_chunk_id: ' || p_doc_chunk_id);

        -- Get model
        v_model_name := NVL(p_model, get_default_model());

        -- Retrieve chunk data
        SELECT doc_chunk_id, doc_id, chunk_text, chunk_sequence
        INTO v_chunk.doc_chunk_id, v_chunk.doc_id, v_chunk.chunk_text, v_chunk.chunk_sequence
        FROM doc_chunks
        WHERE doc_chunk_id = p_doc_chunk_id
          AND is_active = 'Y';

        v_chunk.has_embedding := embedding_exists(p_doc_chunk_id);

        -- Process chunk
        v_result := process_single_chunk_embedding(
            p_chunk => v_chunk,
            p_model => v_model_name,
            p_user_id => p_user_id,
            p_force_regenerate => p_force_regenerate
        );

        -- Check result
        IF v_result.status = c_status_failed THEN
        v_msg :=  'Chunk embedding failed: ' || v_result.error_message;
           debug_util.error(v_msg ||', RAISE_APPLICATION_ERROR(-20030)',vcaller);
            RAISE_APPLICATION_ERROR(-20030,  v_msg );
        END IF;

        -- Commit if requested
        IF p_commit_work THEN
            COMMIT;
        END IF;

        debug_util.info('Single chunk embedding completed: ' || v_result.status,vcaller);

    EXCEPTION
    WHEN NO_DATA_FOUND THEN
         v_msg := 'Chunk ID ' || p_doc_chunk_id || ' not found';
         debug_util.error(v_msg||', RAISE_APPLICATION_ERROR(-20031)', vcaller);
         RAISE_APPLICATION_ERROR(-20031,v_msg );
    WHEN OTHERS THEN
        debug_util.error(sqlerrm, vcaller);
        IF p_commit_work THEN
            ROLLBACK;
        END IF;
        RAISE;
END generate_chunk_embedding;

    /***************************************************************************
     * UTILITY FUNCTIONS
     ***************************************************************************/

    FUNCTION get_default_model RETURN VARCHAR2 IS
         vcaller constant varchar2(70):= c_package_name ||'.get_default_model'; 
    BEGIN
        RETURN get_param_value('DEFAULT_EMBEDDING_MODEL', c_default_model);
    END get_default_model;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION embedding_exists(p_doc_chunk_id IN NUMBER) RETURN BOOLEAN IS
         vcaller constant varchar2(70):= c_package_name ||'.embedding_exists'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO v_count
        FROM doc_chunks 
        WHERE doc_chunk_id = p_doc_chunk_id 
        and  embedding_vector is not null
          AND is_active = 'Y';

        RETURN v_count > 0;
    EXCEPTION
        WHEN OTHERS THEN 
         debug_util.error(sqlerrm, vcaller);
            RETURN FALSE;
    END embedding_exists;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_chunk_count(p_doc_id IN NUMBER) RETURN NUMBER IS
         vcaller constant varchar2(70):= c_package_name ||'.get_chunk_count'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) 
        INTO v_count 
        FROM doc_chunks 
        WHERE doc_id = p_doc_id 
          AND is_active = 'Y';

        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN 
         debug_util.error(sqlerrm, vcaller);
            RETURN 0;
    END get_chunk_count;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_embedding_count(p_doc_id IN NUMBER) RETURN NUMBER IS
         vcaller constant varchar2(70):= c_package_name ||'.get_embedding_count'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT( 1)
        INTO v_count
        FROM  doc_chunks c 
        WHERE c.doc_id = p_doc_id
          AND embedding_vector is not null
          AND c.is_active = 'Y';

        RETURN v_count;
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm, vcaller);
            RETURN 0;
    END get_embedding_count;
 /*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE enable_debug IS
         vcaller constant varchar2(70):= c_package_name ||'.enable_debug'; 
    BEGIN
        g_debug_enabled := TRUE;
          debug_util.info('Debug logging enabled', vcaller);
    END enable_debug;
 /*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE disable_debug IS
         vcaller constant varchar2(70):= c_package_name ||'.disable_debug'; 
    BEGIN
        g_debug_enabled := FALSE;
    END disable_debug;
 /*******************************************************************************
 *  
 *******************************************************************************/
END chunk_embedding_pkg;

/
