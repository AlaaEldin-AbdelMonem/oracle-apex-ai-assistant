prompt --application/pages/page_00703
begin
--   Manifest
--     PAGE: 00703
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
 p_id=>703
,p_name=>'Deployment Versions'
,p_alias=>'DEPLOYMENT-VERSIONS'
,p_step_title=>'Deployment Versions'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Deployment management functions',
'',
'function activateDeployment(deploymentId) {',
'    apex.message.confirm(''Activate this deployment?'', function(okPressed) {',
'        if (okPressed) {',
'            apex.server.process(''ACTIVATE_DEPLOYMENT'', {',
'                x01: deploymentId',
'            }, {',
'                dataType: ''json'',',
'                success: function(data) {',
'                    if (data.success) {',
'                        apex.message.showPageSuccess(data.message);',
'                        apex.region(''deployment-grid'').refresh();',
'                    } else {',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            message: data.message,',
'                            location: ''page''',
'                        }]);',
'                    }',
'                },',
'                error: function(xhr, status, error) {',
'                    apex.message.showErrors([{',
'                        type: ''error'',',
'                        message: ''Error activating deployment: '' + error,',
'                        location: ''page''',
'                    }]);',
'                }',
'            });',
'        }',
'    });',
'}',
'',
'function pauseDeployment(deploymentId) {',
'    apex.message.confirm(''Pause this deployment?'', function(okPressed) {',
'        if (okPressed) {',
'            apex.server.process(''PAUSE_DEPLOYMENT'', {',
'                x01: deploymentId',
'            }, {',
'                dataType: ''json'',',
'                success: function(data) {',
'                    if (data.success) {',
'                        apex.message.showPageSuccess(data.message);',
'                        apex.region(''deployment-grid'').refresh();',
'                    } else {',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            message: data.message,',
'                            location: ''page''',
'                        }]);',
'                    }',
'                }',
'            });',
'        }',
'    });',
'}',
'',
'function deactivateDeployment(deploymentId) {',
'    apex.message.confirm(''Deactivate this deployment? This will stop all traffic to this version.'', function(okPressed) {',
'        if (okPressed) {',
'            apex.server.process(''DEACTIVATE_DEPLOYMENT'', {',
'                x01: deploymentId',
'            }, {',
'                dataType: ''json'',',
'                success: function(data) {',
'                    if (data.success) {',
'                        apex.message.showPageSuccess(data.message);',
'                        apex.region(''deployment-grid'').refresh();',
'                    } else {',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            message: data.message,',
'                            location: ''page''',
'                        }]);',
'                    }',
'                }',
'            });',
'        }',
'    });',
'}',
'',
'function promoteDeployment(deploymentId) {',
'    apex.message.confirm(''Promote this canary deployment to production? This will demote the current production deployment.'', function(okPressed) {',
'        if (okPressed) {',
'            apex.server.process(''PROMOTE_CANARY'', {',
'                x01: deploymentId',
'            }, {',
'                dataType: ''json'',',
'                success: function(data) {',
'                    if (data.success) {',
'                        apex.message.showPageSuccess(data.message);',
'                        apex.region(''deployment-grid'').refresh();',
'                        // Optionally redirect to dashboard',
'                        // apex.navigation.redirect(''f?p=&APP_ID.:702:&SESSION.'');',
'                    } else {',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            message: data.message,',
'                            location: ''page''',
'                        }]);',
'                    }',
'                }',
'            });',
'        }',
'    });',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Deployment type badges */',
'.deployment-type-badge {',
'    display: inline-block;',
'    padding: 0.25rem 0.75rem;',
'    border-radius: 12px;',
'    font-size: 0.85rem;',
'    font-weight: 600;',
'    text-transform: uppercase;',
'}',
'',
'.u-success {',
'    background: #d4edda;',
'    color: #155724;',
'}',
'',
'.u-warning {',
'    background: #fff3cd;',
'    color: #856404;',
'}',
'',
'.u-info {',
'    background: #d1ecf1;',
'    color: #0c5460;',
'}',
'',
'.u-hot {',
'    background: #f8d7da;',
'    color: #721c24;',
'}',
'',
'.u-normal {',
'    background: #e2e3e5;',
'    color: #383d41;',
'}',
'',
'/* Status badges */',
'.status-badge {',
'    display: inline-block;',
'    padding: 0.25rem 0.75rem;',
'    border-radius: 12px;',
'    font-size: 0.85rem;',
'    font-weight: 500;',
'}',
'',
'.status-Active {',
'    background: #d4edda;',
'    color: #155724;',
'}',
'',
'.status-Paused {',
'    background: #fff3cd;',
'    color: #856404;',
'}',
'',
'.status-Draft {',
'    background: #e2e3e5;',
'    color: #383d41;',
'}',
'',
'.status-Inactive {',
'    background: #f8d7da;',
'    color: #721c24;',
'}',
'',
'/* Rollout progress bar */',
'.rollout-bar {',
'    width: 100%;',
'    height: 24px;',
'    background: #e9ecef;',
'    border-radius: 4px;',
'    overflow: hidden;',
'    position: relative;',
'}',
'',
'.rollout-progress {',
'    height: 100%;',
'    background: linear-gradient(90deg, #0d6efd 0%, #0a58ca 100%);',
'    color: white;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    font-size: 0.85rem;',
'    font-weight: 600;',
'    transition: width 0.3s ease;',
'}',
'',
'/* Action buttons */',
'.deployment-actions {',
'    display: flex;',
'    gap: 0.25rem;',
'}',
'',
'.deployment-actions .t-Button {',
'    padding: 0.25rem 0.5rem;',
'    min-width: 32px;',
'}',
'',
'/* Interactive Grid customization */',
'#deployment-grid .a-IG {',
'    font-size: 0.9rem;',
'}',
'',
'#deployment-grid .a-IG-header {',
'    background: #f8f9fa;',
'    font-weight: 600;',
'}',
'',
'/* Filter region */',
'.filters-container {',
'    background: #f8f9fa;',
'    padding: 1rem;',
'    border-radius: 8px;',
'    margin-bottom: 1rem;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'21'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158156549799537625)
,p_plug_name=>'Filters (Search)'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>1555738898046108210
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158156313928537623)
,p_plug_name=>'Deployment Versions'
,p_region_name=>'deployment-grid'
,p_parent_plug_id=>wwv_flow_imp.id(158156549799537625)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    d.deployment_id,',
'    d.deployment_name,',
'   -- d.deployment_type,',
'   ''<span class="deployment-type-badge #TYPE_CSS_CLASS#">''|| d.deployment_type||''</span>''deployment_type,',
'',
'',
'    d.deployment_status,',
'    d.provider,',
'    d.model_name,',
'   -- d.rollout_percentage,',
'    ''<div class="rollout-bar"><div class="rollout-progress" style="width:''||d.rollout_percentage ||''%">''||d.rollout_percentage||''%</div></div>'' rollout_percentage,',
'    d.is_active,',
'    d.priority,',
'    d.created_by,',
'    TO_CHAR(d.created_at, ''YYYY-MM-DD HH24:MI'') AS created_at_display,',
'    TO_CHAR(d.activated_at, ''YYYY-MM-DD HH24:MI'') AS activated_at_display,',
'    d.target_segment_ids,',
'    d.experiment_id,',
'    CASE d.deployment_type',
'        WHEN ''PRODUCTION'' THEN ''u-success''',
'        WHEN ''SHADOW'' THEN ''u-warning''',
'        WHEN ''CANARY'' THEN ''u-info''',
'        WHEN ''AB_TEST'' THEN ''u-hot''',
'        ELSE ''u-normal''',
'    END AS type_css_class,',
'    ',
'    CASE ',
'        WHEN d.is_active = ''Y'' AND ',
'             d.deployment_status = ''ACTIVE'' THEN ''<span class="status-badge status-Active">Active</span>''',
'        WHEN d.deployment_status = ''PAUSED'' THEN  ''<span class="status-badge status-Paused">Paused</span>''',
'        WHEN d.deployment_status = ''DRAFT'' THEN   ''<span class="status-badge status-Draft">Draft</span>''',
'        ELSE                                      ''<span class="status-badge status-Inactive">Inactive</span>''',
'    END AS status_display,',
'    -- Shadow parent info',
'    (SELECT dv.deployment_name ',
'     FROM DEPLOYMENT_VERSIONS dv ',
'     WHERE dv.deployment_id = d.shadow_parent_deployment_id) AS shadow_parent_name,',
'    d.shadow_parent_deployment_id,',
'    d.shadow_execution_mode,',
'    -- Experiment info',
'    (SELECT de.experiment_name ',
'     FROM DEPLOYMENT_EXPERIMENTS de ',
'     WHERE de.experiment_id = d.experiment_id) AS experiment_name,',
'    d.variant_label,',
'    -- Canary info',
'    d.canary_current_stage,',
'    -- JSON configs',
'    d.deployment_config,',
'    d.canary_schedule_json,',
'    -- Metrics summary (last 7 days)',
'    (SELECT SUM(total_calls) ',
'     FROM DEPLOYMENT_METRICS dm ',
'     WHERE dm.deployment_id = d.deployment_id ',
'       AND dm.metric_date >= TRUNC(SYSDATE) - 7) AS calls_last_7_days,',
'    (SELECT ROUND(AVG(avg_total_pipeline_ms), 0)',
'     FROM DEPLOYMENT_METRICS dm ',
'     WHERE dm.deployment_id = d.deployment_id ',
'       AND dm.metric_date >= TRUNC(SYSDATE) - 7) || '' ms'' AS avg_latency_7_days,',
'   ''$''|| (SELECT ROUND(SUM(total_cost_usd), 4)',
'     FROM DEPLOYMENT_METRICS dm ',
'     WHERE dm.deployment_id = d.deployment_id ',
'       AND dm.metric_date >= TRUNC(SYSDATE) - 7) AS cost_last_7_days,',
'       CASE WHEN d.is_active = ''N'' THEN ''inline-block'' ELSE ''none'' END AS is_activate_button,',
'CASE WHEN d.is_active = ''Y'' AND d.deployment_status = ''ACTIVE'' THEN ''inline-block'' ELSE ''none'' END AS is_pause_button,',
'CASE WHEN d.is_active = ''Y'' THEN ''inline-block'' ELSE ''none'' END AS is_deactivate_button,',
'CASE WHEN d.deployment_type = ''CANARY'' AND d.is_active = ''Y'' AND d.rollout_percentage >= 50 THEN ''inline-block'' ELSE ''none'' END AS is_promote_button',
'FROM DEPLOYMENT_VERSIONS d',
'WHERE 1=1',
'  AND (:P703_FILTER_TYPE IS NULL OR d.deployment_type = :P703_FILTER_TYPE)',
'  AND (:P703_FILTER_STATUS IS NULL OR d.deployment_status = :P703_FILTER_STATUS)',
'  AND (:P703_FILTER_ACTIVE IS NULL OR d.is_active LIKE :P703_FILTER_ACTIVE || ''%'')',
' '))
,p_plug_source_type=>'NATIVE_IG'
,p_prn_units=>'INCHES'
,p_prn_paper_size=>'LETTER'
,p_prn_width=>11
,p_prn_height=>8.5
,p_prn_orientation=>'HORIZONTAL'
,p_prn_page_header_font_color=>'#000000'
,p_prn_page_header_font_family=>'Helvetica'
,p_prn_page_header_font_weight=>'normal'
,p_prn_page_header_font_size=>'12'
,p_prn_page_footer_font_color=>'#000000'
,p_prn_page_footer_font_family=>'Helvetica'
,p_prn_page_footer_font_weight=>'normal'
,p_prn_page_footer_font_size=>'12'
,p_prn_header_bg_color=>'#EEEEEE'
,p_prn_header_font_color=>'#000000'
,p_prn_header_font_family=>'Helvetica'
,p_prn_header_font_weight=>'bold'
,p_prn_header_font_size=>'10'
,p_prn_body_bg_color=>'#FFFFFF'
,p_prn_body_font_color=>'#000000'
,p_prn_body_font_family=>'Helvetica'
,p_prn_body_font_weight=>'normal'
,p_prn_body_font_size=>'10'
,p_prn_border_width=>.5
,p_prn_page_header_alignment=>'CENTER'
,p_prn_page_footer_alignment=>'CENTER'
,p_prn_border_color=>'#666666'
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158156831288537628)
,p_name=>'DEPLOYMENT_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPLOYMENT_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Deployment Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>10
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
 p_id=>wwv_flow_imp.id(158156914531537629)
,p_name=>'DEPLOYMENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPLOYMENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Deployment Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>20
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158157027456537630)
,p_name=>'DEPLOYMENT_TYPE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPLOYMENT_TYPE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Deployment Type'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>30
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158157153268537631)
,p_name=>'DEPLOYMENT_STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPLOYMENT_STATUS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Deployment Status'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>40
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158157207963537632)
,p_name=>'PROVIDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PROVIDER'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Provider'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>50
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>true
,p_max_length=>50
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
 p_id=>wwv_flow_imp.id(158157394204537633)
,p_name=>'MODEL_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'MODEL_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Model Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>60
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158157496643537634)
,p_name=>'ROLLOUT_PERCENTAGE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ROLLOUT_PERCENTAGE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Rollout Percentage'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>70
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
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
 p_id=>wwv_flow_imp.id(158157543959537635)
,p_name=>'IS_ACTIVE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_ACTIVE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Is Active'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>80
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>1
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
 p_id=>wwv_flow_imp.id(158157686989537636)
,p_name=>'PRIORITY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'PRIORITY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Priority'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>90
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158157700655537637)
,p_name=>'CREATED_BY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_BY'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Created By'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>100
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
 p_id=>wwv_flow_imp.id(158157832061537638)
,p_name=>'CREATED_AT_DISPLAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CREATED_AT_DISPLAY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Created At Display'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>110
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>16
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
 p_id=>wwv_flow_imp.id(158157978924537639)
,p_name=>'ACTIVATED_AT_DISPLAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ACTIVATED_AT_DISPLAY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Activated At Display'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>120
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>16
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
 p_id=>wwv_flow_imp.id(158158017496537640)
,p_name=>'TARGET_SEGMENT_IDS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TARGET_SEGMENT_IDS'
,p_data_type=>'VARCHAR2'
,p_session_state_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Target Segment Ids'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>130
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>4000
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_sort_group=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158158144619537641)
,p_name=>'EXPERIMENT_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXPERIMENT_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Experiment Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>140
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158158249934537642)
,p_name=>'TYPE_CSS_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'TYPE_CSS_CLASS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Type Css Class'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>150
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>9
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
 p_id=>wwv_flow_imp.id(158158348875537643)
,p_name=>'STATUS_DISPLAY'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS_DISPLAY'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Status Display'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>160
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>8
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
 p_id=>wwv_flow_imp.id(158158482857537644)
,p_name=>'SHADOW_PARENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SHADOW_PARENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Shadow Parent Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>170
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
 p_id=>wwv_flow_imp.id(158158527975537645)
,p_name=>'SHADOW_PARENT_DEPLOYMENT_ID'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SHADOW_PARENT_DEPLOYMENT_ID'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Shadow Parent Deployment Id'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>180
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158158628253537646)
,p_name=>'SHADOW_EXECUTION_MODE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'SHADOW_EXECUTION_MODE'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Shadow Execution Mode'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>190
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158158745821537647)
,p_name=>'EXPERIMENT_NAME'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'EXPERIMENT_NAME'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Experiment Name'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>200
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
 p_id=>wwv_flow_imp.id(158158810744537648)
,p_name=>'VARIANT_LABEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VARIANT_LABEL'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Variant Label'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>210
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>10
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
 p_id=>wwv_flow_imp.id(158158936178537649)
,p_name=>'CANARY_CURRENT_STAGE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CANARY_CURRENT_STAGE'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Canary Current Stage'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>220
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
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158159057339537650)
,p_name=>'DEPLOYMENT_CONFIG'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DEPLOYMENT_CONFIG'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'CLOB'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Deployment Config'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>230
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158170664438674201)
,p_name=>'CANARY_SCHEDULE_JSON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CANARY_SCHEDULE_JSON'
,p_data_type=>'CLOB'
,p_session_state_data_type=>'CLOB'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXTAREA'
,p_heading=>'Canary Schedule Json'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>240
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_lov_type=>'NONE'
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_is_primary_key=>false
,p_duplicate_value=>true
,p_include_in_export=>true
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158170731280674202)
,p_name=>'CALLS_LAST_7_DAYS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'CALLS_LAST_7_DAYS'
,p_data_type=>'NUMBER'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Calls Last 7 Days'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>250
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_format_mask=>'999,999,999'
,p_is_required=>false
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
 p_id=>wwv_flow_imp.id(158170806720674203)
,p_name=>'AVG_LATENCY_7_DAYS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'AVG_LATENCY_7_DAYS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Avg Latency 7 Days'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>260
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
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
 p_id=>wwv_flow_imp.id(158170993603674204)
,p_name=>'COST_LAST_7_DAYS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'COST_LAST_7_DAYS'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_NUMBER_FIELD'
,p_heading=>'Cost Last 7 Days'
,p_heading_alignment=>'RIGHT'
,p_display_sequence=>270
,p_value_alignment=>'RIGHT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_is_required=>false
,p_enable_filter=>true
,p_filter_operators=>'C:S:CASE_INSENSITIVE:REGEXP'
,p_filter_is_required=>false
,p_filter_text_case=>'MIXED'
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
 p_id=>wwv_flow_imp.id(158171058698674205)
,p_name=>'actions'
,p_source_type=>'NONE'
,p_session_state_data_type=>'VARCHAR2'
,p_item_type=>'NATIVE_DISPLAY_ONLY'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>280
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN')).to_clob
,p_use_as_row_header=>false
,p_enable_hide=>true
,p_default_type=>'STATIC'
,p_default_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="deployment-actions">',
'    <button type="button" ',
'            class="t-Button t-Button--noLabel t-Button--icon" ',
'            title="Edit"',
'            onclick="apex.navigation.dialog(''f?p=&APP_ID.:704:&SESSION.::NO:RP,704:P704_DEPLOYMENT_ID:#DEPLOYMENT_ID#'',{title:''Edit Deployment'',height:''auto'',width:''800'',maxWidth:''95%''});">',
'        <span class="fa fa-edit"></span>',
'    </button>',
'    ',
'    <button type="button" ',
'            class="t-Button t-Button--noLabel t-Button--icon t-Button--success" ',
'            title="Activate"',
'            onclick="activateDeployment(#DEPLOYMENT_ID#);"',
'            style="display:#IS_ACTIVE_BUTTON#;">',
'        <span class="fa fa-play"></span>',
'    </button>',
'    ',
'    <button type="button" ',
'            class="t-Button t-Button--noLabel t-Button--icon t-Button--warning" ',
'            title="Pause"',
'            onclick="pauseDeployment(#DEPLOYMENT_ID#);"',
'            style="display:#IS_PAUSE_BUTTON#;">',
'        <span class="fa fa-pause"></span>',
'    </button>',
'    ',
'    <button type="button" ',
'            class="t-Button t-Button--noLabel t-Button--icon t-Button--danger" ',
'            title="Deactivate"',
'            onclick="deactivateDeployment(#DEPLOYMENT_ID#);"',
'            style="display:#IS_DEACTIVATE_BUTTON#;">',
'        <span class="fa fa-stop"></span>',
'    </button>',
'    ',
'    <button type="button" ',
'            class="t-Button t-Button--noLabel t-Button--icon t-Button--hot" ',
'            title="Promote to Production"',
'            onclick="promoteDeployment(#DEPLOYMENT_ID#);"',
'            style="display:#IS_PROMOTE_BUTTON#;">',
'        <span class="fa fa-arrow-up"></span>',
'    </button>',
'</div>'))
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(158171132853674206)
,p_name=>'IS_ACTIVATE_BUTTON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_ACTIVATE_BUTTON'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Is Activate Button'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>290
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>12
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
 p_id=>wwv_flow_imp.id(158171220289674207)
,p_name=>'IS_PAUSE_BUTTON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_PAUSE_BUTTON'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Is Pause Button'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>300
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>12
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
 p_id=>wwv_flow_imp.id(158171317866674208)
,p_name=>'IS_DEACTIVATE_BUTTON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_DEACTIVATE_BUTTON'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Is Deactivate Button'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>310
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>12
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
 p_id=>wwv_flow_imp.id(158171411712674209)
,p_name=>'IS_PROMOTE_BUTTON'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'IS_PROMOTE_BUTTON'
,p_data_type=>'VARCHAR2'
,p_is_query_only=>false
,p_item_type=>'NATIVE_TEXT_FIELD'
,p_heading=>'Is Promote Button'
,p_heading_alignment=>'LEFT'
,p_display_sequence=>320
,p_value_alignment=>'LEFT'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'trim_spaces', 'BOTH')).to_clob
,p_is_required=>false
,p_max_length=>12
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
wwv_flow_imp_page.create_interactive_grid(
 p_id=>wwv_flow_imp.id(158156770824537627)
,p_internal_uid=>158156770824537627
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
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>true
,p_fixed_header=>'PAGE'
,p_show_icon_view=>false
,p_show_detail_view=>false
);
wwv_flow_imp_page.create_ig_report(
 p_id=>wwv_flow_imp.id(158177992930751000)
,p_interactive_grid_id=>wwv_flow_imp.id(158156770824537627)
,p_static_id=>'1581780'
,p_type=>'PRIMARY'
,p_default_view=>'GRID'
,p_show_row_number=>false
,p_settings_area_expanded=>true
);
wwv_flow_imp_page.create_ig_report_view(
 p_id=>wwv_flow_imp.id(158178131932751002)
,p_report_id=>wwv_flow_imp.id(158177992930751000)
,p_view_type=>'GRID'
,p_stretch_columns=>true
,p_srv_exclude_null_values=>false
,p_srv_only_display_columns=>true
,p_edit_mode=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158178684772751010)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>1
,p_column_id=>wwv_flow_imp.id(158156831288537628)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>102
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158179593851751015)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>3
,p_column_id=>wwv_flow_imp.id(158156914531537629)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>121
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158180464151751019)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>2
,p_column_id=>wwv_flow_imp.id(158157027456537630)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>124
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158181337990751023)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>4
,p_column_id=>wwv_flow_imp.id(158157153268537631)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>127
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158182208090751027)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>5
,p_column_id=>wwv_flow_imp.id(158157207963537632)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>75
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158183196978751030)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>6
,p_column_id=>wwv_flow_imp.id(158157394204537633)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>103
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158184060683751034)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>7
,p_column_id=>wwv_flow_imp.id(158157496643537634)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>156
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158184946185751038)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>8
,p_column_id=>wwv_flow_imp.id(158157543959537635)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>87
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158185802894751041)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>9
,p_column_id=>wwv_flow_imp.id(158157686989537636)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>63
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158186780656751045)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>10
,p_column_id=>wwv_flow_imp.id(158157700655537637)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>91
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158187639635751048)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>11
,p_column_id=>wwv_flow_imp.id(158157832061537638)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>136
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158188560418751052)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>12
,p_column_id=>wwv_flow_imp.id(158157978924537639)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>139
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158189461803751056)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>13
,p_column_id=>wwv_flow_imp.id(158158017496537640)
,p_is_visible=>true
,p_is_frozen=>false
,p_width=>185
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158190337833751059)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>14
,p_column_id=>wwv_flow_imp.id(158158144619537641)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158191294697751063)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>15
,p_column_id=>wwv_flow_imp.id(158158249934537642)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158192162022751067)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>16
,p_column_id=>wwv_flow_imp.id(158158348875537643)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158193015122751071)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>17
,p_column_id=>wwv_flow_imp.id(158158482857537644)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158193955684751075)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>18
,p_column_id=>wwv_flow_imp.id(158158527975537645)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158194879652751078)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>19
,p_column_id=>wwv_flow_imp.id(158158628253537646)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158195737966751082)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>20
,p_column_id=>wwv_flow_imp.id(158158745821537647)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158196662512751085)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>21
,p_column_id=>wwv_flow_imp.id(158158810744537648)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158197576182751089)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>22
,p_column_id=>wwv_flow_imp.id(158158936178537649)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158198454845751093)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>23
,p_column_id=>wwv_flow_imp.id(158159057339537650)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158199341718751097)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>24
,p_column_id=>wwv_flow_imp.id(158170664438674201)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158200178095751100)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>25
,p_column_id=>wwv_flow_imp.id(158170731280674202)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158201065935751104)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>26
,p_column_id=>wwv_flow_imp.id(158170806720674203)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158201919459751108)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>27
,p_column_id=>wwv_flow_imp.id(158170993603674204)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158203942909796799)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>28
,p_column_id=>wwv_flow_imp.id(158171058698674205)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158208246862867076)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>29
,p_column_id=>wwv_flow_imp.id(158171132853674206)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158209100946867080)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>30
,p_column_id=>wwv_flow_imp.id(158171220289674207)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158210097957867084)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>31
,p_column_id=>wwv_flow_imp.id(158171317866674208)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_ig_report_column(
 p_id=>wwv_flow_imp.id(158210964314867087)
,p_view_id=>wwv_flow_imp.id(158178131932751002)
,p_display_seq=>32
,p_column_id=>wwv_flow_imp.id(158171411712674209)
,p_is_visible=>true
,p_is_frozen=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158172718894674222)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(158156549799537625)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158156654869537626)
,p_plug_name=>'Create New Deployment '
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158169990335665415)
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
 p_id=>wwv_flow_imp.id(158171524622674210)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(158156654869537626)
,p_button_name=>'CREATE_DEPLOYMENT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>' Create New Deployment'
,p_button_redirect_url=>'f?p=&APP_ID.:704:&SESSION.::&DEBUG.:704:P704_DEPLOYMENT_ID:'
,p_icon_css_classes=>'fa-plus'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158171774924674212)
,p_name=>'P703_FILTER_TYPE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158172718894674222)
,p_prompt=>'Filter Type'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT deployment_type AS display_value, ',
'       deployment_type AS return_value',
'FROM (',
'    SELECT DISTINCT deployment_type ',
'    FROM DEPLOYMENT_VERSIONS',
'    ORDER BY deployment_type',
')'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All Types'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158171882164674213)
,p_name=>'P703_FILTER_STATUS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(158172718894674222)
,p_prompt=>'Filter Status'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT deployment_status AS display_value,',
'       deployment_status AS return_value',
'FROM (',
'    SELECT DISTINCT deployment_status',
'    FROM DEPLOYMENT_VERSIONS',
'    ORDER BY deployment_status',
')'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'All Statuses'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158172244754674217)
,p_name=>'P703_FILTER_ACTIVE'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(158172718894674222)
,p_prompt=>'Filter Active'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'YES_NO (2)'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('SELECT ''Y'' AS return_value, ''\2714 Yes'' AS display_value FROM dual'),
'UNION ALL',
unistr('SELECT ''N'' AS return_value, ''\2716 No'' AS display_value FROM dual;')))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158171944803674214)
,p_name=>'change items'
,p_event_sequence=>10
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P703_FILTER_TYPE, P703_FILTER_STATUS, P703_FILTER_ACTIVE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158172010470674215)
,p_event_id=>wwv_flow_imp.id(158171944803674214)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158156313928537623)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158172332319674218)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ACTIVATE_DEPLOYMENT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_id NUMBER := apex_application.g_x01;',
'BEGIN',
'    DEPLOYMENT_MANAGER_PKG.activate_deployment(',
'        p_deployment_id => v_deployment_id',
'    );',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Deployment activated successfully'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'ACTIVATE_DEPLOYMENT'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>158172332319674218
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158172404966674219)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PAUSE_DEPLOYMENT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_id NUMBER := apex_application.g_x01;',
'BEGIN',
'    DEPLOYMENT_MANAGER_PKG.pause_deployment(',
'        p_deployment_id => v_deployment_id',
'    );',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Deployment paused successfully'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'PAUSE_DEPLOYMENT'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>158172404966674219
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158172538464674220)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>' DEACTIVATE_DEPLOYMENT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_id NUMBER := apex_application.g_x01;',
'BEGIN',
'    DEPLOYMENT_MANAGER_PKG.deactivate_deployment(',
'        p_deployment_id => v_deployment_id',
'    );',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Deployment deactivated successfully'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'DEACTIVATE_DEPLOYMENT'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>158172538464674220
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158172616710674221)
,p_process_sequence=>40
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PROMOTE_CANARY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_id NUMBER := apex_application.g_x01;',
'BEGIN',
'    DEPLOYMENT_MANAGER_PKG.promote_canary_to_production(',
'        p_canary_deployment_id => v_deployment_id',
'    );',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''message'', ''Canary promoted to production successfully'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', false);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_when=>'PROMOTE_CANARY'
,p_process_when_type=>'REQUEST_EQUALS_CONDITION'
,p_internal_uid=>158172616710674221
);
wwv_flow_imp.component_end;
end;
/
