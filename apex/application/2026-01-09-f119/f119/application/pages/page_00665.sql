prompt --application/pages/page_00665
begin
--   Manifest
--     PAGE: 00665
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
 p_id=>665
,p_name=>'Strategy Manager'
,p_alias=>'STRATEGY-MANAGER1'
,p_step_title=>'Strategy Manager'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'',
'/* 1. Force the header text to wrap */',
'#strategy_Mngr_region_id .a-IRR-header {',
'    white-space: normal !important; /* Forces text to wrap */',
'    height: auto !important;         /* Allows the row to expand */',
'}',
'',
'/* 2. Optional: Center the wrapped header text (vertical & horizontal) */',
'#strategy_Mngr_region_id .a-IRR-header:not(.a-IRR-header--group) {',
'    display: flex;                   /* Use Flexbox for alignment */',
'    align-items: center;             /* Vertically center */',
'    justify-content: center;         /* Horizontally center */',
'}',
'',
'/* 3. Optional: Set a minimum height for all header columns */',
'#strategy_Mngr_region_id .a-IRR-headersRow {',
'    min-height: 50px; /* Adjust this value as needed */',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125734364197794704)
,p_plug_name=>'Strategy Details'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125734962543794710)
,p_plug_name=>'Usage Statistics for Selected Strategy'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125735797763794718)
,p_plug_name=>'Administrator Notice'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('1. - \26A0\FE0F Administrator Access Required'),
'    Changes to chunking strategies affect all users.',
'',
'- Disabling a strategy will prevent its use',
'- Only one strategy can be set as default',
'- Modifying chunk sizes affects new chunking operations'))
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125781332603830158)
,p_plug_name=>'Strategy Manager'
,p_region_name=>'strategy_Mngr_region_id'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
' strategy_code,',
' strategy_name,',
' is_active,',
' is_default,',
' default_chunk_size,',
' default_overlap_pct,',
' relative_speed,',
' storage_overhead,',
' semantic_preservation,',
' boundary_accuracy,',
' recommended_doc_types,',
' display_order',
'FROM lkp_chunking_strategy',
' '))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_page_header=>'Strategy Manager'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125782675552830162)
,p_name=>'APEX$LINK'
,p_source_type=>'NONE'
,p_item_type=>'NATIVE_LINK'
,p_heading_alignment=>'CENTER'
,p_display_sequence=>10
,p_value_alignment=>'CENTER'
,p_link_target=>'f?p=&APP_ID.:666:&APP_SESSION.::&DEBUG.:RP,666:P666_STRATEGY_CODE:\&STRATEGY_CODE.\'
,p_link_text=>'<span role="img" aria-label="Edit" class="fa fa-edit" title="Edit"></span>'
,p_enable_hide=>true
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125783654190830166)
,p_name=>'STRATEGY_CODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STRATEGY_CODE'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
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
 p_id=>wwv_flow_imp.id(125784688563830169)
,p_name=>'STRATEGY_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STRATEGY_NAME'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Strategy Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125788667978830179)
,p_name=>'DEFAULT_CHUNK_SIZE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_CHUNK_SIZE'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Default Chunk Size'
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
 p_id=>wwv_flow_imp.id(125789653739830182)
,p_name=>'DEFAULT_OVERLAP_PCT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEFAULT_OVERLAP_PCT'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Default Overlap Pct'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>80
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
 p_id=>wwv_flow_imp.id(125793606458830193)
,p_name=>'RELATIVE_SPEED'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RELATIVE_SPEED'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Relative Speed'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>120
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
 p_id=>wwv_flow_imp.id(125794620127830195)
,p_name=>'STORAGE_OVERHEAD'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STORAGE_OVERHEAD'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Storage Overhead'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>130
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
 p_id=>wwv_flow_imp.id(125800536769830211)
,p_name=>'RECOMMENDED_DOC_TYPES'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RECOMMENDED_DOC_TYPES'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Recommended Doc Types'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>1000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_exact_match=>true
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_control_break=>false
,p_enable_hide=>true
,p_enable_pivot=>false
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125803540146830219)
,p_name=>'SEMANTIC_PRESERVATION'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SEMANTIC_PRESERVATION'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Semantic Preservation'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>220
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>20
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125804590342830222)
,p_name=>'BOUNDARY_ACCURACY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'BOUNDARY_ACCURACY'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Boundary Accuracy'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'send_on_page_submit', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>20
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
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(125805574979830224)
,p_name=>'IS_ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_ACTIVE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Is Active'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(125806583777830227)
,p_name=>'IS_DEFAULT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_DEFAULT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Is Default'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>250
,p_value_alignment=>'LEFT'
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(125807539050830230)
,p_name=>'DISPLAY_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DISPLAY_ORDER'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Display Order'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>260
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(125781816089830159)
,p_internal_uid=>125781816089830159
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
 p_id=>wwv_flow_imp.id(125782256991830161)
,p_interactive_grid_id=>wwv_flow_imp.id(125781816089830159)
,p_static_id=>'1257823'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(125782489673830162)
,p_report_id=>wwv_flow_imp.id(125782256991830161)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125783008666830163)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(125782675552830162)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125784091784830167)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(125783654190830166)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125785059227830170)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(125784688563830169)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>205.7244
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125789056716830180)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(125788667978830179)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>131.723
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125790067505830183)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(125789653739830182)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>158.7287
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125794051458830194)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(125793606458830193)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>112.7287
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125794918371830196)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(125794620127830195)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>145.7287
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125800970133830212)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(125800536769830211)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>278.7287
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125803903513830220)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(125803540146830219)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>160.722
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125804960510830223)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(125804590342830222)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>133.7287
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125805900024830225)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(125805574979830224)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125806947980830228)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(125806583777830227)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(125807996990830231)
,p_view_id=>wwv_flow_imp.id(125782489673830162)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(125807539050830230)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125816179906830253)
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
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125814562701830248)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(125781332603830158)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'EDIT'
,p_button_redirect_url=>'f?p=&APP_ID.:666:&APP_SESSION.::&DEBUG.:666::'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125734441503794705)
,p_name=>'P665_STRATEGY_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125734364197794704)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125734510783794706)
,p_name=>'P665_DESCRIPTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125734364197794704)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT strategy_description',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125734620351794707)
,p_name=>'P665_PROS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125734364197794704)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Advantages'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT pros FROM lkp_chunking_strategy ',
'WHERE strategy_code = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125734775066794708)
,p_name=>'P665_CONS'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(125734364197794704)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Limitations'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT cons FROM lkp_chunking_strategy ',
'WHERE strategy_code = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125734842804794709)
,p_name=>'P665_USE_CASES'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(125734364197794704)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Use Cases'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT use_cases FROM lkp_chunking_strategy ',
'WHERE strategy_code = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125735013990794711)
,p_name=>'P665_DOCS_USING'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125734962543794710)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Documents Using This Strategy'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(*)',
'FROM docs',
'WHERE last_chunking_strategy = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125735108538794712)
,p_name=>'P665_TOTAL_CHUNKS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125734962543794710)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Total Chunks Created'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT SUM(NVL(embedding_count, 0))',
'FROM docs',
'WHERE last_chunking_strategy = :P665_STRATEGY_CODE'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125735281118794713)
,p_name=>'P665_AVG_CHUNKS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125734962543794710)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Average Chunks per Document'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROUND(AVG(embedding_count), 1)',
'FROM docs',
'WHERE last_chunking_strategy = :P665_STRATEGY_CODE',
'AND embedding_count > 0'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(125814811572830249)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(125781332603830158)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125815335741830251)
,p_event_id=>wwv_flow_imp.id(125814811572830249)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125781332603830158)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(125735313637794714)
,p_name=>'Selection Change'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(125781332603830158)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_IG|REGION TYPE|interactivegridselectionchange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125735481872794715)
,p_event_id=>wwv_flow_imp.id(125735313637794714)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P665_STRATEGY_CODE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'this.data.STRATEGY_CODE'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125735505669794716)
,p_event_id=>wwv_flow_imp.id(125735313637794714)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125734364197794704)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125735674910794717)
,p_event_id=>wwv_flow_imp.id(125735313637794714)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125734962543794710)
,p_attribute_01=>'N'
);
wwv_flow_imp.component_end;
end;
/
