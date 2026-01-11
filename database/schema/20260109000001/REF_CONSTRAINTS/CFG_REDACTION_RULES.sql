--------------------------------------------------------
--  Ref Constraints for Table CFG_REDACTION_RULES
--------------------------------------------------------

  ALTER TABLE "CFG_REDACTION_RULES" ADD CONSTRAINT "CFG_REDACTION_RULES_FK1" FOREIGN KEY ("REDACTION_APPLY_PHASE_ID")
	  REFERENCES "LKP_REDACTION_APPLY_PHASE" ("APPLY_PHASE_ID") ENABLE;
