--------------------------------------------------------
--  DDL for Trigger TRG_AUDIT_LLM_PROVIDERS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TRIGGER "TRG_AUDIT_LLM_PROVIDERS" 
AFTER UPDATE ON LLM_PROVIDERS
FOR EACH ROW
DECLARE
    v_old_data CLOB;
    v_new_data CLOB;
    v_msg      VARCHAR2(4000);
BEGIN
    -- 1. Construct JSON-like strings for the audit trail
    v_old_data := '{"package": "'|| :OLD.HANDLER_PACKAGE ||'", "active": "'|| :OLD.IS_ACTIVE ||'", "default": "'|| :OLD.IS_DEFAULT ||'"}';
    v_new_data := '{"package": "'|| :NEW.HANDLER_PACKAGE ||'", "active": "'|| :NEW.IS_ACTIVE ||'", "default": "'|| :NEW.IS_DEFAULT ||'"}';

    -- 2. Define a clear audit message
    v_msg := 'Configuration updated for provider: ' || :NEW.PROVIDER_CODE;

    -- 3. Log to the Permanent Audit Table (CONF Tier)
    audit_util.log_data_change(
        p_event_code => 'SYS_CFG', -- Secondary Category: Config Change
        p_message    => v_msg,
        p_old_data   => v_old_data,
        p_new_data   => v_new_data,
        p_caller     => 'TRIGGER.TRG_AUDIT_LLM_PROVIDERS'
    );
END;
/
ALTER TRIGGER "TRG_AUDIT_LLM_PROVIDERS" ENABLE;
