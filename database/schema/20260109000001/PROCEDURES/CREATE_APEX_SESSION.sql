--------------------------------------------------------
--  DDL for Procedure CREATE_APEX_SESSION
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "CREATE_APEX_SESSION" 
as
/*******************************************************************************
 *  
 *******************************************************************************/
  l_app_id   NUMBER := 119; -- Replace with your APEX application ID
  l_page_id  NUMBER := 100;   -- Replace with the desired page ID for the session context
  l_username VARCHAR2(255) := 'AI'; -- Replace with the username for the session
BEGIN
    APEX_SESSION.CREATE_SESSION (
    p_app_id   => l_app_id,
    p_page_id  => l_page_id,
    p_username => l_username,
    p_call_post_authentication=> FALSE
  );
  APEX_UTIL.SET_SESSION_STATE('G_USER_ID', '4');
  APEX_UTIL.SET_SESSION_STATE('G_CHAT_PROJECT_ID', '0');
  APEX_UTIL.SET_SESSION_STATE('G_TENANT_ID', '1');
  APEX_UTIL.SET_SESSION_STATE('G_TENANT_CODE', 'TEST_TENANT');
  APEX_UTIL.SET_SESSION_STATE('G_TENANT_NAME', 'Test Tenant');
  APEX_UTIL.SET_SESSION_STATE('G_ALL_USER_ROLES', '');
  APEX_UTIL.SET_SESSION_STATE('G_USER_ROLE_ID', '');
  APEX_UTIL.SET_SESSION_STATE('G_USER_ROLE_NAME', '');
  APEX_UTIL.SET_SESSION_STATE('G_CLASSIFICATION_LEVEL', '');
  APEX_UTIL.SET_SESSION_STATE('G_SESSION_START', '');
commit;
end "CREATE_APEX_SESSION";

/
