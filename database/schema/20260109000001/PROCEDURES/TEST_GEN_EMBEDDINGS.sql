--------------------------------------------------------
--  DDL for Procedure TEST_GEN_EMBEDDINGS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."TEST_GEN_EMBEDDINGS" 
as
/*******************************************************************************
 *  
 *******************************************************************************/
 /*
 begin Test_gen_Embeddings; end;
 */
 
    -- Variable to hold a valid Chunk ID from RAG_CHUNKS
    v_chunk_id_test_1       NUMBER;
    v_chunk_id_test_2       NUMBER;
    v_chunk_id_test_3       NUMBER;
    
    -- Fixed user ID for testing
    v_user_id              number := 4;
    
    -- Variables for result verification
    v_embedding_exists      VARCHAR2(3);
    v_embedding_model       VARCHAR2(100);

 

BEGIN
  
    -- Retrieve 3 sample Chunk IDs (replace with your actual table and logic)
    SELECT doc_chunk_id INTO v_chunk_id_test_1 FROM doc_CHUNKS WHERE ROWNUM = 1;
   -- SELECT chunk_id INTO v_chunk_id_test_2 FROM RAG_CHUNKS WHERE ROWNUM = 2;
   --SELECT chunk_id INTO v_chunk_id_test_3 FROM RAG_CHUNKS WHERE ROWNUM = 3;

    DBMS_OUTPUT.PUT_LINE('--- Starting Test Script for GENERATE_CHUNK_EMBEDDING ---');
    DBMS_OUTPUT.PUT_LINE('Chunk IDs selected for testing: ' || 
                         v_chunk_id_test_1 || ', ' || v_chunk_id_test_2 || ', ' || v_chunk_id_test_3);
    DBMS_OUTPUT.PUT_LINE('---------------------------------------------------------');

 
    
    -- Execute the procedure, forcing regeneration and specifying a model
    chunk_EMBEDDING_pkg.generate_chunk_embedding(
        p_doc_chunk_id          => v_chunk_id_test_1,
        p_user_id           => v_user_id,
        p_model             => 'qwen3-large', -- Specify a model name
        p_force_regenerate  => TRUE,          -- Force it to run even if embedding exists
        p_commit_work       => TRUE
    );
  
   /* -- Execute the procedure, forcing regeneration and specifying a model
    RAG_EMBEDDING_UTIL.generate_chunk_embedding(
        p_chunk_id          => v_chunk_id_test_2,
        p_user_id           => v_user_id,
        p_model             => 'qwen3-large', -- Specify a model name
        p_force_regenerate  => TRUE,          -- Force it to run even if embedding exists
        p_commit_work       => TRUE
    );

     -- Execute the procedure, forcing regeneration and specifying a model
    RAG_EMBEDDING_UTIL.generate_chunk_embedding(
        p_chunk_id          => v_chunk_id_test_3,
        p_user_id           => v_user_id,
        p_model             => 'qwen3-large', -- Specify a model name
        p_force_regenerate  => TRUE,          -- Force it to run even if embedding exists
        p_commit_work       => TRUE
    );*/
 
end;

/
