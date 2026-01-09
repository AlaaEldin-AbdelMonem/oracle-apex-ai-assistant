--------------------------------------------------------
--  DDL for Index IDX_CFG_OVERRIDE_CTX
--------------------------------------------------------

  CREATE INDEX "AI8P"."IDX_CFG_OVERRIDE_CTX" ON "AI8P"."CFG_PARAM_OVERRIDES" ("TENANT_ID", "APP_ID", "PARAM_ID", "SCOPE_TYPE", "SCOPE_VALUE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
