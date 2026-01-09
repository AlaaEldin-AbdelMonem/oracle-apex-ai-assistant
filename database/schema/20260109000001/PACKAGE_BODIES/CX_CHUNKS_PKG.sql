--------------------------------------------------------
--  DDL for Package Body CX_CHUNKS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CX_CHUNKS_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_chunks(
        p_user_id IN NUMBER,
        p_context_Domain_id IN NUMBER,
        p_query   IN clob,
        p_top_k   IN NUMBER
    ) RETURN t_chunk_tab PIPELINED
    IS  vcaller constant varchar2(70):= c_package_name ||'.get_chunks';
        v_rec t_chunk_record;
        v_allowed VARCHAR2(4000);
    BEGIN
        --v_allowed := context_policy_pkg.get_allowed_classifications(p_user_id);

       FOR rec IN (
    SELECT 
        d.doc_id,
        c.doc_chunk_id AS chunk_id,
        c.chunk_text AS content,
        0.85 AS similarity,
        d.classification_level AS classification,
        d.source_system
    FROM docs d, 
         doc_chunks c,
         context_registry cr,
         context_domain_registry cdr
    WHERE c.doc_id = d.doc_id
      AND d.doc_id = cr.doc_id                             --Link docs to registry
      AND cr.context_registry_id = cdr.context_registry_id --Link registry to domain
      AND cdr.context_domain_id = p_context_Domain_id      --Filter by domain
      AND cdr.is_active = 'Y'                              --Active domain mappings only
      AND cr.is_active = 'Y'                               --Active registry entries only
      AND d.is_active = 'Y'
      --AND INSTR(','||v_allowed||',', ','||d.classification_level||',') > 0
      AND ROWNUM <= p_top_k
      ) LOOP

            v_rec.doc_id := rec.doc_id;
            v_rec.chunk_id := rec.chunk_id;
            v_rec.content := rec.content;
            v_rec.similarity := rec.similarity;
            v_rec.classification := rec.classification;
            v_rec.source_system := rec.source_system;

            PIPE ROW(v_rec);
        END LOOP;

    END get_chunks;
/*******************************************************************************
 *  
 *******************************************************************************/
END cx_chunks_pkg;

/
