--------------------------------------------------------
--  DDL for Index IDX_DOC_REL_PARENT
--------------------------------------------------------

  CREATE INDEX "IDX_DOC_REL_PARENT" ON "DOC_RELATIONS" ("PARENT_DOC_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
