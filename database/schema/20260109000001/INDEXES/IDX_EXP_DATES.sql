--------------------------------------------------------
--  DDL for Index IDX_EXP_DATES
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_EXP_DATES" ON "AI8P"."DEPLOYMENT_EXPERIMENTS" ("START_DATE", "ACTUAL_END_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
