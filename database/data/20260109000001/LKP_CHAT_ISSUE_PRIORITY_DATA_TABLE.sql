REM INSERTING into LKP_CHAT_ISSUE_PRIORITY
SET DEFINE OFF;
Insert into LKP_CHAT_ISSUE_PRIORITY (CHAT_ISSUE_PRIORITY_CODE,PRIORITY_NAME,DESCRIPTION,IS_ACTIVE) values ('CR','🔴 Critical','System failure or complete inability to use chat.','Y');
Insert into LKP_CHAT_ISSUE_PRIORITY (CHAT_ISSUE_PRIORITY_CODE,PRIORITY_NAME,DESCRIPTION,IS_ACTIVE) values ('LO','🔵 Low','Minor issue; no impact on core chat functionality.','Y');
Insert into LKP_CHAT_ISSUE_PRIORITY (CHAT_ISSUE_PRIORITY_CODE,PRIORITY_NAME,DESCRIPTION,IS_ACTIVE) values ('ME','🟡 Medium','Functional glitch; workaround available.','Y');
Insert into LKP_CHAT_ISSUE_PRIORITY (CHAT_ISSUE_PRIORITY_CODE,PRIORITY_NAME,DESCRIPTION,IS_ACTIVE) values ('HI','🟠 High','Significant problem affecting user experience.','Y');
