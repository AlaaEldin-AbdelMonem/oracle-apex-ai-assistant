--------------------------------------------------------
--  DDL for Trigger TRG_LKP_CHUNK_STRAT_AUDIT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_LKP_CHUNK_STRAT_AUDIT" 
BEFORE UPDATE ON lkp_chunking_strategy
FOR EACH ROW
BEGIN
    :NEW.updated_by := COALESCE(v('APP_USER'), USER);
    :NEW.updated_at := SYSTIMESTAMP;
END;
/
ALTER TRIGGER "TRG_LKP_CHUNK_STRAT_AUDIT" ENABLE;
