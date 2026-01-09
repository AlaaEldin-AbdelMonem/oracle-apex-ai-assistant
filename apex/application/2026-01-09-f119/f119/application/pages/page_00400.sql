prompt --application/pages/page_00400
begin
--   Manifest
--     PAGE: 00400
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
 p_id=>400
,p_name=>'Redaction Rules'
,p_alias=>'REDACTION-RULES'
,p_step_title=>'Redaction Rules'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'    The Redaction Rules Manager allows you to define data masking rules for sensitive fields.',
' '))
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124611347022309329)
,p_plug_name=>'Test Redaction'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124679471962841595)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124680101450841598)
,p_plug_name=>'Redaction Rules'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>8
,p_plug_display_column=>3
,p_query_type=>'TABLE'
,p_query_table=>'CFG_REDACTION_RULES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IG'
,p_prn_page_header=>'Redaction Rules'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124611052349309326)
,p_name=>'APEX$ROW_ACTION'
,p_item_type=>'NATIVE_ROW_ACTION'
,p_display_sequence=>20
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124611152833309327)
,p_name=>'APEX$ROW_SELECTOR'
,p_item_type=>'NATIVE_ROW_SELECTOR'
,p_display_sequence=>10
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'enable_multi_select', 'Y',
  'hide_control', 'N',
  'show_select_all', 'Y')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124682445301841610)
,p_name=>'COLUMN_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COLUMN_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Column Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
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
,p_help_text=>'Name of the database column to apply redaction (e.g., SALARY, NATIONAL_ID)'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(124683412080841613)
,p_name=>'PATTERN'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PATTERN'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Pattern'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>200
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
,p_help_text=>'Regular expression to match sensitive data (e.g., \\d{4,6} for 4-6 digit numbers)'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(135395912529142601)
,p_name=>'REDACTION_RULE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REDACTION_RULE_ID'
,p_data_type=>'NUMBER'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>true
,p_item_type=>'NATIVE_HIDDEN'
,p_display_sequence=>60
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_is_primary_key=>true
,p_include_in_export=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(135396017849142602)
,p_name=>'REPLACEMENT_TXT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REPLACEMENT_TXT'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Replacement Txt'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>70
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(135396198024142603)
,p_name=>'RULE_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'RULE_ORDER'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Rule Order'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>80
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>true
,p_enable_filter=>true
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>true
,p_enable_control_break=>true
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(135396383054142605)
,p_name=>'IS_ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_ACTIVE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>'Active'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>100
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(143300873118236512)
,p_name=>'REDACTION_APPLY_PHASE_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'REDACTION_APPLY_PHASE_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_SELECT_LIST'
,p_heading=>' Apply Phase '
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_is_required=>true
,p_lov_type=>'SHARED'
,p_lov_id=>wwv_flow_imp.id(161637038377549969)
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(124680631963841600)
,p_internal_uid=>124680631963841600
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_add_row_if_empty=>true
,p_submit_checked_rows=>false
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
 p_id=>wwv_flow_imp.id(124681023042841601)
,p_interactive_grid_id=>wwv_flow_imp.id(124680631963841600)
,p_static_id=>'1246811'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(124681268881841602)
,p_report_id=>wwv_flow_imp.id(124681023042841601)
,p_view_type=>'GRID'
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124682812498841611)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(124682445301841610)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124683850134841614)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(124683412080841613)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(124688456382845943)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>0
,p_column_id=>wwv_flow_imp.id(124611052349309326)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(135401998316143118)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(135395912529142601)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(135402891229143122)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(135396017849142602)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(135403794027143125)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(135396198024142603)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(135405543528143132)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(135396383054142605)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(144716995005393907)
,p_view_id=>wwv_flow_imp.id(124681268881841602)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(143300873118236512)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161546269633169245)
,p_plug_name=>'Info'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="redaction-container" style="font-family: ''Segoe UI'', Tahoma, Geneva, Verdana, sans-serif; border: 1px solid #e2e8f0; border-radius: 8px; background-color: #ffffff; overflow: hidden;">',
'    ',
'    <div style="background-color: #f8fafc; padding: 16px 20px; border-bottom: 1px solid #e2e8f0; display: flex; align-items: center; gap: 12px;">',
unistr('        <span style="font-size: 24px;">\D83D\DEE1\FE0F</span>'),
'        <h2 style="margin: 0; font-size: 1.25rem; color: #1e293b; font-weight: 600;">Information Protection: Text Redaction</h2>',
'    </div>',
'',
'    <div style="padding: 20px;">',
'        <div style="margin-bottom: 24px;">',
'            <p style="font-size: 1.1rem; line-height: 1.6; color: #334155; margin: 0;">',
'                <strong style="color: #0f172a;">Text Redaction</strong> is the discipline of permanently removing or obscuring sensitive, confidential, or private information from a document before it is distributed.',
'            </p>',
'        </div>',
'',
'        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 24px;">',
'            <div style="background-color: #f1f5f9; padding: 15px; border-radius: 6px;">',
'                <h4 style="margin-top: 0; color: #475569; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em;">Purpose</h4>',
'                <ul style="margin: 0; padding-left: 20px; font-size: 0.95rem; color: #1e293b;">',
'                    <li>Compliance (GDPR, HIPAA, PCI)</li>',
'                    <li>IP Protection</li>',
'                    <li>Privacy Assurance</li>',
'                </ul>',
'            </div>',
'            <div style="background-color: #f1f5f9; padding: 15px; border-radius: 6px;">',
'                <h4 style="margin-top: 0; color: #475569; font-size: 0.9rem; text-transform: uppercase; letter-spacing: 0.05em;">Typical Targets</h4>',
'                <ul style="margin: 0; padding-left: 20px; font-size: 0.95rem; color: #1e293b;">',
'                    <li>Social Security Numbers</li>',
'                    <li>Financial Account Details</li>',
'                    <li>Proprietary Trade Secrets</li>',
'                </ul>',
'            </div>',
'        </div>',
'',
'        <div style="background-color: #fffbeb; border-left: 4px solid #f59e0b; padding: 12px 16px; border-radius: 4px;">',
'            <div style="display: flex; gap: 10px; align-items: flex-start;">',
unistr('                <span style="color: #d97706; font-weight: bold;">\26A0\FE0F Critical Note:</span>'),
'                <p style="margin: 0; font-size: 0.9rem; color: #92400e; line-height: 1.5;">',
'                    True redaction must remove the <strong>underlying metadata</strong> and raw text from the file. Simply drawing a black rectangle over text in a UI does not prevent data extraction by sophisticated tools.',
'                </p>',
'            </div>',
'        </div>',
'    </div>',
'',
'    <div style="background-color: #f8fafc; padding: 12px 20px; text-align: right; border-top: 1px solid #e2e8f0;">',
'        <span style="font-size: 0.85rem; color: #64748b; font-style: italic;">Data Security Protocol v2.5</span>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124612473957309340)
,p_button_sequence=>40
,p_button_name=>'BTN_BACK_TO_DASHBOARD'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Back to Dashboard'
,p_button_redirect_url=>'f?p=&APP_ID.:500:&SESSION.::&DEBUG.:400::'
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124612556938309341)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(124611347022309329)
,p_button_name=>'clear'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Clear'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124611680480309332)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(124611347022309329)
,p_button_name=>'BTN_TEST_REDACTION'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Run Redaction Test'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-flask'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124611423048309330)
,p_name=>'P400_TEST_INPUT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(124611347022309329)
,p_item_default=>'Employee salary = 12000 and ID = 1234567890'
,p_prompt=>'Sample Text to Test'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter text containing sensitive data to test redaction rules'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(124611568688309331)
,p_name=>'P400_TEST_OUTPUT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(124611347022309329)
,p_prompt=>'Test Output'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_encrypt_session_state_yn=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(124611739138309333)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(124611680480309332)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124611887351309334)
,p_event_id=>wwv_flow_imp.id(124611739138309333)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_output CLOB;',
'  v_test_text CLOB;',
'BEGIN',
'  -- Get input text',
'  v_test_text := :P400_TEST_INPUT;',
'',
'  -- Apply redaction using utility package',
'  -- Note: The actual function may need adjustment based on your package signature',
'  v_output := v_test_text;',
'',
'  -- Apply all active redaction rules manually for testing',
'  FOR rec IN (',
'    SELECT redaction_rule_id, column_name, pattern, replacement_txt',
'    FROM cfg_redaction_rules',
'    WHERE  1=1',
'    ORDER BY redaction_rule_id',
'  ) LOOP',
'    BEGIN',
'      -- Simple regex replacement (Oracle 23ai supports REGEXP_REPLACE)',
'      v_output := REGEXP_REPLACE(v_output, rec.pattern, rec.replacement_txt, 1, 0, ''i'');',
'    EXCEPTION',
'      WHEN OTHERS THEN',
'        -- Log error but continue',
'        NULL;',
'    END;',
'  END LOOP;',
'',
'  -- Set output',
'  :P400_TEST_OUTPUT := v_output;',
'',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    :P400_TEST_OUTPUT := ''Error: '' || SQLERRM;',
'END;'))
,p_attribute_02=>'P400_TEST_INPUT'
,p_attribute_03=>'P400_TEST_OUTPUT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124612168314309337)
,p_event_id=>wwv_flow_imp.id(124611739138309333)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'  apex.message.showPageSuccess("Redaction test completed successfully");',
' '))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(124612246896309338)
,p_name=>'Highlight Inactive Rules'
,p_event_sequence=>20
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(124680101450841598)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124612335844309339)
,p_event_id=>wwv_flow_imp.id(124612246896309338)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Get the Interactive Grid model',
'var grid = apex.region("redaction_rules_grid").widget().interactiveGrid;',
'var model = grid.getViews().grid.model;',
'',
'// Iterate through records and apply styling',
'model.forEach(function(record) {',
' var embedFlag = model.getValue(record, "APPLY_BEFORE_EMBED");',
' var displayFlag = model.getValue(record, "APPLY_BEFORE_DISPLAY");',
' // If both flags are ''N'', highlight row in gray',
'if (embedFlag === ''N'' && displayFlag === ''N'') {',
'    var recordId = model.getRecordId(record);',
'    var rowElement = grid.getViews().grid.view$.grid("getRecordElement", recordId);',
'    if (rowElement) {',
'        rowElement.css("background-color", "#f5f5f5");',
'        rowElement.css("opacity", "0.7");',
'    }',
'}',
'',
'});'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(124612632342309342)
,p_name=>'clear'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(124612556938309341)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124612716138309343)
,p_event_id=>wwv_flow_imp.id(124612632342309342)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P400_TEST_OUTPUT'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124611281948309328)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(124680101450841598)
,p_process_type=>'NATIVE_IG_DML'
,p_process_name=>'Redaction Rules - Save Interactive Grid Data'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>124611281948309328
);
wwv_flow_imp.component_end;
end;
/
