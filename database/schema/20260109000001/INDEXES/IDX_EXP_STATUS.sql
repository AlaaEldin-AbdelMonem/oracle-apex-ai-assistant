--------------------------------------------------------
--  DDL for Index IDX_EXP_STATUS
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_EXP_STATUS" ON "AI8P"."DEPLOYMENT_EXPERIMENTS" ("EXPERIMENT_STATUS", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
