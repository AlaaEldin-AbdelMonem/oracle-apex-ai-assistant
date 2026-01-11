--------------------------------------------------------
--  DDL for Package Body CX_CHUNKS_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CX_CHUNKS_BUILDER_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_context_docs(
        p_user_id IN NUMBER,
        p_context_Domain_id IN NUMBER,
        p_query   IN Clob,
        p_top_k   IN NUMBER
    ) RETURN CLOB
    IS
          vcaller constant varchar2(70):= c_package_name ||'.get_context_docs';
        v_output CLOB := '';
    BEGIN
        v_output := '[RAG CONTEXT BLOCK]'||CHR(10)||
                     'Retrieved domain-relevant context:'||CHR(10)||CHR(10);

        FOR rec IN (
            SELECT * FROM TABLE(
                cx_chunks_pkg.get_chunks(
                    p_context_Domain_id=>p_context_Domain_id,
                    p_user_id => p_user_id,
                    p_query   => p_query,
                    p_top_k   => p_top_k
                )
            )
        ) LOOP

            v_output := v_output ||
                '---'||CHR(10)||
                'Document: '||rec.doc_id||CHR(10)||
                'Chunk: '||rec.chunk_id||CHR(10)||
                'Similarity: '||TO_CHAR(rec.similarity,'0.00')||CHR(10)||
                'Classification: '||rec.classification||CHR(10)||
                'Content:'||CHR(10)||
                policy_redaction_pkg.apply_redaction(rec.content, rec.classification)||
                CHR(10)||CHR(10);
        END LOOP;

        RETURN v_output;
    END get_context_docs;
/*******************************************************************************
 *  
 *******************************************************************************/
END cx_chunks_builder_pkg;

/
