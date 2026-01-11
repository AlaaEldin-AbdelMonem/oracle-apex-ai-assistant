--------------------------------------------------------
--  DDL for Index IDX_DOC_REL_CHILD
--------------------------------------------------------

  CREATE INDEX "IDX_DOC_REL_CHILD" ON "DOC_RELATIONS" ("CHILD_DOC_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
