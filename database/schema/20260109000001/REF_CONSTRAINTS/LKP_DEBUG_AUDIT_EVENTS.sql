--------------------------------------------------------
--  Ref Constraints for Table LKP_DEBUG_AUDIT_EVENTS
--------------------------------------------------------

  ALTER TABLE "LKP_DEBUG_AUDIT_EVENTS" ADD CONSTRAINT "FK_LKP_EVENT_TO_TYPE" FOREIGN KEY ("EVENT_TYPE_CODE")
	  REFERENCES "LKP_DEBUG_AUDIT_EVENT_TYPES" ("AUDIT_EVENT_TYPE_CODE") ENABLE;
