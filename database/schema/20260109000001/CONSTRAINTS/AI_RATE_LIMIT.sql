--------------------------------------------------------
--  Constraints for Table AI_RATE_LIMIT
--------------------------------------------------------

  ALTER TABLE "AI_RATE_LIMIT" ADD PRIMARY KEY ("USER_ID", "REQUEST_HOUR")
  USING INDEX PCTFREE 10 INITRANS 20 MAXTRANS 255  ENABLE;
