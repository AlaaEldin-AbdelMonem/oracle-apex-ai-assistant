--------------------------------------------------------
--  DDL for Index UK_DEPLOYMENT_VER_NAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_DEPLOYMENT_VER_NAME" ON "AI8P"."DEPLOYMENT_VERSIONS" ("DEPLOYMENT_NAME") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
