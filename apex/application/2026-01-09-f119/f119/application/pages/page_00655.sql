prompt --application/pages/page_00655
begin
--   Manifest
--     PAGE: 00655
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
 p_id=>655
,p_name=>'Chunking Analytics'
,p_alias=>'CHUNKING-ANALYTICS'
,p_step_title=>'Chunking Analytics'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125710209333557129)
,p_plug_name=>'Strategy Performance Metrics'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
' s.strategy_name,',
' COUNT(DISTINCT d.doc_id) as total_documents,',
' SUM(d.embedding_count) as total_chunks,',
' ROUND(AVG(d.embedding_count), 1) as avg_chunks_per_doc,',
' MIN(d.embedding_count) as min_chunks,',
' MAX(d.embedding_count) as max_chunks,',
' s.relative_speed || ''x'' as speed,',
' s.storage_overhead || ''x'' as storage,',
' s.semantic_preservation as quality',
'FROM docs d',
'JOIN lkp_chunking_strategy s ON s.strategy_code = d.last_chunking_strategy',
'WHERE d.rag_ready_flag = ''Y''',
'GROUP BY ',
' s.strategy_name, ',
' s.relative_speed, ',
' s.storage_overhead, ',
' s.semantic_preservation',
'ORDER BY COUNT(DISTINCT d.doc_id) DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(125710360348557130)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'AI'
,p_internal_uid=>125710360348557130
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710402564557131)
,p_db_column_name=>'STRATEGY_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Strategy Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710546334557132)
,p_db_column_name=>'TOTAL_DOCUMENTS'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Total Documents'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710672358557133)
,p_db_column_name=>'TOTAL_CHUNKS'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Total Chunks'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710755457557134)
,p_db_column_name=>'AVG_CHUNKS_PER_DOC'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Avg Chunks Per Doc'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710833586557135)
,p_db_column_name=>'MIN_CHUNKS'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Min Chunks'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125710961846557136)
,p_db_column_name=>'MAX_CHUNKS'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Max Chunks'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711053374557137)
,p_db_column_name=>'SPEED'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Speed'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711190746557138)
,p_db_column_name=>'STORAGE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Storage'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711281092557139)
,p_db_column_name=>'QUALITY'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Quality'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(125752099538804278)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1257521'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'STRATEGY_NAME:TOTAL_DOCUMENTS:TOTAL_CHUNKS:AVG_CHUNKS_PER_DOC:MIN_CHUNKS:MAX_CHUNKS:SPEED:STORAGE:QUALITY'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125711306617557140)
,p_plug_name=>'Documents by Category and Strategy'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
' c.category_name,',
' s.strategy_name,',
' COUNT(d.doc_id) as document_count,',
' SUM(d.embedding_count) as total_chunks',
'FROM docs d',
'JOIN lkp_doc_category c ON c.category_code = d.doc_category',
'LEFT JOIN lkp_chunking_strategy s ON s.strategy_code = d.last_chunking_strategy',
'WHERE d.rag_ready_flag = ''Y''',
'GROUP BY c.category_name, s.strategy_name',
'ORDER BY c.category_name, COUNT(d.doc_id) DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(125711490475557141)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'AI'
,p_internal_uid=>125711490475557141
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711532984557142)
,p_db_column_name=>'CATEGORY_NAME'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Category Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711648828557143)
,p_db_column_name=>'STRATEGY_NAME'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Strategy Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711757797557144)
,p_db_column_name=>'DOCUMENT_COUNT'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Document Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125711801447557145)
,p_db_column_name=>'TOTAL_CHUNKS'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Total Chunks'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(125752578052804289)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1257526'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CATEGORY_NAME:STRATEGY_NAME:DOCUMENT_COUNT:TOTAL_CHUNKS'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125723918237710322)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125724619604710326)
,p_plug_name=>'Strategy Usage Distribution'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    s.strategy_name as label,',
'    COUNT(d.doc_id) as value,',
'    s.strategy_code',
'FROM lkp_chunking_strategy s',
'LEFT JOIN docs d ON d.last_chunking_strategy = s.strategy_code',
'WHERE s.is_active = ''Y''',
'GROUP BY s.strategy_name, s.strategy_code',
'ORDER BY COUNT(d.doc_id) DESC'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(125725037724710327)
,p_region_id=>wwv_flow_imp.id(125724619604710326)
,p_chart_type=>'donut'
,p_height=>'400'
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
,p_legend_position=>'auto'
,p_pie_other_threshold=>0
,p_pie_selection_effect=>'highlight'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(125726759958710332)
,p_chart_id=>wwv_flow_imp.id(125725037724710327)
,p_seq=>10
,p_name=>'Strategy Usage Distribution'
,p_max_row_count=>20
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'VALUE'
,p_items_label_column_name=>'LABEL'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125727311476710334)
,p_plug_name=>'Average Chunks per Document by Strategy'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
' s.strategy_name as label,',
' ROUND(AVG(d.embedding_count), 1) as avg_chunks,',
' COUNT(d.doc_id) as documents',
'FROM docs d',
'JOIN lkp_chunking_strategy s ON s.strategy_code = d.last_chunking_strategy',
'WHERE d.rag_ready_flag = ''Y''',
'GROUP BY s.strategy_name',
'ORDER BY AVG(d.embedding_count) DESC'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(125727748404710335)
,p_region_id=>wwv_flow_imp.id(125727311476710334)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'horizontal'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(125728260713710336)
,p_chart_id=>wwv_flow_imp.id(125727748404710335)
,p_seq=>10
,p_name=>'Average Chunks per Document by Strategy'
,p_max_row_count=>20
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'AVG_CHUNKS'
,p_items_label_column_name=>'LABEL'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>true
,p_items_label_position=>'auto'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(125710099049557127)
,p_chart_id=>wwv_flow_imp.id(125727748404710335)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(125710187846557128)
,p_chart_id=>wwv_flow_imp.id(125727748404710335)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp.component_end;
end;
/
