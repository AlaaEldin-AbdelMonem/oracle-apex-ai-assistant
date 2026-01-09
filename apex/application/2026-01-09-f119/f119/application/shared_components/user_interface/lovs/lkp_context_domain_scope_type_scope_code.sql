prompt --application/shared_components/user_interface/lovs/lkp_context_domain_scope_type_scope_code
begin
--   Manifest
--     LKP_CONTEXT_DOMAIN_SCOPE_TYPE.SCOPE_CODE
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
 p_id=>wwv_flow_imp.id(155718963601975591)
,p_lov_name=>'LKP_CONTEXT_DOMAIN_SCOPE_TYPE.SCOPE_CODE'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_CONTEXT_DOMAIN_SCOPE_TYPE'
,p_return_column_name=>'SCOPE_CODE'
,p_default_sort_column_name=>'SCOPE_CODE'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38948052626018
);
wwv_flow_imp.component_end;
end;
/
