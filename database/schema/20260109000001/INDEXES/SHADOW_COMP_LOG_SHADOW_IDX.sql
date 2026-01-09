--------------------------------------------------------
--  DDL for Index SHADOW_COMP_LOG_SHADOW_IDX
--------------------------------------------------------

  CREATE INDEX "AI8P"."SHADOW_COMP_LOG_SHADOW_IDX" ON "AI8P"."SHADOW_COMPARISON_LOG" ("SHADOW_DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
