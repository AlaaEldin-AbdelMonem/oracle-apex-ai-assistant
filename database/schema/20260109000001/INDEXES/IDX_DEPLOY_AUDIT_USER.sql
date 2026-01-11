--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_USER
--------------------------------------------------------

  CREATE INDEX "IDX_DEPLOY_AUDIT_USER" ON "DEPLOYMENT_AUDIT_LOG" ("TRIGGERED_BY_USER_ID", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
