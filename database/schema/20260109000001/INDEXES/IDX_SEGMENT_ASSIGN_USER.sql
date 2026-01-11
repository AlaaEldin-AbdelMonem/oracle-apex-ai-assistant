--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_USER
--------------------------------------------------------

  CREATE INDEX "IDX_SEGMENT_ASSIGN_USER" ON "USER_SEGMENT_ASSIGNMENTS" ("USER_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
