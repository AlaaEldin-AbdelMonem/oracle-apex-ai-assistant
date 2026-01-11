--------------------------------------------------------
--  DDL for Index IDX_LOG_ARCHIVE_TS
--------------------------------------------------------

  CREATE INDEX "IDX_LOG_ARCHIVE_TS" ON "LOG_ARCHIVE_STORE" ("CREATED_TS") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
