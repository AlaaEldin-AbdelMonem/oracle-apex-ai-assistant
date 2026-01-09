--------------------------------------------------------
--  Ref Constraints for Table USER_ROLES
--------------------------------------------------------

  ALTER TABLE "AI8P"."USER_ROLES" ADD CONSTRAINT "USER_ROLES_FK2" FOREIGN KEY ("USER_ID")
	  REFERENCES "AI8P"."USERS" ("USER_ID") ENABLE;
  ALTER TABLE "AI8P"."USER_ROLES" ADD CONSTRAINT "USER_ROLES_FK1" FOREIGN KEY ("ROLE_ID")
	  REFERENCES "AI8P"."ROLES" ("ROLE_ID") ENABLE;
