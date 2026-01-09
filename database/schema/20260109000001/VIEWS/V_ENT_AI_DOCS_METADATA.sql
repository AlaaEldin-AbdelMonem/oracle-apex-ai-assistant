--------------------------------------------------------
--  DDL for View V_ENT_AI_DOCS_METADATA
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "AI8P"."V_ENT_AI_DOCS_METADATA" ("DOC_ID", "DOC_TITLE", "DOC_CATEGORY", "DOC_STATUS", "LANGUAGE_CODE", "FILE_NAME", "FILE_SIZE", "CHUNKING_STRATEGY", "CHUNK_SIZE_OVERRIDE", "OVERLAP_PCT_OVERRIDE", "CHUNKING_NOTES", "LAST_CHUNKED_AT", "EMBEDDING_COUNT", "RAG_READY_FLAG", "CREATED_BY", "CREATED_AT", "LAST_CHUNKING_STRATEGY", "TEXT_EXTRACTED_LENGTH", "TEXT_SUMMARY_LENGTH", "TEXT_SUMMARY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    doc_id,
    doc_title,
    doc_category,
    doc_status,
    language_code,
    file_name,
    file_size,
    chunking_strategy,
    chunk_size_override,
    overlap_pct_override,
    chunking_notes,
    last_chunked_at,
    embedding_count,
    rag_ready_flag,
    created_by,
    created_at,
    last_chunking_strategy,
    -- Pre-calculate text lengths to avoid DBMS_LOB.GETLENGTH
    DBMS_LOB.GETLENGTH(text_extracted) as text_extracted_length,
    DBMS_LOB.GETLENGTH(text_summary) as text_summary_length,
    -- Include summary but not full text
    text_summary
FROM docs
;
