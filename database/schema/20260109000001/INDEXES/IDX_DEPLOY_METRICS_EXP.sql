--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_METRICS_EXP
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_METRICS_EXP" ON "AI8P"."DEPLOYMENT_METRICS" ("EXPERIMENT_ID", "METRIC_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
