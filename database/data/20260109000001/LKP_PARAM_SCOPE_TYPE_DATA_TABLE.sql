REM INSERTING into LKP_PARAM_SCOPE_TYPE
SET DEFINE OFF;
Insert into LKP_PARAM_SCOPE_TYPE (SCOPE_TYPE,DESCRIPTION) values ('TENANT','Tenant-level configuration');
Insert into LKP_PARAM_SCOPE_TYPE (SCOPE_TYPE,DESCRIPTION) values ('APP','Application-level configuration');
Insert into LKP_PARAM_SCOPE_TYPE (SCOPE_TYPE,DESCRIPTION) values ('ROLE','Role-based configuration');
Insert into LKP_PARAM_SCOPE_TYPE (SCOPE_TYPE,DESCRIPTION) values ('USER','User-level configuration');
Insert into LKP_PARAM_SCOPE_TYPE (SCOPE_TYPE,DESCRIPTION) values ('SESSION','Session-level configuration');
