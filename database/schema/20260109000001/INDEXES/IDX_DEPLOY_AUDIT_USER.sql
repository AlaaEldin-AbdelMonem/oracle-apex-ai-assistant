--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_USER
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_AUDIT_USER" ON "AI8P"."DEPLOYMENT_AUDIT_LOG" ("TRIGGERED_BY_USER_ID", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
