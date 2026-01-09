prompt --application/shared_components/files/rangeslider_plugin_range_slider_min_js
begin
--   Manifest
--     APP STATIC FILES: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2166756E6374696F6E286E297B6E2E52616E6765536C696465723D7B696E69743A66756E6374696F6E286E297B636F6E737420743D646F63756D656E742E676574456C656D656E7442794964286E292C653D646F63756D656E742E676574456C656D656E';
wwv_flow_imp.g_varchar2_table(2) := '7442794964286E2B225F76616C22293B742626652626742E6164644576656E744C697374656E65722822696E707574222C2828293D3E652E74657874436F6E74656E743D742E76616C756529297D7D7D2877696E646F77293B';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(131990035539467803)
,p_file_name=>'RANGESLIDER_PLUGIN/range-slider.min.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
