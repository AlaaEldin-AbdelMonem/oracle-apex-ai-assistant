prompt --application/shared_components/user_interface/lovs/data_classification_code_list
begin
--   Manifest
--     DATA_CLASSIFICATION-CODE-LIST
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
 p_id=>wwv_flow_imp.id(141022543036429558)
,p_lov_name=>'DATA_CLASSIFICATION-CODE-LIST'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_DATA_CLASSIFICATION'
,p_query_where=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    UNICODE_ICON || '' '' || CLASSIFICATION_NAME AS DISPLAY_VALUE,',
'    CLASSIFICATION_CODE  AS RETURN_VALUE',
'FROM LKP_DATA_CLASSIFICATION',
'ORDER BY CLASSIFICATION_LEVEL;'))
,p_return_column_name=>'CLASSIFICATION_LEVEL'
,p_display_column_name=>'CLASSIFICATION_CODE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CLASSIFICATION_CODE'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947436608472
);
wwv_flow_imp.component_end;
end;
/
