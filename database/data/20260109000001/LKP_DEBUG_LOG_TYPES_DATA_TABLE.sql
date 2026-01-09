REM INSERTING into LKP_DEBUG_LOG_TYPES
SET DEFINE OFF;
Insert into LKP_DEBUG_LOG_TYPES (LOG_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR,SORT_ORDER) values ('FLOW','📍 Flow','\D83D\DCCD','Breadcrumbs for tracing code execution.','u-color-1',1);
Insert into LKP_DEBUG_LOG_TYPES (LOG_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR,SORT_ORDER) values ('USER','👤 User','\D83D\DC64','Friendly messages intended for end-users.','u-color-3',3);
Insert into LKP_DEBUG_LOG_TYPES (LOG_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR,SORT_ORDER) values ('TECH','⚙ Tech','\2699','Technical details and system errors.','u-color-2',2);
Insert into LKP_DEBUG_LOG_TYPES (LOG_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR,SORT_ORDER) values ('TIME','⏱ Time','\23F1','Performance metrics and durations.','u-color-4',4);
Insert into LKP_DEBUG_LOG_TYPES (LOG_TYPE_CODE,DISPLAY_NAME,ICON_HEX,DESCRIPTION,UI_COLOR,SORT_ORDER) values ('SEC','🛡 Sec','\D83D\DEE1','Security and authorization events.','u-color-5',5);
