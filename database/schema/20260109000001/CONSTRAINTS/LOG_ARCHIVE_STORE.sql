--------------------------------------------------------
--  Constraints for Table LOG_ARCHIVE_STORE
--------------------------------------------------------

  ALTER TABLE "AI8P"."LOG_ARCHIVE_STORE" MODIFY ("ARCHIVE_ID" NOT NULL ENABLE);
  ALTER TABLE "AI8P"."LOG_ARCHIVE_STORE" ADD CONSTRAINT "PK_LOG_ARCHIVE_STORE" PRIMARY KEY ("ARCHIVE_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
