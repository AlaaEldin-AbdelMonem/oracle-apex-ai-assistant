REM INSERTING into LKP_DEBUG_AUDIT_EVENT_TYPES
SET DEFINE OFF;
Insert into LKP_DEBUG_AUDIT_EVENT_TYPES (AUDIT_EVENT_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR) values ('SEC','🛡️ Security','\D83D\DEE1','Critical for compliance. Logs logins, access denials, and permission changes.','u-color-1');
Insert into LKP_DEBUG_AUDIT_EVENT_TYPES (AUDIT_EVENT_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR) values ('EVNT','📅 Event','\D83D\DCC5','Success tracking. Logs when a business process completes successfully (e.g. Order Paid).','u-color-2');
Insert into LKP_DEBUG_AUDIT_EVENT_TYPES (AUDIT_EVENT_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR) values ('FAIL','⚠️ Failure','\26A0','Performance tracking. Logs when a process fails due to business/external logic (e.g. LLM Timeout).','u-danger');
Insert into LKP_DEBUG_AUDIT_EVENT_TYPES (AUDIT_EVENT_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR) values ('DATA','📝 Data','\D83D\DCDD','Forensic tracking. Logs changes to sensitive data fields or record deletions.','u-color-3');
Insert into LKP_DEBUG_AUDIT_EVENT_TYPES (AUDIT_EVENT_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR) values ('CONF','⚙️ Configuration','\2699','Change management. Logs changes to system settings, parameters, or debug levels.','u-color-4');
