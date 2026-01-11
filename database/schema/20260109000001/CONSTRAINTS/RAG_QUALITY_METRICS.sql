--------------------------------------------------------
--  Constraints for Table RAG_QUALITY_METRICS
--------------------------------------------------------

  ALTER TABLE "RAG_QUALITY_METRICS" MODIFY ("METRIC_ID" NOT NULL ENABLE);
  ALTER TABLE "RAG_QUALITY_METRICS" ADD PRIMARY KEY ("METRIC_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
