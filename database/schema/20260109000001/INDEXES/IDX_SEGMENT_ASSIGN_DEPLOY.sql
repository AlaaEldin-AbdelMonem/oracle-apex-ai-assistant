--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_DEPLOY
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_SEGMENT_ASSIGN_DEPLOY" ON "AI8P"."USER_SEGMENT_ASSIGNMENTS" ("DEPLOYMENT_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
