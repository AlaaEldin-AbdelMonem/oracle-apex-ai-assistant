--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_VER_EXPERIMENT
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_VER_EXPERIMENT" ON "AI8P"."DEPLOYMENT_VERSIONS" ("EXPERIMENT_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
