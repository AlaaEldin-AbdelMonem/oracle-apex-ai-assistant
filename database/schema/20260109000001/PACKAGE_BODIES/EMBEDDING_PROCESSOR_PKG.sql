--------------------------------------------------------
--  DDL for Package Body EMBEDDING_PROCESSOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."EMBEDDING_PROCESSOR_PKG" AS

    FUNCTION embed_document_chunks(
        p_doc_id          IN NUMBER,
        p_strategy        IN VARCHAR2,
        p_chunk_size      IN NUMBER,
        p_embedding_model IN VARCHAR2 DEFAULT 'E5_MULTILINGUAL'
    ) RETURN NUMBER IS
         vcaller constant varchar2(70):= c_package_name ||'.embed_document_chunks'; 
    BEGIN
        RETURN rag_chunk_pkg.chunk_and_embed_document(
            p_doc_id          => p_doc_id,
            p_strategy        => p_strategy,
            p_chunk_size      => p_chunk_size,
            p_embedding_model => p_embedding_model
        );
    END;

    PROCEDURE refresh_embeddings(
        p_doc_id        IN NUMBER  DEFAULT NULL,
        p_force_refresh IN BOOLEAN DEFAULT FALSE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_embeddings'; 
        CURSOR c_docs IS
            SELECT doc_id,
                   NVL(last_chunking_strategy,'SENTENCE_BOUNDARY') AS strategy,
                   NVL(chunk_size_override,512)                    AS chunk_size
            FROM docs
            WHERE is_active = 'Y'
              AND (p_doc_id IS NULL OR doc_id = p_doc_id);

        v_count NUMBER;
    BEGIN
        FOR r IN c_docs LOOP
            IF p_force_refresh OR r.strategy IS NOT NULL THEN
                DELETE FROM doc_chunks WHERE doc_id = r.doc_id;

                v_count := embed_document_chunks(
                    p_doc_id     => r.doc_id,
                    p_strategy   => r.strategy,
                    p_chunk_size => r.chunk_size
                );
            END IF;
        END LOOP;

        COMMIT;
    END;

END embedding_processor_pkg;

/
