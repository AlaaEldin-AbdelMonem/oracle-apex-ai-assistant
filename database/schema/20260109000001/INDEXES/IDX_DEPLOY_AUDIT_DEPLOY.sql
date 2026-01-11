--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_DEPLOY
--------------------------------------------------------

  CREATE INDEX "IDX_DEPLOY_AUDIT_DEPLOY" ON "DEPLOYMENT_AUDIT_LOG" ("DEPLOYMENT_ID", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
