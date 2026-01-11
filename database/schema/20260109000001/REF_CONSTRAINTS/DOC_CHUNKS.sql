--------------------------------------------------------
--  Ref Constraints for Table DOC_CHUNKS
--------------------------------------------------------

  ALTER TABLE "DOC_CHUNKS" ADD CONSTRAINT "FK_RAG_CHUNKS_DOC" FOREIGN KEY ("DOC_ID")
	  REFERENCES "DOCS" ("DOC_ID") ON DELETE CASCADE ENABLE;
