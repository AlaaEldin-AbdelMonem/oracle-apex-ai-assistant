prompt --application/shared_components/security/authentications/custom_authentication
begin
--   Manifest
--     AUTHENTICATION: Custom Authentication
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_authentication(
 p_id=>wwv_flow_imp.id(147184512221516461)
,p_name=>'Custom Authentication'
,p_scheme_type=>'NATIVE_CUSTOM'
,p_attribute_03=>'APP_SESSION_UTIL.authenticate_user'
,p_attribute_05=>'N'
,p_invalid_session_type=>'LOGIN'
,p_cookie_name=>'&WORKSPACE_COOKIE.'
,p_use_secure_cookie_yn=>'N'
,p_ras_mode=>0
,p_switch_in_session_yn=>'Y'
,p_version_scn=>38947682143170
);
wwv_flow_imp.component_end;
end;
/
