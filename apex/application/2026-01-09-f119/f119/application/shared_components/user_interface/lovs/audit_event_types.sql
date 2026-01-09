prompt --application/shared_components/user_interface/lovs/audit_event_types
begin
--   Manifest
--     AUDIT_EVENT_TYPES
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(164484289796540923)
,p_lov_name=>'AUDIT_EVENT_TYPES'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_DEBUG_AUDIT_EVENT_TYPES'
,p_return_column_name=>'AUDIT_EVENT_TYPE_CODE'
,p_display_column_name=>'DISPLAY_NAME'
,p_default_sort_column_name=>'DISPLAY_NAME'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38951415303848
);
wwv_flow_imp.component_end;
end;
/
