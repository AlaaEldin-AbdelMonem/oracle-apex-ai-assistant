--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_EXP
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_SEGMENT_ASSIGN_EXP" ON "AI8P"."USER_SEGMENT_ASSIGNMENTS" ("EXPERIMENT_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
