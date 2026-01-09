prompt --application/shared_components/user_interface/lovs/unified_task_list_lov_due
begin
--   Manifest
--     UNIFIED_TASK_LIST.LOV.DUE
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
 p_id=>wwv_flow_imp.id(128089382545978487)
,p_lov_name=>'UNIFIED_TASK_LIST.LOV.DUE'
,p_lov_query=>'.'||wwv_flow_imp.id(128089382545978487)||'.'
,p_location=>'STATIC'
,p_version_scn=>38946886083772
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128089661854978488)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Overdue'
,p_lov_return_value=>'|0'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128090057975978491)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'Next hour'
,p_lov_return_value=>'0|1'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128090475516978492)
,p_lov_disp_sequence=>3
,p_lov_disp_value=>'Next 24 hours'
,p_lov_return_value=>'1|24'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128090894151978493)
,p_lov_disp_sequence=>4
,p_lov_disp_value=>'Next 7 days'
,p_lov_return_value=>'24|168'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128091240465978494)
,p_lov_disp_sequence=>5
,p_lov_disp_value=>'Next 30 days'
,p_lov_return_value=>'168|720'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(128091640867978495)
,p_lov_disp_sequence=>6
,p_lov_disp_value=>'More than 30 days'
,p_lov_return_value=>'720|'
);
wwv_flow_imp.component_end;
end;
/
