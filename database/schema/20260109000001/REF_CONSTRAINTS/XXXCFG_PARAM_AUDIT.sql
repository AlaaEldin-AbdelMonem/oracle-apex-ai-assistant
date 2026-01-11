--------------------------------------------------------
--  Ref Constraints for Table XXXCFG_PARAM_AUDIT
--------------------------------------------------------

  ALTER TABLE "XXXCFG_PARAM_AUDIT" ADD CONSTRAINT "FK_AUDIT_PARAM" FOREIGN KEY ("PARAM_ID")
	  REFERENCES "CFG_PARAMETERS" ("PARAM_ID") ON DELETE CASCADE ENABLE;
