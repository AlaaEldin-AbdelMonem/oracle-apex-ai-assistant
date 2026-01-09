prompt --application/pages/page_00716
begin
--   Manifest
--     PAGE: 00716
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
 p_id=>716
,p_name=>unistr('Debug Configuration \D83D\DEE0\FE0F')
,p_alias=>'DEBUG-CONFIGURATION2'
,p_page_mode=>'MODAL'
,p_step_title=>unistr('Debug Configuration \D83D\DEE0\FE0F')
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_height=>'500'
,p_dialog_width=>'1000'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158831906845853347)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>30
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(302083000816703227)
,p_plug_name=>'Debug Configuration'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'DEBUG_CONFIG'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_prn_page_header=>'Debug Configuration'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(163910354212754828)
,p_name=>'SCOPE_LEVEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SCOPE_LEVEL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Scope Level'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(163948941785212525)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302084251829703234)
,p_name=>'APEX$LINK'
,p_source_type=>'NONE'
,p_item_type=>'NATIVE_LINK'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>10
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:717:&SESSION.::&DEBUG.:RP,717:P717_CONFIG_ID:&CONFIG_ID.'
,p_link_text=>'<span role="img" aria-label="Edit" class="fa fa-edit" title="Edit"></span>'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_escape_on_http_output=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302085287180703238)
,p_name=>'CONFIG_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CONFIG_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>20
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_enable_filter=>false
,p_enable_hide=>true
,p_is_primary_key=>true
,p_duplicate_value=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302086225260703241)
,p_name=>'IS_ENABLED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_ENABLED'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Active'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_is_required=>true
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(124111059557222693)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302088279336703247)
,p_name=>'APP_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'APP_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Application'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(142784952100993911)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302089274735703249)
,p_name=>'USER_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'USER_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'User'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(142784559434972307)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302090223047703252)
,p_name=>'SESSION_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SESSION_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Session Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302091302094703254)
,p_name=>'MODULE_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODULE_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Module Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(142785128474004023)
,p_lov_display_extra=>true
,p_lov_display_null=>true
,p_lov_null_text=>'--All Modules--'
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302092289758703257)
,p_name=>'MIN_DEBUG_LEVEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MIN_DEBUG_LEVEL'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Min Debug Level'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>90
,p_value_alignment=>'LEFT'
,p_is_required=>false
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(142783886284945216)
,p_lov_display_extra=>false
,p_lov_display_null=>true
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'LOV'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_default_type=>'STATIC'
,p_default_expression=>'4'
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302093242553703259)
,p_name=>'CREATED_ON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_ON'
,p_data_type=>'DATE'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_DATE_PICKER_APEX'
,p_heading=>'Created On'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'appearance_and_behavior', 'MONTH-PICKER:YEAR-PICKER:TODAY-BUTTON',
  'days_outside_month', 'VISIBLE',
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_on', 'FOCUS',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_date_ranges=>'ALL'
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(302094306527703262)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>100
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'DISTINCT'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(302083444073703229)
,p_internal_uid=>302083444073703229
,p_is_editable=>false
,p_lazy_loading=>false
,p_requires_filter=>false
,p_select_first_row=>true
,p_fixed_row_height=>true
,p_pagination_type=>'SCROLL'
,p_show_total_row_count=>true
,p_show_toolbar=>true
,p_enable_save_public_report=>false
,p_enable_subscriptions=>true
,p_enable_flashback=>true
,p_define_chart_view=>true
,p_enable_download=>true
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(302083885718703231)
,p_interactive_grid_id=>wwv_flow_imp.id(302083444073703229)
,p_static_id=>'1427663'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(302084021834703232)
,p_report_id=>wwv_flow_imp.id(302083885718703231)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(5593858081630)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(163910354212754828)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>89
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302084709546703236)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(302084251829703234)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>40
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302085654848703239)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(302085287180703238)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302086640371703242)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(302086225260703241)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>60
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302088673515703247)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(302088279336703247)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>108
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302089662807703250)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(302089274735703249)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>59
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302090689639703253)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(302090223047703252)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>89
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302091697517703255)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(302091302094703254)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>91
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302092681497703258)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(302092289758703257)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>123
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302093708345703260)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(302093242553703259)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>90
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(302094675063703263)
,p_view_id=>wwv_flow_imp.id(302084021834703232)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(302094306527703262)
,p_is_visible=>false
,p_is_frozen=>false
,p_width=>40
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(302596925043069141)
,p_plug_name=>'Quick Pick'
,p_region_template_options=>'#DEFAULT#:is-expanded:t-Region--noUI:t-Region--scrollBody:t-Form--standardPadding'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>20
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>3
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(159324554650953558)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(302596925043069141)
,p_button_name=>'ENABLE_SESSION_DEBUG'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Enable Debug for This Session'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-heartbeat'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(159324961253953559)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(302596925043069141)
,p_button_name=>'DISABLE_SESSION_DEBUG'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Disable Debug for This Session'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-heart-o'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(160902151497492331)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(302596925043069141)
,p_button_name=>'OPEN_DEBUG'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>' Debug Results Window'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-nurse'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(160903698981492346)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(302596925043069141)
,p_button_name=>'Purge_Log'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Purge Log'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-cut'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(159323753875953554)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(302083000816703227)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI'
,p_button_template_id=>2349107722467437027
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'PREVIOUS'
,p_button_redirect_url=>'f?p=&APP_ID.:717:&SESSION.::&DEBUG.:707::'
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(160902675221492336)
,p_name=>'P716_DEBUG_DTL_URL'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(159329098285953589)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(302083000816703227)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159329551751953591)
,p_event_id=>wwv_flow_imp.id(159329098285953589)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302083000816703227)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(159326256835953581)
,p_name=>'Enable Debug for This Session'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(159324554650953558)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159326744356953583)
,p_event_id=>wwv_flow_imp.id(159326256835953581)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_app_id     NUMBER := TO_NUMBER(NVL(V(''APP_ID''),''0''));',
'    l_session_id NUMBER := TO_NUMBER(NVL(V(''APP_SESSION''),''0''));',
'    l_user       VARCHAR2(100) := V(''APP_USER'');',
'BEGIN',
'    -- Safety: if no session, do nothing',
'    IF l_session_id = 0 THEN',
'        RETURN;',
'    END IF;',
'',
'    -- Remove any existing SESSION-scoped entries for this session/app to avoid duplicates',
'    DELETE FROM debug_config',
'     WHERE scope_level = ''SESSION''',
'       AND app_id      = l_app_id',
'       AND session_id  = l_session_id;',
'',
'    -- Insert a fresh SESSION-scoped debug config at DEBUG level',
'    INSERT INTO debug_config (',
'        is_enabled,',
'        scope_level,',
'        app_id,',
'        session_id,',
'        min_debug_level,',
'        created_by',
'    ) VALUES (',
'        ''Y'',',
'        ''SESSION'',',
'        l_app_id,',
'        l_session_id,',
'        4,               -- DEBUG (most verbose)',
'        NVL(l_user, ''SYSTEM'')',
'    );',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159327268232953585)
,p_event_id=>wwv_flow_imp.id(159326256835953581)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302083000816703227)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(159327612042953586)
,p_name=>'Disable Debug for This Session'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(159324961253953559)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159328672346953589)
,p_event_id=>wwv_flow_imp.id(159327612042953586)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_app_id     NUMBER := TO_NUMBER(NVL(V(''APP_ID''),''0''));',
'    l_session_id NUMBER := TO_NUMBER(NVL(V(''APP_SESSION''),''0''));',
'BEGIN',
'    DELETE FROM debug_config',
'     WHERE scope_level = ''SESSION''',
'       AND app_id      = l_app_id',
'       AND session_id  = l_session_id;',
'END;',
''))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(159328132826953588)
,p_event_id=>wwv_flow_imp.id(159327612042953586)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302083000816703227)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(160902231681492332)
,p_name=>'open Window'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(160902151497492331)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(160902302252492333)
,p_event_id=>wwv_flow_imp.id(160902231681492332)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let urlValue = $v("P716_DEBUG_DTL_URL");',
'',
'// Check if it''s an APEX action URL',
'if (urlValue.includes(''target='')) {',
'    // Extract the actual URL from the target parameter',
'    let cleanUrl = decodeURIComponent(urlValue.split(''target='')[1].split(''&'')[0]);',
'    window.open(cleanUrl, ''_blank'');',
'} else {',
'    // If it''s already a clean URL',
'    window.open(urlValue, ''_blank'');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(160902413974492334)
,p_name=>'get_debug_dtl_info'
,p_event_sequence=>50
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(160902557146492335)
,p_event_id=>wwv_flow_imp.id(160902413974492334)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P716_DEBUG_DTL_URL:= apex_page.get_url(   p_page   => 718,   p_items  => null,  p_values => null  );'
,p_attribute_03=>'P716_DEBUG_DTL_URL'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(160903763468492347)
,p_name=>'Purge Log'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(160903698981492346)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(160903875812492348)
,p_event_id=>wwv_flow_imp.id(160903763468492347)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Purge All , Are You sure?'
,p_attribute_04=>'fa-exclamation-diamond'
,p_attribute_06=>'Confirm Purge'
,p_attribute_07=>'Cancel Purge'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(160903910537492349)
,p_event_id=>wwv_flow_imp.id(160903763468492347)
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
 p_id=>wwv_flow_imp.id(163910020073754825)
,p_event_id=>wwv_flow_imp.id(160903763468492347)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(302083000816703227)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp.component_end;
end;
/
