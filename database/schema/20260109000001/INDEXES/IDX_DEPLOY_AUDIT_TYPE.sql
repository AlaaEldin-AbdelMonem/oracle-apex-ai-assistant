--------------------------------------------------------
--  DDL for Index IDX_DEPLOY_AUDIT_TYPE
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DEPLOY_AUDIT_TYPE" ON "AI8P"."DEPLOYMENT_AUDIT_LOG" ("EVENT_TYPE", "EVENT_TIMESTAMP" DESC) 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
