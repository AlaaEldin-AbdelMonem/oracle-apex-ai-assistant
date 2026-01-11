--------------------------------------------------------
--  DDL for Index SHADOW_COMP_LOG_PROD_IDX
--------------------------------------------------------

  CREATE INDEX "SHADOW_COMP_LOG_PROD_IDX" ON "SHADOW_COMPARISON_LOG" ("PRODUCTION_DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
