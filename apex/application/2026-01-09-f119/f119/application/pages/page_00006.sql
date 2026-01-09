prompt --application/pages/page_00006
begin
--   Manifest
--     PAGE: 00006
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
 p_id=>6
,p_name=>'JSON Editor'
,p_alias=>'JSON-EDITOR'
,p_step_title=>'JSON Editor'
,p_autocomplete_on_off=>'OFF'
,p_javascript_file_urls=>'#WORKSPACE_FILES#jsonview/jquery.jsonview.min.js'
,p_javascript_code_onload=>' '
,p_css_file_urls=>'#WORKSPACE_FILES#jsonview/jquery.jsonview.min.css'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.jsonview .bool, .jsonview .num {',
'    color: var(--ut-palette-success);',
'}',
'',
'.jsonview .string {',
'    color: var(--ut-palette-info);',
'}',
'',
'.jsonview .null {',
'    color: var(--ut-palette-danger);',
'}',
'',
'.jsonview .collapser {',
'    color: var(--ut-palette-primary-alt);',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'25'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(135398901168142631)
,p_plug_name=>'t'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>3223171818405608528
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(135451835445194802)
,p_plug_name=>'Advanced_Viewer'
,p_title=>'Advanced Editor'
,p_parent_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source_type=>'PLUGIN_COM.APEXJSONVIEWER.PLUGIN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'attribute_01', 'light')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(135451911058194803)
,p_plug_name=>'viewer'
,p_parent_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>'  <pre class="my_json_item">&P6_JSON_TEXT.</pre>'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(135452085009194804)
,p_plug_name=>'Viewer'
,p_region_name=>'json_result'
,p_parent_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_function_body_language=>'PLSQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*declare',
'    l_result clob;',
'begin',
'',
'    for c in ( select MANDATORY_FILTERS from RAG_SOURCE_REGISTRY  where SOURCE_REGISTRY_ID = 3 )',
'',
'    loop',
'        l_result := l_result || ''<pre class="my_json_item">'' || c.MANDATORY_FILTERS || ''</pre>'';',
'    end loop;',
'',
'    return l_result;',
'end;*/',
'',
'',
'begin',
'',
' return   ''<pre class="my_json_item">'' || :P6_JSON_TEXT  || ''</pre>'';',
'end;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_DYNAMIC_CONTENT'
,p_ajax_items_to_submit=>'P6_JSON_TEXT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(135452474409194808)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(135452085009194804)
,p_button_name=>'Collapse_All'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Collapse All'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-expand-collapse'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(135452555163194809)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(135452085009194804)
,p_button_name=>'Expand_All'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Expand All'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-expand'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(135399914025142641)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_button_name=>'SAVE'
,p_button_static_id=>'btnSaveJson'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(135400351090142645)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_button_name=>'FormatJSON'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\D83E\DDE9Format json')
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(135400469629142646)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_button_name=>'Cancel'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'NEXT'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135399038313142632)
,p_name=>'P6_TABLE_NAME'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135399454757142636)
,p_name=>'P6_JSON_TEXT'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135399572395142637)
,p_name=>'P6_ROW_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135399645565142638)
,p_name=>'P6_PK_COLUMN'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135399775517142639)
,p_name=>'P6_COLUMN_NAME'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(135451738267194801)
,p_name=>'P6_READ_ONLY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(135398901168142631)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135400043117142642)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(135399914025142641)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135400173002142643)
,p_event_id=>wwv_flow_imp.id(135400043117142642)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'try {',
'  JSON.parse(window.jsonEditor.getValue());',
'  apex.submit(''SAVE'');',
'} catch (e) {',
'  apex.message.showErrors([{',
'    type: ''error'',',
'    location: ''page'',',
'    message: ''Invalid JSON: '' + e.message,',
'    unsafe: false',
'  }]);',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135400528283142647)
,p_name=>'close dialog'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(135400469629142646)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135400607150142648)
,p_event_id=>wwv_flow_imp.id(135400528283142647)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135400766817142649)
,p_name=>'Beautify JSON'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(135400351090142645)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135400851671142650)
,p_event_id=>wwv_flow_imp.id(135400766817142649)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'try {',
'  var editor = window.jsonEditor;',
'  var obj = JSON.parse(editor.getValue());',
'  editor.setValue(JSON.stringify(obj, null, 2), -1);',
'} catch(e) {',
'  apex.message.alert(''Cannot format: '' + e.message);',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135452187296194805)
,p_name=>'formatJson'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135452252505194806)
,p_event_id=>wwv_flow_imp.id(135452187296194805)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var json = $(''.my_json_item'').text();',
'',
'  $(function() {',
'    $(".my_json_item").JSONView(json, { collapsed: true });',
'  });'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135452618627194810)
,p_name=>'New_1'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(135452555163194809)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135452784133194811)
,p_event_id=>wwv_flow_imp.id(135452618627194810)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Expand All JSON nodes',
'function expand_all() {',
'   var json = $(''.my_json_item'').text();',
'',
'   $(function() {',
'       $(".my_json_item").JSONView(json, { collapsed: false });',
'   }); ',
' }',
'',
' ( apex.region("json_result").refresh() )',
'     .then(() => ( expand_all() )',
' )',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(135452834601194812)
,p_name=>'New_2'
,p_event_sequence=>60
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(135452474409194808)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(135452909615194813)
,p_event_id=>wwv_flow_imp.id(135452834601194812)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Collapse All JSON nodes',
'function collapse_all() {',
'   var json = $(''.my_json_item'').text();',
'',
'   $(function() {',
'       $(".my_json_item").JSONView(json, { collapsed: true });',
'   }); ',
' }',
'',
' ( apex.region("json_result").refresh() )',
'     .then(() => ( collapse_all() )',
' )',
''))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(135400286581142644)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_JSON_DYNAMICALLY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sql VARCHAR2(1000);',
'BEGIN',
'',
'IF :P6_READ_ONLY = ''Y'' THEN',
'    raise_application_error(-20001, ''Page is read-only; cannot save.'');',
'END IF;',
'',
'    apex_json.parse(:P6_JSON_TEXT); -- Validate JSON syntax',
'',
'    IF :P6_PK_COLUMN IS NULL THEN',
'       :P6_PK_COLUMN := ''ID'';',
'    END IF;',
'',
'    v_sql := ''UPDATE '' || :P6_TABLE_NAME ||',
'             '' SET '' || :P6_COLUMN_NAME || '' = :1 '' ||',
'             '' WHERE '' || :P6_PK_COLUMN || '' = :2'';',
'',
'    EXECUTE IMMEDIATE v_sql USING :P6_JSON_TEXT, :P6_ROW_ID;',
'    COMMIT;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(',
'            p_message => ''Failed to save JSON: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_field,',
'            p_page_item_name   => ''P6_JSON_TEXT''',
'        );',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(135399914025142641)
,p_internal_uid=>135400286581142644
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(135399853687142640)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_JSON_DYNAMICALLY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_sql   VARCHAR2(1000);',
'BEGIN',
'    IF :P6_TABLE_NAME IS NOT NULL',
'       AND :P6_COLUMN_NAME IS NOT NULL',
'       AND :P6_ROW_ID IS NOT NULL THEN',
'',
'        IF :P6_PK_COLUMN IS NULL THEN',
'           :P6_PK_COLUMN := ''ID'';',
'        END IF;',
'',
'        v_sql := ''SELECT '' || :P6_COLUMN_NAME ||',
'                 '' FROM '' || :P6_TABLE_NAME ||',
'                 '' WHERE '' || :P6_PK_COLUMN || '' = :1'';',
'',
'        EXECUTE IMMEDIATE v_sql INTO :P6_JSON_TEXT USING :P6_ROW_ID;',
'    END IF;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P6_JSON_TEXT := ''{"error":"Failed to load JSON: '' || SQLERRM || ''"}'';',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>135399853687142640
);
wwv_flow_imp.component_end;
end;
/
