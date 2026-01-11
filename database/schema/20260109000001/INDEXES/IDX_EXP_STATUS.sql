--------------------------------------------------------
--  DDL for Index IDX_EXP_STATUS
--------------------------------------------------------

  CREATE INDEX "IDX_EXP_STATUS" ON "DEPLOYMENT_EXPERIMENTS" ("EXPERIMENT_STATUS", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
