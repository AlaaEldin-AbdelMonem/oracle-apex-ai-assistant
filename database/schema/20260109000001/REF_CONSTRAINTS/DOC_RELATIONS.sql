--------------------------------------------------------
--  Ref Constraints for Table DOC_RELATIONS
--------------------------------------------------------

  ALTER TABLE "AI8P"."DOC_RELATIONS" ADD FOREIGN KEY ("PARENT_DOC_ID")
	  REFERENCES "AI8P"."DOCS" ("DOC_ID") ON DELETE CASCADE ENABLE;
  ALTER TABLE "AI8P"."DOC_RELATIONS" ADD FOREIGN KEY ("CHILD_DOC_ID")
	  REFERENCES "AI8P"."DOCS" ("DOC_ID") ON DELETE CASCADE ENABLE;
