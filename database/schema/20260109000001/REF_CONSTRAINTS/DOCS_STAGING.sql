--------------------------------------------------------
--  Ref Constraints for Table DOCS_STAGING
--------------------------------------------------------

  ALTER TABLE "DOCS_STAGING" ADD CONSTRAINT "FK_STAGING_DOC" FOREIGN KEY ("DOC_ID")
	  REFERENCES "DOCS" ("DOC_ID") ENABLE;
