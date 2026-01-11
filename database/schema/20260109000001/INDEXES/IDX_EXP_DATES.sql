--------------------------------------------------------
--  DDL for Index IDX_EXP_DATES
--------------------------------------------------------

  CREATE INDEX "IDX_EXP_DATES" ON "DEPLOYMENT_EXPERIMENTS" ("START_DATE", "ACTUAL_END_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
