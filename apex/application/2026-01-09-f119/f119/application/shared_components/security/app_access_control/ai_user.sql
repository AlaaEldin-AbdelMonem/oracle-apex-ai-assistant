prompt --application/shared_components/security/app_access_control/ai_user
begin
--   Manifest
--     ACL ROLE: AI_USER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_acl_role(
 p_id=>wwv_flow_imp.id(145253725167333305)
,p_static_id=>'AI_USER'
,p_name=>'AI_USER'
,p_version_scn=>38947586990787
);
wwv_flow_imp.component_end;
end;
/
