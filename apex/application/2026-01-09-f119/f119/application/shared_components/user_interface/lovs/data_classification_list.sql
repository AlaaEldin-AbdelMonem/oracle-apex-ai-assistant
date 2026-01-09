prompt --application/shared_components/user_interface/lovs/data_classification_list
begin
--   Manifest
--     DATA CLASSIFICATION LIST
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
 p_id=>wwv_flow_imp.id(124094819518184644)
,p_lov_name=>'DATA CLASSIFICATION LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    UNICODE_ICON || '' '' || DESCRIPTION AS DISPLAY_VALUE,',
'    CLASSIFICATION_ID AS RETURN_VALUE',
'FROM LKP_DATA_CLASSIFICATION',
'ORDER BY CLASSIFICATION_LEVEL;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_table=>'LKP_DATA_CLASSIFICATION'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947436634974
);
wwv_flow_imp.component_end;
end;
/
