prompt --application/shared_components/files/rangeslider_plugin_range_slider_css
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
wwv_flow_imp.g_varchar2_table(1) := '2E72616E67652D736C69646572207B0D0A202077696474683A20313030253B0D0A2020616363656E742D636F6C6F723A20766172282D2D75742D636F6C6F722D7072696D6172792C23633734363334293B0D0A7D0D0A0D0A2E736C696465722D76616C75';
wwv_flow_imp.g_varchar2_table(2) := '65207B0D0A2020746578742D616C69676E3A2072696768743B0D0A2020666F6E742D7765696768743A203630303B0D0A20206D617267696E2D746F703A203470783B0D0A2020636F6C6F723A20233064316232613B0D0A7D0D0A';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(131990387838471180)
,p_file_name=>'RANGESLIDER_PLUGIN/range-slider.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
