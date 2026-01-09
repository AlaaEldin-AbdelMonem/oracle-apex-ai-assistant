prompt --application/pages/page_00720
begin
--   Manifest
--     PAGE: 00720
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
 p_id=>720
,p_name=>'Audit Log Viewer'
,p_alias=>'AUDIT-LOG-VIEWER'
,p_step_title=>'Audit Log Viewer'
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
 p_id=>wwv_flow_imp.id(164000862252856590)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(464483787299239014)
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
 p_id=>wwv_flow_imp.id(327898477205611328)
,p_plug_name=>'btn'
,p_parent_plug_id=>wwv_flow_imp.id(464483787299239014)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>160
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(466125927818908192)
,p_plug_name=>'Audit Log Viewer'
,p_region_name=>'logViewerStaticId'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_plug_grid_row_css_classes=>'#ROW_CLASS#'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
' SELECT ',
'    a.AUDIT_ID,',
'    a.CREATED_AT,',
'    a.APP_ID,',
'    a.PAGE_ID,',
'    a.USER_ID,',
'    a.SESSION_ID,',
'    a.MODULE_NAME,',
'    a.TRACE_ID,',
'    a.MESSAGE,',
'    a.EXTRA_DATA,',
'    -- Get Type Icon and Display Name',
'    t.DISPLAY_NAME as EVENT_TYPE_DESC,',
'    -- Get Specific Event Icon and Name',
'  ',
'    -- APEX CSS Classes for Row Styling',
'    CASE a.AUDIT_EVENT_TYPE_CODE',
'        WHEN ''SEC''   THEN ''u-color-1'' -- Security (Blue)',
'        WHEN ''KPI_F'' THEN ''u-color-9'' -- Failure (Red)',
'        WHEN ''EVNT''  THEN ''u-color-5'' -- Success (Green)',
'        WHEN ''DATA''  THEN ''u-color-7'' -- Data (Orange)',
'        ELSE ''u-color-2''',
'    END as ROW_CLASS',
'FROM DEBUG_AUDIT_LOG a',
'LEFT JOIN LKP_DEBUG_AUDIT_EVENT_TYPES t ',
'    ON a.AUDIT_EVENT_TYPE_CODE = t.AUDIT_EVENT_TYPE_CODE',
' ',
'WHERE 1=1',
'  -- Context Filters',
'  AND (:P720_APP_ID     IS NULL OR a.APP_ID      = :P720_APP_ID)',
'  AND (:P720_PAGE_ID    IS NULL OR a.PAGE_ID     = :P720_PAGE_ID)',
'  AND (:P720_USER_ID    IS NULL OR a.USER_ID     = TO_NUMBER(TRIM(:P720_USER_ID)))',
'  AND (:P720_SESSION_ID IS NULL OR a.SESSION_ID  = :P720_SESSION_ID)',
'  ',
'  -- Audit Specific Filters',
'  AND (:P720_EVENT_TYPE IS NULL OR a.AUDIT_EVENT_TYPE_CODE = :P720_EVENT_TYPE)',
' ',
'  ',
'  -- Search & Trace',
'  AND (:P720_MODULE   IS NULL OR UPPER(a.MODULE_NAME) LIKE ''%''||UPPER(:P720_MODULE)||''%'')',
'  AND (:P720_TRACE_ID IS NULL OR a.TRACE_ID = :P720_TRACE_ID)',
'  AND (:P720_MESSAGE_SEARCH   IS NULL OR INSTR(UPPER(a.MESSAGE), UPPER(TRIM(:P720_MESSAGE_SEARCH))) > 0)',
'',
'  -- Time Range Logic',
'  AND (',
'    :P720_TIME_RANGE IS NULL OR :P720_TIME_RANGE = ''ALL''',
'    OR (:P720_TIME_RANGE = ''5M''    AND a.CREATED_AT >= SYSTIMESTAMP - INTERVAL ''5'' MINUTE)',
'    OR (:P720_TIME_RANGE = ''1H''    AND a.CREATED_AT >= SYSTIMESTAMP - INTERVAL ''1'' HOUR)',
'    OR (:P720_TIME_RANGE = ''TODAY'' AND a.CREATED_AT >= TRUNC(SYSDATE))',
'    OR (:P720_TIME_RANGE = ''7D''    AND a.CREATED_AT >= TRUNC(SYSDATE) - 7)',
'  )',
'',
'  -- Manual Date Range',
'  AND (:P720_FROM_TS IS NULL OR a.CREATED_AT >= CAST(:P720_FROM_TS AS TIMESTAMP))',
'  AND (:P720_TO_TS   IS NULL OR a.CREATED_AT <  CAST(:P720_TO_TS AS TIMESTAMP) + INTERVAL ''1'' DAY)',
'',
'ORDER BY ',
'    CASE WHEN :P720_SORT_DIR = ''ASC''  THEN a.AUDIT_ID END ASC,',
'    CASE WHEN :P720_SORT_DIR = ''DESC'' THEN a.AUDIT_ID END DESC'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P720_APP_ID,P720_SESSION_ID,P720_MODULE,P720_TRACE_ID,P720_LEVEL,P720_USER_ID,P720_TIME_RANGE,P720_FROM_TS,P720_TO_TS,P720_MESSAGE_SEARCH,P720_SORT_DIR'
,p_prn_page_header=>'Debug Log Viewer'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(466125985603908192)
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
,p_internal_uid=>466125985603908192
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(466127856623908237)
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
 p_id=>wwv_flow_imp.id(327899547534611339)
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
 p_id=>wwv_flow_imp.id(466128243094908238)
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
 p_id=>wwv_flow_imp.id(466635746360064580)
,p_db_column_name=>'TRACE_ID'
,p_display_order=>34
,p_column_identifier=>'M'
,p_column_label=>'Trace Id'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(466128687617908239)
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
 p_id=>wwv_flow_imp.id(466129463681908241)
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
 p_id=>wwv_flow_imp.id(466130723906908245)
,p_db_column_name=>'MESSAGE'
,p_display_order=>84
,p_column_identifier=>'K'
,p_column_label=>'Message'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(466131105937908246)
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
 p_id=>wwv_flow_imp.id(326760786916357457)
,p_db_column_name=>'ROW_CLASS'
,p_display_order=>114
,p_column_identifier=>'N'
,p_column_label=>'Row Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(163910758867754832)
,p_db_column_name=>'AUDIT_ID'
,p_display_order=>124
,p_column_identifier=>'P'
,p_column_label=>'Audit Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(163910809508754833)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>134
,p_column_identifier=>'Q'
,p_column_label=>'Created At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(163910917397754834)
,p_db_column_name=>'EVENT_TYPE_DESC'
,p_display_order=>144
,p_column_identifier=>'R'
,p_column_label=>'Event Type Desc'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(466132877413921121)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1427973'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'MODULE_NAME:MESSAGE:EXTRA_DATA:TRACE_ID:USER_ID:SESSION_ID:APP_ID:PAGE_ID'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(163989145845856521)
,p_button_sequence=>10
,p_button_name=>'Purge_Log'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--link:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Purge Log'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-cut'
,p_grid_new_row=>'Y'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(163999528566856587)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(327898477205611328)
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
 p_id=>wwv_flow_imp.id(163999998945856588)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(327898477205611328)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(164000346258856589)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(327898477205611328)
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
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(163911115576754836)
,p_name=>'P720_EVENT_TYPE'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
,p_prompt=>'Event Type'
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
 p_id=>wwv_flow_imp.id(326766898901357515)
,p_name=>'P720_USER_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327902800358611369)
,p_name=>'P720_TIME_RANGE'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327902933879611370)
,p_name=>'P720_FROM_TS'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327903009899611371)
,p_name=>'P720_TO_TS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327903920347611380)
,p_name=>'P720_MESSAGE_SEARCH'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327903981017611381)
,p_name=>'P720_SORT_DIR'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
,p_item_default=>'DESC'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(327905584987611397)
,p_name=>'P720_PAGE_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
,p_prompt=>'Page '
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select page_title ||''(''||page_name ||'')'' page_name,',
'     page_id ',
'FROM apex_application_pages',
'WHERE application_id = :P720_APP_ID ',
' '))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'-- All Pages --'
,p_lov_cascade_parent_items=>'P720_APP_ID'
,p_ajax_items_to_submit=>'P720_APP_ID'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(464495923567239106)
,p_name=>'P720_APP_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(464496000508239107)
,p_name=>'P720_MODULE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(464496075739239108)
,p_name=>'P720_SESSION_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
,p_prompt=>'SESSION ID'
,p_placeholder=>'--All Sessions--'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(464496217064239109)
,p_name=>'P720_TRACE_ID'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(464496437783239111)
,p_name=>'P720_LEVEL'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(464483787299239014)
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
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164008570226856618)
,p_name=>'Search'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(164000346258856589)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164009071240856619)
,p_event_id=>wwv_flow_imp.id(164008570226856618)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(466125927818908192)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164001691067856598)
,p_name=>'clear Search'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(163999528566856587)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164002064420856601)
,p_event_id=>wwv_flow_imp.id(164001691067856598)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P720_APP_ID,P720_SESSION_ID,P720_MODULE,P720_TRACE_ID,P720_LEVEL,P720_USER_ID,P720_TIME_RANGE,P720_FROM_TS,P720_TO_TS,P720_MESSAGE_SEARCH'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164002408211856601)
,p_name=>'Toggle Date Range-ALL'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P720_TIME_RANGE'
,p_condition_element=>'P720_TIME_RANGE'
,p_triggering_condition_type=>'NOT_EQUALS'
,p_triggering_expression=>'ALL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164002955428856603)
,p_event_id=>wwv_flow_imp.id(164002408211856601)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'clear'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P720_FROM_TS, P720_TO_TS'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
,p_server_condition_type=>'VAL_OF_ITEM_IN_COND_NOT_EQ_COND2'
,p_server_condition_expr1=>'P720_TIME_RANGE'
,p_server_condition_expr2=>'ALL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164003463276856604)
,p_event_id=>wwv_flow_imp.id(164002408211856601)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DISABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P720_FROM_TS, P720_TO_TS'
,p_client_condition_type=>'NOT_EQUALS'
,p_client_condition_element=>'P720_TIME_RANGE'
,p_client_condition_expression=>'ALL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164003865990856605)
,p_name=>'Toggle Date Range-Not-ALL'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P720_TIME_RANGE'
,p_condition_element=>'P720_TIME_RANGE'
,p_triggering_condition_type=>'EQUALS'
,p_triggering_expression=>'ALL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164004393735856606)
,p_event_id=>wwv_flow_imp.id(164003865990856605)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_ENABLE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P720_FROM_TS, P720_TO_TS'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164006620364856612)
,p_name=>'Toggle Sort Direction'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(163999998945856588)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164007107490856614)
,p_event_id=>wwv_flow_imp.id(164006620364856612)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P720_SORT_DIR'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'($v(''P720_SORT_DIR'') === ''DESC'') ? ''ASC'' : ''DESC'''
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164008118075856617)
,p_event_id=>wwv_flow_imp.id(164006620364856612)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var dir = $v(''P720_SORT_DIR'');',
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
 p_id=>wwv_flow_imp.id(164007616869856615)
,p_event_id=>wwv_flow_imp.id(164006620364856612)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(466125927818908192)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(164004702874856607)
,p_name=>'delete All log data'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(163989145845856521)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(164005796672856610)
,p_event_id=>wwv_flow_imp.id(164004702874856607)
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
 p_id=>wwv_flow_imp.id(164006208519856611)
,p_event_id=>wwv_flow_imp.id(164004702874856607)
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
 p_id=>wwv_flow_imp.id(164005283840856609)
,p_event_id=>wwv_flow_imp.id(164004702874856607)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(466125927818908192)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
