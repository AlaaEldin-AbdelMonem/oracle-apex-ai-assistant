prompt --application/shared_components/user_interface/lovs/app_pages_all
begin
--   Manifest
--     APP_PAGES_ALL
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
 p_id=>wwv_flow_imp.id(163957443930745159)
,p_lov_name=>'APP_PAGES_ALL'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    application_id, ',
'    application_name,',
'    page_id, ',
'    page_name, ',
'    page_title',
'FROM apex_application_pages',
' ORDER BY application_id, page_id;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38951393308691
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(163959044866757710)
,p_query_column_name=>'PAGE_ID'
,p_display_sequence=>10
,p_data_type=>'NUMBER'
,p_is_visible=>'N'
,p_is_searchable=>'N'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(163958671066757709)
,p_query_column_name=>'PAGE_NAME'
,p_heading=>'Page Name'
,p_display_sequence=>20
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp_shared.create_list_of_values_cols(
 p_id=>wwv_flow_imp.id(163958211006757707)
,p_query_column_name=>'APPLICATION_NAME'
,p_heading=>'Application Name'
,p_display_sequence=>30
,p_data_type=>'VARCHAR2'
);
wwv_flow_imp.component_end;
end;
/
