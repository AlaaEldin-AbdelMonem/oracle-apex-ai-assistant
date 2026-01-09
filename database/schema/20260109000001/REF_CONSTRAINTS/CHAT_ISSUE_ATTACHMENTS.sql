--------------------------------------------------------
--  Ref Constraints for Table CHAT_ISSUE_ATTACHMENTS
--------------------------------------------------------

  ALTER TABLE "AI8P"."CHAT_ISSUE_ATTACHMENTS" ADD CONSTRAINT "FK_ATTACHMENT_ISSUE" FOREIGN KEY ("CHAT_ISSUE_ID")
	  REFERENCES "AI8P"."CHAT_ISSUES" ("CHAT_ISSUE_ID") ON DELETE CASCADE ENABLE;
