--------------------------------------------------------
--  Ref Constraints for Table SEGMENT_USERS
--------------------------------------------------------

  ALTER TABLE "SEGMENT_USERS" ADD CONSTRAINT "SEGMENT_USERS_SEG_FK" FOREIGN KEY ("SEGMENT_ID")
	  REFERENCES "USER_SEGMENTS" ("SEGMENT_ID") ON DELETE CASCADE ENABLE;
