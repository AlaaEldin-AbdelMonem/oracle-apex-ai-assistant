--------------------------------------------------------
--  DDL for Index UK_DEPLOYMENT_VER_UUID
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_DEPLOYMENT_VER_UUID" ON "AI8P"."DEPLOYMENT_VERSIONS" ("DEPLOYMENT_UUID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
