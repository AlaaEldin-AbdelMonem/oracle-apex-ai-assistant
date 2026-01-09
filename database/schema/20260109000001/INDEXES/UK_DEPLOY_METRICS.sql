--------------------------------------------------------
--  DDL for Index UK_DEPLOY_METRICS
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_DEPLOY_METRICS" ON "AI8P"."DEPLOYMENT_METRICS" ("DEPLOYMENT_ID", "SEGMENT_ID", "METRIC_DATE", "METRIC_HOUR") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
