--------------------------------------------------------
--  DDL for Index UK_EXPERIMENT_NAME
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_EXPERIMENT_NAME" ON "AI8P"."DEPLOYMENT_EXPERIMENTS" ("EXPERIMENT_NAME") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
