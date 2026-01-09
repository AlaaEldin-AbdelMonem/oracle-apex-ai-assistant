prompt --application/shared_components/user_interface/lovs/chat_project_session_by_userid
begin
--   Manifest
--     CHAT-PROJECT-SESSION-BY(USERID)
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(154738453991024728)
,p_lov_name=>'CHAT-PROJECT-SESSION-BY(USERID)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CHAT_PROJECT_ID,',
'       PROJECT_CODE,',
'       PROJECT_NAME,',
'       PROJECT_INSTRUCTIONS,',
'       IS_ACTIVE,',
'       TENANT_ID ',
'from  CHAT_PROJECTS  a ',
'where OWNER_USER_ID =v(''G_USER_ID'')',
'AND IS_DELETED=''N''',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_table=>'CHAT_PROJECTS'
,p_return_column_name=>'CHAT_PROJECT_ID'
,p_display_column_name=>'PROJECT_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PROJECT_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38948005411932
);
wwv_flow_imp.component_end;
end;
/
