--------------------------------------------------------
--  DDL for Index UK_REGEN_PAIR
--------------------------------------------------------

  CREATE UNIQUE INDEX "UK_REGEN_PAIR" ON "CHAT_CALL_REGENERATIONS" ("PARENT_CHAT_CALL_ID", "CHILD_CHAT_CALL_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
