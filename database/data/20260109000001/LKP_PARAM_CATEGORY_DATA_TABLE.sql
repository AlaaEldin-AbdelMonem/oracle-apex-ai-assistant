REM INSERTING into LKP_PARAM_CATEGORY
SET DEFINE OFF;
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('INT','Endpoints, API keys, connectors, and third-party integration toggles.','Integration Settings',4,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('PERF','Cache sizes, query limits, and runtime optimization flags.','Performance & Tuning',5,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('UI','User-facing settings like color themes, layouts, or language settings.','User Interface',6,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('BUZ','Tenant or domain-specific functional parameters and rules.','Business Logic',7,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('NTFT','Email, SMS, and in-app notification preferences and templates.','Notification & Alerts',8,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('AI','AI-driven automation, model thresholds, or embedding settings.','AI / ML Features',9,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('AUDIT','Logging levels, retention policies, and auditing configurations.','Audit & Logging',10,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('RAG_SEARCH','Configuration parameters for RAG vector search and retrieval','RAG Search Configuration',110,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('SYS','Core engine and system-wide behavior flags.','System Parameters',1,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('APP','App-level default values such as UI themes, pagination, or session timeout.','Application Defaults',2,'Y');
Insert into LKP_PARAM_CATEGORY (CATEGORY_CODE,DESCRIPTION,CATEGORY_NAME,DISPLAY_ORDER,IS_ACTIVE) values ('SEC','Parameters controlling authentication, password policy, data redaction, etc.','Security & Access',3,'Y');
