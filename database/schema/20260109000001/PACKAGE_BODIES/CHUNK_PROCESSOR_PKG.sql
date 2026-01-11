--------------------------------------------------------
--  DDL for Package Body CHUNK_PROCESSOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHUNK_PROCESSOR_PKG" AS
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION generate_chunks(
        p_doc_id      IN NUMBER,
        p_strategy    IN VARCHAR2,
        p_chunk_size  IN NUMBER,
        p_overlap_pct IN NUMBER
    ) RETURN chunk_types.t_chunk_tab IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_chunks'; 
        v_text CLOB;
    BEGIN
        SELECT text_extracted INTO v_text FROM docs WHERE doc_id = p_doc_id;

        RETURN rag_chunk_pkg.chunk_text(
                   p_text        => v_text,
                   p_strategy    => p_strategy,
                   p_chunk_size  => p_chunk_size,
                   p_overlap_pct => p_overlap_pct
               );
    END generate_chunks;
 /*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE save_chunks(
        p_doc_id IN NUMBER,
        p_chunks IN chunk_types.t_chunk_tab
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.save_chunks'; 
    BEGIN
        IF p_chunks.COUNT > 0 THEN
            FOR i IN 1 .. p_chunks.COUNT LOOP
                INSERT INTO doc_chunks(
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
                    p_chunks(i).chunk_sequence,
                    p_chunks(i).chunk_text,
                    p_chunks(i).chunk_size,
                    p_chunks(i).start_pos,
                    p_chunks(i).end_pos,
                    p_chunks(i).strategy_used,
                    p_chunks(i).chunk_metadata,
                    SYSTIMESTAMP,
                    SYS_CONTEXT('USERENV','SESSION_USER'),
                    'Y'
                );
            END LOOP;
        END IF;
    END save_chunks;
 /*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE delete_chunks(p_doc_id NUMBER) IS
       vcaller constant varchar2(70):= c_package_name ||'.delete_chunks'; 
    BEGIN
        DELETE FROM doc_chunks WHERE doc_id = p_doc_id;
    END delete_chunks;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION count_chunks(p_doc_id NUMBER) RETURN NUMBER IS
         vcaller constant varchar2(70):= c_package_name ||'.count_chunks'; 
        v NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v FROM doc_chunks WHERE doc_id = p_doc_id;
        RETURN v;
    END count_chunks;
 /*******************************************************************************
 *  
 *******************************************************************************/
END chunk_processor_pkg;

/
