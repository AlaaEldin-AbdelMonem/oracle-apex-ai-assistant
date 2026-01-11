--------------------------------------------------------
--  DDL for Procedure TEST_CHUNKING2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "TEST_CHUNKING2" (doc_id number default 2) AS
    v_text    CLOB;
    v_chunks  chunk_types.t_chunk_tab;
BEGIN
 /*******************************************************************************
 *  
 *******************************************************************************/
 
 chunk_proxy_util.run_chunk(
    p_doc_id              =>doc_id ,
    p_recommend_strategy  => 'N',
    p_force_rechunk      => TRUE,--default FALSE
    p_commit_after      =>TRUE
) ;

   
EXCEPTION
   
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('❌ Error in TEST_CHUNKING2: ' || SQLERRM);
END TEST_CHUNKING2;

/
