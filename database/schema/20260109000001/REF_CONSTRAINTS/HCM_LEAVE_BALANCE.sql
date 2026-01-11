--------------------------------------------------------
--  Ref Constraints for Table HCM_LEAVE_BALANCE
--------------------------------------------------------

  ALTER TABLE "HCM_LEAVE_BALANCE" ADD FOREIGN KEY ("EMPLOYEE_ID")
	  REFERENCES "HCM_EMPLOYEE" ("EMPLOYEE_ID") ENABLE;
