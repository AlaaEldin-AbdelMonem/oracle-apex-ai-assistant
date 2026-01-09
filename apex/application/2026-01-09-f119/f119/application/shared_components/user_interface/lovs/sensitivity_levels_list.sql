prompt --application/shared_components/user_interface/lovs/sensitivity_levels_list
begin
--   Manifest
--     SENSITIVITY LEVELS LIST
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
 p_id=>wwv_flow_imp.id(125482126216396534)
,p_lov_name=>'SENSITIVITY LEVELS LIST'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  UNICODE_ICON||  '' '' || SENSITIVITY_NAME as display_value, ',
'SENSITIVITY_LEVEL return_value,',
'SENSITIVITY_CODE, DESCRIPTION,IS_ACTIVE,ICON_CSS_CLASS ',
'from "LKP_REGISTRY_SENSITIVITY_LEVELS" a'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_icon_column_name=>'ICON_CSS_CLASS'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947433833317
);
wwv_flow_imp.component_end;
end;
/
