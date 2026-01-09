--------------------------------------------------------
--  Ref Constraints for Table XXXCFG_PARAM_AUDIT
--------------------------------------------------------

  ALTER TABLE "AI8P"."XXXCFG_PARAM_AUDIT" ADD CONSTRAINT "FK_AUDIT_PARAM" FOREIGN KEY ("PARAM_ID")
	  REFERENCES "AI8P"."CFG_PARAMETERS" ("PARAM_ID") ON DELETE CASCADE ENABLE;
