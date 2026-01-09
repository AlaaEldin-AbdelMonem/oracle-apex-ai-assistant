--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_METRICS_SEGMENT
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_METRICS_SEGMENT" ON "AI8P"."DEPLOYMENT_METRICS" ("SEGMENT_ID", "METRIC_DATE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
