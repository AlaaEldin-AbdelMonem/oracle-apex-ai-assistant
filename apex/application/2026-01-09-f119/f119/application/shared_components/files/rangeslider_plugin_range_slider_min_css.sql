prompt --application/shared_components/files/rangeslider_plugin_range_slider_min_css
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
wwv_flow_imp.g_varchar2_table(1) := '2E72616E67652D736C69646572207B77696474683A20313030253B616363656E742D636F6C6F723A20766172282D2D75742D636F6C6F722D7072696D6172792C23633734363334293B7D2E736C696465722D76616C7565207B746578742D616C69676E3A';
wwv_flow_imp.g_varchar2_table(2) := '2072696768743B666F6E742D7765696768743A203630303B6D617267696E2D746F703A203470783B636F6C6F723A20233064316232613B7D';
wwv_flow_imp_shared.create_app_static_file(
 p_id=>wwv_flow_imp.id(131991366252472582)
,p_file_name=>'RANGESLIDER_PLUGIN/range-slider.min.css'
,p_mime_type=>'text/css'
,p_file_charset=>'utf-8'
,p_file_content => wwv_flow_imp.varchar2_to_blob(wwv_flow_imp.g_varchar2_table)
);
wwv_flow_imp.component_end;
end;
/
