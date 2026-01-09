prompt --application/shared_components/user_interface/lovs/lov_llm_models
begin
--   Manifest
--     LOV_LLM_MODELS
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
 p_id=>wwv_flow_imp.id(144722697826346442)
,p_lov_name=>'LOV_LLM_MODELS'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT model_name AS display_value,',
'       model_code AS return_value',
'FROM llm_provider_models',
'WHERE provider_code = :P110_PROVIDER',
'  AND is_active = ''Y''',
'  AND is_embedding_model = ''N''',
'  AND is_production_ready = ''Y''',
'ORDER BY display_order;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURN_VALUE'
,p_display_column_name=>'DISPLAY_VALUE'
,p_version_scn=>38947574622817
);
wwv_flow_imp.component_end;
end;
/
