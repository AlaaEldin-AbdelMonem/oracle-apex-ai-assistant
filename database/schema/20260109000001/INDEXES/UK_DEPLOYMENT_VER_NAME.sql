--------------------------------------------------------
--  DDL for Index UK_DEPLOYMENT_VER_NAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "UK_DEPLOYMENT_VER_NAME" ON "DEPLOYMENT_VERSIONS" ("DEPLOYMENT_NAME") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
