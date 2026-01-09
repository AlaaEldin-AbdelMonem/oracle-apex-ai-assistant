--------------------------------------------------------
--  Ref Constraints for Table CFG_PARAM_OVERRIDES
--------------------------------------------------------

  ALTER TABLE "AI8P"."CFG_PARAM_OVERRIDES" ADD FOREIGN KEY ("PARAM_ID")
	  REFERENCES "AI8P"."CFG_PARAMETERS" ("PARAM_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "AI8P"."CFG_PARAM_OVERRIDES" ADD FOREIGN KEY ("SCOPE_TYPE")
	  REFERENCES "AI8P"."LKP_PARAM_SCOPE_TYPE" ("SCOPE_TYPE") ENABLE;
