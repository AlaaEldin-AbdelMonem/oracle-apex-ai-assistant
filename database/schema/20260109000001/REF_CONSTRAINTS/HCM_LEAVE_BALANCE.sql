--------------------------------------------------------
--  Ref Constraints for Table HCM_LEAVE_BALANCE
--------------------------------------------------------

  ALTER TABLE "AI8P"."HCM_LEAVE_BALANCE" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "AI8P"."HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
