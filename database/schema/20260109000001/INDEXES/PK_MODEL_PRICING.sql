--------------------------------------------------------
--  DDL for Index PK_MODEL_PRICING
--------------------------------------------------------

  CREATE UNIQUE INDEX "PK_MODEL_PRICING" ON "AI_MODEL_PRICING" ("PROVIDER", "MODEL_NAME") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 ;
