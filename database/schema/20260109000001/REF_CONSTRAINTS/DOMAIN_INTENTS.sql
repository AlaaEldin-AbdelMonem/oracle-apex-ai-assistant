--------------------------------------------------------
--  Ref Constraints for Table DOMAIN_INTENTS
--------------------------------------------------------

  ALTER TABLE "DOMAIN_INTENTS" ADD FOREIGN KEY ("CONTEXT_DOMAIN_ID")
	  REFERENCES "CONTEXT_DOMAINS" ("CONTEXT_DOMAIN_ID") ENABLE;
  ALTER TABLE "DOMAIN_INTENTS" ADD FOREIGN KEY ("ACTION_TYPE_CODE")
	  REFERENCES "LKP_INTENT_ACTION_TYPE" ("ACTION_TYPE_CODE") ENABLE;
