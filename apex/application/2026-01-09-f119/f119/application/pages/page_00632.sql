prompt --application/pages/page_00632
begin
--   Manifest
--     PAGE: 00632
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
 p_id=>632
,p_name=>'View Chunk Detail'
,p_alias=>'VIEW-CHUNK-DETAIL'
,p_page_mode=>'MODAL'
,p_step_title=>'View Chunk Detail'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(129604360456647820)
,p_plug_name=>'Cunk'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(129605671650647833)
,p_button_sequence=>10
,p_button_name=>'close'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_POSITION_03'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129604437652647821)
,p_name=>'P632_CHUNK_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(129604360456647820)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129604566480647822)
,p_name=>'P632_CHUNK_SEQUENCE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(129604360456647820)
,p_prompt=>'Sequence'
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
 p_id=>wwv_flow_imp.id(129604666157647823)
,p_name=>'P632_CHUNK_SIZE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(129604360456647820)
,p_prompt=>'Chunk Id'
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
 p_id=>wwv_flow_imp.id(129604774875647824)
,p_name=>'P632_FULL_TEXT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(129604360456647820)
,p_prompt=>'Full Text'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>30
,p_colspan=>12
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(129605723571647834)
,p_name=>'closeDialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(129605671650647833)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(129605860977647835)
,p_event_id=>wwv_flow_imp.id(129605723571647834)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CLOSE'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(129604985693647826)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Chunk Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    SELECT ',
'        chunk_sequence,',
'        LENGTH(chunk_text) as chunk_size,',
'        chunk_text',
'    INTO ',
'        :P632_CHUNK_SEQUENCE,',
'        :P632_CHUNK_SIZE,',
'        :P632_FULL_TEXT',
'    FROM doc_chunks',
'    WHERE doc_chunk_id = :P632_CHUNK_ID;',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_error.add_error(',
'            p_message => ''Chunk not found.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>129604985693647826
);
wwv_flow_imp.component_end;
end;
/
