prompt --application/shared_components/user_interface/lovs/context_domains_id
begin
--   Manifest
--     CONTEXT_DOMAINS(ID)
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
 p_id=>wwv_flow_imp.id(152757137945460727)
,p_lov_name=>'CONTEXT_DOMAINS(ID)'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'CONTEXT_DOMAINS'
,p_return_column_name=>'CONTEXT_DOMAIN_ID'
,p_display_column_name=>'DOMAIN_NAME'
,p_default_sort_column_name=>'DOMAIN_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947905551353
);
wwv_flow_imp.component_end;
end;
/
