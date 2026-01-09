prompt --application/pages/page_00704
begin
--   Manifest
--     PAGE: 00704
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
 p_id=>704
,p_name=>'deployments Edit'
,p_alias=>'DEPLOYMENTS-EDIT'
,p_step_title=>'deployments Edit'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Initialize form based on deployment type',
'(function() {',
'    // Hide conditional regions on load',
'    $(''#region_shadow_config'').hide();',
'    $(''#region_canary_config'').hide();',
'    $(''#region_ab_test_config'').hide();',
'    ',
'    // Show appropriate region based on current type',
'    var deploymentType = apex.item(''P704_DEPLOYMENT_TYPE'').getValue();',
'    if (deploymentType === ''SHADOW'') {',
'        $(''#region_shadow_config'').show();',
'    } else if (deploymentType === ''CANARY'') {',
'        $(''#region_canary_config'').show();',
'    } else if (deploymentType === ''AB_TEST'') {',
'        $(''#region_ab_test_config'').show();',
'    }',
'    ',
'    // Sync slider with number field',
'    var syncSlider = function() {',
'        var percentage = apex.item(''P704_ROLLOUT_PERCENTAGE'').getValue();',
'        apex.item(''P704_ROLLOUT_SLIDER'').setValue(percentage);',
'    };',
'    ',
'    apex.item(''P704_ROLLOUT_PERCENTAGE'').onChange = syncSlider;',
'    syncSlider(); // Initial sync',
'    ',
'    // JSON syntax highlighting enhancement',
'    if (typeof monaco !== ''undefined'') {',
'        // Monaco editor is available, enhance JSON fields',
'        console.log(''Monaco editor available for JSON editing'');',
'    }',
'})();'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Modal dialog customization */',
'.deployment-form-dialog .t-DialogRegion {',
'    max-width: 900px;',
'}',
'',
'/* Form sections */',
'.t-Region-header {',
'    background: #f8f9fa;',
'    border-bottom: 2px solid #dee2e6;',
'    padding: 0.75rem 1rem;',
'}',
'',
'/* JSON editor enhancement */',
'.apex-item-textarea.monaco-editor {',
'    font-family: ''Monaco'', ''Menlo'', ''Ubuntu Mono'', ''Consolas'', monospace;',
'    font-size: 0.9rem;',
'}',
'',
'/* Rollout percentage slider */',
'input[type="range"] {',
'    width: 100%;',
'    margin: 0.5rem 0;',
'}',
'',
'input[type="range"]::-webkit-slider-thumb {',
'    background: #0d6efd;',
'}',
'',
'/* Required field indicator */',
'.is-required label::after {',
'    content: '' *'';',
'    color: #dc3545;',
'    font-weight: bold;',
'}',
'',
'/* Conditional region styling */',
'#region_shadow_config,',
'#region_canary_config,',
'#region_ab_test_config {',
'    border-left: 4px solid #0d6efd;',
'    padding-left: 1rem;',
'}',
'',
'/* Help text styling */',
'.apex-item-help {',
'    font-size: 0.85rem;',
'    color: #6c757d;',
'    font-style: italic;',
'}',
'',
'/* Button styling */',
'button[data-action="SAVE"] {',
'    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);',
'    border: none;',
'    padding: 0.75rem 2rem;',
'    font-weight: 600;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'02'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158174175277674236)
,p_plug_name=>'Targeting & Segmentation'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158174216399674237)
,p_plug_name=>'Metadata'
,p_region_template_options=>'#DEFAULT#:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158708742760133367)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158709440655133419)
,p_plug_name=>'deployments Edit'
,p_title=>'deployments '
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'DEPLOYMENT_VERSIONS'
,p_include_rowid_column=>false
,p_is_editable=>true
,p_edit_operations=>'i:u:d'
,p_lost_update_check_type=>'VALUES'
,p_plug_source_type=>'NATIVE_FORM'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158173071198674225)
,p_plug_name=>'Basic Information'
,p_parent_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158173158555674226)
,p_plug_name=>'Shadow_Configuration'
,p_title=>'Shadow Configuration'
,p_region_name=>'region_shadow_config'
,p_parent_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>140
,p_location=>null
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P704_DEPLOYMENT_TYPE'
,p_plug_display_when_cond2=>'SHADOW'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158173266640674227)
,p_plug_name=>'Model Configuration'
,p_parent_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>130
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158173975587674234)
,p_plug_name=>'Canary Configuration'
,p_region_name=>'region_canary_config'
,p_parent_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>150
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158174009481674235)
,p_plug_name=>'A/B Test Configuration'
,p_region_name=>'region_ab_test_config'
,p_parent_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>210
,p_location=>null
,p_plug_display_condition_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_plug_display_when_condition=>'P704_DEPLOYMENT_TYPE'
,p_plug_display_when_cond2=>'AB_TEST'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158731941116133494)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_button_name=>'SAVE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Apply Changes'
,p_button_position=>'CHANGE'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P704_DEPLOYMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'UPDATE'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158730962892133491)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_button_name=>'CANCEL'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_button_alignment=>'RIGHT'
,p_button_redirect_url=>'f?p=&APP_ID.:702:&APP_SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158732350472133495)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_button_name=>'CREATE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'CREATE'
,p_button_alignment=>'RIGHT'
,p_button_condition=>'P704_DEPLOYMENT_ID'
,p_button_condition_type=>'ITEM_IS_NULL'
,p_database_action=>'INSERT'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158731507898133493)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_button_name=>'DELETE'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Delete'
,p_button_position=>'DELETE'
,p_button_alignment=>'RIGHT'
,p_button_execute_validations=>'N'
,p_confirm_message=>'&APP_TEXT$DELETE_MSG!RAW.'
,p_confirm_style=>'danger'
,p_button_condition=>'P704_DEPLOYMENT_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_database_action=>'DELETE'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(158732603917133495)
,p_branch_name=>'Go To Page 703'
,p_branch_action=>'f?p=&APP_ID.: 703:&SESSION.::&DEBUG.: 704::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158173554928674230)
,p_name=>'P704_ROLLOUT_SLIDER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(158173266640674227)
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'PLUGIN_SLIDER'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '100',
  'min_value', '0',
  'return_item', 'P704_ROLLOUT_PERCENTAGE',
  'step', '1')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158709753531133420)
,p_name=>'P704_DEPLOYMENT_ID'
,p_source_data_type=>'NUMBER'
,p_is_primary_key=>true
,p_is_query_only=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_source=>'DEPLOYMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158710158025133425)
,p_name=>'P704_DEPLOYMENT_UUID'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Deployment Uuid'
,p_source=>'DEPLOYMENT_UUID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>36
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
 p_id=>wwv_flow_imp.id(158710510989133427)
,p_name=>'P704_DEPLOYMENT_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Deployment Name'
,p_placeholder=>'e.g., "Production GPT-4o" or "Shadow Test - Claude"'
,p_source=>'DEPLOYMENT_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>100
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Descriptive name for this deployment'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158710962535133428)
,p_name=>'P704_DEPLOYMENT_TYPE'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Deployment Type'
,p_source=>'DEPLOYMENT_TYPE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Production;PRODUCTION,Shadow Testing;SHADOW,Canary Rollout; CANARY,A/B Test Variant;AB_TEST,Draft;DRAFT'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select the deployment strategy type'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158711337538133429)
,p_name=>'P704_DEPLOYMENT_STATUS'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_item_default=>'DRAFT'
,p_prompt=>'Status'
,p_source=>'DEPLOYMENT_STATUS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Draft;DRAFT,Active;ACTIVE,Paused;PAUSED,Completed;COMPLETED,Archived;ARCHIVED'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158711775003133431)
,p_name=>'P704_PROVIDER'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(158173266640674227)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Provider'
,p_source=>'PROVIDER'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LLM_PROVIDERS(CODE)-ACTIVE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select PROVIDER_ID,',
'       PROVIDER_CODE,',
'       PROVIDER_NAME,',
'       DESCRIPTION,',
'       IS_DEFAULT,',
'       PRIORITY_LEVEL,',
'       DISPLAY_ORDER',
'from "LLM_PROVIDERS" a',
'Where  IS_ACTIVE= ''Y''',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158712190330133432)
,p_name=>'P704_MODEL_NAME'
,p_source_data_type=>'VARCHAR2'
,p_is_required=>true
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(158173266640674227)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Model Name'
,p_source=>'MODEL_NAME'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'LLM_MODELS-(CODE)'
,p_lov_display_null=>'YES'
,p_lov_cascade_parent_items=>'P704_PROVIDER'
,p_ajax_items_to_submit=>'P704_MODEL_NAME'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158712581132133433)
,p_name=>'P704_DEPLOYMENT_CONFIG'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(158173266640674227)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Deployment Config'
,p_source=>'DEPLOYMENT_CONFIG'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'JSON configuration for model parameters'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158712977033133436)
,p_name=>'P704_ROLLOUT_PERCENTAGE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173266640674227)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_item_default=>'0'
,p_prompt=>'Rollout Percentage'
,p_post_element_text=>'%'
,p_source=>'ROLLOUT_PERCENTAGE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_display_when=>'P704_DEPLOYMENT_TYPE'
,p_display_when2=>'CANARY:AB_TEST'
,p_display_when_type=>'VALUE_OF_ITEM_IN_CONDITION_IN_COLON_DELIMITED_LIST'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Percentage of users to receive this deployment (0-100)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '100',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158713343331133437)
,p_name=>'P704_IS_ACTIVE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_item_default=>'N'
,p_prompt=>'Is Active'
,p_source=>'IS_ACTIVE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO '
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''Y'' AS return_value, ''\D83D\DFE2 Yes'' AS display_value FROM dual'),
'UNION ALL',
unistr('SELECT ''N'' AS return_value, ''\26AA No'' AS display_value FROM dual;')))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>'Activate this deployment immediately'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158713769720133438)
,p_name=>'P704_PRIORITY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_item_default=>'50'
,p_prompt=>'Priority'
,p_source=>'PRIORITY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>32
,p_cMaxlength=>255
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Higher priority deployments are selected first (1-100)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '100',
  'min_value', '1',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158714186830133439)
,p_name=>'P704_TARGET_SEGMENT_IDS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174175277674236)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Target Segment Ids'
,p_source=>'TARGET_SEGMENT_IDS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SHUTTLE'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    segment_name || '' ('' || segment_type || '') - '' || current_user_count || '' users'' AS display_value,',
'    segment_id AS return_value',
'FROM USER_SEGMENTS',
'WHERE is_active = ''Y''',
'ORDER BY segment_type, segment_name'))
,p_cHeight=>5
,p_display_when=>'P704_DEPLOYMENT_TYPE'
,p_display_when2=>'CANARY'
,p_display_when_type=>'VAL_OF_ITEM_IN_COND_EQ_COND2'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>' Leave empty to target all users, or select specific segments'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'show_controls', 'ALL')).to_clob
,p_multi_value_type=>'SEPARATED'
,p_multi_value_separator=>','
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158714513112133441)
,p_name=>'P704_EXCLUDED_USER_IDS'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(158174175277674236)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>' Excluded User IDs'
,p_placeholder=>'Comma-separated user IDs: 101, 205, 340'
,p_source=>'EXCLUDED_USER_IDS'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>3
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Users who should never receive this deployment'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158714968866133442)
,p_name=>'P704_SHADOW_PARENT_DEPLOYMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173158555674226)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Shadow Parent Deployment  '
,p_source=>'SHADOW_PARENT_DEPLOYMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    deployment_name || '' ('' || deployment_type || '')'' AS display_value,',
'    deployment_id AS return_value',
'FROM DEPLOYMENT_VERSIONS',
'WHERE is_active = ''Y''',
'  AND deployment_type IN (''PRODUCTION'', ''CANARY'')',
'  AND deployment_status = ''ACTIVE''',
'ORDER BY ',
'    CASE deployment_type ',
'        WHEN ''PRODUCTION'' THEN 1 ',
'        ELSE 2 ',
'    END'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- All Active Deployments -'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>'Select the production deployment to shadow, or leave blank to shadow all'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158715637474133446)
,p_name=>'P704_SHADOW_EXECUTION_MODE'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173158555674226)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_item_default=>'ASYNC'
,p_prompt=>' Execution Mode'
,p_source=>'SHADOW_EXECUTION_MODE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>'STATIC: Asynchronous (Recommended);ASYNC,Synchronous;SYNC,Scheduled Batch;SCHEDULED'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'ASYNC: Run in background (best UX)',
'SYNC: Run sequentially (testing only)',
'SCHEDULED: Batch replay (cost optimization)'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158716024838133447)
,p_name=>'P704_EXPERIMENT_ID'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174009481674235)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Experiment '
,p_source=>'EXPERIMENT_ID'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    experiment_name || '' ('' || experiment_status || '')'' AS display_value,',
'    experiment_id AS return_value',
'FROM DEPLOYMENT_EXPERIMENTS',
'WHERE experiment_status IN (''DRAFT'', ''RUNNING'')',
'ORDER BY ',
'    CASE experiment_status ',
'        WHEN ''RUNNING'' THEN 1 ',
'        ELSE 2 ',
'    END,',
'    created_at DESC'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Create New Experiment -'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158716409052133448)
,p_name=>'P704_VARIANT_LABEL'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(158174009481674235)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Variant Label'
,p_placeholder=>'e.g., A, B, CONTROL, VARIANT_1'
,p_source=>'VARIANT_LABEL'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>32
,p_cMaxlength=>10
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Identifier for this variant (A, B, C, CONTROL, etc.)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158716867603133450)
,p_name=>'P704_CANARY_SCHEDULE_JSON'
,p_data_type=>'CLOB'
,p_source_data_type=>'CLOB'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173975587674234)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Canary Schedule Json'
,p_placeholder=>'{   "stages": [     {"percentage": 10, "duration_hours": 24},     {"percentage": 25, "duration_hours": 48},     {"percentage": 50, "duration_hours": 72},     {"percentage": 100, "duration_hours": 0}   ],   "auto_promote": false,   "rollback_threshold'
||'": { '
,p_source=>'CANARY_SCHEDULE_JSON'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>8
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_help_text=>'Define staged rollout schedule with automatic promotion rules'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158717255124133451)
,p_name=>'P704_CANARY_CURRENT_STAGE'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158173975587674234)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Canary Current Stage'
,p_format_mask=>'Stage #CANARY_CURRENT_STAGE#'
,p_source=>'CANARY_CURRENT_STAGE'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P704_DEPLOYMENT_ID'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
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
 p_id=>wwv_flow_imp.id(158717630484133452)
,p_name=>'P704_DESCRIPTION'
,p_source_data_type=>'VARCHAR2'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(158173071198674225)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Description'
,p_source=>'DESCRIPTION'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cMaxlength=>4000
,p_cHeight=>4
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
 p_id=>wwv_flow_imp.id(158718040833133453)
,p_name=>'P704_CREATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Created By'
,p_source=>'CREATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158718435932133454)
,p_name=>'P704_CREATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Created At'
,p_format_mask=>' YYYY-MM-DD HH24:MI'
,p_source=>'CREATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(158719274860133457)
,p_name=>'P704_UPDATED_BY'
,p_source_data_type=>'NUMBER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Updated By'
,p_source=>'UPDATED_BY'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(158719615567133458)
,p_name=>'P704_UPDATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Updated At'
,p_format_mask=>' YYYY-MM-DD HH24:MI'
,p_source=>'UPDATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(158720478487133461)
,p_name=>'P704_ACTIVATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Activated At'
,p_format_mask=>' YYYY-MM-DD HH24:MI'
,p_source=>'ACTIVATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(158721273340133463)
,p_name=>'P704_DEACTIVATED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Deactivated At'
,p_format_mask=>' YYYY-MM-DD HH24:MI'
,p_source=>'DEACTIVATED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
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
 p_id=>wwv_flow_imp.id(158722033295133465)
,p_name=>'P704_PROMOTED_AT'
,p_source_data_type=>'TIMESTAMP'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158174216399674237)
,p_item_source_plug_id=>wwv_flow_imp.id(158709440655133419)
,p_prompt=>'Promoted At'
,p_format_mask=>' YYYY-MM-DD HH24:MI'
,p_source=>'PROMOTED_AT'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158718922847133456)
,p_validation_name=>'P704_CREATED_AT must be timestamp'
,p_validation_sequence=>210
,p_validation=>'P704_CREATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(158718435932133454)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158720150551133460)
,p_validation_name=>'P704_UPDATED_AT must be timestamp'
,p_validation_sequence=>230
,p_validation=>'P704_UPDATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(158719615567133458)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158720937984133462)
,p_validation_name=>'P704_ACTIVATED_AT must be timestamp'
,p_validation_sequence=>240
,p_validation=>'P704_ACTIVATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(158720478487133461)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158721728058133464)
,p_validation_name=>'P704_DEACTIVATED_AT must be timestamp'
,p_validation_sequence=>250
,p_validation=>'P704_DEACTIVATED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(158721273340133463)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158722587004133466)
,p_validation_name=>'P704_PROMOTED_AT must be timestamp'
,p_validation_sequence=>260
,p_validation=>'P704_PROMOTED_AT'
,p_validation_type=>'ITEM_IS_TIMESTAMP'
,p_error_message=>'#LABEL# must be a valid timestamp.'
,p_associated_item=>wwv_flow_imp.id(158722033295133465)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158173859182674233)
,p_validation_name=>'New'
,p_validation_sequence=>270
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_json JSON;',
'BEGIN',
'    -- Try to parse as JSON',
'    v_json := JSON(:P704_DEPLOYMENT_CONFIG);',
'    RETURN TRUE;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        RETURN FALSE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Invalid JSON format. Please check syntax.'
,p_associated_item=>wwv_flow_imp.id(158712581132133433)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158174687782674241)
,p_validation_name=>'Deployment Name Required'
,p_validation_sequence=>280
,p_validation=>'P704_DEPLOYMENT_NAME'
,p_validation_type=>'ITEM_NOT_NULL'
,p_error_message=>'Deployment name is required'
,p_associated_item=>wwv_flow_imp.id(158710510989133427)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158174757755674242)
,p_validation_name=>'Valid Rollout Percentage'
,p_validation_sequence=>290
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P704_DEPLOYMENT_TYPE IN (''CANARY'', ''AB_TEST'') THEN',
'        RETURN :P704_ROLLOUT_PERCENTAGE BETWEEN 0 AND 100;',
'    END IF;',
'    RETURN TRUE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Rollout percentage must be between 0 and 100'
,p_associated_item=>wwv_flow_imp.id(158712977033133436)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158174879493674243)
,p_validation_name=>'Shadow Parent Required'
,p_validation_sequence=>300
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P704_DEPLOYMENT_TYPE = ''SHADOW'' THEN',
'        RETURN :P704_SHADOW_PARENT_DEPLOYMENT_ID IS NOT NULL OR TRUE;',
'        -- Allow NULL for "shadow all active"',
'    END IF;',
'    RETURN TRUE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>' Shadow Parent Required'
,p_associated_item=>wwv_flow_imp.id(158714968866133442)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(158174970742674244)
,p_validation_name=>'Experiment Required for A/B Test'
,p_validation_sequence=>310
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    IF :P704_DEPLOYMENT_TYPE = ''AB_TEST'' THEN',
'        RETURN :P704_EXPERIMENT_ID IS NOT NULL;',
'    END IF;',
'    RETURN TRUE;',
'END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Experiment selection is required for A/B Test deployments'
,p_associated_item=>wwv_flow_imp.id(158716024838133447)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158172875708674223)
,p_name=>'New'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P704_DEPLOYMENT_TYPE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158172991039674224)
,p_event_id=>wwv_flow_imp.id(158172875708674223)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Show/hide conditional regions based on deployment type',
'var deploymentType = apex.item(''P704_DEPLOYMENT_TYPE'').getValue();',
'',
'// Hide all conditional regions first',
'$(''#region_shadow_config'').hide();',
'$(''#region_canary_config'').hide();',
'$(''#region_ab_test_config'').hide();',
'',
'// Show relevant region',
'if (deploymentType === ''SHADOW'') {',
'    $(''#region_shadow_config'').show();',
'} else if (deploymentType === ''CANARY'') {',
'    $(''#region_canary_config'').show();',
'} else if (deploymentType === ''AB_TEST'') {',
'    $(''#region_ab_test_config'').show();',
'}',
'',
'// Set default values',
'if (deploymentType === ''PRODUCTION'') {',
'    apex.item(''P704_ROLLOUT_PERCENTAGE'').setValue(100);',
'    apex.item(''P704_IS_ACTIVE'').setValue(''Y'');',
'} else if (deploymentType === ''CANARY'') {',
'    apex.item(''P704_ROLLOUT_PERCENTAGE'').setValue(10);',
'} else if (deploymentType === ''DRAFT'') {',
'    apex.item(''P704_IS_ACTIVE'').setValue(''N'');',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158173324781674228)
,p_name=>'New_1'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P704_PROVIDER'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158173428450674229)
,p_event_id=>wwv_flow_imp.id(158173324781674228)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Update model list based on provider',
'var provider = apex.item(''P704_PROVIDER'').getValue();',
'var modelSelect = apex.item(''P704_MODEL_NAME'');',
'',
'// Clear current value',
'modelSelect.setValue('''');',
'',
'// Update model LOV via cascade',
'apex.item(''P704_MODEL_NAME'').enable();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158173657216674231)
,p_name=>'New_2'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P704_ROLLOUT_SLIDER'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158173716312674232)
,p_event_id=>wwv_flow_imp.id(158173657216674231)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'Y'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P704_ROLLOUT_PERCENTAGE'
,p_attribute_01=>'JAVASCRIPT_EXPRESSION'
,p_attribute_05=>'apex.item(''P704_ROLLOUT_SLIDER'').getValue()'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158733512559133498)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_region_id=>wwv_flow_imp.id(158709440655133419)
,p_process_type=>'NATIVE_FORM_DML'
,p_process_name=>'Process form deployments Edit'
,p_attribute_01=>'REGION_SOURCE'
,p_attribute_05=>'Y'
,p_attribute_06=>'Y'
,p_attribute_08=>'Y'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>158733512559133498
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158174449730674239)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Deployment'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_id NUMBER;',
'    v_json_config JSON;',
'    v_canary_schedule JSON;',
'BEGIN',
'    -- Validate and parse JSON configs',
'    IF :P704_DEPLOYMENT_CONFIG IS NOT NULL THEN',
'        BEGIN',
'            v_json_config := JSON(:P704_DEPLOYMENT_CONFIG);',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                apex_error.add_error(',
'                    p_message => ''Invalid JSON in Model Configuration: '' || SQLERRM,',
'                    p_display_location => apex_error.c_inline_with_field_and_notif,',
'                    p_page_item_name => ''P704_DEPLOYMENT_CONFIG''',
'                );',
'                RETURN;',
'        END;',
'    END IF;',
'    ',
'    IF :P704_DEPLOYMENT_TYPE = ''CANARY'' AND :P704_CANARY_SCHEDULE_JSON IS NOT NULL THEN',
'        BEGIN',
'            v_canary_schedule := JSON(:P704_CANARY_SCHEDULE_JSON);',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                apex_error.add_error(',
'                    p_message => ''Invalid JSON in Canary Schedule: '' || SQLERRM,',
'                    p_display_location => apex_error.c_inline_with_field_and_notif,',
'                    p_page_item_name => ''P704_CANARY_SCHEDULE_JSON''',
'                );',
'                RETURN;',
'        END;',
'    END IF;',
'    ',
'    -- INSERT or UPDATE',
'    IF :P704_DEPLOYMENT_ID IS NULL THEN',
'        -- Create new deployment',
'        INSERT INTO DEPLOYMENT_VERSIONS (',
'            deployment_name, deployment_type, deployment_status,',
'            provider, model_name, deployment_config,',
'            rollout_percentage, is_active, priority,',
'            target_segment_ids, excluded_user_ids,',
'            shadow_parent_deployment_id, shadow_execution_mode,',
'            canary_schedule_json, canary_current_stage,',
'            experiment_id, variant_label,',
'            created_by, created_at',
'        ) VALUES (',
'            :P704_DEPLOYMENT_NAME, :P704_DEPLOYMENT_TYPE, :P704_DEPLOYMENT_STATUS,',
'            :P704_PROVIDER, :P704_MODEL_NAME, v_json_config,',
'            :P704_ROLLOUT_PERCENTAGE, :P704_IS_ACTIVE, :P704_PRIORITY,',
'            :P704_TARGET_SEGMENT_IDS, :P704_EXCLUDED_USER_IDS,',
'            :P704_SHADOW_PARENT_DEPLOYMENT_ID, :P704_SHADOW_EXECUTION_MODE,',
'            v_canary_schedule, CASE WHEN :P704_DEPLOYMENT_TYPE = ''CANARY'' THEN 1 ELSE NULL END,',
'            :P704_EXPERIMENT_ID, :P704_VARIANT_LABEL,',
'            :APP_USER, SYSTIMESTAMP',
'        ) RETURNING deployment_id INTO v_deployment_id;',
'        ',
'        :P704_DEPLOYMENT_ID := v_deployment_id;',
'        ',
'        -- Log creation event',
'        DEPLOYMENT_MANAGER_PKG.log_deployment_event(',
'            p_deployment_id => v_deployment_id,',
'            p_event_type => ''CREATED'',',
'            p_new_value => :P704_DEPLOYMENT_NAME',
'        );',
'        ',
'        apex_application.g_print_success_message := ''Deployment created successfully (ID: '' || v_deployment_id || '')'';',
'        ',
'    ELSE',
'        -- Update existing deployment',
'        UPDATE DEPLOYMENT_VERSIONS SET',
'            deployment_name = :P704_DEPLOYMENT_NAME,',
'            deployment_type = :P704_DEPLOYMENT_TYPE,',
'            deployment_status = :P704_DEPLOYMENT_STATUS,',
'            provider = :P704_PROVIDER,',
'            model_name = :P704_MODEL_NAME,',
'            deployment_config = v_json_config,',
'            rollout_percentage = :P704_ROLLOUT_PERCENTAGE,',
'            is_active = :P704_IS_ACTIVE,',
'            priority = :P704_PRIORITY,',
'            target_segment_ids = :P704_TARGET_SEGMENT_IDS,',
'            excluded_user_ids = :P704_EXCLUDED_USER_IDS,',
'            shadow_parent_deployment_id = :P704_SHADOW_PARENT_DEPLOYMENT_ID,',
'            shadow_execution_mode = :P704_SHADOW_EXECUTION_MODE,',
'            canary_schedule_json = v_canary_schedule,',
'            experiment_id = :P704_EXPERIMENT_ID,',
'            variant_label = :P704_VARIANT_LABEL',
'        WHERE deployment_id = :P704_DEPLOYMENT_ID;',
'        ',
'        -- Log update event',
'        DEPLOYMENT_MANAGER_PKG.log_deployment_event(',
'            p_deployment_id => :P704_DEPLOYMENT_ID,',
'            p_event_type => ''CONFIG_CHANGED'',',
'            p_new_value => :P704_DEPLOYMENT_NAME',
'        );',
'        ',
'        apex_application.g_print_success_message := ''Deployment updated successfully'';',
'    END IF;',
'    ',
'    COMMIT;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_error.add_error(',
'            p_message => ''Error saving deployment: '' || SQLERRM,',
'            p_display_location => apex_error.c_on_error_page',
'        );',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when=>'SAVE'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>158174449730674239
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158174340362674238)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'intit'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment DEPLOYMENT_VERSIONS%ROWTYPE;',
'BEGIN',
'    SELECT *',
'    INTO v_deployment',
'    FROM DEPLOYMENT_VERSIONS',
'    WHERE deployment_id = :P704_DEPLOYMENT_ID;',
'    ',
'    -- Populate form items',
'    :P704_DEPLOYMENT_NAME := v_deployment.deployment_name;',
'    :P704_DEPLOYMENT_TYPE := v_deployment.deployment_type;',
'    :P704_DEPLOYMENT_STATUS := v_deployment.deployment_status;',
'    :P704_PROVIDER := v_deployment.provider;',
'    :P704_MODEL_NAME := v_deployment.model_name;',
'    :P704_ROLLOUT_PERCENTAGE := v_deployment.rollout_percentage;',
'    :P704_IS_ACTIVE := v_deployment.is_active;',
'    :P704_PRIORITY := v_deployment.priority;',
'    ',
unistr('    -- \2705 FIXED: Use JSON_SERIALIZE for JSON \2192 CLOB conversion'),
'    :P704_DEPLOYMENT_CONFIG := JSON_SERIALIZE(v_deployment.deployment_config RETURNING CLOB PRETTY);',
'    ',
'    :P704_TARGET_SEGMENT_IDS := v_deployment.target_segment_ids;',
'    :P704_EXCLUDED_USER_IDS := v_deployment.excluded_user_ids;',
'    ',
'    -- Shadow-specific',
'    :P704_SHADOW_PARENT_DEPLOYMENT_ID := v_deployment.shadow_parent_deployment_id;',
'    :P704_SHADOW_EXECUTION_MODE := v_deployment.shadow_execution_mode;',
'    ',
unistr('    -- \2705 FIXED: Use JSON_SERIALIZE for canary schedule'),
'    IF v_deployment.canary_schedule_json IS NOT NULL THEN',
'        :P704_CANARY_SCHEDULE_JSON := JSON_SERIALIZE(v_deployment.canary_schedule_json RETURNING CLOB PRETTY);',
'    ELSE',
'        :P704_CANARY_SCHEDULE_JSON := NULL;',
'    END IF;',
'    ',
'    :P704_CANARY_CURRENT_STAGE := v_deployment.canary_current_stage;',
'    ',
'    -- A/B Test-specific',
'    :P704_EXPERIMENT_ID := v_deployment.experiment_id;',
'    :P704_VARIANT_LABEL := v_deployment.variant_label;',
'    ',
'    -- Metadata',
'    :P704_CREATED_BY := v_deployment.created_by;',
'    :P704_CREATED_AT := TO_CHAR(v_deployment.created_at, ''YYYY-MM-DD HH24:MI'');',
'    :P704_ACTIVATED_AT := TO_CHAR(v_deployment.activated_at, ''YYYY-MM-DD HH24:MI'');',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        -- New deployment - set defaults',
'        :P704_DEPLOYMENT_STATUS := ''DRAFT'';',
'        :P704_IS_ACTIVE := ''N'';',
'        :P704_PRIORITY := 50;',
'        :P704_ROLLOUT_PERCENTAGE := 0;',
'        :P704_DEPLOYMENT_CONFIG := NULL;',
'        :P704_CANARY_SCHEDULE_JSON := NULL;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'P704_DEPLOYMENT_ID'
,p_process_when_type=>'ITEM_IS_NOT_NULL'
,p_internal_uid=>158174340362674238
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158733165332133497)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_region_id=>wwv_flow_imp.id(158709440655133419)
,p_process_type=>'NATIVE_FORM_INIT'
,p_process_name=>'Initialize form deployments Edit'
,p_internal_uid=>158733165332133497
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158174518783674240)
,p_process_sequence=>40
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>' Close Dialog '
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'BEGIN',
'    apex_util.set_session_state(''P703_LAST_UPDATED'', SYSTIMESTAMP);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_success_message=>'Deployment saved successfully'
,p_internal_uid=>158174518783674240
);
wwv_flow_imp.component_end;
end;
/
