prompt --application/create_application
begin
--   Manifest
--     FLOW: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_imp_workspace.create_flow(
 p_id=>wwv_flow.g_flow_id
,p_owner=>nvl(wwv_flow_application_install.get_schema,'AI8P')
,p_name=>nvl(wwv_flow_application_install.get_application_name,'Enterprise Chatpot')
,p_alias=>nvl(wwv_flow_application_install.get_application_alias,'ENTERPRISE-CHATPOT')
,p_page_view_logging=>'YES'
,p_page_protection_enabled_y_n=>'Y'
,p_checksum_salt=>'EF164E3B6101F8B4F66B1C6A523E6ED07B2E61025F5F513AF60FD9E1EC2F44FE'
,p_bookmark_checksum_function=>'SH512'
,p_compatibility_mode=>'24.2'
,p_flow_language=>'en'
,p_flow_language_derived_from=>'FLOW_PRIMARY_LANGUAGE'
,p_allow_feedback_yn=>'Y'
,p_date_format=>'DS'
,p_timestamp_format=>'DS'
,p_timestamp_tz_format=>'DS'
,p_flow_image_prefix => nvl(wwv_flow_application_install.get_image_prefix,'')
,p_authentication_id=>wwv_flow_imp.id(147184512221516461)
,p_application_tab_set=>0
,p_logo_type=>'T'
,p_logo_text=>'Enterprise Chatpot'
,p_public_user=>'APEX_PUBLIC_USER'
,p_proxy_server=>nvl(wwv_flow_application_install.get_proxy,'')
,p_no_proxy_domains=>nvl(wwv_flow_application_install.get_no_proxy_domains,'')
,p_flow_version=>'Release 1.0'
,p_flow_status=>'AVAILABLE_W_EDIT_LINK'
,p_flow_unavailable_text=>'This application is currently unavailable at this time.'
,p_exact_substitutions_only=>'Y'
,p_browser_cache=>'N'
,p_browser_frame=>'D'
,p_runtime_api_usage=>'T'
,p_rejoin_existing_sessions=>'N'
,p_csv_encoding=>'Y'
,p_auto_time_zone=>'N'
,p_substitution_string_01=>'APP_NAME'
,p_substitution_value_01=>'Enterprise Chatpot'
,p_file_prefix => nvl(wwv_flow_application_install.get_static_app_file_prefix,'')
,p_files_version=>62
,p_version_scn=>38951771172486
,p_print_server_type=>'NATIVE'
,p_file_storage=>'DB'
,p_is_pwa=>'Y'
,p_pwa_is_installable=>'N'
,p_pwa_is_push_enabled=>'N'
,p_ai_remote_server_id=>wwv_flow_imp.id(125616421973820021)
,p_ai_consent_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Enter a consent message for the use of the selected AI Service.',
'',
'The Consent Message you define displays to the user the first time they access the AI Service. The user must agree with the message before they interact with the AI. The user''s choice is stored as a preference so they are only prompted once.',
'',
'You can also use the APEX_AI package to programmatically set or clear user consent.'))
);
wwv_flow_imp.component_end;
end;
/
