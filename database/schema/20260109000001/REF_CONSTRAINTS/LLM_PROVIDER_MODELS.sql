--------------------------------------------------------
--  Ref Constraints for Table LLM_PROVIDER_MODELS
--------------------------------------------------------

  ALTER TABLE "LLM_PROVIDER_MODELS" ADD CONSTRAINT "FK_REPLACEMENT_MODEL" FOREIGN KEY ("REPLACEMENT_MODEL_ID")
	  REFERENCES "LLM_PROVIDER_MODELS" ("PROVIDER_MODEL_ID") ENABLE;
