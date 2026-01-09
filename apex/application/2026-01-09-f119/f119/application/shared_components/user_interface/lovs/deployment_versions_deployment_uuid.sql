prompt --application/shared_components/user_interface/lovs/deployment_versions_deployment_uuid
begin
--   Manifest
--     DEPLOYMENT_VERSIONS.DEPLOYMENT_UUID
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
 p_id=>wwv_flow_imp.id(158715072133133443)
,p_lov_name=>'DEPLOYMENT_VERSIONS.DEPLOYMENT_UUID'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'DEPLOYMENT_VERSIONS'
,p_return_column_name=>'DEPLOYMENT_ID'
,p_display_column_name=>'DEPLOYMENT_UUID'
,p_default_sort_column_name=>'DEPLOYMENT_UUID'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38948182189540
);
wwv_flow_imp.component_end;
end;
/
