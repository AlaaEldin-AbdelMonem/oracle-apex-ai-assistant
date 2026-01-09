prompt --application/shared_components/user_interface/lovs/domain_scope_types_list_code
begin
--   Manifest
--     DOMAIN SCOPE TYPES LIST (CODE)
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
 p_id=>wwv_flow_imp.id(141772149084159315)
,p_lov_name=>'DOMAIN SCOPE TYPES LIST (CODE)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select -- DOMAIN_SCOPE_TYPE_ID,',
'       SCOPE_CODE as retrunx,',
'       SCOPE_NAME as display,',
'       SCOPE_DESCRIPTION,',
'       IS_ACTIVE',
'from "LKP_CONTEXT_DOMAIN_SCOPE_TYPE" a',
''))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETRUNX'
,p_display_column_name=>'DISPLAY'
,p_default_sort_column_name=>'DISPLAY'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947440948817
);
wwv_flow_imp.component_end;
end;
/
