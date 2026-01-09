prompt --application/pages/page_00600
begin
--   Manifest
--     PAGE: 00600
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_page.create_page(
 p_id=>600
,p_name=>'Document Dashboard'
,p_alias=>'DOCUMENT-DASHBOARD'
,p_step_title=>'Document Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'27'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125439594405652007)
,p_plug_name=>'Summary Cards'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>3371237801798025892
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'       COUNT(*) as value,',
'       ''Total Documents'' as label,',
'       ''fa fa-file-text'' as icon,',
'       ''u-color-1'' as color_class',
'   FROM docs',
'   union all',
'    SELECT ',
'       COUNT(*) as value,',
'       ''RAG Ready'' as label,',
'       ''fa fa-check-circle'' as icon,',
'       ''u-color-9'' as color_class',
'   FROM docs',
'   WHERE rag_ready_flag = ''Y''',
'   union all',
'    SELECT ',
'       NVL(SUM(embedding_count), 0) as value,',
'       ''Total Chunks'' as label,',
'       ''fa fa-cubes'' as icon,',
'       ''u-color-5'' as color_class',
'   FROM docs',
'   union all ',
'   SELECT ',
'       COUNT(*) as value,',
'       ''Pending'' as label,',
'       ''fa fa-clock-o'' as icon,',
'       ''u-color-14'' as color_class',
'   FROM docs',
'   WHERE rag_ready_flag = ''N''',
'     AND text_extracted IS NOT NULL'))
,p_template_component_type=>'REPORT'
,p_lazy_loading=>false
,p_plug_source_type=>'TMPL_THEME_42$BADGE'
,p_plug_query_num_rows=>15
,p_plug_query_num_rows_type=>'SET'
,p_show_total_row_count=>false
,p_landmark_type=>'region'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'ICON', '&ICON.',
  'LABEL', '&LABEL.',
  'LABEL_DISPLAY', 'Y',
  'SHAPE', 't-Badge--circle',
  'SIZE', 't-Badge--lg',
  'STATE', 'COLOR_CLASS',
  'VALUE', 'VALUE')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125440796738652019)
,p_name=>'VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VALUE'
,p_data_type=>'NUMBER'
,p_display_sequence=>10
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125440851247652020)
,p_name=>'LABEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LABEL'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>20
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125440976059652021)
,p_name=>'ICON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ICON'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>30
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125441070687652022)
,p_name=>'COLOR_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COLOR_CLASS'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>40
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161679419728437934)
,p_plug_name=>'cnt'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125441394775652025)
,p_plug_name=>'Chunking Strategy Distribution'
,p_parent_plug_id=>wwv_flow_imp.id(161679419728437934)
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>4
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'   SELECT ',
'       NVL(s.strategy_name, ''Not Processed'') as label,',
'       COUNT(d.doc_id) as value',
'   FROM lkp_chunking_strategy s',
'   LEFT JOIN docs d ON d.last_chunking_strategy = s.strategy_code',
'   WHERE s.is_active = ''Y''',
'   GROUP BY s.strategy_name',
'   ORDER BY COUNT(d.doc_id) DESC'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(125441464871652026)
,p_region_id=>wwv_flow_imp.id(125441394775652025)
,p_chart_type=>'donut'
,p_height=>'300'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hide_and_show_behavior=>'withRescale'
,p_hover_behavior=>'dim'
,p_value_format_type=>'decimal'
,p_value_decimal_places=>0
,p_value_format_scaling=>'none'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_value=>true
,p_legend_rendered=>'on'
,p_legend_title=>'Chunking Strategy Distribution'
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(125441574999652027)
,p_chart_id=>wwv_flow_imp.id(125441464871652026)
,p_seq=>10
,p_name=>'Chunking Strategy Distribution'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(125441895349652030)
,p_name=>'Recent Chunking Activity'
,p_parent_plug_id=>wwv_flow_imp.id(161679419728437934)
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_new_grid_row=>false
,p_grid_column_span=>6
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT d.doc_id,',
'       d.doc_title,',
'       c.category_name,',
'       s.strategy_name,',
'       d.embedding_count as chunks,',
'       TO_CHAR(d.last_chunked_at, ''DD-MON-YYYY HH24:MI'') as processed_at,',
'       d.created_by',
'   FROM docs d',
'   LEFT JOIN lkp_doc_category c ON c.category_code = d.doc_category',
'   LEFT JOIN lkp_chunking_strategy s ON s.strategy_code = d.last_chunking_strategy',
'   WHERE d.last_chunked_at IS NOT NULL',
'   ORDER BY d.last_chunked_at DESC',
'   FETCH FIRST 10 ROWS ONLY'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442564351652037)
,p_query_column_id=>1
,p_column_alias=>'DOC_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Doc Id'
,p_column_link=>'f?p=&APP_ID.:630:&SESSION.::&DEBUG.:630:P630_DOC_ID:#DOC_ID#'
,p_column_linktext=>'#DOC_ID#'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125441975983652031)
,p_query_column_id=>2
,p_column_alias=>'DOC_TITLE'
,p_column_display_sequence=>20
,p_column_heading=>'Doc Title'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442004713652032)
,p_query_column_id=>3
,p_column_alias=>'CATEGORY_NAME'
,p_column_display_sequence=>30
,p_column_heading=>'Category Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442111611652033)
,p_query_column_id=>4
,p_column_alias=>'STRATEGY_NAME'
,p_column_display_sequence=>40
,p_column_heading=>'Strategy Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442222277652034)
,p_query_column_id=>5
,p_column_alias=>'CHUNKS'
,p_column_display_sequence=>50
,p_column_heading=>'Chunks'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442364631652035)
,p_query_column_id=>6
,p_column_alias=>'PROCESSED_AT'
,p_column_display_sequence=>60
,p_column_heading=>'Processed At'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125442470720652036)
,p_query_column_id=>7
,p_column_alias=>'CREATED_BY'
,p_column_display_sequence=>70
,p_column_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125442786411652039)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(125441895349652030)
,p_button_name=>'UPLOAD_NEW'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Upload New Document'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:620:&SESSION.::&DEBUG.:620::'
,p_icon_css_classes=>'fa-cloud-upload'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125442897919652040)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(125441895349652030)
,p_button_name=>'VIEW_ALL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'View All Documents'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:610:&SESSION.::&DEBUG.:610::'
,p_icon_css_classes=>'fa-list'
);
wwv_flow_imp.component_end;
end;
/
