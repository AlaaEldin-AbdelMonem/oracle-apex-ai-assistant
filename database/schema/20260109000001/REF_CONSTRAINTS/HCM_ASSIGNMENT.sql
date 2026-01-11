--------------------------------------------------------
--  Ref Constraints for Table HCM_ASSIGNMENT
--------------------------------------------------------

  ALTER TABLE "HCM_ASSIGNMENT" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
