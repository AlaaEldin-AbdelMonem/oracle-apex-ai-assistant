prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 119
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(123960129859486144)
,p_group_name=>'Administration'
);
wwv_flow_imp.component_end;
end;
/
