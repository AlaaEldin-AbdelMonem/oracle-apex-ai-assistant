prompt --application/shared_components/user_interface/lovs/error_severity_type_list
begin
--   Manifest
--     ERROR SEVERITY TYPE LIST
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
 p_id=>wwv_flow_imp.id(141702400117512509)
,p_lov_name=>'ERROR SEVERITY TYPE LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT ',
'    UNICODE_ICON || '' '' || SEVERITY_NAME AS DISPLAY_VALUE,',
'    SEVERITY_CODE AS RETURN_VALUE',
'FROM LKP_ERROR_SEVERITY',
'WHERE IS_ACTIVE = ''Y''',
'ORDER BY SEVERITY_LEVEL;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_version_scn=>38947436794272
);
wwv_flow_imp.component_end;
end;
/
