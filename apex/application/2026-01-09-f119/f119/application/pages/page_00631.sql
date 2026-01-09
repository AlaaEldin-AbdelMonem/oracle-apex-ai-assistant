prompt --application/pages/page_00631
begin
--   Manifest
--     PAGE: 00631
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
 p_id=>631
,p_name=>'Document Text Viewer'
,p_alias=>'DOCUMENT-TEXT-VIEWER'
,p_page_mode=>'MODAL'
,p_step_title=>'&P631_DOC_TITLE.'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'16'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(128259882420285032)
,p_plug_name=>'btn'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>90
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(132482492670108015)
,p_plug_name=>'Doc'
,p_title=>'&P631_DOC_TITLE.'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(132485698015108047)
,p_plug_name=>'info'
,p_region_template_options=>'#DEFAULT#:margin-top-none:margin-bottom-none:margin-left-none:margin-right-none'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128259944483285033)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_FIRST_PAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>unistr('\23EE\FE0F First')
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-page-first'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128260021365285034)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_PREV_PAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\25C0\FE0F Previous')
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128260276846285036)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_NEXT_PAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\25B6\FE0F Next')
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128260368228285037)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_LAST_PAGE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\23ED\FE0F Last')
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128260472206285038)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_DOWNLOAD'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\2B07\FE0FFull  Download ')
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P631_DOC_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-arrow-down-alt'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128260605849285040)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(128259882420285032)
,p_button_name=>'BTN_CLOSE'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Close'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259061722285024)
,p_name=>'P631_DOC_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132482492670108015)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259187582285025)
,p_name=>'P631_DOC_TITLE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132485698015108047)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT doc_title ',
'FROM docs ',
'WHERE doc_id = :P631_DOC_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259257867285026)
,p_name=>'P631_CURRENT_PAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132485698015108047)
,p_item_default=>'1'
,p_prompt=>'Page'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_colspan=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'min_value', '1',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259373859285027)
,p_name=>'P631_PAGE_SIZE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132485698015108047)
,p_item_default=>'10000'
,p_prompt=>' **Characters per Page**'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC(,):5,000 chars500010,000 chars1000020,000 chars20000200,000 chars200000Full Document999999999'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259419626285028)
,p_name=>'P631_TOTAL_PAGES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132485698015108047)
,p_prompt=>'Last Page'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_size NUMBER := NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000);',
'    v_doc_id NUMBER := TO_NUMBER(:P631_DOC_ID);',
'    v_total NUMBER;',
'BEGIN',
'    SELECT CEIL(DBMS_LOB.GETLENGTH(text_extracted) / v_size)',
'    INTO v_total',
'    FROM docs',
'    WHERE doc_id = v_doc_id;',
'    ',
'    RETURN TO_CHAR(v_total);',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        RETURN ''0'';',
'    WHEN VALUE_ERROR THEN',
'        RETURN ''1'';',
'    WHEN OTHERS THEN',
'        RETURN ''1'';',
'END;'))
,p_source_type=>'FUNCTION_BODY'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259515205285029)
,p_name=>'P631_TOTAL_SIZE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(132485698015108047)
,p_prompt=>'Doc Size'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ROUND(DBMS_LOB.GETLENGTH(text_extracted) / 1024, 2) || '' KB''',
'FROM docs',
'WHERE doc_id = :P631_DOC_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128259750464285031)
,p_name=>'P631_TEXT_CONTENT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(132482492670108015)
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT get_doc_text_page(  p_doc_id => :P631_DOC_ID, ',
'                           p_page_num => NVL(TO_NUMBER(:P631_CURRENT_PAGE), 1), ',
'                           p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)  )d',
'  FROM dual;'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cHeight=>30
,p_colspan=>12
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>3031561666792084173
,p_item_template_options=>'t-Form-fieldContainer--stretchInputs'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'Y',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128260739921285041)
,p_name=>'close'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128260605849285040)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128260847828285042)
,p_event_id=>wwv_flow_imp.id(128260739921285041)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132482179614108012)
,p_name=>'Navigate to First Page'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128259944483285033)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132484866716108039)
,p_event_id=>wwv_flow_imp.id(132482179614108012)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    :P631_CURRENT_PAGE := 1;',
'    ',
'    :P631_TEXT_CONTENT := get_doc_text_page(',
'        p_doc_id => :P631_DOC_ID,',
'        p_page_num => 1,',
'        p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'    );',
'END;'))
,p_attribute_02=>'P631_CURRENT_PAGE,P631_PAGE_SIZE,P631_DOC_ID'
,p_attribute_03=>'P631_CURRENT_PAGE,P631_TEXT_CONTENT,P631_TEXT_CONTENT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132482378012108014)
,p_event_id=>wwv_flow_imp.id(132482179614108012)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(132482492670108015)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132484299306108033)
,p_event_id=>wwv_flow_imp.id(132482179614108012)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Refresh_btn'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(128259882420285032)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132482522379108016)
,p_name=>'Navigate to Previous Page'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128260021365285034)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132482611869108017)
,p_event_id=>wwv_flow_imp.id(132482522379108016)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- Decrement page number, don''t go below 1',
'    :P631_CURRENT_PAGE := GREATEST(',
'        NVL(TO_NUMBER(:P631_CURRENT_PAGE), 1) - 1,',
'        1',
'    );',
'    ',
'    -- Update text content',
'    :P631_TEXT_CONTENT := get_doc_text_page(',
'        p_doc_id => :P631_DOC_ID,',
'        p_page_num => TO_NUMBER(:P631_CURRENT_PAGE),',
'        p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'    );',
'END;'))
,p_attribute_02=>'P631_CURRENT_PAGE,P631_PAGE_SIZE,P631_DOC_ID,P631_PAGE_SIZE,P631_DOC_ID'
,p_attribute_03=>'P631_CURRENT_PAGE,P631_TEXT_CONTENT,P631_TEXT_CONTENT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132482720155108018)
,p_event_id=>wwv_flow_imp.id(132482522379108016)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(132482492670108015)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132484314088108034)
,p_event_id=>wwv_flow_imp.id(132482522379108016)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Refresh_btn'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(128259882420285032)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132482876774108019)
,p_name=>'Navigate to Next Page'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128260276846285036)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132482918428108020)
,p_event_id=>wwv_flow_imp.id(132482876774108019)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_current_page NUMBER;',
'    v_total_pages NUMBER;',
'BEGIN',
'    -- Get current values safely',
'    v_current_page := NVL(TO_NUMBER(:P631_CURRENT_PAGE), 1);',
'    ',
'    -- Calculate total pages',
'    SELECT CEIL(DBMS_LOB.GETLENGTH(text_extracted) / NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000))',
'    INTO v_total_pages',
'    FROM docs',
'    WHERE doc_id = :P631_DOC_ID;',
'    ',
'    -- Increment page number, don''t exceed max',
'    IF v_current_page < v_total_pages THEN',
'        :P631_CURRENT_PAGE := v_current_page + 1;',
'    ELSE',
'        :P631_CURRENT_PAGE := v_total_pages;  -- Stay at max',
'    END IF;',
'    ',
'    -- Update text content',
'    :P631_TEXT_CONTENT := get_doc_text_page(',
'        p_doc_id => :P631_DOC_ID,',
'        p_page_num => TO_NUMBER(:P631_CURRENT_PAGE),',
'        p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'    );',
'END;'))
,p_attribute_02=>'P631_CURRENT_PAGE,P631_PAGE_SIZE,P631_DOC_ID'
,p_attribute_03=>'P631_CURRENT_PAGE,P631_TEXT_CONTENT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132483010147108021)
,p_event_id=>wwv_flow_imp.id(132482876774108019)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(132482492670108015)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132484431236108035)
,p_event_id=>wwv_flow_imp.id(132482876774108019)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_name=>'Refresh_btn'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(128259882420285032)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132483127559108022)
,p_name=>'Navigate to Last Page'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128260368228285037)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132483264289108023)
,p_event_id=>wwv_flow_imp.id(132483127559108022)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_total_pages NUMBER;',
'BEGIN',
'    -- Calculate total pages',
'    SELECT CEIL(DBMS_LOB.GETLENGTH(text_extracted) / NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000))',
'    INTO v_total_pages',
'    FROM docs',
'    WHERE doc_id = :P631_DOC_ID;',
'    ',
'    -- Jump to last page',
'    :P631_CURRENT_PAGE := v_total_pages;',
'    ',
'    -- Update text content',
'    :P631_TEXT_CONTENT := get_doc_text_page(',
'        p_doc_id => :P631_DOC_ID,',
'        p_page_num => v_total_pages,',
'        p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'    );',
'END;'))
,p_attribute_02=>'P631_CURRENT_PAGE,P631_PAGE_SIZE,P631_DOC_ID,P631_PAGE_SIZE,P631_DOC_ID'
,p_attribute_03=>'P631_CURRENT_PAGE,P631_TEXT_CONTENT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132483340707108024)
,p_event_id=>wwv_flow_imp.id(132483127559108022)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(132482492670108015)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132484595413108036)
,p_event_id=>wwv_flow_imp.id(132483127559108022)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Refresh_btn'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(128259882420285032)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132485263504108043)
,p_name=>'Jump to Specific Page'
,p_event_sequence=>80
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P631_CURRENT_PAGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132485371812108044)
,p_event_id=>wwv_flow_imp.id(132485263504108043)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_requested_page NUMBER;',
'    v_total_pages NUMBER;',
'    v_final_page NUMBER;',
'BEGIN',
'    -- Get the requested page number (what user typed)',
'    v_requested_page := NVL(TO_NUMBER(:P631_CURRENT_PAGE), 1);',
'    ',
'    -- Calculate total pages from database',
'    SELECT CEIL(DBMS_LOB.GETLENGTH(text_extracted) / NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000))',
'    INTO v_total_pages',
'    FROM docs',
'    WHERE doc_id = :P631_DOC_ID;',
'    ',
'    -- Validate and constrain the page number',
'    v_final_page := v_requested_page;',
'    ',
'    -- Don''t go below 1',
'    IF v_final_page < 1 THEN',
'        v_final_page := 1;',
'    END IF;',
'    ',
'    -- Don''t exceed max pages',
'    IF v_final_page > v_total_pages THEN',
'        v_final_page := v_total_pages;',
'    END IF;',
'    ',
' ',
'    ',
'    -- Update text content',
'    :P631_TEXT_CONTENT := get_doc_text_page(',
'        p_doc_id => :P631_DOC_ID,',
'        p_page_num => v_final_page,',
'        p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'    );',
'    ',
'EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'        -- If user enters invalid input (like ''abc''), default to page 1',
'        :P631_CURRENT_PAGE := 1;',
'        :P631_TEXT_CONTENT := get_doc_text_page(',
'            p_doc_id => :P631_DOC_ID,',
'            p_page_num => 1,',
'            p_page_size => NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000)',
'        );',
'    WHEN NO_DATA_FOUND THEN',
'        -- Document not found',
'        :P631_CURRENT_PAGE := 1;',
'        :P631_TEXT_CONTENT := ''Error: Document not found'';',
'    WHEN OTHERS THEN',
'        -- Any other error',
'        :P631_CURRENT_PAGE := 1;',
'        :P631_TEXT_CONTENT := ''Error: '' || SQLERRM;',
'END;'))
,p_attribute_02=>'P631_CURRENT_PAGE,P631_PAGE_SIZE,P631_DOC_ID'
,p_attribute_03=>'P631_TEXT_CONTENT'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132485431473108045)
,p_event_id=>wwv_flow_imp.id(132485263504108043)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(132482492670108015)
,p_attribute_01=>'N'
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132485504232108046)
,p_event_id=>wwv_flow_imp.id(132485263504108043)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.message.showPageSuccess(''Jumped to page '' + apex.item(''P631_CURRENT_PAGE'').getValue());',
'setTimeout(function() {',
'    apex.message.clearMessages();',
'}, 2000);'))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132579717143302005)
,p_name=>'Ajax_download_txt'
,p_event_sequence=>90
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128260472206285038)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132579858893302006)
,p_event_id=>wwv_flow_imp.id(132579717143302005)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.server.process(''AJAX_DOWNLOAD'', {',
'    x01: apex.item(''P631_DOC_ID'').getValue()',
'}, {',
'    dataType: ''json'',',
'    success: function(data) {',
'        if (data.success) {',
'            var blob = new Blob([data.text], {type: ''text/plain''});',
'            var url = URL.createObjectURL(blob);',
'            var a = document.createElement(''a'');',
'            a.href = url;',
'            a.download = data.filename;',
'            a.click();',
'            URL.revokeObjectURL(url);',
'            apex.message.showPageSuccess(''Downloaded!'');',
'        }',
'    },',
'    error: function() {',
'        apex.message.showErrors([{type: ''error'', message: ''Download failed''}]);',
'    }',
'});'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(129603173679647808)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>' Initialize Page on Entry'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    -- When opening page fresh (from Page 630), reset to page 1',
'    IF :REQUEST = ''MODAL'' THEN',
'        :P631_CURRENT_PAGE := 1;',
'        :P631_PAGE_SIZE := NVL(:P631_PAGE_SIZE, 10000);',
'    END IF;',
'    ',
'    -- Ensure values are never null',
'    :P631_CURRENT_PAGE := NVL(TO_NUMBER(:P631_CURRENT_PAGE), 1);',
'    :P631_PAGE_SIZE := NVL(TO_NUMBER(:P631_PAGE_SIZE), 10000);',
'    ',
'    -- Calculate max pages',
'    SELECT CEIL(DBMS_LOB.GETLENGTH(text_extracted) / TO_NUMBER(:P631_PAGE_SIZE))',
'    INTO :P631_TOTAL_PAGES',
'    FROM docs',
'    WHERE doc_id = :P631_DOC_ID;',
'    ',
'    -- Ensure current page doesn''t exceed max',
'    IF TO_NUMBER(:P631_CURRENT_PAGE) > TO_NUMBER(:P631_TOTAL_PAGES) THEN',
'        :P631_CURRENT_PAGE := :P631_TOTAL_PAGES;',
'    END IF;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P631_CURRENT_PAGE := 1;',
'        :P631_PAGE_SIZE := 10000;',
'        :P631_TOTAL_PAGES := 1;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'MODAL'
,p_process_when_type=>'REQUEST_IN_CONDITION'
,p_internal_uid=>129603173679647808
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128260136461285035)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'init'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'',
'BEGIN',
'    -- Initialize P631_CURRENT_PAGE if null or invalid',
'    IF :P631_CURRENT_PAGE IS NULL OR ',
'       TO_NUMBER(:P631_CURRENT_PAGE) < 1 THEN',
'        :P631_CURRENT_PAGE := ''1'';',
'    END IF;',
'    ',
'    -- Initialize P631_PAGE_SIZE if null or invalid',
'    IF :P631_PAGE_SIZE IS NULL OR ',
'       TO_NUMBER(:P631_PAGE_SIZE) < 1 THEN',
'        :P631_PAGE_SIZE := ''10000'';',
'    END IF;',
'    ',
'    -- Validate P631_DOC_ID',
'    IF :P631_DOC_ID IS NULL THEN',
'        apex_error.add_error(',
'            p_message => ''Document ID is required'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'    END IF;',
'    ',
'EXCEPTION',
'    WHEN VALUE_ERROR THEN',
'        :P631_CURRENT_PAGE := ''1'';',
'        :P631_PAGE_SIZE := ''10000'';',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message => ''Error initializing page: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>128260136461285035
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(132579639521302004)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'AJAX_DOWNLOAD'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_text CLOB;',
'    v_filename VARCHAR2(255);',
'BEGIN',
'    SELECT text_extracted, NVL(file_name, ''document'') || ''_extracted.txt''',
'    INTO v_text, v_filename',
'    FROM docs',
'    WHERE doc_id = TO_NUMBER(apex_application.g_x01);',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''text'', v_text);',
'    apex_json.write(''filename'', v_filename);',
'    apex_json.write(''success'', true);',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>132579639521302004
);
wwv_flow_imp.component_end;
end;
/
