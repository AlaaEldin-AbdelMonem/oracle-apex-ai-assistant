prompt --application/shared_components/user_interface/lovs/app_list
begin
--   Manifest
--     APP LIST
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
 p_id=>wwv_flow_imp.id(142784952100993911)
,p_lov_name=>'APP LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    application_id,',
'    application_name,',
'    alias',
'FROM',
'    apex_applications',
'ORDER BY',
'    application_id;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'APPLICATION_ID'
,p_display_column_name=>'APPLICATION_NAME'
,p_version_scn=>38947489134408
);
wwv_flow_imp.component_end;
end;
/
