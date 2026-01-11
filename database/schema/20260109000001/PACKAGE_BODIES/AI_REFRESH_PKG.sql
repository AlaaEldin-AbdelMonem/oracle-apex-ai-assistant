--------------------------------------------------------
--  DDL for Package Body AI_REFRESH_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI_REFRESH_PKG" AS
/**
 * PROJECT:     Enterprise AI Assistant
 * MODULE:      AI_REFRESH_PKG (Body)
 * PURPOSE:     Implementation of vector embedding refresh logic using 
 * AI_LOG_UTIL for decomposed audit logging.
 * * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 */

    /*******************************************************************************
     * PROCEDURE: refresh_embeddings
     * PURPOSE:   Refresh vector embeddings for documents.
     * * @param:    p_doc_id - Specific document ID (Pass NULL to process all active)
     * * @audit:    Uses AI_LOG_UTIL.LOG_DOCUMENT_OPERATION
     * @error:    Logs exceptions to the decomposed audit structure
     *******************************************************************************/
  PROCEDURE refresh_embeddings(p_doc_id IN NUMBER DEFAULT NULL) IS
   vcaller constant varchar2(70):= c_package_name ||'.get_mime_type'; 
    v_start_time       TIMESTAMP;
    v_processing_time  NUMBER;
    v_chunk_count      NUMBER;
    v_doc_title        VARCHAR2(500);
    l_event varchar2(32000);
  BEGIN
    -- Process each document
    FOR rec IN (
      SELECT doc_id, 
             doc_title,
             text_extracted AS document_text
      FROM docs
      WHERE (p_doc_id IS NULL OR doc_id = p_doc_id)
        AND is_active = 'Y'
        AND text_extracted IS NOT NULL
    ) LOOP
      v_start_time := SYSTIMESTAMP;
      v_doc_title := rec.doc_title;

      BEGIN
        -- Process the document through RAG pipeline
        rag_processing_pkg.process_document(
          p_doc_id => rec.doc_id
        );

        -- Get chunk count for logging
        SELECT COUNT(*)
        INTO v_chunk_count
        FROM doc_chunks
        WHERE doc_id = rec.doc_id;

        -- Calculate processing time in milliseconds
        v_processing_time := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        -- Log successful embedding refresh using AI_LOG_UTIL
    
        l_event:= '{"pipeline": "DOC",
                     "base": {
                                "event_type_id": 501,
                                "user_name": "'||v('APP_USER')||'",
                                 "user_id": '||v('G_USER_ID')||',
                                 "project_id": 0,
                                 "tenant_id": '||v('G_TENANT_ID')||',
                                  "app_session_id": '||v('APP_SESSION')||',
                                  "chat_session_id": null,
                                  "pipeline_stage": "DOCUMENT",
                                    "is_error": "N"
                                 },
                                 "payload": {
                                    "doc_id": '||rec.doc_id||',
                                    "doc_title": '||rec.doc_title||',
                                    "stage_name": "EMBED",
                                    "stage_status": "COMPLETED",
                                    "chunk_strategy_code": null,
                                    "chunk_count": '||v_chunk_count||',
                                    "chunks_per_second": null,
                                    "embedding_model": "E5_MULTILINGUAL",
                                    "embeddings_generated": '||v_chunk_count||',
                                    "processing_time_ms": '||v_processing_time||',
                                    "file_size_bytes": null
                                 }
                              }'
                            ;

       debug_util.info(l_event,vcaller);
         
      EXCEPTION
        WHEN OTHERS THEN
          -- Calculate processing time for failed attempt
          v_processing_time := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        
          l_event:=  '{
                                 "pipeline": "DOC",
                                 "base": {
                                    "event_type_id": 502,
                                    "user_name": "'||v('APP_USER')||'",
                                    "user_id": '||v('G_USER_ID')||',
                                    "tenant_id": '||v('G_TENANT_ID')||',
                                    "app_session_id": '||v('APP_SESSION')||',
                                    "pipeline_stage": "DOCUMENT",
                                    "is_error": "Y"
                                 },
                                 "payload": {
                                    "doc_id": '||rec.doc_id||',
                                    "doc_title": '|| rec.doc_title||',
                                    "stage_name": "EMBED",
                                    "stage_status": "FAILED",
                                    "error_message": '||
                                            SQLERRM||' | '||DBMS_UTILITY.format_error_backtrace() ||',
                                    "embedding_model": "E5_MULTILINGUAL",
                                    "embeddings_generated": 0,
                                    "processing_time_ms": '||v_processing_time||'
                                 }
                              }' ;
         debug_util.error(l_event,vcaller);                    
          -- Re-raise for calling code to handle
          RAISE;
      END;
    END LOOP;

    COMMIT;

  EXCEPTION
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);   
      ROLLBACK;
      RAISE;
  END refresh_embeddings;

END ai_refresh_pkg;

/
