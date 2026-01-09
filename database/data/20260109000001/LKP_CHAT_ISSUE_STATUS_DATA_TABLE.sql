REM INSERTING into LKP_CHAT_ISSUE_STATUS
SET DEFINE OFF;
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('AS','👤 Assigned','A support agent has been assigned to handle the request.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('IP','⚙️ In Progress','The issue is actively being investigated or worked on.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('PU','⏳ Pending User Response','Waiting for the customer to provide additional information.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('RS','✅ Resolved','A solution has been provided and is awaiting user confirmation.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('CL','🔒 Closed','The issue is completed and no further action is required.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('RO','🔄 Reopened','A previously resolved or closed issue has been flagged as still active.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('NW','📩 New','The initial state when a chat issue is created and awaiting review.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('PT','🤝 Pending Third Party','Waiting for a response from an external vendor or partner.','Y');
Insert into LKP_CHAT_ISSUE_STATUS (CHAT_ISSUE_STATUS_CODE,ISSUE_STATUS,DESCRIPTION,IS_ACTIVE) values ('CA','🚫 Cancelled','The request was withdrawn or deemed invalid.','Y');
