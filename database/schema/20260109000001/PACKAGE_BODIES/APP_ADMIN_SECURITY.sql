--------------------------------------------------------
--  DDL for Package Body APP_ADMIN_SECURITY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."APP_ADMIN_SECURITY" AS

FUNCTION is_admin RETURN BOOLEAN IS
    vcaller constant varchar2(70):= c_package_name ||'.get_mime_type'; 
    l_app_id   NUMBER;
    l_username VARCHAR2(200);
    l_dummy    NUMBER;
BEGIN
    l_app_id   := TO_NUMBER(NVL(V('APP_ID'),'0'));
    l_username := V('APP_USER');

    -- No user ⇒ no access
    IF l_username IS NULL THEN
        RETURN FALSE;
    END IF;

    BEGIN
        SELECT 1
          INTO l_dummy
          FROM app_admin_users
         WHERE is_active = 'Y'
           AND username  = l_username
           AND (app_id IS NULL OR app_id = l_app_id);

        RETURN TRUE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN FALSE;
    END;
END is_admin;

END app_admin_security;

/
