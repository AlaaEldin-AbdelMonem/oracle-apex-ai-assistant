--------------------------------------------------------
--  DDL for View SMART_SEARCH_RESULTS_V
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "SMART_SEARCH_RESULTS_V" ("RESULT_NUMBER", "CHUNK_ID", "DOC_ID", "DOC_TITLE", "CHUNK_SEQUENCE", "CHUNK_TEXT", "RELEVANCE_SCORE", "RELEVANCE_PCT", "EMBEDDING_MODEL", "SEARCH_QUERY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    seq_id as result_number,
    n001 as chunk_id,
    n002 as doc_id,
    c001 as doc_title,
    n003 as chunk_sequence,
    clob001 as chunk_text,
    n004 as relevance_score,
    n005 as relevance_pct,
    c002 as embedding_model,
    c003 as search_query
FROM apex_collections
WHERE collection_name = 'SMART_SEARCH_RESULTS'
ORDER BY n005 DESC
;
