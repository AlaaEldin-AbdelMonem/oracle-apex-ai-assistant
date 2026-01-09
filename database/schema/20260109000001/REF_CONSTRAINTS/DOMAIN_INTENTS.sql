--------------------------------------------------------
--  Ref Constraints for Table DOMAIN_INTENTS
--------------------------------------------------------

  ALTER TABLE "AI8P"."DOMAIN_INTENTS" ADD FOREIGN KEY ("CONTEXT_DOMAIN_ID")
	  REFERENCES "AI8P"."CONTEXT_DOMAINS" ("CONTEXT_DOMAIN_ID") ENABLE;
  ALTER TABLE "AI8P"."DOMAIN_INTENTS" ADD FOREIGN KEY ("ACTION_TYPE_CODE")
	  REFERENCES "AI8P"."LKP_INTENT_ACTION_TYPE" ("ACTION_TYPE_CODE") ENABLE;
