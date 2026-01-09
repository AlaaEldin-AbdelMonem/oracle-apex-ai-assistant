prompt --application/shared_components/user_interface/lovs/yes_no_3
begin
--   Manifest
--     YES_NO (3)
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
 p_id=>wwv_flow_imp.id(141689693115487954)
,p_lov_name=>'YES_NO (3)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''Y'' return_value, ''\D83D\DFE2 Yes'' display_value FROM dual'),
'UNION ALL',
unistr('SELECT ''N'' return_value, ''\D83D\DD34 No'' display_value FROM dual;')))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_default_sort_column_name=>'DISPLAY_VALUE'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947433988958
);
wwv_flow_imp.component_end;
end;
/
