prompt --application/shared_components/user_interface/lovs/chat_issue_status
begin
--   Manifest
--     CHAT_ISSUE_STATUS
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
 p_id=>wwv_flow_imp.id(160955045819327024)
,p_lov_name=>'CHAT_ISSUE_STATUS'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_CHAT_ISSUE_STATUS'
,p_query_where=>'is_Active=''Y'''
,p_return_column_name=>'CHAT_ISSUE_STATUS_CODE'
,p_display_column_name=>'ISSUE_STATUS'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'ISSUE_STATUS'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38948267020769
);
wwv_flow_imp.component_end;
end;
/
