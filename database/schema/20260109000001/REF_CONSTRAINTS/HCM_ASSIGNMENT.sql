--------------------------------------------------------
--  Ref Constraints for Table HCM_ASSIGNMENT
--------------------------------------------------------

  ALTER TABLE "AI8P"."HCM_ASSIGNMENT" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "AI8P"."HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
