--------------------------------------------------------
--  DDL for Index UK_DEPLOYMENT_VER_UUID
--------------------------------------------------------

  CREATE UNIQUE INDEX "UK_DEPLOYMENT_VER_UUID" ON "DEPLOYMENT_VERSIONS" ("DEPLOYMENT_UUID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
