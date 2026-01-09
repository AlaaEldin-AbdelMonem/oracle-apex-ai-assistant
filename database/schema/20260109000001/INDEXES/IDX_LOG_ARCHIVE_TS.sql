--------------------------------------------------------
--  DDL for Index IDX_LOG_ARCHIVE_TS
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_LOG_ARCHIVE_TS" ON "AI8P"."LOG_ARCHIVE_STORE" ("CREATED_TS") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
