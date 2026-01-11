--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_TYPE
--------------------------------------------------------

  CREATE INDEX "IDX_DEPLOY_AUDIT_TYPE" ON "DEPLOYMENT_AUDIT_LOG" ("EVENT_TYPE", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
