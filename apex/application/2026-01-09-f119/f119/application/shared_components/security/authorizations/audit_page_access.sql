prompt --application/shared_components/security/authorizations/audit_page_access
begin
--   Manifest
--     SECURITY SCHEME: AUDIT_PAGE_ACCESS
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
 p_id=>wwv_flow_imp.id(124057368318858339)
,p_name=>'AUDIT_PAGE_ACCESS'
,p_scheme_type=>'NATIVE_EXISTS'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  1',
'FROM user_roles ur ,roles lr , users u',
'WHERE',
'  u.user_id= ur.user_id ',
'and u.user_name = :APP_USER',
'and ur.role_id = lr.role_id',
'  AND lr.role_name  IN (''AIADMIN'', ''AUD'')'))
,p_error_message=>'Access Restricted: Only authorized auditors and administrators can view audit traces.'
,p_version_scn=>38947175599640
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_imp.component_end;
end;
/
