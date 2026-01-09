prompt --application/shared_components/user_interface/lovs/user_modules_db_pkgs
begin
--   Manifest
--     USER MODULES (DB PKGS)
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
 p_id=>wwv_flow_imp.id(142785128474004023)
,p_lov_name=>'USER MODULES (DB PKGS)'
,p_lov_query=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    object_name AS display,',
'    object_name AS returnx',
'FROM',
'    user_objects',
'WHERE',
'    object_type = ''PACKAGE''',
'ORDER BY',
'    object_name;'))
,p_source_type=>'SQL'
,p_location=>'LOCAL'
,p_query_owner=>'AI'
,p_return_column_name=>'RETURNX'
,p_display_column_name=>'DISPLAY'
,p_version_scn=>38947489158790
);
wwv_flow_imp.component_end;
end;
/
