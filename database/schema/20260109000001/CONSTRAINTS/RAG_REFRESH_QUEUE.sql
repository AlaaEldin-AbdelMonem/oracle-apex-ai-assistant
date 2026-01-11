--------------------------------------------------------
--  Constraints for Table RAG_REFRESH_QUEUE
--------------------------------------------------------

  ALTER TABLE "RAG_REFRESH_QUEUE" MODIFY ("QUEUE_ID" NOT NULL ENABLE);
  ALTER TABLE "RAG_REFRESH_QUEUE" ADD PRIMARY KEY ("QUEUE_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
