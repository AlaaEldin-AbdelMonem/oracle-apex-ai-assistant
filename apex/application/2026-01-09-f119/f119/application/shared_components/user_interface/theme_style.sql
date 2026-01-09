prompt --application/shared_components/user_interface/theme_style
begin
--   Manifest
--     THEME STYLE: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_theme_style(
 p_id=>wwv_flow_imp.id(141665759721161616)
,p_theme_id=>42
,p_name=>'Vita (copy_1)'
,p_is_public=>true
,p_is_accessible=>true
,p_theme_roller_input_file_urls=>'#THEME_FILES#less/theme/Vita.less'
,p_theme_roller_config=>'{"classes":[],"vars":{},"customCSS":"/* Sets the root font size to 16px */\nhtml {\n    font-size: 100% !important; \n}","useCustomLess":"N"}'
,p_theme_roller_output_file_url=>'#THEME_DB_FILES#141665759721161616.css'
,p_theme_roller_read_only=>false
);
wwv_flow_imp.component_end;
end;
/
