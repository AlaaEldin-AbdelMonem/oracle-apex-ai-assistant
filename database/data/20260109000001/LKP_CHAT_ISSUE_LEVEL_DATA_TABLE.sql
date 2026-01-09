REM INSERTING into LKP_CHAT_ISSUE_LEVEL
SET DEFINE OFF;
Insert into LKP_CHAT_ISSUE_LEVEL (ISSUE_LEVEL_CODE,LEVEL_NAME,DESCRIPTION,IS_ACTIVE) values ('MESSAGE','💬 Message Level','Issue relates to a specific text bubble or attachment.','Y');
Insert into LKP_CHAT_ISSUE_LEVEL (ISSUE_LEVEL_CODE,LEVEL_NAME,DESCRIPTION,IS_ACTIVE) values ('SESSION','📱 Session Level','Issue relates to the entire chat connection or user experience.','Y');
