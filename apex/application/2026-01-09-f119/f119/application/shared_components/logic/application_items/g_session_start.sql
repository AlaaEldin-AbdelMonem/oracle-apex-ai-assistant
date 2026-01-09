prompt --application/shared_components/logic/application_items/g_session_start
begin
--   Manifest
--     APPLICATION ITEM: G_SESSION_START
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_flow_item(
 p_id=>wwv_flow_imp.id(123972192120705565)
,p_name=>'G_SESSION_START'
,p_scope=>'GLOBAL'
,p_protection_level=>'N'
,p_version_scn=>38947194620237
);
wwv_flow_imp.component_end;
end;
/
