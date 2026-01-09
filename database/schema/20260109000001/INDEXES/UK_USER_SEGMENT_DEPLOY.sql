--------------------------------------------------------
--  DDL for Index UK_USER_SEGMENT_DEPLOY
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_USER_SEGMENT_DEPLOY" ON "AI8P"."USER_SEGMENT_ASSIGNMENTS" ("USER_ID", "SEGMENT_ID", "DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
