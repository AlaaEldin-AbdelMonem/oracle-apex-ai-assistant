--------------------------------------------------------
--  DDL for Index UK_REGEN_PAIR
--------------------------------------------------------

  CREATE UNIQUE INDEX "AI8P"."UK_REGEN_PAIR" ON "AI8P"."CHAT_CALL_REGENERATIONS" ("PARENT_CHAT_CALL_ID", "CHILD_CHAT_CALL_ID") 
  PCTFREE 10 INITRANS 20 MAXTRANS 255 COMPUTE STATISTICS ;
