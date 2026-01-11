--------------------------------------------------------
--  DDL for Index IDX_CFG_OVERRIDE_CTX
--------------------------------------------------------

  CREATE INDEX "IDX_CFG_OVERRIDE_CTX" ON "CFG_PARAM_OVERRIDES" ("TENANT_ID", "APP_ID", "PARAM_ID", "SCOPE_TYPE", "SCOPE_VALUE") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
