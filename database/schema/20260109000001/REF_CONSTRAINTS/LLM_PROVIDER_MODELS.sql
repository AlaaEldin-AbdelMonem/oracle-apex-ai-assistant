--------------------------------------------------------
--  Ref Constraints for Table LLM_PROVIDER_MODELS
--------------------------------------------------------

  ALTER TABLE "AI8P"."LLM_PROVIDER_MODELS" ADD CONSTRAINT "FK_REPLACEMENT_MODEL" FOREIGN KEY ("REPLACEMENT_MODEL_ID")
	  REFERENCES "AI8P"."LLM_PROVIDER_MODELS" ("PROVIDER_MODEL_ID") ENABLE;
