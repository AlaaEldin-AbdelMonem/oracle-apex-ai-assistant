--------------------------------------------------------
--  DDL for Index UK_USER_SEGMENT_DEPLOY
--------------------------------------------------------

  CREATE UNIQUE INDEX "UK_USER_SEGMENT_DEPLOY" ON "USER_SEGMENT_ASSIGNMENTS" ("USER_ID", "SEGMENT_ID", "DEPLOYMENT_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
