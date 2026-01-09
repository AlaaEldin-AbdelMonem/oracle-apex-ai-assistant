prompt --application/shared_components/logic/build_options
begin
--   Manifest
--     BUILD OPTIONS: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(123954063565486069)
,p_build_option_name=>'Commented Out'
,p_build_option_status=>'EXCLUDE'
,p_version_scn=>38946746791129
);
wwv_flow_imp_shared.create_build_option(
 p_id=>wwv_flow_imp.id(157640184699345808)
,p_build_option_name=>'Feature: Theme Style Selection'
,p_build_option_status=>'INCLUDE'
,p_version_scn=>38948141441348
,p_feature_identifier=>'APPLICATION_THEME_STYLE_SELECTION'
,p_build_option_comment=>'Allow administrators to select a default color scheme (theme style) for the application. Administrators can also choose to allow end users to choose their own theme style. '
);
wwv_flow_imp.component_end;
end;
/
