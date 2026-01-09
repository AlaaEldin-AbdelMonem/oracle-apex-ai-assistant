REM INSERTING into LKP_TEST_CATEGORY
SET DEFINE OFF;
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('INFRASTRUCTURE','Infrastructure Tests','Database objects, schemas, and system setup',10,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('DATA','Data Validation Tests','Data integrity, relationships, and constraints',20,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('RAG','RAG Functionality Tests','Document chunking, embedding, and search',30,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('SECURITY','Security Tests','Access control, RLS, redaction, and authentication',40,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('PERFORMANCE','Performance Tests','Query performance, load testing, and optimization',50,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('INTEGRATION','Integration Tests','EBS integration, LLM connectivity, and API tests',60,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('AUDIT','Audit  Tests','Audit logging, compliance, and governance',70,'Y');
Insert into LKP_TEST_CATEGORY (CATEGORY_CODE,CATEGORY_NAME,CATEGORY_DESCRIPTION,DISPLAY_ORDER,IS_ACTIVE) values ('UI','APEX UI Tests','User interface, workflows, and APEX functionality',80,'Y');
