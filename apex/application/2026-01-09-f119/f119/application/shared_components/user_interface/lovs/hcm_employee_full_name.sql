prompt --application/shared_components/user_interface/lovs/hcm_employee_full_name
begin
--   Manifest
--     HCM_EMPLOYEE.FULL_NAME
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
 p_id=>wwv_flow_imp.id(124800669036508037)
,p_lov_name=>'HCM_EMPLOYEE.FULL_NAME'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'HCM_EMPLOYEE'
,p_return_column_name=>'EMPLOYEE_ID'
,p_display_column_name=>'FULL_NAME'
,p_default_sort_column_name=>'FULL_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38946763658729
);
wwv_flow_imp.component_end;
end;
/
