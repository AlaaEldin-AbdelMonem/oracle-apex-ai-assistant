--------------------------------------------------------
--  Ref Constraints for Table USER_ROLES
--------------------------------------------------------

  ALTER TABLE "USER_ROLES" ADD CONSTRAINT "USER_ROLES_FK2" FOREIGN KEY ("USER_ID")
	  REFERENCES "USERS" ("USER_ID") ENABLE;
  ALTER TABLE "USER_ROLES" ADD CONSTRAINT "USER_ROLES_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "ROLES" ("ROLE_ID") ENABLE;
