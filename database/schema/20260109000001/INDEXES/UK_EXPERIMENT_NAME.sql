--------------------------------------------------------
--  DDL for Index UK_EXPERIMENT_NAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "UK_EXPERIMENT_NAME" ON "DEPLOYMENT_EXPERIMENTS" ("EXPERIMENT_NAME") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
