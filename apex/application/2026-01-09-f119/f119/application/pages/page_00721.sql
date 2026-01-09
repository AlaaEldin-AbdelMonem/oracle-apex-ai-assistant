prompt --application/pages/page_00721
begin
--   Manifest
--     PAGE: 00721
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
 p_id=>721
,p_name=>'Audit Intelligence Dashboard'
,p_alias=>'AUDIT-INTELLIGENCE-DASHBOARD'
,p_step_title=>'Audit Intelligence Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(163911626558754841)
,p_plug_name=>'System Health'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    EVENT_GROUP,',
'    COUNT(*) as TOTAL,',
'    MAX(CREATED_AT) as LAST_OCCURRENCE,',
'    -- Alert logic: Red if any FAIL types exist in this group today',
'    CASE ',
'        WHEN SUM(CASE WHEN TYPE_CODE = ''FAIL'' THEN 1 ELSE 0 END) > 0 THEN ''u-danger'' ',
'        ELSE ''u-success'' ',
'    END as CARD_COLOR',
'FROM AUDIT_DASHBOARD_V',
'WHERE CREATED_AT >= TRUNC(SYSDATE)',
'GROUP BY EVENT_GROUP;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(163911759768754842)
,p_region_id=>wwv_flow_imp.id(163911626558754841)
,p_layout_type=>'GRID'
,p_component_css_classes=>'#CARD_COLOR#'
,p_title_adv_formatting=>false
,p_title_column_name=>'EVENT_GROUP'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'LAST_OCCURRENCE'
,p_body_adv_formatting=>false
,p_body_column_name=>'TOTAL'
,p_second_body_adv_formatting=>false
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(163911843931754843)
,p_plug_name=>'AI KPI'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    EVENT_NAME,',
'    COUNT(*) as VAL',
'FROM AUDIT_DASHBOARD_V',
'WHERE EVENT_GROUP = ''AI KPI''',
'  AND CREATED_AT >= TRUNC(SYSDATE)',
'GROUP BY EVENT_NAME;'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(163911932362754844)
,p_region_id=>wwv_flow_imp.id(163911843931754843)
,p_chart_type=>'bar'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
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
 p_id=>wwv_flow_imp.id(163912061132754845)
,p_chart_id=>wwv_flow_imp.id(163911932362754844)
,p_seq=>10
,p_name=>'AI KPI '
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'VAL'
,p_items_label_column_name=>'EVENT_NAME'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(163912293407754847)
,p_chart_id=>wwv_flow_imp.id(163911932362754844)
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
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(163912138396754846)
,p_chart_id=>wwv_flow_imp.id(163911932362754844)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(163912344038754848)
,p_plug_name=>'The Forensic Audit Trail'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_grid_row_css_classes=>'#TYPE_COLOR#'
,p_query_type=>'SQL'
,p_plug_source=>'SELECT * FROM AUDIT_DASHBOARD_V'
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
 p_id=>wwv_flow_imp.id(163912492260754849)
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
,p_internal_uid=>163912492260754849
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(163912513537754850)
,p_db_column_name=>'AUDIT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Audit Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491137291600502)
,p_db_column_name=>'APP_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'App Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491272627600503)
,p_db_column_name=>'PAGE_ID'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Page Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491326834600504)
,p_db_column_name=>'USER_ID'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'User Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491448591600505)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Session Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491538133600506)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'Module Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491646848600507)
,p_db_column_name=>'MESSAGE'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491706204600508)
,p_db_column_name=>'TRACE_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Trace Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491858890600509)
,p_db_column_name=>'EXTRA_DATA'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Extra Data'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_heading_alignment=>'LEFT'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491989350600510)
,p_db_column_name=>'TYPE_CODE'
,p_display_order=>110
,p_column_identifier=>'K'
,p_column_label=>'Type Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492031207600511)
,p_db_column_name=>'TYPE_NAME'
,p_display_order=>120
,p_column_identifier=>'L'
,p_column_label=>'Type Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492195314600512)
,p_db_column_name=>'TYPE_COLOR'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Type Color'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492286304600513)
,p_db_column_name=>'EVENT_GROUP'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Event Group'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492327500600514)
,p_db_column_name=>'EVENT_CODE'
,p_display_order=>150
,p_column_identifier=>'O'
,p_column_label=>'Event Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492457849600515)
,p_db_column_name=>'EVENT_NAME'
,p_display_order=>160
,p_column_identifier=>'P'
,p_column_label=>'Event Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164492544087600516)
,p_db_column_name=>'EVENT_ICON'
,p_display_order=>170
,p_column_identifier=>'Q'
,p_column_label=>'Event Icon'
,p_column_html_expression=>'<span class="fa #EVENT_ICON#"></span> #EVENT_NAME#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(164491043820600501)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>180
,p_column_identifier=>'B'
,p_column_label=>'Created At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(164503789503645758)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1645038'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'AUDIT_ID:APP_ID:PAGE_ID:USER_ID:SESSION_ID:MODULE_NAME:MESSAGE:TRACE_ID:EXTRA_DATA:TYPE_CODE:TYPE_NAME:TYPE_COLOR:EVENT_GROUP:EVENT_CODE:EVENT_NAME:EVENT_ICON:CREATED_AT'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(164483494753510861)
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
 p_id=>wwv_flow_imp.id(163911208454754837)
,p_plug_name=>'filter'
,p_parent_plug_id=>wwv_flow_imp.id(164483494753510861)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163911384091754838)
,p_name=>'P721_TIME_RANGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(163911208454754837)
,p_prompt=>'Time Range'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Last 15M;15M, Last 1H;1H,Today;TODAY,7 Days;7D,All;ALL'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163911411741754839)
,p_name=>'P721_SEARCH'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(163911208454754837)
,p_prompt=>'Search'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163911590850754840)
,p_name=>'P721_TYPE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(163911208454754837)
,p_prompt=>'Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'AUDIT_EVENT_TYPES'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp.component_end;
end;
/
