--------------------------------------------------------
--  Ref Constraints for Table LLM_PROVIDERS
--------------------------------------------------------

  ALTER TABLE "AI8P"."LLM_PROVIDERS" ADD CONSTRAINT "FK_PROVIDER_TO_HANDLER" FOREIGN KEY ("HANDLER_PACKAGE")
	  REFERENCES "AI8P"."LKP_REGISTERED_HANDLERS" ("HANDLER_PACKAGE") ENABLE;
