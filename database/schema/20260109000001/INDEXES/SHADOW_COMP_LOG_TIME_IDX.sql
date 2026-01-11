--------------------------------------------------------
--  DDL for Index SHADOW_COMP_LOG_TIME_IDX
--------------------------------------------------------

  CREATE INDEX "SHADOW_COMP_LOG_TIME_IDX" ON "SHADOW_COMPARISON_LOG" ("COMPARED_AT") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
