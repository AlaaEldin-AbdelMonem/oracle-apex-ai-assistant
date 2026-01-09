prompt --application/shared_components/user_interface/lovs/app_pages_current_session
begin
--   Manifest
--     APP_PAGES_CURRENT_SESSION
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
 p_id=>wwv_flow_imp.id(163957600564751563)
,p_lov_name=>'APP_PAGES_CURRENT_SESSION'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    application_id, ',
'    page_id, ',
'    page_name, ',
'    page_title',
'FROM apex_application_pages',
'WHERE application_id = v(''APP_ID'')  ',
'ORDER BY application_id, page_id;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'PAGE_ID'
,p_display_column_name=>'PAGE_NAME'
,p_version_scn=>38951393286982
);
wwv_flow_imp.component_end;
end;
/
