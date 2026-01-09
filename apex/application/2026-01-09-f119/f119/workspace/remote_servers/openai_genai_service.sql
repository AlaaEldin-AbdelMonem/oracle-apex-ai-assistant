prompt --workspace/remote_servers/openai_genai_service
begin
--   Manifest
--     REMOTE SERVER: OpenAI GenAI Service
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_imp_workspace.create_remote_server(
 p_id=>wwv_flow_imp.id(125616421973820021)
,p_name=>'OpenAI GenAI Service'
,p_static_id=>'EBA_GENAI_OPENAI'
,p_base_url=>nvl(wwv_flow_application_install.get_remote_server_base_url('EBA_GENAI_OPENAI'),'https://api.openai.com/v1')
,p_https_host=>nvl(wwv_flow_application_install.get_remote_server_https_host('EBA_GENAI_OPENAI'),'')
,p_server_type=>'GENERATIVE_AI'
,p_ords_timezone=>nvl(wwv_flow_application_install.get_remote_server_ords_tz('EBA_GENAI_OPENAI'),'')
,p_credential_id=>wwv_flow_imp.id(125616182939820021)
,p_remote_sql_default_schema=>nvl(wwv_flow_application_install.get_remote_server_default_db('EBA_GENAI_OPENAI'),'')
,p_mysql_sql_modes=>nvl(wwv_flow_application_install.get_remote_server_sql_mode('EBA_GENAI_OPENAI'),'')
,p_prompt_on_install=>false
,p_ai_provider_type=>'OPENAI'
,p_ai_is_builder_service=>false
,p_ai_model_name=>nvl(wwv_flow_application_install.get_remote_server_ai_model('EBA_GENAI_OPENAI'),'gpt-4o')
,p_ai_http_headers=>nvl(wwv_flow_application_install.get_remote_server_ai_headers('EBA_GENAI_OPENAI'),'')
,p_ai_attributes=>nvl(wwv_flow_application_install.get_remote_server_ai_attrs('EBA_GENAI_OPENAI'),'')
);
wwv_flow_imp.component_end;
end;
/
