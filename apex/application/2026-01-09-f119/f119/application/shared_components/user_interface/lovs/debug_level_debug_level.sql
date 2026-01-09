prompt --application/shared_components/user_interface/lovs/debug_level_debug_level
begin
--   Manifest
--     DEBUG LEVEL (DEBUG_LEVEL)
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
 p_id=>wwv_flow_imp.id(142783886284945216)
,p_lov_name=>'DEBUG LEVEL (DEBUG_LEVEL)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select debug_level return_Val,',
' Level_Name ||'' (''||debug_level||'')'' display_value',
'  from LKP_DEBUG_LEVEL'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VAL'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'RETURN_VAL'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38951386510986
);
wwv_flow_imp.component_end;
end;
/
