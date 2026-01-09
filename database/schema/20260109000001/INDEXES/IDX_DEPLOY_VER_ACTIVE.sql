--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_VER_ACTIVE
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_VER_ACTIVE" ON "AI8P"."DEPLOYMENT_VERSIONS" ("IS_ACTIVE", "ROLLOUT_PERCENTAGE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
