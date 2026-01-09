--------------------------------------------------------
--  DDL for Trigger ENT_AI_DOCS_METADATA_TRG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "AI8P"."ENT_AI_DOCS_METADATA_TRG" 
BEFORE INSERT OR UPDATE ON "DOCS"
FOR EACH ROW
BEGIN
    -- Auto-populate file metadata if BLOB is provided and metadata is missing
    IF :NEW.file_blob IS NOT NULL THEN

        -- Populate FILE_NAME if missing (use doc_title as fallback)
        IF :NEW.file_name IS NULL OR LENGTH(TRIM(:NEW.file_name)) = 0 THEN
            :NEW.file_name := COALESCE(:NEW.doc_title, 'document_' || :NEW.doc_id);
        END IF;

        -- Populate FILE_MIME_TYPE if missing
        IF :NEW.file_mime_type IS NULL THEN
            :NEW.file_mime_type := ent_ai_file_util.get_mime_type(:NEW.file_name);
        END IF;

        -- Populate FILE_SIZE if missing
        IF :NEW.file_size IS NULL OR :NEW.file_size = 0 THEN
            :NEW.file_size := ent_ai_file_util.get_blob_size(:NEW.file_blob);
        END IF;
    END IF;

    -- Ensure DOC_STATUS has default value
    IF :NEW.doc_status IS NULL OR LENGTH(TRIM(:NEW.doc_status)) = 0 THEN
        :NEW.doc_status := 'DRAFT';
    END IF;

    -- Ensure FILE_VERSION_NO has default value
    IF :NEW.file_version_no IS NULL THEN
        :NEW.file_version_no := 1;
    END IF;

    -- Auto-set CREATED_BY on INSERT
    IF INSERTING THEN
        IF :NEW.created_by IS NULL THEN
            :NEW.created_by := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
        END IF;
        IF :NEW.created_at IS NULL THEN
            :NEW.created_at := SYSTIMESTAMP;
        END IF;
    END IF;

    -- Auto-set UPDATED_BY on UPDATE
    IF UPDATING THEN
        :NEW.updated_at := SYSTIMESTAMP;
        :NEW.updated_by := COALESCE(SYS_CONTEXT('APEX$SESSION', 'APP_USER'), USER);
    END IF;

    -- Set RAG_READY_FLAG based on whether text is extracted
    IF :NEW.text_extracted IS NOT NULL AND DBMS_LOB.GETLENGTH(:NEW.text_extracted) > 0 THEN
        :NEW.rag_ready_flag := 'Y';
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        -- Log error but don't block the insert/update
        RAISE_APPLICATION_ERROR(-20002, 
            'Error in ent_ai_docs_metadata_trg: ' || SQLERRM);
END;
/
ALTER TRIGGER "AI8P"."ENT_AI_DOCS_METADATA_TRG" ENABLE;
