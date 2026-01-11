--------------------------------------------------------
--  Ref Constraints for Table ROLES
--------------------------------------------------------

  ALTER TABLE "ROLES" ADD CONSTRAINT "ROLES_FK1" FOREIGN KEY ("CLEARANCE_LEVEL")
	  REFERENCES "LKP_ROLE_CLEARANCE_LEVELS" ("CLEARANCE_LEVEL") ENABLE;
