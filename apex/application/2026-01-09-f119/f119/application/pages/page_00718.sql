prompt --application/pages/page_00718
begin
--   Manifest
--     PAGE: 00718
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
 p_id=>718
,p_name=>'Debug Log Viewer'
,p_alias=>'DEBUG-LOG-VIEWER1'
,p_step_title=>'Debug Log Viewer'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'(function () {',
'  const region = apex.jQuery("#logViewerStaticId");',
'',
'  region.on("apexafterrefresh", function () {',
'    region.find("tbody tr").each(function () {',
'      const levelCell = apex.jQuery(this).find("td[headers=''C302138586923051728'']");',
'      const txt = levelCell.text();',
'',
'      if (txt.includes("(1)")) this.dataset.level = "1";',
'      else if (txt.includes("(2)")) this.dataset.level = "2";',
'      else if (txt.includes("(3)")) this.dataset.level = "3";',
'      else if (txt.includes("(4)")) this.dataset.level = "4";',
'    });',
'  });',
'})();',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ===== Row Coloring ===== */',
'#logViewerStaticId tr[data-level="1"] {',
'  background-color: #fff5f5;',
'}',
'',
'#logViewerStaticId tr[data-level="2"] {',
'  background-color: #fff7ed;',
'}',
'',
'#logViewerStaticId tr[data-level="3"] {',
'  background-color: #f0f9ff;',
'}',
'',
'#logViewerStaticId tr[data-level="4"] {',
'  background-color: #f0fdf4;',
'}',
''))
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(300494908458382506)
,p_plug_name=>'filters'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--accent15:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_02'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(163909598364754820)
,p_plug_name=>'btn'
,p_parent_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>160
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(302137048978051684)
,p_plug_name=>'Debug Log Viewer'
,p_region_name=>'logViewerStaticId'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_grid_row_css_classes=>'#ROW_CLASS#'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select LOG_ID,',
'       LOG_TS,',
'       DEBUG_LEVEL,',
'       APP_ID,',
'       USER_ID,',
'       SESSION_ID,',
'       SCOPE_LEVEL,',
'       MODULE_NAME,',
'       PROCEDURE_NAME,',
'       TRACE_ID,',
'       MESSAGE,',
'       EXTRA_DATA,',
'       PAGE_ID,',
'       -- Mapping levels to APEX Universal Theme status classes',
'       CASE debug_level ',
'            WHEN 1 THEN ''log-error''',
'            WHEN 2 THEN ''log-warn''',
'            WHEN 3 THEN ''log-info''',
'            WHEN 4 THEN ''log-debug'' ',
'       END as ROW_CLASS  ',
'',
'',
'  from DEBUG_LOG',
'  WHERE 1=1',
'  AND ( trim(:P718_APP_ID)     IS NULL   OR app_id       = :P718_APP_ID )',
'  AND ( trim(:P718_PAGE_ID)     IS NULL  OR PAGE_ID       = :P718_PAGE_ID )',
'  AND  (:P718_USER_ID          IS NULL    OR user_id     =   TO_NUMBER( trim(:P718_USER_ID))    ) ',
'  AND ( trim(:P718_SESSION_ID) IS NULL OR session_id  = :P718_SESSION_ID )',
'  AND ( trim(:P718_MODULE )    IS NULL OR UPPER(module_name) LIKE ''%'' || UPPER(:P718_MODULE) || ''%'' )',
'  AND ( trim(:P718_trace_ID)   IS NULL OR trace_id  =  :P718_TRACE_ID )',
'  AND ( :P718_LEVEL      IS NULL OR debug_level <= TO_NUMBER( trim(:P718_LEVEL)) )',
'  AND (',
'  :P718_TIME_RANGE IS NULL',
'  OR :P718_TIME_RANGE = ''ALL''',
'',
'  OR ( :P718_TIME_RANGE = ''5M''',
'       AND log_ts >= SYSTIMESTAMP - INTERVAL ''5'' MINUTE )',
'',
'  OR ( :P718_TIME_RANGE = ''15M''',
'       AND log_ts >= SYSTIMESTAMP - INTERVAL ''15'' MINUTE )',
'',
'  OR ( :P718_TIME_RANGE = ''1H''',
'       AND log_ts >= SYSTIMESTAMP - INTERVAL ''1'' HOUR )',
'',
'  OR ( :P718_TIME_RANGE = ''24H''',
'       AND log_ts >= SYSTIMESTAMP - INTERVAL ''24'' HOUR )',
'',
'  OR ( :P718_TIME_RANGE = ''TODAY''',
'       AND log_ts >= TRUNC(SYSDATE) )',
'',
'  OR ( :P718_TIME_RANGE = ''YDAY''',
'       AND log_ts >= TRUNC(SYSDATE) - 1',
'       AND log_ts <  TRUNC(SYSDATE) )',
'',
'  OR ( :P718_TIME_RANGE = ''7D''',
'       AND log_ts >= TRUNC(SYSDATE) - 7 )',
')',
'',
'AND ( :P718_FROM_TS IS NULL    OR log_ts >= CAST(:P718_FROM_TS AS TIMESTAMP) )',
'AND ( :P718_TO_TS IS NULL  OR log_ts <  CAST(:P718_TO_TS AS TIMESTAMP)  + INTERVAL ''1'' DAY )',
'',
'AND (  :P718_MESSAGE_SEARCH IS NULL',
'   OR INSTR(   UPPER(message),  UPPER(TRIM(:P718_MESSAGE_SEARCH))  ) > 0',
')',
'',
' ',
' ORDER BY',
'  CASE WHEN :P718_SORT_DIR = ''ASC''  THEN log_id END ASC,',
'  CASE WHEN :P718_SORT_DIR = ''DESC'' THEN log_id END DESC ',
'',
' ',
''))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P718_APP_ID,P718_SESSION_ID,P718_MODULE,P718_TRACE_ID,P718_LEVEL,P718_USER_ID,P718_TIME_RANGE,P718_FROM_TS,P718_TO_TS,P718_MESSAGE_SEARCH,P718_SORT_DIR'
,p_prn_page_header=>'Debug Log Viewer'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(302137106763051684)
,p_name=>'Debug Log Viewer'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_csv_output_separator=>','
,p_owner=>'AI'
,p_internal_uid=>302137106763051684
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302137775036051723)
,p_db_column_name=>'LOG_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Log ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302138586923051728)
,p_db_column_name=>'DEBUG_LEVEL'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Debug Level'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span class="log-level log-level-#LEVEL_CODE#">',
'  #DEBUG_LEVEL#',
'</span>'))
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(142783886284945216)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302138977783051729)
,p_db_column_name=>'APP_ID'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Application'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(142784952100993911)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(163910668693754831)
,p_db_column_name=>'PAGE_ID'
,p_display_order=>14
,p_column_identifier=>'O'
,p_column_label=>'Page '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(163957443930745159)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302139364254051730)
,p_db_column_name=>'USER_ID'
,p_display_order=>24
,p_column_identifier=>'E'
,p_column_label=>'User '
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(142784559434972307)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302646867519208072)
,p_db_column_name=>'TRACE_ID'
,p_display_order=>34
,p_column_identifier=>'M'
,p_column_label=>'Trace Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302139808777051731)
,p_db_column_name=>'SESSION_ID'
,p_display_order=>44
,p_column_identifier=>'F'
,p_column_label=>'Session ID'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302140186778051732)
,p_db_column_name=>'SCOPE_LEVEL'
,p_display_order=>54
,p_column_identifier=>'G'
,p_column_label=>'Scope Level'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(163948941785212525)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302140584841051733)
,p_db_column_name=>'MODULE_NAME'
,p_display_order=>64
,p_column_identifier=>'H'
,p_column_label=>'Module Name'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(142785128474004023)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302140967247051735)
,p_db_column_name=>'PROCEDURE_NAME'
,p_display_order=>74
,p_column_identifier=>'I'
,p_column_label=>'Procedure Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302141845066051737)
,p_db_column_name=>'MESSAGE'
,p_display_order=>84
,p_column_identifier=>'K'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(302142227097051738)
,p_db_column_name=>'EXTRA_DATA'
,p_display_order=>94
,p_column_identifier=>'L'
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
 p_id=>wwv_flow_imp.id(302138169914051726)
,p_db_column_name=>'LOG_TS'
,p_display_order=>104
,p_column_identifier=>'B'
,p_column_label=>'Log Ts'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'YYMMDD-HH24:MI:SS'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(162771908075500949)
,p_db_column_name=>'ROW_CLASS'
,p_display_order=>114
,p_column_identifier=>'N'
,p_column_label=>'Row Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(302143998573064613)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1427973'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'LOG_ID:DEBUG_LEVEL:MODULE_NAME:PROCEDURE_NAME:MESSAGE:EXTRA_DATA:TRACE_ID:LOG_TS:USER_ID:SESSION_ID:SCOPE_LEVEL:APP_ID:PAGE_ID:'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(163943995759605796)
,p_button_sequence=>10
,p_button_name=>'Purge_Log'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Purge Log'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-cut'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(159352206794971598)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(163909598364754820)
,p_button_name=>'Search'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Search'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-search'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(160902948775492339)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(163909598364754820)
,p_button_name=>'clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'clear'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-eraser'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(163909086091754815)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(163909598364754820)
,p_button_name=>'sort'
,p_button_static_id=>'BTN_TOGGLE_SORT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--noUI'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'sort'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-down'
,p_button_comment=>'sort'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(162771851133500948)
,p_name=>'P718_USER_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_item_default=>'v(''G_USER_ID'')'
,p_item_default_type=>'EXPRESSION'
,p_item_default_language=>'PLSQL'
,p_prompt=>'User'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'USERS(USERID)'
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--All Users---'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163907752590754802)
,p_name=>'P718_TIME_RANGE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_item_default=>'ALL'
,p_prompt=>'Time Range'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov_language=>'PLSQL'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'select NAME, RETURNX from (',
'SELECT ''5M'' AS RETURNX, UNISTR(''\23F2 '') || ''Last 5 minutes'' AS NAME FROM DUAL',
'UNION ALL',
'SELECT ''15M'',   UNISTR(''\23F2 '') || ''Last 15 minutes'' FROM DUAL',
'UNION ALL',
'SELECT ''1H'',    UNISTR(''\23F2 '') || ''Last hour'' FROM DUAL',
'UNION ALL',
'SELECT ''24H'',   UNISTR(''\23F2 '') || ''Last 24 hours'' FROM DUAL',
'UNION ALL',
'SELECT ''TODAY'', UNISTR(''\23F2 '') || ''Today'' FROM DUAL',
'UNION ALL',
'SELECT ''YDAY'',  UNISTR(''\23F2 '') || ''Yesterday'' FROM DUAL',
'UNION ALL',
'SELECT ''7D'',    UNISTR(''\23F2 '') || ''Last 7 days'' FROM DUAL',
'UNION ALL',
'SELECT ''ALL'',   UNISTR(''\23F2 '') || ''All time'' FROM DUAL',
')'))
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Choose a quick time range.',
'Select All to enable custom From / To dates.'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163907886111754803)
,p_name=>'P718_FROM_TS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'From Date'
,p_placeholder=>'-- Any Date --'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163907962131754804)
,p_name=>'P718_TO_TS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'To Date'
,p_placeholder=>'-- Any Date --'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163908872579754813)
,p_name=>'P718_MESSAGE_SEARCH'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'Message Search'
,p_placeholder=>'Searching for.......'
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
 p_id=>wwv_flow_imp.id(163908933249754814)
,p_name=>'P718_SORT_DIR'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_item_default=>'DESC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163910537219754830)
,p_name=>'P718_PAGE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'Page '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select page_title ||''(''||page_name ||'')'' page_name,',
'     page_id ',
'FROM apex_application_pages',
'WHERE application_id = :P718_APP_ID ',
' '))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- All Pages --'
,p_lov_cascade_parent_items=>'P718_APP_ID'
,p_ajax_items_to_submit=>'P718_APP_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300500875799382539)
,p_name=>'P718_APP_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_item_default=>'APP_ID'
,p_item_default_type=>'ITEM'
,p_prompt=>'Application'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'APP LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    application_id,',
'    application_name,',
'    alias',
'FROM',
'    apex_applications',
'ORDER BY',
'    application_id;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--All Apps--'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300500952740382540)
,p_name=>'P718_MODULE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'Module'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'USER MODULES (DB PKGS)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    object_name AS display,',
'    object_name AS returnx',
'FROM',
'    user_objects',
'WHERE',
'    object_type = ''PACKAGE''',
'ORDER BY',
'    object_name;'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- All Modules --'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300501027971382541)
,p_name=>'P718_SESSION_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'SESSION ID'
,p_placeholder=>'--All Sessions--'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300501169296382542)
,p_name=>'P718_TRACE_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'Trace Text'
,p_placeholder=>'--All Traces--'
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
 p_id=>wwv_flow_imp.id(300501390015382544)
,p_name=>'P718_LEVEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(300494908458382506)
,p_prompt=>'Level'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'DEBUG LEVEL (DEBUG_LEVEL)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select debug_level return_Val,',
' Level_Name ||'' (''||debug_level||'')'' display_value',
'  from LKP_DEBUG_LEVEL'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'--All Levels--'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(159354954315971607)
,p_name=>'Search'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(159352206794971598)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159355492134971608)
,p_event_id=>wwv_flow_imp.id(159354954315971607)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302137048978051684)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(160903137046492341)
,p_name=>'clear Search'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(160902948775492339)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(160903298898492342)
,p_event_id=>wwv_flow_imp.id(160903137046492341)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P718_APP_ID,P718_SESSION_ID,P718_MODULE,P718_TRACE_ID,P718_LEVEL,P718_USER_ID,P718_TIME_RANGE,P718_FROM_TS,P718_TO_TS,P718_MESSAGE_SEARCH'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(163908031815754805)
,p_name=>'Toggle Date Range-ALL'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P718_TIME_RANGE'
,p_condition_element=>'P718_TIME_RANGE'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'ALL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163908274249754807)
,p_event_id=>wwv_flow_imp.id(163908031815754805)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'clear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P718_FROM_TS, P718_TO_TS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_server_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_server_condition_expr1=>'P718_TIME_RANGE'
,p_server_condition_expr2=>'ALL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163908163359754806)
,p_event_id=>wwv_flow_imp.id(163908031815754805)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P718_FROM_TS, P718_TO_TS'
,p_client_condition_type=>'NOT_EQUALS'
,p_client_condition_element=>'P718_TIME_RANGE'
,p_client_condition_expression=>'ALL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(163908556513754810)
,p_name=>'Toggle Date Range-Not-ALL'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P718_TIME_RANGE'
,p_condition_element=>'P718_TIME_RANGE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'ALL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163908761619754812)
,p_event_id=>wwv_flow_imp.id(163908556513754810)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P718_FROM_TS, P718_TO_TS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(163909116979754816)
,p_name=>'Toggle Sort Direction'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(163909086091754815)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163909252231754817)
,p_event_id=>wwv_flow_imp.id(163909116979754816)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P718_SORT_DIR'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'($v(''P718_SORT_DIR'') === ''DESC'') ? ''ASC'' : ''DESC'''
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163909410706754819)
,p_event_id=>wwv_flow_imp.id(163909116979754816)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var dir = $v(''P718_SORT_DIR'');',
'var btn = $(''#BTN_TOGGLE_SORT'');',
'',
'btn.find(''.fa'')',
'   .removeClass(''fa-arrow-up fa-arrow-down'')',
'   .addClass(dir === ''ASC'' ? ''fa-arrow-up'' : ''fa-arrow-down'');',
'',
'btn.attr(',
'  ''title'',',
'  dir === ''ASC'' ? ''Oldest first'' : ''Newest first''',
');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163909371768754818)
,p_event_id=>wwv_flow_imp.id(163909116979754816)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302137048978051684)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(163909749149754822)
,p_name=>'delete All log data'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(163943995759605796)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163909810716754823)
,p_event_id=>wwv_flow_imp.id(163909749149754822)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'All Log data will be lost? ',
'!!!!!!'))
,p_attribute_02=>'Purge Log'
,p_attribute_03=>'danger'
,p_attribute_04=>'fa-warning'
,p_attribute_06=>'Confirm Purge'
,p_attribute_07=>'Cancel'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163909997990754824)
,p_event_id=>wwv_flow_imp.id(163909749149754822)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'delete DEBUG_LOG;',
'commit;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(163910125831754826)
,p_event_id=>wwv_flow_imp.id(163909749149754822)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302137048978051684)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
