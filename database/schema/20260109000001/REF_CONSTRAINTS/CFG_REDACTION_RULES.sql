--------------------------------------------------------
--  Ref Constraints for Table CFG_REDACTION_RULES
--------------------------------------------------------

  ALTER TABLE "AI8P"."CFG_REDACTION_RULES" ADD CONSTRAINT "CFG_REDACTION_RULES_FK1" FOREIGN KEY ("REDACTION_APPLY_PHASE_ID")
	  REFERENCES "AI8P"."LKP_REDACTION_APPLY_PHASE" ("APPLY_PHASE_ID") ENABLE;
