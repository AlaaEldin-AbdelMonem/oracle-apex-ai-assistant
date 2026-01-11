--------------------------------------------------------
--  DDL for View V_DOC_TEXT_PAGINATED
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "V_DOC_TEXT_PAGINATED" ("DOC_ID", "DOC_TITLE", "FILE_NAME", "TOTAL_PAGES", "TOTAL_SIZE_KB", "TEXT_EXTRACTED", "TEXT_SUMMARY") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    doc_id,
    doc_title,
    file_name,
    -- Split text into pages of 10000 characters each
    CEIL(DBMS_LOB.GETLENGTH(text_extracted) / 10000) as total_pages,
    ROUND(DBMS_LOB.GETLENGTH(text_extracted) / 1024, 2) as total_size_kb,
    text_extracted,
    text_summary
FROM docs
WHERE text_extracted IS NOT NULL
;
