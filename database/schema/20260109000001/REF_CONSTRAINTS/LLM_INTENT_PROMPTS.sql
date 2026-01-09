--------------------------------------------------------
--  Ref Constraints for Table LLM_INTENT_PROMPTS
--------------------------------------------------------

  ALTER TABLE "AI8P"."LLM_INTENT_PROMPTS" ADD FOREIGN KEY ("DOMAIN_INTENT_ID")
	  REFERENCES "AI8P"."DOMAIN_INTENTS" ("DOMAIN_INTENT_ID") ENABLE;
