prompt --application/shared_components/user_interface/lovs/lov_llm_providers
begin
--   Manifest
--     LOV_LLM_PROVIDERS
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
 p_id=>wwv_flow_imp.id(144722457248343192)
,p_lov_name=>'LOV_LLM_PROVIDERS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT provider_name AS display_value,',
'       provider_code AS return_value',
'FROM llm_providers',
'WHERE is_active = ''Y''',
'ORDER BY display_order;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_version_scn=>38947574616272
);
wwv_flow_imp.component_end;
end;
/
