--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_SEGMENT
--------------------------------------------------------

  CREATE INDEX "IDX_SEGMENT_ASSIGN_SEGMENT" ON "USER_SEGMENT_ASSIGNMENTS" ("SEGMENT_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
