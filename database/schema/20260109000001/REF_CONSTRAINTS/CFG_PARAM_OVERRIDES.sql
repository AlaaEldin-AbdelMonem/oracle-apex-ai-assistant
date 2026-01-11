--------------------------------------------------------
--  Ref Constraints for Table CFG_PARAM_OVERRIDES
--------------------------------------------------------

  ALTER TABLE "CFG_PARAM_OVERRIDES" ADD FOREIGN KEY ("PARAM_ID")
	  REFERENCES "CFG_PARAMETERS" ("PARAM_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "CFG_PARAM_OVERRIDES" ADD FOREIGN KEY ("SCOPE_TYPE")
	  REFERENCES "LKP_PARAM_SCOPE_TYPE" ("SCOPE_TYPE") ENABLE;
