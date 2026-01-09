--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_USER
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_SEGMENT_ASSIGN_USER" ON "AI8P"."USER_SEGMENT_ASSIGNMENTS" ("USER_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
