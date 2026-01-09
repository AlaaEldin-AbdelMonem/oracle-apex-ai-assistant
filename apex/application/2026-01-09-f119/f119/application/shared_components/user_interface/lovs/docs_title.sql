prompt --application/shared_components/user_interface/lovs/docs_title
begin
--   Manifest
--     DOCS.TITLE
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
 p_id=>wwv_flow_imp.id(124878841167551232)
,p_lov_name=>'DOCS.TITLE'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'DOCS'
,p_return_column_name=>'DOC_ID'
,p_display_column_name=>'DOC_TITLE'
,p_group_sort_direction=>'ASC'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947417812238
);
wwv_flow_imp.component_end;
end;
/
