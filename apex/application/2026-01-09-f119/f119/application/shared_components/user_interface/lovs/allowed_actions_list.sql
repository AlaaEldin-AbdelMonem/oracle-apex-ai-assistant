prompt --application/shared_components/user_interface/lovs/allowed_actions_list
begin
--   Manifest
--     ALLOWED ACTIONS LIST
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
 p_id=>wwv_flow_imp.id(124110398289209878)
,p_lov_name=>'ALLOWED ACTIONS LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT action_name  ,',
'       action_code  ',
'FROM lkp_access_action',
'ORDER BY action_id'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'ACTION_CODE'
,p_display_column_name=>'ACTION_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947437257564
);
wwv_flow_imp.component_end;
end;
/
