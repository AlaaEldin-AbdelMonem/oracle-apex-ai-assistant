--------------------------------------------------------
--  DDL for Package Body RAG_API_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "RAG_API_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
  FUNCTION build_response(
        p_success BOOLEAN,
        p_message VARCHAR2,
        p_data    CLOB DEFAULT NULL
    ) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.build_response'; 
    BEGIN
        RETURN JSON_OBJECT( 'success' VALUE p_success,
                            'message' VALUE p_message,
                            'data'    VALUE p_data  ) ;
        
        
    END build_response;
/*******************************************************************************
 *  
 *******************************************************************************/

    --------------------------------------------------------------------------
    -- POST /rag/processDocument
    --------------------------------------------------------------------------
    FUNCTION process_document_api(
        p_body CLOB
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.process_document_api'; 
        j       JSON_OBJECT_T;
        v_doc   NUMBER;
        v_strat VARCHAR2(200);
        v_embed BOOLEAN;
        v_user  VARCHAR2(200);
        v_uid   NUMBER;
        v_app   NUMBER;
        v_page  NUMBER;
        v_sess  NUMBER;
        v_tnt   NUMBER;
    BEGIN
        j := JSON_OBJECT_T.parse(p_body);

        v_doc   := j.get_Number('doc_id');
        v_strat := j.get_string('strategy');
        v_embed := j.get_boolean('create_embeddings');

        v_user  := j.get_string('user_name');
        v_uid   := j.get_Number('user_id');
        v_app   := j.get_Number('app_id');
        v_page  := j.get_Number('app_page_id');
        v_sess  := j.get_Number('app_session_id');
        v_tnt   := j.get_Number('tenant_id');

        rag_processing_pkg.process_document(
            p_doc_id            => v_doc,
            p_chunking_strategy => v_strat,
            p_create_embeddings => v_embed,
            p_user_name         => v_user,
            p_user_id           => v_uid,
            p_app_session_id    => v_sess,
            p_app_id            => v_app,
            p_app_page_id       => v_page,
            p_tenant_id         => v_tnt
        );

        RETURN build_response(TRUE, 'Document processed successfully');

    EXCEPTION WHEN OTHERS THEN
      debug_util.error(sqlerrm,vcaller);
        RETURN build_response(FALSE, SQLERRM);
    END;

/*******************************************************************************
 *  
 *******************************************************************************/

    --------------------------------------------------------------------------
    -- POST /rag/refreshEmbeddings
    --------------------------------------------------------------------------
    FUNCTION refresh_embeddings_api(
        p_body CLOB
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_embeddings_api'; 
        j        JSON_OBJECT_T;
        v_doc    NUMBER;
        v_force  BOOLEAN;
    BEGIN
        j := JSON_OBJECT_T.parse(p_body);

        v_doc   := j.get_Number('doc_id');
        v_force := j.get_boolean('force_refresh');

        rag_processing_pkg.refresh_embeddings(
            p_doc_id        => v_doc,
            p_force_refresh => v_force
        );

        RETURN build_response(TRUE, 'Embeddings refreshed');

    EXCEPTION WHEN OTHERS THEN
      debug_util.error(sqlerrm,vcaller);
        RETURN build_response(FALSE, SQLERRM);
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
   --------------------------------------------------------------------------
    -- DELETE /rag/documentChunks/{doc_id}
    --------------------------------------------------------------------------
    FUNCTION delete_document_chunks_api(
        p_doc_id NUMBER
    ) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.delete_document_chunks_api'; 
    BEGIN
        rag_processing_pkg.delete_document_chunks(p_doc_id);
        RETURN build_response(TRUE, 'Document chunks deleted');
    EXCEPTION WHEN OTHERS THEN
      debug_util.error(sqlerrm,vcaller);
        RETURN build_response(FALSE, SQLERRM);
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
END rag_api_pkg;

/
