--------------------------------------------------------
--  DDL for Index IDX_DOC_REL_PARENT
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_DOC_REL_PARENT" ON "AI8P"."DOC_RELATIONS" ("PARENT_DOC_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
