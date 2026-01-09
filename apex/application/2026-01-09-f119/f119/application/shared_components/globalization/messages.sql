prompt --application/shared_components/globalization/messages
begin
--   Manifest
--     MESSAGES: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_message(
 p_id=>wwv_flow_imp.id(124122931931468804)
,p_name=>'POLICY_MANAGER_ACCESS_DENIED'
,p_message_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('\26A0\FE0F Access Denied'),
'       ',
'       You do not have permission to access the Policy Manager.',
'       This page is restricted to HR Administrators and AI Governance Admins.',
'       ',
'       Please contact your system administrator if you require access.'))
,p_comment=>'for page 300'
,p_version_scn=>38946753678022
);
wwv_flow_imp.component_end;
end;
/
