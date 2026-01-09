prompt --application/pages/page_00116
begin
--   Manifest
--     PAGE: 00116
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
 p_id=>116
,p_name=>'Report Issue'
,p_alias=>'REPORT-ISSUE'
,p_page_mode=>'MODAL'
,p_step_title=>'Report Issue'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ============================================================================',
'   PAGE 116 - REPORT ISSUE DIALOG',
'   ============================================================================ */',
'',
'// Display issue context info',
'const issueLevel  = apex.item(''P116_ISSUE_LEVEL'').getValue();',
'const entityId    = apex.item(''P116_ENTITY_ID'').getValue();',
'const messageText = apex.item(''P116_MESSAGE_TEXT'').getValue();',
'',
'const firstRegion = document.querySelector(''.t-Region-body'');',
'',
unistr('console.log(''\D83D\DCCB Report Issue Dialog Opened'');'),
'console.log(''   Level:'', issueLevel);',
'console.log(''   Entity ID:'', entityId);',
'console.log(''   Message Preview:'', messageText ? messageText.substring(0, 50) + ''...'' : ''N/A'');',
'',
'// Add context info',
'if (issueLevel === ''CALL'' && messageText && firstRegion) {',
'',
'    const contextDiv = document.createElement(''div'');',
'    contextDiv.style.cssText = `',
'        background: #f0f9ff;',
'        border-left: 4px solid #0ea5e9;',
'        padding: 12px;',
'        margin-bottom: 16px;',
'        border-radius: 4px;',
'        font-size: 13px;',
'        display: flex;',
'        align-items: center;',
'        gap: 6px;',
'        white-space: nowrap;',
'    `;',
'',
'    contextDiv.innerHTML = `',
unistr('        <span style="font-weight:600;">\D83D\DCE8 Reporting issue for call</span>'),
unistr('        <span style="color:#64748b;">\2014 Call ID: ${entityId}</span>'),
'    `;',
'',
'    firstRegion.insertBefore(contextDiv, firstRegion.firstChild);',
'',
'} else if (issueLevel === ''SESSION'' && firstRegion) {',
'',
'    const contextDiv = document.createElement(''div'');',
'    contextDiv.style.cssText = `',
'        background: #fef3c7;',
'        border-left: 4px solid #f59e0b;',
'        padding: 12px;',
'        margin-bottom: 16px;',
'        border-radius: 4px;',
'        font-size: 13px;',
'        display: flex;',
'        align-items: center;',
'        gap: 6px;',
'        white-space: nowrap;',
'    `;',
'',
'    contextDiv.innerHTML = `',
unistr('        <span style="font-weight:600;">\D83D\DCAC Reporting issue for entire session</span>'),
unistr('        <span style="color:#64748b;">\2014 Session ID: ${entityId}</span>'),
'    `;',
'',
'    firstRegion.insertBefore(contextDiv, firstRegion.firstChild);',
'}',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'css/* ============================================================================',
'   PAGE 116 - REPORT ISSUE DIALOG',
'   ============================================================================ */',
'',
'/* Dialog Container */',
'.t-Dialog-page {',
'    max-width: 800px !important;',
'}',
'',
'.t-Dialog-body {',
'    padding: 24px;',
'    background: #f9fafb;',
'}',
'',
'/* Issue Type Cards */',
'.issue-type-card {',
'    display: flex;',
'    align-items: flex-start;',
'    gap: 12px;',
'    padding: 12px;',
'    background: white;',
'    border: 2px solid #e2e8f0;',
'    border-radius: 8px;',
'    cursor: pointer;',
'    transition: all 0.2s ease;',
'    margin-bottom: 8px;',
'}',
'',
'.issue-type-card:hover {',
'    border-color: #3b82f6;',
'    background: #eff6ff;',
'    transform: translateX(2px);',
'}',
'',
'.issue-type-card.selected {',
'    border-color: #3b82f6;',
'    background: #eff6ff;',
'}',
'',
'.issue-type-icon {',
'    font-size: 24px;',
'    flex-shrink: 0;',
'    width: 40px;',
'    height: 40px;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    background: #f1f5f9;',
'    border-radius: 8px;',
'}',
'',
'.issue-type-content h4 {',
'    margin: 0 0 4px 0;',
'    font-size: 14px;',
'    font-weight: 600;',
'    color: #1e293b;',
'}',
'',
'.issue-type-content p {',
'    margin: 0;',
'    font-size: 12px;',
'    color: #64748b;',
'    line-height: 1.4;',
'}',
'',
'/* Category Badges */',
'.category-badge {',
'    display: inline-block;',
'    padding: 2px 8px;',
'    border-radius: 12px;',
'    font-size: 10px;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'    letter-spacing: 0.5px;',
'}',
'',
'.category-badge.accuracy {',
'    background: #fee2e2;',
'    color: #991b1b;',
'}',
'',
'.category-badge.quality {',
'    background: #dbeafe;',
'    color: #1e40af;',
'}',
'',
'.category-badge.safety {',
'    background: #fef3c7;',
'    color: #92400e;',
'}',
'',
'.category-badge.technical {',
'    background: #f3e8ff;',
'    color: #6b21a8;',
'}',
'',
'/* Form Fields */',
'.t-Form-fieldContainer {',
'    margin-bottom: 20px;',
'}',
'',
'.t-Form-label {',
'    font-weight: 600;',
'    color: #334155;',
'    margin-bottom: 8px;',
'}',
'',
'.apex-item-text,',
'.apex-item-textarea,',
'.apex-item-select {',
'    border: 2px solid #e2e8f0;',
'    border-radius: 8px;',
'    padding: 10px 12px;',
'    font-size: 14px;',
'    transition: all 0.2s ease;',
'}',
'',
'.apex-item-text:focus,',
'.apex-item-textarea:focus,',
'.apex-item-select:focus {',
'    border-color: #3b82f6;',
'    outline: none;',
'    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);',
'}',
'',
'/* File Upload Area */',
'.apex-item-file {',
'    border: 2px dashed #cbd5e1;',
'    border-radius: 8px;',
'    padding: 24px;',
'    text-align: center;',
'    background: white;',
'    transition: all 0.2s ease;',
'}',
'',
'.apex-item-file:hover {',
'    border-color: #3b82f6;',
'    background: #eff6ff;',
'}',
'',
'/* Help Text */',
'.t-Form-helpText {',
'    font-size: 12px;',
'    color: #64748b;',
'    margin-top: 6px;',
'    font-style: italic;',
'}',
'',
'/* Buttons */',
'.t-Button {',
'    padding: 10px 20px;',
'    border-radius: 8px;',
'    font-weight: 600;',
'    font-size: 14px;',
'    transition: all 0.2s ease;',
'}',
'',
'.t-Button--hot {',
'    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);',
'    border: none;',
'}',
'',
'.t-Button--hot:hover {',
'    transform: translateY(-2px);',
'    box-shadow: 0 4px 12px rgba(59, 130, 246, 0.4);',
'}',
'',
'/* Region Headers */',
'.t-Region-header {',
'    background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);',
'    border-bottom: 2px solid #e2e8f0;',
'    padding: 16px 20px;',
'}',
'',
'.t-Region-title {',
'    font-weight: 700;',
'    color: #1e293b;',
'    font-size: 16px;',
'}',
'',
'/* Priority Indicator */',
'.priority-low { color: #10b981; }',
'.priority-medium { color: #f59e0b; }',
'.priority-high { color: #ef4444; }',
'.priority-critical { ',
'    color: #dc2626; ',
'    font-weight: 700;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_comment=>'User will use this page to create the issue'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(147673252283110416)
,p_plug_name=>'hiddenItems'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(147673866936110422)
,p_plug_name=>'Issue Details'
,p_title=>'Issue Details'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(147675624651110440)
,p_plug_name=>'btn'
,p_parent_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>70
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(147674730803110431)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(147675624651110440)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Cancel'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-left'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(147674529946110429)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(147675624651110440)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_icon_css_classes=>'fa-save'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673366895110417)
,p_name=>'P116_ISSUE_LEVEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(147673252283110416)
,p_item_default=>'MESSAGE'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673410671110418)
,p_name=>'P116_ENTITY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(147673252283110416)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673569520110419)
,p_name=>'P116_MESSAGE_TEXT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(147673252283110416)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673609586110420)
,p_name=>'P116_BROWSER_INFO'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(147673252283110416)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673753501110421)
,p_name=>'P116_ISSUE_ID'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(147673252283110416)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147673940409110423)
,p_name=>'P116_ISSUE_TYPE_CODE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_prompt=>'Issue Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT issue_type_name || '' - '' || issue_description AS display_value,',
'                                              issue_type_code AS return_value',
'                                       FROM lkp_issue_types',
'                                       WHERE is_active = ''Y''',
'                                       ORDER BY display_order'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147674027018110424)
,p_name=>'P116_ISSUE_TITLE'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_prompt=>'Issue Title'
,p_placeholder=>'Brief description of the issue'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147674172425110425)
,p_name=>'P116_ISSUE_DESCRIPTION'
,p_is_required=>true
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_prompt=>'Issue Description'
,p_placeholder=>'Please provide as much detail as possible about the issue...'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>8
,p_colspan=>12
,p_field_template=>2040785906935475274
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147674216078110426)
,p_name=>'P116_PRIORITY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_item_default=>'MEDIUM'
,p_prompt=>'Priority'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CHAT_ISSUE_PRIORITY'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(147674342715110427)
,p_name=>'P116_ATTACHMENT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(147673866936110422)
,p_prompt=>'Attach Files'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'Y',
  'display_as', 'DROPZONE_BLOCK',
  'file_types', '.doc,.docx,.pdf,.txt,.csv,.html,.htm,.md,.png,.jpg,.jpeg,.gif',
  'max_file_size', '10000',
  'purge_file_at', 'REQUEST',
  'storage_type', 'APEX_APPLICATION_TEMP_FILES')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(147674893626110432)
,p_name=>'Close Dialog on Cancel'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(147674730803110431)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(147674978860110433)
,p_event_id=>wwv_flow_imp.id(147674893626110432)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(148845946356293947)
,p_name=>'Init Region items'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(148846059782293948)
,p_event_id=>wwv_flow_imp.id(148845946356293947)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P116_ISSUE_TYPE_CODE    := NULL;',
':P116_MESSAGE_TEXT      := NULL;',
':P116_ISSUE_DESCRIPTION := NULL;',
':P116_PRIORITY           := ''MEDIUM'';'))
,p_attribute_03=>'P116_ISSUE_TYPE_CODE,P116_MESSAGE_TEXT,P116_ISSUE_DESCRIPTION,P116_PRIORITY'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(155687651576186612)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_EXECUTION_CHAIN'
,p_process_name=>'SAVE_ISSUE'
,p_attribute_01=>'N'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(147674529946110429)
,p_internal_uid=>155687651576186612
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(147674457773110428)
,p_process_sequence=>40
,p_parent_process_id=>wwv_flow_imp.id(155687651576186612)
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_ISSUE_REPORT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'    v_issue_id              NUMBER;',
'    v_user_id               NUMBER := v(''G_USER_ID'');',
'    v_session_id            NUMBER;',
'    v_call_id               NUMBER;',
'    v_issue_level           VARCHAR2(20);',
'    v_issue_type_code       VARCHAR2(50);',
'    v_issue_title           VARCHAR2(200);',
'    v_issue_description     CLOB;',
'    v_priority              VARCHAR2(20);',
'    v_browser_info          VARCHAR2(4000);',
'    v_attachment_count      NUMBER := 0;',
'',
'BEGIN',
'    apex_debug.enable(p_level => apex_debug.c_log_level_info);',
'    debug_util.init(p_module_name => ''PAGE_116'');',
'    debug_util.info(''Starting issue report submission'');',
'',
'    BEGIN',
'        -- Read values',
'        v_issue_level        := UPPER(TRIM(:P116_ISSUE_LEVEL));',
'        v_issue_type_code    := :P116_ISSUE_TYPE_CODE;',
'        v_issue_title        := TRIM(:P116_ISSUE_TITLE);',
'        v_issue_description  := :P116_ISSUE_DESCRIPTION;',
'        v_priority           := :P116_PRIORITY;',
'        v_browser_info       := :P116_BROWSER_INFO;',
'',
'        -- Resolve context',
'        IF v_issue_level = ''MESSAGE'' THEN',
'            v_call_id := TO_NUMBER(:P116_ENTITY_ID);',
'            SELECT chat_session_id INTO v_session_id',
'            FROM chat_calls WHERE call_id = v_call_id;',
'',
'        ELSIF v_issue_level = ''SESSION'' THEN',
'            v_session_id := TO_NUMBER(:P116_ENTITY_ID);',
'            v_call_id := NULL;',
'',
'        ELSE',
'            RAISE_APPLICATION_ERROR(-20001, ''Invalid issue level: '' || v_issue_level);',
'        END IF;',
'',
'        -- Required checks',
'        IF v_issue_type_code IS NULL THEN',
'            RAISE_APPLICATION_ERROR(-20002, ''Issue type is required'');',
'        END IF;',
'',
'        IF v_issue_title IS NULL THEN',
'            RAISE_APPLICATION_ERROR(-20003, ''Issue title is required'');',
'        END IF;',
'',
'        IF v_session_id IS NULL THEN',
'            RAISE_APPLICATION_ERROR(-20004, ''Invalid session context'');',
'        END IF;',
'',
'        debug_util.info(''Creating issue report...'');',
'',
'        -- Create issue',
'        INSERT INTO chat_issues (',
'            CHAT_ISSUE_LEVEL_CODE,',
'            chat_call_id,',
'            chat_session_id,',
'            chat_issue_type_code,',
'            issue_title,',
'            issue_description,',
'            user_id,',
'            username,',
'            CHAT_ISSUE_PRIORITY_CODE,',
'            CHAT_ISSUE_STATUS_CODE,',
'            browser_info,',
'            user_agent,',
'            page_url',
'        ) VALUES (',
'            v_issue_level,',
'            v_call_id,',
'            v_session_id,',
'            v_issue_type_code,',
'            v_issue_title,',
'            v_issue_description,',
'            v_user_id,',
'            :APP_USER,',
'            v_priority,',
'            ''NW'',',
'            v_browser_info,',
'            SUBSTR(owa_util.get_cgi_env(''HTTP_USER_AGENT''), 1, 500),',
'            SUBSTR(owa_util.get_cgi_env(''REQUEST_URI''), 1, 2000)',
'        ) RETURNING chat_issue_id INTO v_issue_id;',
'',
'        debug_util.info(''Issue created with ID: '' || v_issue_id);',
'',
'        ----------------------------------------------------------------------',
'        -- Handle MULTIPLE ATTACHMENTS (APEX 24.2)',
'        ----------------------------------------------------------------------',
'        IF :P116_ATTACHMENT IS NOT NULL THEN',
'            DECLARE',
'                l_file_names apex_t_varchar2;',
'                l_file       apex_application_temp_files%ROWTYPE;',
'            BEGIN',
'                -- Split names (multiple files)',
'                l_file_names := apex_string.split(:P116_ATTACHMENT, '':'');',
'',
'                FOR i IN 1 .. l_file_names.count LOOP',
'',
'                    -- Read the temp file',
'                    SELECT *',
'                      INTO l_file',
'                      FROM apex_application_temp_files',
'                     WHERE name = l_file_names(i);',
'',
'                    -- Insert into permanent table',
'                    INSERT INTO chat_issue_attachments (',
'                        chat_issue_id,',
'                        attachment_name,',
'                        attachment_type,',
'                        attachment_size,',
'                        attachment_blob',
'                    ) VALUES (',
'                        v_issue_id,',
'                        l_file.filename,',
'                        l_file.mime_type,',
'                        DBMS_LOB.getlength(l_file.blob_content),',
'                        l_file.blob_content',
'                    );',
'',
'                    v_attachment_count := v_attachment_count + 1;',
'',
'                    -- cleanup temp file',
'                    DELETE FROM apex_application_temp_files',
'                     WHERE name = l_file_names(i);',
'',
'                END LOOP;',
'            END;',
'        END IF;',
'',
'        -- Update issue with attachment metadata',
'        IF v_attachment_count > 0 THEN',
'            UPDATE chat_issues',
'               SET attachment_count = v_attachment_count,',
'                   has_screenshot = CASE ',
'                       WHEN EXISTS (',
'                           SELECT 1 FROM chat_issue_attachments',
'                           WHERE chat_issue_id = v_issue_id',
'                             AND attachment_type LIKE ''image%''',
'                       ) THEN ''Y''',
'                       ELSE ''N''',
'                   END',
'             WHERE chat_issue_id = v_issue_id;',
'',
'            debug_util.info(''Saved '' || v_attachment_count || '' attachments'');',
'        END IF;',
'',
'        :P116_ISSUE_ID := v_issue_id;',
'',
'      --  COMMIT;',
'',
'        apex_application.g_print_success_message :=',
'            ''Issue #'' || v_issue_id ||',
'            '' reported successfully. Our team will review it shortly.'';',
'',
'    EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        debug_util.error(',
'          ''Invalid context. ISSUE_LEVEL='' || v_issue_level ||  '', ENTITY_ID='' || :P116_ENTITY_ID );',
'        RAISE_APPLICATION_ERROR(  -20010,  ''Invalid issue context. Please refresh and try again.'' );',
'',
'    WHEN OTHERS THEN',
'        debug_util.error(''SAVE_ISSUE_REPORT failed: '' || SQLERRM);',
'        RAISE;',
' ',
'    END;',
'',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Issue Error !'
,p_process_success_message=>'Issue Reported !'
,p_internal_uid=>147674457773110428
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(155687550088186611)
,p_process_sequence=>50
,p_parent_process_id=>wwv_flow_imp.id(155687651576186612)
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_attribute_02=>'Y'
,p_internal_uid=>155687550088186611
);
wwv_flow_imp.component_end;
end;
/
