--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_METRICS_EXP
--------------------------------------------------------

  CREATE INDEX "IDX_DEPLOY_METRICS_EXP" ON "DEPLOYMENT_METRICS" ("EXPERIMENT_ID", "METRIC_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
