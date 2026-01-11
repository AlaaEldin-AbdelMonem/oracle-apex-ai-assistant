--------------------------------------------------------
--  DDL for Package Body RAG_PROCESSING_PKG_LEGACY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "RAG_PROCESSING_PKG_LEGACY" AS
    /***************************************************************************
     * process_document
     * -------------------------------------------------------------------------
     * Splits a document into chunks using RAG_CHUNK_PKG and optionally
     * generates embeddings. Logs activity to AI_AUDIT_LOG.
     ***************************************************************************/
/*******************************************************************************
 *  
 *******************************************************************************/
PROCEDURE log_rag_event (
    p_event_type_id   IN NUMBER,
    p_user_id         IN NUMBER,
    p_user_name       IN VARCHAR2,
    p_tenant_id       IN NUMBER,
    p_app_id          IN NUMBER,
    p_app_page_id     IN NUMBER,
    p_app_session_id  IN NUMBER,
    p_chat_session_id IN NUMBER,
    p_project_id      IN NUMBER,
    p_is_error        IN VARCHAR2,
    p_payload         IN CLOB
) IS
    vcaller constant varchar2(70):= c_package_name ||'.log_rag_event';  
    v_evt   log_types.t_log_event;
BEGIN
    -- Fill base attributes
    v_evt.base.event_type_id   := p_event_type_id;
    v_evt.base.user_id         := p_user_id;
    v_evt.base.user_name       := p_user_name;
    v_evt.base.tenant_id       := p_tenant_id;
    v_evt.base.app_id          := p_app_id;
    v_evt.base.app_page_id     := p_app_page_id;
    v_evt.base.app_session_id  := p_app_session_id;
    v_evt.base.chat_session_id := p_chat_session_id;
    v_evt.base.project_id      := p_project_id;

    v_evt.base.pipeline_stage  := 'RAG';      -- FIXED: always RAG stage
    v_evt.base.is_error        := p_is_error; -- 'Y' or 'N'

    -- Assign JSON payload
    v_evt.payload := p_payload;

    -- New Logging Call
 
END log_rag_event;


Function DOC_TO_TEXT(  p_blob_doc blob ) return clob
 IS
begin
    return DBMS_VECTOR_CHAIN.UTL_TO_TEXT ( p_blob_doc, 
      json('{ "plaintext": "true",  "charset"  : "UTF8"}' ));          

 exception
 when others then 
    dbms_output.put_line('Error>RAG_PROCESSING_PKG.DOC_TO_TEXT>'||sqlerrm);  
      return null;
 end DOC_TO_TEXT;
 -----------------------
----------------------- 
procedure Generate_DOC_TEXT(   p_doc_id  IN NUMBER , p_commit_flag char default 'Y' )  
    IS
    vcaller constant varchar2(70):= c_package_name ||'.Generate_DOC_TEXT';  
begin
  update docs set text_extracted = DOC_TO_TEXT( file_blob ) 
  where doc_id = p_doc_id;

  if p_commit_flag ='Y' then commit; else null; end if;
 exception
 when others then   null;
 end Generate_DOC_TEXT;

 Function Generate_DOC_TEXT(   p_doc_id  IN NUMBER , p_commit_flag char default 'Y' )  Return clob
    IS
    vclob clob;
begin
 
 select DOC_TO_TEXT( file_blob ) into vclob from docs where doc_id = p_doc_id;

  update docs set text_extracted = vclob where doc_id = p_doc_id;

  if p_commit_flag ='Y' then commit; else null; end if;

  return vclob;
 exception
 when others then    return vclob;
 end Generate_DOC_TEXT;
 ---------------------
Function is_doc_texted( p_doc_id  IN NUMBER ) return varchar2 is
vcaller constant varchar2(70):= c_package_name ||'.is_doc_texted';  
v_clob_len number;
v_blob_len number;
begin
   select   DBMS_LOB.GETLENGTH(text_extracted) clob_len,  DBMS_LOB.GETLENGTH(FILE_BLOB)
          INTO v_clob_len ,v_blob_len
           FROM docs
          WHERE doc_id = p_doc_id;
       
         if v_clob_len is null or v_blob_len is null  then
            return 'N';
         end if;

         return 'Y';

 exception
 when others then return 'N';
 end;        
 ---------------------
    PROCEDURE process_document(
        p_doc_id            IN NUMBER,
        p_chunking_strategy IN VARCHAR2 DEFAULT 'SEMANTIC',
        p_create_embeddings IN BOOLEAN  DEFAULT TRUE,
        p_user_name             IN VARCHAR2 DEFAULT v('APP_USER'),
        P_user_Id               IN NUmber   DEFAULT v('G_USER_ID'),
        p_app_session_id        IN NUMBER   DEFAULT v('APP_SESSION') ,
        p_App_id                IN NUMBER   DEFAULT v('APP_ID'),
        p_App_Page_id           IN NUMBER   DEFAULT v('APP_PAGE_ID') ,  
        p_tenant_id             IN NUMBER   DEFAULT v('G_TENANT_ID')
     ) IS
        vcaller constant varchar2(70):= c_package_name ||'.process_document';  
        v_text        CLOB;
        v_chunks      CHUNK_TYPES.t_chunk_tab;
        v_chunk_count NUMBER := 0;
        v_strategy    VARCHAR2(30);
        v_chunk_size  NUMBER;
        v_overlap_pct NUMBER;
        v_metadata    CLOB;
        
    BEGIN 
          if  is_doc_texted( p_doc_id =>p_doc_id) ='N' then --may be file is not exist, or text may not be generated
             Generate_DOC_TEXT(   p_doc_id => p_doc_id , p_commit_flag=>  'Y' )  ;
          end if;
         
        -- 1️⃣ Load document text and parameters
        SELECT text_extracted,
               NVL(chunking_strategy, p_chunking_strategy),
               NVL(chunk_size_override, 512),
               NVL(overlap_pct_override, 20)
          INTO v_text, v_strategy, v_chunk_size, v_overlap_pct
          FROM docs
         WHERE doc_id = p_doc_id;

        IF v_text IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'No text extracted for document ' || p_doc_id);
        END IF;

        -- 2️⃣ Delete old chunks and embeddings
        DELETE FROM doc_chunks     WHERE doc_id = p_doc_id;
 
        -- 3️⃣ Chunking using selected strategy
        v_chunks := rag_chunk_pkg.chunk_text(
            p_text        => v_text,
            p_strategy    => v_strategy,
            p_chunk_size  => v_chunk_size,
            p_overlap_pct => v_overlap_pct
        );

        -- 4️⃣ Insert new chunks
        IF v_chunks.COUNT > 0 THEN
            FOR i IN 1 .. v_chunks.COUNT LOOP
                INSERT INTO doc_chunks (
                    doc_chunk_id,
                    doc_id,
                    chunk_sequence,
                    chunk_text,
                    chunk_size,
                    start_position,
                    end_position,
                    chunking_strategy,
                    metadata_json,
                    created_at,
                    created_by,
                    is_active
                ) VALUES (
                    seq_rag_chunks.NEXTVAL,
                    p_doc_id,
                    v_chunks(i).chunk_sequence,
                    v_chunks(i).chunk_text,
                    v_chunks(i).chunk_size,
                    v_chunks(i).start_pos,
                    v_chunks(i).end_pos,
                    v_strategy,
                    v_chunks(i).chunk_metadata,
                    SYSTIMESTAMP,
                    SYS_CONTEXT('USERENV','SESSION_USER'),
                    'Y'
                );
                v_chunk_count := v_chunk_count + 1;
            END LOOP;
        END IF;

        -- 5️⃣ Optionally generate embeddings
        IF p_create_embeddings THEN
            v_chunk_count := rag_chunk_pkg.chunk_and_embed_document(
                p_doc_id          => p_doc_id,
                p_strategy        => v_strategy,
                p_chunk_size      => v_chunk_size,
                p_embedding_model => 'E5_MULTILINGUAL'
            );
        END IF;

        -- 6️⃣ Update document metadata
        UPDATE docs
           SET rag_ready_flag         = 'Y',
               embedding_count        = v_chunk_count,
               last_chunked_at        = SYSTIMESTAMP,
               last_chunking_strategy = v_strategy,
               updated_at             = SYSTIMESTAMP
         WHERE doc_id = p_doc_id;

        COMMIT;

        -- 7️⃣ Build audit JSON
        v_metadata := TO_CLOB(
            JSON_OBJECT(
                'doc_id'      VALUE p_doc_id,
                'chunk_count' VALUE v_chunk_count,
                'strategy'    VALUE v_strategy
            )
        );

     -- 8️⃣ Log chunk generation event
DECLARE
    v_doc_title VARCHAR2(500);
BEGIN
    -- Get document title for logging
    SELECT doc_title INTO v_doc_title
    FROM docs
    WHERE doc_id = p_doc_id;
    
    -- Log document operation using AI_LOG_UTIL
   /* log_util.log_document_operation(
         p_doc_id               => p_doc_id,
        p_doc_title            => v_doc_title,
        p_stage_name           => 'CHUNK',
        p_stage_status         => 'COMPLETED',
        p_chunk_strategy_code  => v_strategy,
        p_chunk_count          => v_chunk_count,
        p_chunks_per_second    => NULL,
        p_embedding_model      => CASE WHEN p_create_embeddings THEN 'E5_MULTILINGUAL' ELSE NULL END,
        p_embeddings_generated => CASE WHEN p_create_embeddings THEN v_chunk_count ELSE NULL END,
        p_processing_time_ms   => NULL,
        p_file_size_bytes      => LENGTH(v_text),
         p_is_error             => 'N',
        p_error_message        => NULL,
        p_user_name              => p_user_name,
        P_user_Id                => P_user_Id,-- v('G_USER_ID'),
        p_app_session_id         => p_APP_SESSION_Id,-- v('APP_SESSION') ,
        p_App_id                 => p_App_id,-- v('APP_ID'),
        p_App_Page_id            => p_App_Page_id,-- v('APP_PAGE_ID') ,  
        p_tenant_id              => p_tenant_id -- v('G_TENANT_ID'),
  );*/
 /* LOG_UTIL.LOG_EVENT(
'{
   "pipeline": "'||LOG_UTIL.json_str(p_pipeline)||'",   -- DOC / CHUNK / EMBED / RAG
   "base": {
      "event_type_id": '||p_event_type_id||',          -- e.g. 512, 522, 532
      "user_name": "'||LOG_UTIL.json_str(p_user_name)||'",
      "user_id": '||NVL(p_user_id,0)||',
      "tenant_id": '||NVL(p_tenant_id,0)||',
      "app_session_id": '||NVL(p_app_session_id,0)||',
      "pipeline_stage": "'||LOG_UTIL.json_str(p_stage_name)||'",   -- CHUNK / EMBED / DELETE
      "is_error": "N"
   },
   "payload": {
      "doc_id": '||NVL(p_doc_id,0)||',
      "stage_name": "'||LOG_UTIL.json_str(p_stage_name)||'",      -- CHUNK / EMBED / DELETE
      "stage_status": "'||LOG_UTIL.json_str(p_stage_status)||'",  -- COMPLETED / PARTIAL
      "chunk_count": '||NVL(p_chunk_count,0)||',
      "chunk_strategy_code": '||LOG_UTIL.json_str(p_strategy)||',
      "embedding_model": '||LOG_UTIL.json_str(p_embedding_model)||',
      "embeddings_generated": '||NVL(p_embeddings_generated,0)||',
      "file_size_bytes": '||NVL(p_file_size_bytes,0)||',
      "processing_time_ms": '||NVL(p_processing_time_ms,0)||'
   }
}'
);*/
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Warning: Audit logging failed: ' || SQLERRM);
    END;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error in process_document: ' || SQLERRM);
            RAISE;
    END process_document;


    /***************************************************************************
     * refresh_embeddings
     * -------------------------------------------------------------------------
     * Regenerates embeddings for one or more documents.
     ***************************************************************************/
    PROCEDURE refresh_embeddings(
        p_doc_id        IN NUMBER  DEFAULT NULL,
        p_force_refresh IN BOOLEAN DEFAULT FALSE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_embeddings';  
        CURSOR c_docs IS
            SELECT doc_id,
                   NVL(last_chunking_strategy, 'SENTENCE_BOUNDARY') AS strategy,
                   NVL(chunk_size_override, 512) AS chunk_size
              FROM docs
             WHERE is_active = 'Y'
               AND (p_doc_id IS NULL OR doc_id = p_doc_id);
        v_metadata    CLOB;
        v_chunk_count NUMBER := 0;
    BEGIN
        FOR r IN c_docs LOOP
            IF p_force_refresh OR r.strategy IS NOT NULL THEN
                DELETE FROM doc_chunks WHERE doc_id = r.doc_id;

               v_chunk_count := rag_chunk_pkg.chunk_and_embed_document(
                                                    p_doc_id          => r.doc_id,
                                                    p_strategy        => r.strategy,
                                                    p_chunk_size      => r.chunk_size,
                                                    p_embedding_model => 'E5_MULTILINGUAL'
                                                );

            -- Log embedding refresh using AI_LOG_UTIL
            DECLARE
                v_doc_title VARCHAR2(500);
            BEGIN
                SELECT doc_title INTO v_doc_title
                FROM docs
                WHERE doc_id = r.doc_id;
                
                /*ai_log_util.log_document_operation(
                     p_doc_id               => r.doc_id,
                    p_doc_title            => v_doc_title,
                    p_stage_name           => 'EMBED',
                    p_stage_status         => 'COMPLETED',
                    p_chunk_strategy_code  => r.strategy,
                    p_chunk_count          => v_chunk_count,
                    p_chunks_per_second    => NULL,
                    p_embedding_model      => 'E5_MULTILINGUAL',
                    p_embeddings_generated => v_chunk_count,
                    p_processing_time_ms   => NULL,
                    p_file_size_bytes      => NULL,
                     p_is_error             => 'N',
                    p_error_message        => NULL,
                    p_user_name              => v('APP_USER'),
                    P_user_Id                => V('G_USER_ID'),-- v('G_USER_ID'),
                    p_app_session_id         => v('APP_SESSION') ,
                    p_App_id                 =>  v('APP_ID'),
                    p_App_Page_id            => v('APP_PAGE_ID') ,  
                    p_tenant_id              => v('G_TENANT_ID')
                  );*/
                  LOG_UTIL.LOG_EVENT(
'{
   "pipeline": "'||LOG_UTIL.json_str(p_pipeline)||'",   -- DOC / CHUNK / EMBED / DELETE / RAG
   "base": {
      "event_type_id": '||p_error_event_id||',         -- e.g. 901
      "user_name": "'||AI_LOG_UTIL.json_str(p_user_name)||'",
      "user_id": '||NVL(p_user_id,0)||',
      "tenant_id": '||NVL(p_tenant_id,0)||',
      "app_session_id": '||NVL(p_app_session_id,0)||',
      "pipeline_stage": "'||AI_LOG_UTIL.json_str(p_stage_name)||'",
      "is_error": "Y"
   },
   "payload": {
      "error_message": '||AI_LOG_UTIL.json_str(SQLERRM)||',
      "error_stack": '||AI_LOG_UTIL.json_str(DBMS_UTILITY.format_error_backtrace())||',
      "doc_id": '||NVL(p_doc_id,0)||',
      "stage_name": "'||AI_LOG_UTIL.json_str(p_stage_name)||'"
   }
}'
);
            EXCEPTION
                WHEN OTHERS THEN
                    DBMS_OUTPUT.PUT_LINE('Warning: Audit logging failed: ' || SQLERRM);
            END;
            END IF;
        END LOOP;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error in refresh_embeddings: ' || SQLERRM);
            RAISE;
    END refresh_embeddings;


    /***************************************************************************
     * delete_document_chunks
     * -------------------------------------------------------------------------
     * Deletes all chunks and embeddings for a given document.
     ***************************************************************************/
    PROCEDURE delete_document_chunks(p_doc_id IN NUMBER) IS
        vcaller constant varchar2(70):= c_package_name ||'.delete_document_chunks';  
        v_deleted_chunks NUMBER;
        v_deleted_embeds NUMBER;
        v_metadata       CLOB;
    BEGIN
        DELETE FROM doc_chunks     WHERE doc_id = p_doc_id;
        v_deleted_chunks := SQL%ROWCOUNT;
 

     -- Update document metadata
UPDATE docs
   SET rag_ready_flag  = 'N',
       embedding_count = 0,
       updated_at      = SYSTIMESTAMP
 WHERE doc_id = p_doc_id;

-- Log chunk deletion using AI_LOG_UTIL
DECLARE
    v_doc_title VARCHAR2(500);
BEGIN
    SELECT doc_title INTO v_doc_title
    FROM docs
    WHERE doc_id = p_doc_id;
    
    /*ai_log_util.log_document_operation(
         p_doc_id               => p_doc_id,
        p_doc_title            => v_doc_title,
        p_stage_name           => 'CHUNK',
        p_stage_status         => 'DELETED',
        p_chunk_strategy_code  => NULL,
        p_chunk_count          => v_deleted_chunks,
        p_chunks_per_second    => NULL,
        p_embedding_model      => NULL,
        p_embeddings_generated => v_deleted_embeds,
        p_processing_time_ms   => NULL,
        p_file_size_bytes      => NULL,
         p_is_error             => 'N',
        p_error_message        => NULL,
         p_user_name              => v('APP_USER'),
        P_user_Id                =>  v('G_USER_ID'),
        p_app_session_id         =>  v('APP_SESSION') ,
        p_App_id                 => v('APP_ID'),
        p_App_Page_id            => v('APP_PAGE_ID') ,  
        p_tenant_id              => v('G_TENANT_ID') 
    );*/

    AI_LOG_UTIL.LOG_EVENT(
'{
   "pipeline": "DOC",
   "base": {
      "event_type_id": 512,
      "user_name": "'||LOG_UTIL.json_str(p_user_name)||'",
      "user_id": '||NVL(p_user_id,0)||',
      "tenant_id": '||NVL(p_tenant_id,0)||',
      "app_session_id": '||NVL(p_app_session_id,0)||',
      "pipeline_stage": "CHUNK",
      "is_error": "N"
   },
   "payload": {
      "doc_id": '||p_doc_id||',
      "stage_name": "CHUNK",
      "stage_status": "COMPLETED",
      "chunk_count": '||v_chunk_count||',
      "chunk_strategy_code": '||AI_LOG_UTIL.json_str(v_strategy)||',
      "processing_time_ms": '||v_processing_time_ms||'
   }
}'
);
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Warning: Audit logging failed: ' || SQLERRM);
END;

COMMIT;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error in delete_document_chunks: ' || SQLERRM);
            RAISE;
    END delete_document_chunks;

END rag_processing_pkg_legacy;

/
