prompt --application/shared_components/user_interface/lovs/llm_providers_code_active
begin
--   Manifest
--     LLM_PROVIDERS(CODE)-ACTIVE
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
 p_id=>wwv_flow_imp.id(142748082094460762)
,p_lov_name=>'LLM_PROVIDERS(CODE)-ACTIVE'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROVIDER_ID,',
'       PROVIDER_CODE,',
'       PROVIDER_NAME,',
'       DESCRIPTION,',
'       IS_DEFAULT,',
'       PRIORITY_LEVEL,',
'       DISPLAY_ORDER',
'from "LLM_PROVIDERS" a',
'Where  IS_ACTIVE= ''Y''',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'PROVIDER_CODE'
,p_display_column_name=>'PROVIDER_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'PROVIDER_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947485381655
);
wwv_flow_imp.component_end;
end;
/
