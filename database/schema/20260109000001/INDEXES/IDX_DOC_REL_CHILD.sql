--------------------------------------------------------
--  DDL for Index IDX_DOC_REL_CHILD
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DOC_REL_CHILD" ON "AI8P"."DOC_RELATIONS" ("CHILD_DOC_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
