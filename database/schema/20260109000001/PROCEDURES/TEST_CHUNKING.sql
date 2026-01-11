--------------------------------------------------------
--  DDL for Procedure TEST_CHUNKING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "TEST_CHUNKING" 
as
/*******************************************************************************
 *  
 *******************************************************************************/
/*--ie use
begin 
TEST_CHUNKING;
end;
*/

    v_text    CLOB;
    v_chunks  chunk_types.t_chunk_tab;
BEGIN
    -- 1️⃣ Prepare a sample text (multi-sentence paragraph)
    v_text := 'Oracle 23ai introduces built-in Vector Search and Retrieval-Augmented Generation (RAG) capabilities. '
           || 'These features enable developers to process, chunk, and vectorize documents directly inside the database. '
           || 'Each chunk can be embedded, searched, and retrieved efficiently for generative AI applications. '
           || 'This native integration reduces data movement and improves both latency and security. '
           || 'By using DBMS_VECTOR, developers can handle text embeddings, ONNX models, and AI pipelines end-to-end.';

    -- 2️⃣ Call the chunk_text function with default parameters
    v_chunks := chunk_proxy_util.chunk_text(
        p_text             => v_text,
        p_strategy         => NULL,
        p_chunk_size       => NULL,
        p_overlap_size     => NULL,
        p_language         => NULL,
        p_normalize        => NULL,
        p_preserve_format  => NULL
    );
    --check dbms_output
   
end TEST_CHUNKING;

/
