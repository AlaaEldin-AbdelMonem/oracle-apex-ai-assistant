prompt --application/pages/page_00004
begin
--   Manifest
--     PAGE: 00004
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
 p_id=>4
,p_name=>'Docs'
,p_alias=>'ENT-AI-DOCS'
,p_page_mode=>'MODAL'
,p_step_title=>'Ent Ai Docs'
,p_autocomplete_on_off=>'OFF'
,p_step_template=>1661186590416509825
,p_page_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_dialog_chained=>'N'
,p_dialog_resizable=>'Y'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(128127375788737081)
,p_plug_name=>'Ent Ai Docs'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'DOCS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(128160348825737190)
,p_plug_name=>'Buttons'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'TEXT',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128160775668737191)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(128160348825737190)
,p_button_name=>'CANCEL'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128162134464737196)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(128160348825737190)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--danger:t-Button--simple'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P4_DOC_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128162491102737197)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(128160348825737190)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P4_DOC_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128162831142737198)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(128160348825737190)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'NEXT'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P4_DOC_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(128164468367737203)
,p_branch_name=>'Redirect to new'
,p_branch_action=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:RP:P3_DOC_ID:&P4_DOC_ID.&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(128162831142737198)
,p_branch_sequence=>10
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(128164856846737204)
,p_branch_name=>'Redirect to all'
,p_branch_action=>'f?p=&APP_ID.:3:&APP_SESSION.::&DEBUG.:RP,3::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_when_button_id=>wwv_flow_imp.id(128162134464737196)
,p_branch_sequence=>20
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128127760732737083)
,p_name=>'P4_DOC_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Id'
,p_source=>'DOC_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128128116240737088)
,p_name=>'P4_DOC_TITLE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Title'
,p_source=>'DOC_TITLE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128128550547737091)
,p_name=>'P4_DOC_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Description'
,p_source=>'DOC_DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>2000
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128128941047737092)
,p_name=>'P4_DOC_CATEGORY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Category'
,p_source=>'DOC_CATEGORY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128129343100737094)
,p_name=>'P4_DOC_TOPIC'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Topic'
,p_source=>'DOC_TOPIC'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>200
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128129708240737095)
,p_name=>'P4_DOC_TAGS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Tags'
,p_source=>'DOC_TAGS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>500
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128130104379737096)
,p_name=>'P4_FILE_NAME'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Name'
,p_source=>'FILE_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128130428072737098)
,p_name=>'P4_FILE_MIME_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Mime Type'
,p_source=>'FILE_MIME_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128130841333737099)
,p_name=>'P4_FILE_BLOB'
,p_source_data_type=>'BLOB'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Blob'
,p_source=>'FILE_BLOB'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_FILE'
,p_cSize=>60
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'allow_multiple_files', 'N',
  'content_disposition', 'attachment',
  'display_as', 'INLINE',
  'display_download_link', 'Y',
  'purge_file_at', 'SESSION',
  'storage_type', 'DB_COLUMN')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128131250093737100)
,p_name=>'P4_FILE_SIZE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Size'
,p_source=>'FILE_SIZE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128131621710737101)
,p_name=>'P4_TEXT_EXTRACTED'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Text Extracted'
,p_source=>'TEXT_EXTRACTED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128132046909737103)
,p_name=>'P4_TEXT_SUMMARY'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Text Summary'
,p_source=>'TEXT_SUMMARY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128132429601737104)
,p_name=>'P4_TEXT_SUMMARY_VECTOR'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Text Summary Vector'
,p_source=>'TEXT_SUMMARY_VECTOR'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128132896198737105)
,p_name=>'P4_CLASSIFICATION_LEVEL'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Classification Level'
,p_source=>'CLASSIFICATION_LEVEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128133282045737107)
,p_name=>'P4_SENSITIVITY_LABEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Sensitivity Label'
,p_source=>'SENSITIVITY_LABEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128133672697737108)
,p_name=>'P4_DOC_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Doc Status'
,p_source=>'DOC_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128134088597737109)
,p_name=>'P4_SOURCE_SYSTEM'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Source System'
,p_source=>'SOURCE_SYSTEM'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128134421742737110)
,p_name=>'P4_LANGUAGE_CODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Language Code'
,p_source=>'LANGUAGE_CODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>10
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128134874618737112)
,p_name=>'P4_RELATED_PROJECT'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Related Project'
,p_source=>'RELATED_PROJECT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128135244295737113)
,p_name=>'P4_FILE_VERSION_NO'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>200
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Version No'
,p_source=>'FILE_VERSION_NO'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128135663374737114)
,p_name=>'P4_FILE_VERSION_LABEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>210
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'File Version Label'
,p_source=>'FILE_VERSION_LABEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>50
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128136001603737115)
,p_name=>'P4_LAST_UPDATED_VERSION'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>220
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Updated Version'
,p_source=>'LAST_UPDATED_VERSION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128136485463737117)
,p_name=>'P4_APPROVAL_USER'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>230
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Approval User'
,p_source=>'APPROVAL_USER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128136878666737118)
,p_name=>'P4_APPROVAL_DATE'
,p_source_data_type=>'DATE'
,p_item_sequence=>240
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Approval Date'
,p_source=>'APPROVAL_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128137294065737119)
,p_name=>'P4_EMBEDDING_MODEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>250
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Embedding Model'
,p_source=>'EMBEDDING_MODEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128137611711737120)
,p_name=>'P4_SUMMARY_MODEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>260
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Summary Model'
,p_source=>'SUMMARY_MODEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128138060727737122)
,p_name=>'P4_RAG_READY_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>270
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Rag Ready Flag'
,p_source=>'RAG_READY_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128138402053737123)
,p_name=>'P4_VECTOR_INDEXED_FLAG'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>280
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Vector Indexed Flag'
,p_source=>'VECTOR_INDEXED_FLAG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128138873717737124)
,p_name=>'P4_RETENTION_PERIOD_DAYS'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>290
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Retention Period Days'
,p_source=>'RETENTION_PERIOD_DAYS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128139208676737125)
,p_name=>'P4_AUDIT_REFERENCE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>300
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Audit Reference'
,p_source=>'AUDIT_REFERENCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128139611725737126)
,p_name=>'P4_CREATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>310
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128140065521737128)
,p_name=>'P4_CREATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>320
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Created At'
,p_source=>'CREATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128140809237737131)
,p_name=>'P4_UPDATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>330
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Updated At'
,p_source=>'UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128141682160737133)
,p_name=>'P4_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>340
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Is Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128142095702737134)
,p_name=>'P4_EMBEDDING_COUNT'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>350
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Embedding Count'
,p_source=>'EMBEDDING_COUNT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128142459569737135)
,p_name=>'P4_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>360
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128142888645737137)
,p_name=>'P4_CHUNKING_STRATEGY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>370
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Chunking Strategy'
,p_source=>'CHUNKING_STRATEGY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128143237115737138)
,p_name=>'P4_CHUNK_SIZE_OVERRIDE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>380
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Chunk Size Override'
,p_source=>'CHUNK_SIZE_OVERRIDE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128143674985737139)
,p_name=>'P4_OVERLAP_PCT_OVERRIDE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>390
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Overlap Pct Override'
,p_source=>'OVERLAP_PCT_OVERRIDE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128144058354737140)
,p_name=>'P4_CHUNKING_NOTES'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>400
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Chunking Notes'
,p_source=>'CHUNKING_NOTES'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>1000
,p_cHeight=>4
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128144475855737142)
,p_name=>'P4_LAST_CHUNKED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>410
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Chunked At'
,p_source=>'LAST_CHUNKED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128145224034737145)
,p_name=>'P4_LAST_CHUNKING_STRATEGY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>420
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Chunking Strategy'
,p_source=>'LAST_CHUNKING_STRATEGY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>30
,p_label_alignment=>'RIGHT'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128145652831737146)
,p_name=>'P4_CREATED_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>430
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Created Date'
,p_source=>'CREATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128146030615737147)
,p_name=>'P4_LAST_UPDATED_DATE'
,p_source_data_type=>'DATE'
,p_is_required=>true
,p_item_sequence=>440
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Updated Date'
,p_source=>'LAST_UPDATED_DATE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>32
,p_cMaxlength=>255
,p_cHeight=>1
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
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
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(128146413997737149)
,p_name=>'P4_LAST_UPDATED_BY'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>450
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Last Updated By'
,p_source=>'LAST_UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_label_alignment=>'RIGHT'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144385566410901)
,p_name=>'P4_CHUNK_STATS_JSON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>460
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Chunk Stats Json'
,p_source=>'CHUNK_STATS_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144409982410902)
,p_name=>'P4_CHUNK_STATS_UPDATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>470
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Chunk Stats Updated At'
,p_source=>'CHUNK_STATS_UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144544597410903)
,p_name=>'P4_RECOMMENDED_STRATEGY'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>480
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Recommended Strategy'
,p_source=>'RECOMMENDED_STRATEGY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>50
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144615567410904)
,p_name=>'P4_RECOMMENDATION_REASON'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>490
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Recommendation Reason'
,p_source=>'RECOMMENDATION_REASON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144787979410905)
,p_name=>'P4_RECOMMENDATION_CONFIDENCE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>500
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Recommendation Confidence'
,p_source=>'RECOMMENDATION_CONFIDENCE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144845461410906)
,p_name=>'P4_RECOMMENDATION_UPDATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>510
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Recommendation Updated At'
,p_source=>'RECOMMENDATION_UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141144941885410907)
,p_name=>'P4_TEXT_ORIGINAL'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>520
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Text Original'
,p_source=>'TEXT_ORIGINAL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145033848410908)
,p_name=>'P4_ENHANCEMENT_APPLIED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>530
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Enhancement Applied'
,p_source=>'ENHANCEMENT_APPLIED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145164286410909)
,p_name=>'P4_ENHANCEMENT_STEPS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>540
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Enhancement Steps'
,p_source=>'ENHANCEMENT_STEPS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145244563410910)
,p_name=>'P4_ENHANCEMENT_STATS'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>550
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Enhancement Stats'
,p_source=>'ENHANCEMENT_STATS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145353100410911)
,p_name=>'P4_ENHANCEMENT_TIMESTAMP'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>560
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Enhancement Timestamp'
,p_source=>'ENHANCEMENT_TIMESTAMP'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DATE_PICKER_APEX'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'display_as', 'POPUP',
  'max_date', 'NONE',
  'min_date', 'NONE',
  'multiple_months', 'N',
  'show_time', 'N',
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145457136410912)
,p_name=>'P4_LANGUAGE_DETECTED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>570
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Language Detected'
,p_source=>'LANGUAGE_DETECTED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>10
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145559652410913)
,p_name=>'P4_TEXT_QUALITY_SCORE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>580
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Text Quality Score'
,p_source=>'TEXT_QUALITY_SCORE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145677539410914)
,p_name=>'P4_STRUCTURE_DETECTED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>590
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Structure Detected'
,p_source=>'STRUCTURE_DETECTED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>100
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145791726410915)
,p_name=>'P4_DOC_TOC_JSON'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>600
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Doc Toc Json'
,p_source=>'DOC_TOC_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145841259410916)
,p_name=>'P4_DOC_INDEX_JSON'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>610
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Doc Index Json'
,p_source=>'DOC_INDEX_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141145959986410917)
,p_name=>'P4_DOC_INTRODUCTION'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>620
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Doc Introduction'
,p_source=>'DOC_INTRODUCTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141146065226410918)
,p_name=>'P4_DOC_EXECUTIVE_SUMMARY'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>630
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Doc Executive Summary'
,p_source=>'DOC_EXECUTIVE_SUMMARY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141146158758410919)
,p_name=>'P4_DOC_PREFACE'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>640
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Doc Preface'
,p_source=>'DOC_PREFACE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141146242323410920)
,p_name=>'P4_HAS_STRUCTURED_SECTIONS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>650
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Has Structured Sections'
,p_source=>'HAS_STRUCTURED_SECTIONS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141146324388410921)
,p_name=>'P4_SECTION_MARKERS_JSON'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>660
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Section Markers Json'
,p_source=>'SECTION_MARKERS_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(141146433492410922)
,p_name=>'P4_FRONT_MATTER_REMOVED'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>670
,p_item_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_item_source_plug_id=>wwv_flow_imp.id(128127375788737081)
,p_prompt=>'Front Matter Removed'
,p_source=>'FRONT_MATTER_REMOVED'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_cMaxlength=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128140539409737130)
,p_validation_name=>'P4_CREATED_AT must be timestamp'
,p_validation_sequence=>310
,p_validation=>'P4_CREATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(128140065521737128)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128141334097737132)
,p_validation_name=>'P4_UPDATED_AT must be timestamp'
,p_validation_sequence=>320
,p_validation=>'P4_UPDATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(128140809237737131)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(128144952867737144)
,p_validation_name=>'P4_LAST_CHUNKED_AT must be timestamp'
,p_validation_sequence=>400
,p_validation=>'P4_LAST_CHUNKED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(128144475855737142)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(128160835609737191)
,p_name=>'Cancel Dialog'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(128160775668737191)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(128161606826737195)
,p_event_id=>wwv_flow_imp.id(128160835609737191)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_DIALOG_CANCEL'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128163620264737200)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(128127375788737081)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form Ent Ai Docs'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>128163620264737200
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128164032701737201)
,p_process_sequence=>50
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_CLOSE_WINDOW'
,p_process_name=>'Close Dialog'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(128162491102737197)
,p_internal_uid=>128164032701737201
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(128163215614737199)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(128127375788737081)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form Ent Ai Docs'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>128163215614737199
);
wwv_flow_imp.component_end;
end;
/
