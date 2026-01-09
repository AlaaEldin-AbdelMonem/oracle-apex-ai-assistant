--------------------------------------------------------
--  Ref Constraints for Table DOCS_STAGING
--------------------------------------------------------

  ALTER TABLE "AI8P"."DOCS_STAGING" ADD CONSTRAINT "FK_STAGING_DOC" FOREIGN KEY ("DOC_ID")
	  REFERENCES "AI8P"."DOCS" ("DOC_ID") ENABLE;
