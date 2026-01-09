--------------------------------------------------------
--  Ref Constraints for Table HCM_SALARY
--------------------------------------------------------

  ALTER TABLE "AI8P"."HCM_SALARY" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "AI8P"."HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
