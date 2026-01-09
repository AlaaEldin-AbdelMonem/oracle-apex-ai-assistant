prompt --application/pages/page_00635
begin
--   Manifest
--     PAGE: 00635
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
 p_id=>635
,p_name=>'Chunking Configuration'
,p_alias=>'CHUNKING-CONFIGURATION'
,p_page_mode=>'MODAL'
,p_step_title=>'Chunking Configuration'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125683196445257450)
,p_plug_name=>'1'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125707594410557102)
,p_plug_name=>'Select Chunking Strategy'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125707930401557106)
,p_plug_name=>'Strategy Details'
,p_icon_css_classes=>'fa-info-circle'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(125708461412557111)
,p_name=>'Chunk Preview (First 5 Chunks)'
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
' chunk_sequence,',
' LENGTH(chunk_text) as chunk_size,',
' SUBSTR(chunk_text, 1, 150) || ''...'' as preview',
'FROM (',
' SELECT ',
'     ROWNUM as chunk_sequence,',
'     chunk_text,',
'     LENGTH(chunk_text) as chunk_size',
' FROM (',
'     -- This is a simplified preview',
'     -- In production, you''d call the chunking function',
'     SELECT SUBSTR(text_extracted, ',
'                   ((LEVEL-1) * :P635_CHUNK_SIZE) + 1, ',
'                   :P635_CHUNK_SIZE) as chunk_text',
'     FROM docs',
'     WHERE doc_id = :P635_DOC_ID',
'     CONNECT BY LEVEL <= CEIL(LENGTH(text_extracted) / :P635_CHUNK_SIZE)',
' )',
' WHERE ROWNUM <= 5',
')'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P635_CHUNK_SIZE'
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
 p_id=>wwv_flow_imp.id(125708534153557112)
,p_query_column_id=>1
,p_column_alias=>'CHUNK_SEQUENCE'
,p_column_display_sequence=>10
,p_column_heading=>'Chunk Sequence'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125708613235557113)
,p_query_column_id=>2
,p_column_alias=>'CHUNK_SIZE'
,p_column_display_sequence=>20
,p_column_heading=>'Chunk Size'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125708770442557114)
,p_query_column_id=>3
,p_column_alias=>'PREVIEW'
,p_column_display_sequence=>30
,p_column_heading=>'Preview'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125709399994557120)
,p_button_sequence=>10
,p_button_name=>'APPLY_GENERATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply & Generate Chunks'
,p_button_position=>'REGION_POSITION_03'
,p_grid_new_row=>'Y'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125709471430557121)
,p_button_sequence=>20
,p_button_name=>'SAVE_CONFIG'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save Configuration Only'
,p_button_position=>'REGION_POSITION_03'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125709574364557122)
,p_button_sequence=>30
,p_button_name=>'CANCEL'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'REGION_POSITION_03'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(125709772994557124)
,p_branch_name=>'goto 630'
,p_branch_action=>'f?p=&APP_ID.:630:&SESSION.::&DEBUG.:630:P630_DOC_ID:&P635_DOC_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125707451188557101)
,p_name=>'P635_DOC_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125683196445257450)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125707616171557103)
,p_name=>'P635_STRATEGY'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125707594410557102)
,p_prompt=>'Chunking Strategy'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    strategy_name || '' - '' || ',
'    SUBSTR(best_for, 1, 50) as display_value,',
'    strategy_code as return_value',
'FROM lkp_chunking_strategy',
'WHERE is_active = ''Y''',
'ORDER BY display_order'))
,p_lov_display_null=>'YES'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125707710971557104)
,p_name=>'P635_CHUNK_SIZE'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125707594410557102)
,p_item_default=>'512'
,p_prompt=>'Chunk Size'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '8000',
  'min_value', '50',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125707883649557105)
,p_name=>'P635_OVERLAP_PCT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125707594410557102)
,p_item_default=>'20'
,p_prompt=>'Overlap Percentage'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'- Minimum Value: `0`',
'- Maximum Value: `50`',
'- Step: `5`',
'- Default Value: `20`'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '50',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125708092823557107)
,p_name=>'P635_STRATEGY_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125707930401557106)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Strategy '
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT strategy_name',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = :P635_STRATEGY'))
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
 p_id=>wwv_flow_imp.id(125708134320557108)
,p_name=>'P635_STRATEGY_DESC'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125707930401557106)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Description'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'SELECT strategy_description',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = :P635_STRATEGY'))
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
 p_id=>wwv_flow_imp.id(125708245594557109)
,p_name=>'P635_METRICS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125707930401557106)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Performance'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
unistr('  ''\26A1 Speed: '' || relative_speed || ''x  |  '' ||'),
unistr('  ''\D83D\DCBE Storage: '' || storage_overhead || ''x  |  '' ||'),
unistr('  ''\2B50 Quality: '' || semantic_preservation'),
'FROM lkp_chunking_strategy',
'WHERE strategy_code = :P635_STRATEGY'))
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
 p_id=>wwv_flow_imp.id(125708321857557110)
,p_name=>'P635_BEST_FOR'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(125707930401557106)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Best For'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT best_for',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = :P635_STRATEGY'))
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
 p_id=>wwv_flow_imp.id(125708894014557115)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P635_STRATEGY'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125708944371557116)
,p_event_id=>wwv_flow_imp.id(125708894014557115)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_chunk_size NUMBER;',
'    v_overlap NUMBER;',
'BEGIN',
'    SELECT default_chunk_size, default_overlap_pct',
'    INTO v_chunk_size, v_overlap',
'    FROM lkp_chunking_strategy',
'    WHERE strategy_code = :P635_STRATEGY;',
'',
'    :P635_CHUNK_SIZE := v_chunk_size;',
'    :P635_OVERLAP_PCT := v_overlap;',
'END;'))
,p_attribute_02=>'P635_STRATEGY'
,p_attribute_03=>'P635_CHUNK_SIZE,P635_OVERLAP_PCT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125709098006557117)
,p_event_id=>wwv_flow_imp.id(125708894014557115)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125707930401557106)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125709188692557118)
,p_event_id=>wwv_flow_imp.id(125708894014557115)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125708461412557111)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125709666287557123)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Apply and Generate Chunks'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'v_chunk_count NUMBER;',
'BEGIN',
'-- Update configuration',
'UPDATE docs',
'SET chunking_strategy = :P635_STRATEGY,',
'   chunk_size_override = :P635_CHUNK_SIZE,',
'   overlap_pct_override = :P635_OVERLAP_PCT',
'WHERE doc_id = :P635_DOC_ID;',
'/*',
'-- Generate chunks',
'v_chunk_count := CHUNK_PROXY_UTIL.chunk_document_intelligent(',
'   p_doc_id => :P635_DOC_ID,',
'   p_force_strategy => :P635_STRATEGY,',
'   p_force_chunk_size => :P635_CHUNK_SIZE,',
'   p_force_overlap_pct => :P635_OVERLAP_PCT',
');',
'*/',
'apex_application.g_print_success_message := ',
'   ''Configuration applied and '' || v_chunk_count || '' chunks generated!'';',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(125709399994557120)
,p_internal_uid=>125709666287557123
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125709821593557125)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Configuration'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE docs',
'SET chunking_strategy = :P635_STRATEGY,',
'chunk_size_override = :P635_CHUNK_SIZE,',
'overlap_pct_override = :P635_OVERLAP_PCT',
'WHERE doc_id = :P635_DOC_ID;',
'apex_application.g_print_success_message := ''Configuration saved!'';'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(125709471430557121)
,p_internal_uid=>125709821593557125
);
wwv_flow_imp.component_end;
end;
/
