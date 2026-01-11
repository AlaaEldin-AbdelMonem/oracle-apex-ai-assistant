--------------------------------------------------------
--  Ref Constraints for Table CONTEXT_DOMAIN_INSTRUCTIONS
--------------------------------------------------------

  ALTER TABLE "CONTEXT_DOMAIN_INSTRUCTIONS" ADD CONSTRAINT "FK_INSTRUCTION_MODE" FOREIGN KEY ("CONTEXT_DOMAIN_ID")
	  REFERENCES "CONTEXT_DOMAINS" ("CONTEXT_DOMAIN_ID") ENABLE;
