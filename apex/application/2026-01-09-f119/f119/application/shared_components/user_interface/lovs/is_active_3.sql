prompt --application/shared_components/user_interface/lovs/is_active_3
begin
--   Manifest
--     IS_ACTIVE_3
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
 p_id=>wwv_flow_imp.id(124597466510100787)
,p_lov_name=>'IS_ACTIVE_3'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''\D83C\DFF3\FE0F All''          AS display_value,        NULL AS return_value  FROM dual'),
'UNION ALL',
unistr('SELECT ''\D83D\DFE9 Active Only''  AS display_value,  ''Y''  AS return_value  FROM dual '),
'UNION ALL',
unistr('SELECT ''\D83D\DFE5 Inactive Only'' AS display_value , ''N'' AS return_value  FROM dual'),
' '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947437241765
);
wwv_flow_imp.component_end;
end;
/
