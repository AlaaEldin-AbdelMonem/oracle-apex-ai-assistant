prompt --application/shared_components/user_interface/lovs/lkp_context_domain_categories_category_code
begin
--   Manifest
--     LKP_CONTEXT_DOMAIN_CATEGORIES.CATEGORY_CODE
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
 p_id=>wwv_flow_imp.id(140966433950402822)
,p_lov_name=>'LKP_CONTEXT_DOMAIN_CATEGORIES.CATEGORY_CODE'
,p_source_type=>'TABLE'
,p_location=>'LOCAL'
,p_query_table=>'LKP_CONTEXT_DOMAIN_CATEGORIES'
,p_return_column_name=>'CONTEXT_DOMAIN_CATEGORY_ID'
,p_display_column_name=>'CATEGORY_NAME'
,p_group_sort_direction=>'ASC'
,p_default_sort_column_name=>'CATEGORY_CODE'
,p_default_sort_direction=>'ASC'
,p_version_scn=>38947437252358
);
wwv_flow_imp.component_end;
end;
/
