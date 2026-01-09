prompt --application/shared_components/files/rangeslider_plugin_range_slider_js
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
wwv_flow_imp.g_varchar2_table(1) := '2866756E6374696F6E2877696E646F77297B0D0A202077696E646F772E52616E6765536C69646572203D207B0D0A20202020696E69743A2066756E6374696F6E286964297B0D0A202020202020636F6E737420656C203D20646F63756D656E742E676574';
wwv_flow_imp.g_varchar2_table(2) := '456C656D656E7442794964286964293B0D0A202020202020636F6E73742076616C203D20646F63756D656E742E676574456C656D656E7442794964286964202B20225F76616C22293B0D0A20202020202069662821656C207C7C202176616C2920726574';
wwv_flow_imp.g_varchar2_table(3) := '75726E3B0D0A202020202020656C2E6164644576656E744C697374656E65722822696E707574222C2028293D3E2076616C2E74657874436F6E74656E74203D20656C2E76616C7565293B0D0A202020207D0D0A20207D3B0D0A7D292877696E646F77293B';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(131988240968464794)
,p_file_name=>'RANGESLIDER_PLUGIN/range-slider.js'
,p_mime_type=>'text/javascript'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
