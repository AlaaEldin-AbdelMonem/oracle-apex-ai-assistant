--------------------------------------------------------
--  Constraints for Table LLM_INTENT_PROMPTS
--------------------------------------------------------

  ALTER TABLE "LLM_INTENT_PROMPTS" MODIFY ("PROMPT_ID" NOT NULL ENABLE);
  ALTER TABLE "LLM_INTENT_PROMPTS" ADD PRIMARY KEY ("PROMPT_ID")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
