--------------------------------------------------------
--  Ref Constraints for Table HCM_SALARY
--------------------------------------------------------

  ALTER TABLE "HCM_SALARY" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
