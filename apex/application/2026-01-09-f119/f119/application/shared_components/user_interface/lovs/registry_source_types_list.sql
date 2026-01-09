prompt --application/shared_components/user_interface/lovs/registry_source_types_list
begin
--   Manifest
--     REGISTRY_SOURCE_TYPES LIST
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
 p_id=>wwv_flow_imp.id(141021442957429555)
,p_lov_name=>'REGISTRY_SOURCE_TYPES LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'   UNICODE_ICON || '' '' || NAME AS DISPLAY_VALUE,',
'    CONTEXT_REGISTRY_SOURCE_TYPE_CODE AS RETURN_VALUE',
'FROM LKP_CONTEXT_REGISTRY_SOURCE_TYPES',
' '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_table=>'LKP_CONTEXT_REGISTRY_SOURCE_TYPES'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947434484650
);
wwv_flow_imp.component_end;
end;
/
