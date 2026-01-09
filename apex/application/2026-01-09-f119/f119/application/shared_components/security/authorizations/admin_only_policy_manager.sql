prompt --application/shared_components/security/authorizations/admin_only_policy_manager
begin
--   Manifest
--     SECURITY SCHEME: ADMIN_ONLY_POLICY_MANAGER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(124122524807463932)
,p_name=>'ADMIN_ONLY_POLICY_MANAGER'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'         v_count NUMBER;',
'     BEGIN',
'         SELECT COUNT(*)',
'         INTO v_count',
'         FROM user_roles ur ,  roles lr  , users u',
'         WHERE UPPER(u.user_name) = UPPER(:APP_USER)',
'         and  ur.role_id = lr.role_id',
'          and u.user_id = ur.user_id',
'           AND lr.role_code IN (''AIADMIN'', ''HR'');',
'         ',
'         RETURN (v_count > 0);',
'     EXCEPTION',
'         WHEN OTHERS THEN',
'             RETURN FALSE;',
'     END;'))
,p_error_message=>' Access Denied. Policy Manager is restricted to HR Administrators only.'
,p_version_scn=>38947175610112
,p_caching=>'BY_USER_BY_SESSION'
,p_comments=>'page 300'
);
wwv_flow_imp.component_end;
end;
/
