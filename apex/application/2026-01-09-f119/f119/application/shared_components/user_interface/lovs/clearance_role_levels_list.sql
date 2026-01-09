prompt --application/shared_components/user_interface/lovs/clearance_role_levels_list
begin
--   Manifest
--     CLEARANCE_ROLE_LEVELS LIST
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
 p_id=>wwv_flow_imp.id(141681599978262029)
,p_lov_name=>'CLEARANCE_ROLE_LEVELS LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select CLEARANCE_LEVEL return,',
'       CLEARANCE_CODE,',
'      UNICODE_ICON|| '' ''|| CLEARANCE_NAME display,',
'       DESCRIPTION,',
'       ICON_CSS_CLASS ',
'from "LKP_ROLE_CLEARANCE_LEVELS" a',
'',
' '))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN'
,p_display_column_name=>'DISPLAY'
,p_icon_column_name=>'ICON_CSS_CLASS'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947440188582
);
wwv_flow_imp.component_end;
end;
/
