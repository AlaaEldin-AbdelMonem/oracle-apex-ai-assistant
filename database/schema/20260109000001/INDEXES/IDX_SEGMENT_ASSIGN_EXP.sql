--------------------------------------------------------
--  DDL for Index IDX_SEGMENT_ASSIGN_EXP
--------------------------------------------------------

  CREATE INDEX "IDX_SEGMENT_ASSIGN_EXP" ON "USER_SEGMENT_ASSIGNMENTS" ("EXPERIMENT_ID", "IS_ACTIVE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
