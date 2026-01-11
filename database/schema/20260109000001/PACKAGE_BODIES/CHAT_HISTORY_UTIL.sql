--------------------------------------------------------
--  DDL for Package Body CHAT_HISTORY_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHAT_HISTORY_UTIL" AS
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_user_role_code(p_user_id IN VARCHAR2) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_user_role_code';
        v_role_code VARCHAR2(50);
    BEGIN
        SELECT r.role_code
        INTO v_role_code
        FROM user_roles ur,roles r , users u
        WHERE u.user_name = p_user_id  
        AND u.user_id = ur.user_id
        AND ur.role_id = r.role_id
        AND ROWNUM = 1;

        RETURN v_role_code;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'EMP';
    END get_user_role_code;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION can_view_all_logs(p_user_id IN VARCHAR2) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.can_view_all_logs';
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM user_roles ur, roles r, users u
        WHERE u.user_name = p_user_id
        AND ur.user_id = u.user_id
        AND ur.role_id = r.role_id
        AND r.role_code IN ('HR', 'AIADMIN', 'AUD');

        RETURN v_count > 0;
    END can_view_all_logs;
 /*******************************************************************************
 *  
 *******************************************************************************/
  PROCEDURE get_model_list(p_models OUT SYS_REFCURSOR) IS
   vcaller constant varchar2(70):= c_package_name ||'.get_model_list';

BEGIN
    OPEN p_models FOR
        SELECT DISTINCT model_name AS d, model_name AS r
        FROM LLM_PROVIDER_MODELS
        WHERE model_name IS NOT NULL
        ORDER BY model_name;
END get_model_list;
 

END chat_history_util;

/
