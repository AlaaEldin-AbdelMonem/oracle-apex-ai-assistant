--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_DEPLOY
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_AUDIT_DEPLOY" ON "AI8P"."DEPLOYMENT_AUDIT_LOG" ("DEPLOYMENT_ID", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
