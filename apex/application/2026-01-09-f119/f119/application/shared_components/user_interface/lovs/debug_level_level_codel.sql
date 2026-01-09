prompt --application/shared_components/user_interface/lovs/debug_level_level_codel
begin
--   Manifest
--     DEBUG LEVEL (LEVEL CODEL)
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
 p_id=>wwv_flow_imp.id(142784049886952758)
,p_lov_name=>'DEBUG LEVEL (LEVEL CODEL)'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_DEBUG_LEVEL'
,p_return_column_name=>'LEVEL_CODE'
,p_display_column_name=>'LEVEL_NAME'
,p_default_sort_column_name=>'LEVEL_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947489021437
);
wwv_flow_imp.component_end;
end;
/
