--------------------------------------------------------
--  Ref Constraints for Table SEGMENT_USERS
--------------------------------------------------------

  ALTER TABLE "AI8P"."SEGMENT_USERS" ADD CONSTRAINT "SEGMENT_USERS_SEG_FK" FOREIGN KEY ("SEGMENT_ID")
	  REFERENCES "AI8P"."USER_SEGMENTS" ("SEGMENT_ID") ON DELETE CASCADE ENABLE;
