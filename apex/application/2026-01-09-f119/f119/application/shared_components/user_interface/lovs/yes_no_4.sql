prompt --application/shared_components/user_interface/lovs/yes_no_4
begin
--   Manifest
--     YES_NO (4)
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
 p_id=>wwv_flow_imp.id(141689860723500268)
,p_lov_name=>'YES_NO (4)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''Y'' return_name,''\2611 Yes'' display  FROM dual'),
'UNION ALL',
unistr('SELECT ''N'' return_name ,''\2610 No'' display FROM dual;')))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_NAME'
,p_display_column_name=>'DISPLAY'
,p_default_sort_column_name=>'DISPLAY'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947434015732
);
wwv_flow_imp.component_end;
end;
/
