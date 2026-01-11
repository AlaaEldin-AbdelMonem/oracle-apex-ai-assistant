--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_METRICS_DATE
--------------------------------------------------------

  CREATE INDEX "IDX_DEPLOY_METRICS_DATE" ON "DEPLOYMENT_METRICS" ("METRIC_DATE" DESC, "DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
