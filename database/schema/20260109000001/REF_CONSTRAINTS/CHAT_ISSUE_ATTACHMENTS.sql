--------------------------------------------------------
--  Ref Constraints for Table CHAT_ISSUE_ATTACHMENTS
--------------------------------------------------------

  ALTER TABLE "CHAT_ISSUE_ATTACHMENTS" ADD CONSTRAINT "FK_ATTACHMENT_ISSUE" FOREIGN KEY ("CHAT_ISSUE_ID")
	  REFERENCES "CHAT_ISSUES" ("CHAT_ISSUE_ID") ON DELETE CASCADE ENABLE;
