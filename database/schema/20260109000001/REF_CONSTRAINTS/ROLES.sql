--------------------------------------------------------
--  Ref Constraints for Table ROLES
--------------------------------------------------------

  ALTER TABLE "AI8P"."ROLES" ADD CONSTRAINT "ROLES_FK1" FOREIGN KEY ("CLEARANCE_LEVEL")
	  REFERENCES "AI8P"."LKP_ROLE_CLEARANCE_LEVELS" ("CLEARANCE_LEVEL") ENABLE;
