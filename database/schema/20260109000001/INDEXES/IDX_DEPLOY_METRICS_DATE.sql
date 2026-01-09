--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_METRICS_DATE
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_METRICS_DATE" ON "AI8P"."DEPLOYMENT_METRICS" ("METRIC_DATE" DESC, "DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
