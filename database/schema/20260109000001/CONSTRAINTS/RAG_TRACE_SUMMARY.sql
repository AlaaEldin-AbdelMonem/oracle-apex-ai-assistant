--------------------------------------------------------
--  Constraints for Table RAG_TRACE_SUMMARY
--------------------------------------------------------

  ALTER TABLE "RAG_TRACE_SUMMARY" MODIFY ("SUMMARY_ID" NOT NULL ENABLE);
  ALTER TABLE "RAG_TRACE_SUMMARY" ADD PRIMARY KEY ("SUMMARY_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
