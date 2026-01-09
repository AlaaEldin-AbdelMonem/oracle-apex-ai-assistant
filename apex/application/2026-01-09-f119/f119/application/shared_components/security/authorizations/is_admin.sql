prompt --application/shared_components/security/authorizations/is_admin
begin
--   Manifest
--     SECURITY SCHEME: IS_ADMIN
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
 p_id=>wwv_flow_imp.id(143295087385194865)
,p_name=>'IS_ADMIN'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>'RETURN app_admin_security.is_admin;'
,p_error_message=>'Sorry, You are not authorized to Access this page, It is for Admins Only'
,p_version_scn=>38947500298946
,p_caching=>'BY_USER_BY_SESSION'
);
wwv_flow_imp.component_end;
end;
/
