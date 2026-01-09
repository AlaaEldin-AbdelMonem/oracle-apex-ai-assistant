--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_VER_TYPE_STATUS
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_VER_TYPE_STATUS" ON "AI8P"."DEPLOYMENT_VERSIONS" ("DEPLOYMENT_TYPE", "DEPLOYMENT_STATUS", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
