--------------------------------------------------------
--  DDL for Package Body RAG_PROCESSING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."RAG_PROCESSING_PKG" AS

    c_evt_chunk_embed   CONSTANT NUMBER := 512;
    c_evt_embed_refresh CONSTANT NUMBER := 522;
    c_evt_chunk_delete  CONSTANT NUMBER := 532;
    c_evt_rag_error     CONSTANT NUMBER := 901;

/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE process_document(
        p_doc_id            IN NUMBER,
        p_chunking_strategy IN VARCHAR2 DEFAULT 'SEMANTIC',
        p_create_embeddings IN BOOLEAN DEFAULT TRUE,
        p_user_name         IN VARCHAR2 DEFAULT v('APP_USER'),
        p_user_id           IN NUMBER   DEFAULT v('G_USER_ID'),
        p_app_session_id    IN NUMBER   DEFAULT v('APP_SESSION'),
        p_app_id            IN NUMBER   DEFAULT v('APP_ID'),
        p_app_page_id       IN NUMBER   DEFAULT v('APP_PAGE_ID'),
        p_tenant_id         IN NUMBER   DEFAULT v('G_TENANT_ID')
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.process_document';  
        v_chunks    chunk_types.t_chunk_tab;
        v_count     NUMBER;
        v_chunk_sz  NUMBER;
        v_overlap   NUMBER;
        v_text_len  NUMBER;
        v_strategy  VARCHAR2(50);
    BEGIN
        -- Ensure text exists
        IF NOT doc_extract_pkg.is_text_ready(p_doc_id) THEN
            doc_extract_pkg.generate_text(p_doc_id);
        END IF;

        -- Load parameters
        SELECT NVL(chunking_strategy, p_chunking_strategy),
               NVL(chunk_size_override, 512),
               NVL(overlap_pct_override, 20)
        INTO v_strategy, v_chunk_sz, v_overlap
        FROM docs WHERE doc_id = p_doc_id;

        SELECT DBMS_LOB.GETLENGTH(text_extracted)
        INTO v_text_len
        FROM docs WHERE doc_id = p_doc_id;

        -- Delete existing chunks
        chunk_processor_pkg.delete_chunks(p_doc_id);

        -- Generate new chunks
        v_chunks := chunk_processor_pkg.generate_chunks(
                        p_doc_id     => p_doc_id,
                        p_strategy   => v_strategy,
                        p_chunk_size => v_chunk_sz,
                        p_overlap_pct=> v_overlap );

        chunk_processor_pkg.save_chunks(p_doc_id, v_chunks);

        v_count := v_chunks.COUNT;

        -- Embedding (optional)
        IF p_create_embeddings THEN
            v_count := embedding_processor_pkg.embed_document_chunks(
                           p_doc_id     => p_doc_id,
                           p_strategy   => v_strategy,
                           p_chunk_size => v_chunk_sz
                       );
        END IF;

        UPDATE docs
           SET rag_ready_flag         = 'Y',
               embedding_count        = v_count,
               last_chunked_at        = SYSTIMESTAMP,
               last_chunking_strategy = v_strategy,
               updated_at             = SYSTIMESTAMP
         WHERE doc_id = p_doc_id;

        COMMIT;

        -- Log success
        rag_logging_pkg.log_event(
            p_event_type_id        => c_evt_chunk_embed,
            p_is_error             => 'N',
            p_doc_id               => p_doc_id,
            p_stage_name           => 'CHUNK_EMBED',
            p_stage_status         => 'COMPLETED',
            p_chunk_count          => v_count,
            p_chunk_strategy_code  => v_strategy,
            p_embedding_model      => CASE WHEN p_create_embeddings THEN 'E5_MULTILINGUAL' END,
            p_embeddings_generated => CASE WHEN p_create_embeddings THEN v_count END,
            p_file_size_bytes      => v_text_len,
            p_processing_ms        => NULL,
            p_error_message        => NULL,
            p_user_name            => p_user_name,
            p_user_id              => p_user_id,
            p_tenant_id            => p_tenant_id,
            p_app_id               => p_app_id,
            p_app_page_id          => p_app_page_id,
            p_app_session_id       => p_app_session_id
        );

    EXCEPTION WHEN OTHERS THEN
     debug_util.error( sqlerrm,vcaller);
        rag_logging_pkg.log_event(
            p_event_type_id        => c_evt_rag_error,
            p_is_error             => 'Y',
            p_doc_id               => p_doc_id,
            p_stage_name           => 'CHUNK_EMBED',
            p_stage_status         => 'ERROR',
            p_error_message        => SQLERRM,
            p_user_name            => p_user_name,
            p_user_id              => p_user_id,
            p_tenant_id            => p_tenant_id,
            p_app_id               => p_app_id,
            p_app_page_id          => p_app_page_id,
            p_app_session_id       => p_app_session_id
        );

        ROLLBACK;
        RAISE;
    END process_document;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE refresh_embeddings(
        p_doc_id        IN NUMBER DEFAULT NULL,
        p_force_refresh IN BOOLEAN DEFAULT FALSE
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.refresh_embeddings'; 
    BEGIN
        embedding_processor_pkg.refresh_embeddings(
            p_doc_id        => p_doc_id,
            p_force_refresh => p_force_refresh
        );
          debug_util.info( 'Refresh',vcaller);
        rag_logging_pkg.log_event(
            p_event_type_id        => c_evt_embed_refresh,
            p_is_error             => 'N',
            p_doc_id               => p_doc_id,
            p_stage_name           => 'EMBED_REFRESH',
            p_stage_status         => 'COMPLETED'
        );
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE delete_document_chunks(p_doc_id NUMBER) IS
        vcaller constant varchar2(70):= c_package_name ||'.delete_document_chunks'; 
        v_count NUMBER;
    BEGIN
        chunk_processor_pkg.delete_chunks(p_doc_id);
        v_count := 0;

        UPDATE docs
           SET rag_ready_flag  = 'N',
               embedding_count = 0
         WHERE doc_id = p_doc_id;

        rag_logging_pkg.log_event(
            p_event_type_id        => c_evt_chunk_delete,
            p_is_error             => 'N',
            p_doc_id               => p_doc_id,
            p_stage_name           => 'CHUNK',
            p_stage_status         => 'DELETED',
            p_chunk_count          => v_count
        );

        COMMIT;
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
END rag_processing_pkg;

/
