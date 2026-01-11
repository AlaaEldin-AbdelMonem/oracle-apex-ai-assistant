--------------------------------------------------------
--  Ref Constraints for Table LLM_INTENT_PROMPTS
--------------------------------------------------------

  ALTER TABLE "LLM_INTENT_PROMPTS" ADD FOREIGN KEY ("DOMAIN_INTENT_ID")
	  REFERENCES "DOMAIN_INTENTS" ("DOMAIN_INTENT_ID") ENABLE;
