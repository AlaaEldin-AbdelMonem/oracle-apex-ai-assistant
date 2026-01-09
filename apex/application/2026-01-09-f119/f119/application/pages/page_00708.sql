prompt --application/pages/page_00708
begin
--   Manifest
--     PAGE: 00708
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
 p_id=>708
,p_name=>'Deployment Comparison'
,p_alias=>'DEPLOYMENT-COMPARISON'
,p_step_title=>'Deployment Comparison'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Load comparison winners',
'function loadComparisonWinners() {',
'    apex.server.process(''CALCULATE_WINNERS'', {}, {',
'        dataType: ''json'',',
'        success: function(data) {',
'            if (data.error) {',
'                console.error(''Error calculating winners:'', data.error);',
'                return;',
'            }',
'            ',
'            // Update latency winner',
'            $(''#latency-winner'').html(''<span class="fa fa-trophy"></span> '' + data.latency_winner);',
'            $(''#latency-difference'').text(data.latency_diff + '' ms difference'');',
'            ',
'            // Update cost winner',
'            $(''#cost-winner'').html(''<span class="fa fa-trophy"></span> '' + data.cost_winner);',
'            $(''#cost-difference'').text(''$'' + data.cost_diff.toFixed(6) + '' difference'');',
'            ',
'            // Update success winner',
'            $(''#success-winner'').html(''<span class="fa fa-trophy"></span> '' + data.success_winner);',
'            $(''#success-difference'').text(data.success_diff + ''% difference'');',
'            ',
'            // Update overall recommendation',
'            $(''#overall-recommendation'').html(''<span class="fa fa-star"></span> '' + data.overall_winner);',
'            ',
'            if (data.overall_winner === ''Mixed Results'') {',
'                $(''#recommendation-reason'').text(''Different deployments excel at different metrics. Consider your priorities when choosing.'');',
'            } else {',
'                $(''#recommendation-reason'').text(''This deployment wins on multiple key metrics.'');',
'            }',
'            ',
'            // Update statistical significance',
'            $(''#latency-p-value'').text(data.p_value.toFixed(4));',
'            ',
'            var significanceLabel = $(''#latency-significance'');',
'            if (data.p_value < 0.01) {',
'                significanceLabel.text(''Highly Significant (99% confidence)'')',
'                                .removeClass(''not-significant'')',
'                                .addClass(''significant'');',
'            } else if (data.p_value < 0.05) {',
'                significanceLabel.text(''Statistically Significant (95% confidence)'')',
'                                .removeClass(''not-significant'')',
'                                .addClass(''significant'');',
'            } else {',
'                significanceLabel.text(''Not Statistically Significant'')',
'                                .removeClass(''significant'')',
'                                .addClass(''not-significant'');',
'            }',
'        },',
'        error: function(xhr, status, error) {',
'            console.error(''AJAX error:'', error);',
'        }',
'    });',
'}',
'',
'// Export comparison results',
'function exportComparison() {',
'    var deploymentA = apex.item(''P708_DEPLOYMENT_A'').getValue();',
'    var deploymentB = apex.item(''P708_DEPLOYMENT_B'').getValue();',
'    var dateRange = apex.item(''P708_DATE_RANGE'').getValue();',
'    ',
'    if (!deploymentA || !deploymentB) {',
'        apex.message.showErrors([{',
'            type: ''error'',',
'            message: ''Please select both deployments to compare'',',
'            location: ''page''',
'        }]);',
'        return;',
'    }',
'    ',
'    window.location = ''f?p=&APP_ID.:708:&SESSION.:EXPORT_COMPARISON::'' +',
'                      ''P708_DEPLOYMENT_A,P708_DEPLOYMENT_B,P708_DATE_RANGE:'' +',
'                      deploymentA + '','' + deploymentB + '','' + dateRange;',
'}'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Comparison container */',
'.comparison-container {',
'    display: grid;',
'    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));',
'    gap: 1.5rem;',
'    margin: 1.5rem 0;',
'}',
'',
'.comparison-card {',
'    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);',
'    border-radius: 16px;',
'    padding: 1.5rem;',
'    color: white;',
'    text-align: center;',
'    box-shadow: 0 10px 20px rgba(0,0,0,0.1);',
'}',
'',
'.comparison-card h3 {',
'    margin-top: 0;',
'    margin-bottom: 1rem;',
'    font-size: 1.1rem;',
'    opacity: 0.9;',
'}',
'',
'.winner-badge {',
'    font-size: 1.8rem;',
'    font-weight: 700;',
'    margin: 1rem 0;',
'}',
'',
'.winner-badge .fa {',
'    color: #ffd700;',
'    margin-right: 0.5rem;',
'}',
'',
'.metric-difference {',
'    font-size: 1rem;',
'    opacity: 0.85;',
'    margin-top: 0.5rem;',
'}',
'',
'.recommendation-badge {',
'    font-size: 1.5rem;',
'    font-weight: 700;',
'    margin: 1rem 0;',
'}',
'',
'.recommendation-text {',
'    font-size: 0.95rem;',
'    margin-top: 0.75rem;',
'    line-height: 1.5;',
'}',
'',
'/* Statistical test styling */',
'.statistical-test-container {',
'    padding: 1.5rem;',
'}',
'',
'.test-result {',
'    background: #f8f9fa;',
'    border-radius: 12px;',
'    padding: 1.5rem;',
'    margin-bottom: 1.5rem;',
'}',
'',
'.test-result h4 {',
'    margin-top: 0;',
'    color: #333;',
'}',
'',
'.p-value-display {',
'    display: flex;',
'    align-items: center;',
'    gap: 1rem;',
'    margin: 1rem 0;',
'}',
'',
'.p-value-display .label {',
'    font-weight: 600;',
'    font-size: 1.1rem;',
'}',
'',
'.p-value {',
'    font-size: 2rem;',
'    font-weight: 700;',
'    color: #667eea;',
'}',
'',
'.significance-label {',
'    padding: 0.5rem 1rem;',
'    border-radius: 8px;',
'    font-weight: 600;',
'    display: inline-block;',
'    margin-top: 0.5rem;',
'}',
'',
'.significance-label.significant {',
'    background: #d4edda;',
'    color: #155724;',
'}',
'',
'.significance-label.not-significant {',
'    background: #f8d7da;',
'    color: #721c24;',
'}',
'',
'.test-explanation {',
'    background: #e7f3ff;',
'    border-left: 4px solid #2196F3;',
'    padding: 1rem 1.5rem;',
'    border-radius: 4px;',
'}',
'',
'.test-explanation p {',
'    margin-top: 0;',
'    font-weight: 600;',
'}',
'',
'.test-explanation ul {',
'    margin-bottom: 0;',
'}',
'',
'/* Filter region */',
'#comparison-filters .t-Form-fieldContainer {',
'    margin-bottom: 0;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158827431544853302)
,p_plug_name=>'Select Deployments to Compare'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(158827587707853303)
,p_name=>'Metrics Comparison'
,p_region_name=>'metrics-comparison'
,p_template=>4072358936313175081
,p_display_sequence=>60
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-AVPList--leftAligned'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH deployment_a AS (',
'    SELECT ',
'        ''Deployment A'' AS deployment_label,',
'        d.deployment_name,',
'        d.deployment_type,',
'        COUNT(m.message_id) AS total_calls,',
'        ROUND(AVG(m.PROVIDER_PROCESSING_MS), 2) AS avg_latency_ms,',
'       -- SUM(m.tokens_used) AS total_tokens,',
'       -- ROUND(SUM(m.tokens_used) * 0.002 / 1000, 4) AS total_cost_usd,',
'        ROUND(',
'            SUM(CASE WHEN m.user_prompt IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / ',
'            NULLIF(COUNT(m.call_id), 0),',
'            2',
'        ) AS success_rate_pct',
'    FROM DEPLOYMENT_VERSIONS d',
'    LEFT JOIN CHAT_CALLS m ON m.deployment_id = d.deployment_id',
'        AND m.DB_CREATED_AT >= TRUNC(SYSDATE) - :P708_DATE_RANGE',
'    WHERE d.deployment_id = :P708_DEPLOYMENT_A',
'    GROUP BY d.deployment_name, d.deployment_type',
'),',
'deployment_b AS (',
'    SELECT ',
'        ''Deployment B'' AS deployment_label,',
'        d.deployment_name,',
'        d.deployment_type,',
'        COUNT(m.message_id) AS total_calls,',
'       ROUND(AVG(m.PROVIDER_PROCESSING_MS), 2) AS avg_latency_ms,',
'       -- SUM(m.tokens_used) AS total_tokens,',
'       -- ROUND(SUM(m.tokens_used) * 0.002 / 1000, 4) AS total_cost_usd,',
'        ROUND(',
'            SUM(CASE WHEN m.user_prompt IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / ',
'            NULLIF(COUNT(m.call_id), 0),',
'            2',
'        ) AS success_rate_pct',
'    FROM DEPLOYMENT_VERSIONS d',
'    LEFT JOIN CHAT_CALLS m ON m.deployment_id = d.deployment_id',
'        AND m.DB_CREATED_AT >= TRUNC(SYSDATE) - :P708_DATE_RANGE',
'    WHERE d.deployment_id = :P708_DEPLOYMENT_B',
'    GROUP BY d.deployment_name, d.deployment_type',
')',
'SELECT * FROM deployment_a',
'UNION ALL',
'SELECT * FROM deployment_b'))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2100515439059797523
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
 p_id=>wwv_flow_imp.id(158828060448853308)
,p_query_column_id=>1
,p_column_alias=>'DEPLOYMENT_LABEL'
,p_column_display_sequence=>10
,p_column_heading=>'Deployment Label'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158828134427853309)
,p_query_column_id=>2
,p_column_alias=>'DEPLOYMENT_NAME'
,p_column_display_sequence=>20
,p_column_heading=>'Deployment Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158828231902853310)
,p_query_column_id=>3
,p_column_alias=>'DEPLOYMENT_TYPE'
,p_column_display_sequence=>30
,p_column_heading=>'Deployment Type'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158828369912853311)
,p_query_column_id=>4
,p_column_alias=>'TOTAL_CALLS'
,p_column_display_sequence=>40
,p_column_heading=>'Total Calls'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158828421039853312)
,p_query_column_id=>5
,p_column_alias=>'AVG_LATENCY_MS'
,p_column_display_sequence=>50
,p_column_heading=>'Avg Latency Ms'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158828518228853313)
,p_query_column_id=>6
,p_column_alias=>'SUCCESS_RATE_PCT'
,p_column_display_sequence=>60
,p_column_heading=>'Success Rate Pct'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158827613915853304)
,p_plug_name=>' Comparison Filters'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158828601304853314)
,p_plug_name=>'Winner Determination'
,p_region_name=>'winner-determination'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>70
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="comparison-container">',
'    <div class="comparison-card">',
'        <h3>Latency Winner</h3>',
'        <div id="latency-winner" class="winner-badge">',
'            <span class="fa fa-trophy"></span> Loading...',
'        </div>',
'        <div id="latency-difference" class="metric-difference">-</div>',
'    </div>',
'    ',
'    <div class="comparison-card">',
'        <h3>Cost Efficiency Winner</h3>',
'        <div id="cost-winner" class="winner-badge">',
'            <span class="fa fa-trophy"></span> Loading...',
'        </div>',
'        <div id="cost-difference" class="metric-difference">-</div>',
'    </div>',
'    ',
'    <div class="comparison-card">',
'        <h3>Success Rate Winner</h3>',
'        <div id="success-winner" class="winner-badge">',
'            <span class="fa fa-trophy"></span> Loading...',
'        </div>',
'        <div id="success-difference" class="metric-difference">-</div>',
'    </div>',
'    ',
'    <div class="comparison-card">',
'        <h3>Overall Recommendation</h3>',
'        <div id="overall-recommendation" class="recommendation-badge">',
'            <span class="fa fa-star"></span> Analyzing...',
'        </div>',
'        <div id="recommendation-reason" class="recommendation-text">-</div>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158828746791853315)
,p_plug_name=>'Performance Trends Comparison'
,p_region_name=>'trend-comparison-chart'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH deployment_a_trend AS (',
'    SELECT ',
'        TO_CHAR(TRUNC(m.db_created_at, ''HH''), ''YYYY-MM-DD HH24:MI'') AS time_label,',
'        ROUND(AVG(m.provider_processing_ms), 2) AS avg_latency_a,',
'        0 AS avg_latency_b',
'    FROM CHAT_CALLS m',
'    WHERE m.deployment_id = :P708_DEPLOYMENT_A',
'      AND m.DB_CREATED_AT >= TRUNC(SYSDATE) - :P708_DATE_RANGE',
'    GROUP BY TRUNC(m.DB_CREATED_AT, ''HH'')',
'),',
'deployment_b_trend AS (',
'    SELECT ',
'        TO_CHAR(TRUNC(m.DB_CREATED_AT, ''HH''), ''YYYY-MM-DD HH24:MI'') AS time_label,',
'        0 AS avg_latency_a,',
'        ROUND(AVG(m.provider_processing_ms), 2) AS avg_latency_b',
'    FROM CHAT_CALLS m',
'    WHERE m.deployment_id = :P708_DEPLOYMENT_B',
'      AND m.db_created_at >= TRUNC(SYSDATE) - :P708_DATE_RANGE',
'    GROUP BY TRUNC(m.DB_CREATED_AT, ''HH'')',
')',
'SELECT ',
'    time_label,',
'    MAX(avg_latency_a) AS deployment_a_latency,',
'    MAX(avg_latency_b) AS deployment_b_latency',
'FROM (',
'    SELECT * FROM deployment_a_trend',
'    UNION ALL',
'    SELECT * FROM deployment_b_trend',
')',
'GROUP BY time_label',
'ORDER BY time_label'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(158828895443853316)
,p_region_id=>wwv_flow_imp.id(158828746791853315)
,p_chart_type=>'line'
,p_height=>'400'
,p_animation_on_display=>'auto'
,p_animation_on_data_change=>'auto'
,p_orientation=>'vertical'
,p_data_cursor=>'auto'
,p_data_cursor_behavior=>'auto'
,p_hover_behavior=>'dim'
,p_stack=>'off'
,p_connect_nulls=>'Y'
,p_sorting=>'label-asc'
,p_fill_multi_series_gaps=>true
,p_zoom_and_scroll=>'off'
,p_tooltip_rendered=>'Y'
,p_show_series_name=>true
,p_show_group_name=>true
,p_show_value=>true
,p_legend_rendered=>'off'
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(158828903063853317)
,p_chart_id=>wwv_flow_imp.id(158828895443853316)
,p_seq=>10
,p_name=>'deployement1'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'DEPLOYMENT_A_LATENCY'
,p_items_label_column_name=>'TIME_LABEL'
,p_color=>'#667eea'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(158829289404853320)
,p_chart_id=>wwv_flow_imp.id(158828895443853316)
,p_seq=>20
,p_name=>'deployement2'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'DEPLOYMENT_B_LATENCY'
,p_items_label_column_name=>'TIME_LABEL'
,p_color=>'#f093fb'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(158829092579853318)
,p_chart_id=>wwv_flow_imp.id(158828895443853316)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_tick_label_rotation=>'auto'
,p_tick_label_position=>'outside'
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(158829146685853319)
,p_chart_id=>wwv_flow_imp.id(158828895443853316)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Avg Latency (ms)'
,p_format_type=>'decimal'
,p_decimal_places=>0
,p_format_scaling=>'none'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158829374925853321)
,p_plug_name=>'Statistical Significance Test'
,p_region_name=>'statistical-test'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>90
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="statistical-test-container">',
'    <div class="test-result">',
'        <h4>Latency Comparison (Welch''s t-test)</h4>',
'        <div class="p-value-display">',
'            <span class="label">p-value:</span>',
'            <span id="latency-p-value" class="p-value">-</span>',
'        </div>',
'        <div id="latency-significance" class="significance-label">-</div>',
'    </div>',
'    ',
'    <div class="test-explanation">',
'        <p><strong>Interpretation:</strong></p>',
'        <ul>',
'            <li><strong>p < 0.05:</strong> Statistically significant difference (95% confidence)</li>',
'            <li><strong>p < 0.01:</strong> Highly significant difference (99% confidence)</li>',
unistr('            <li><strong>p \2265 0.05:</strong> No statistically significant difference</li>'),
'        </ul>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(159358171059979811)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158827740087853305)
,p_name=>'P708_DEPLOYMENT_B'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158827613915853304)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT deployment_id ',
'FROM DEPLOYMENT_VERSIONS ',
'WHERE deployment_type = ''SHADOW'' ',
'  AND is_active = ''Y''',
'  AND ROWNUM = 1'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Deployment B'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    d.deployment_name || '' ('' || d.deployment_type || '')'' AS display_value,',
'    d.deployment_id AS return_value',
'FROM DEPLOYMENT_VERSIONS d',
'ORDER BY d.deployment_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Deployment B -'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158827813965853306)
,p_name=>'P708_DEPLOYMENT_A'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158827613915853304)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT deployment_id ',
'FROM DEPLOYMENT_VERSIONS ',
'WHERE deployment_type = ''PRODUCTION'' ',
'  AND is_active = ''Y''',
'  AND ROWNUM = 1'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Deployment A'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    d.deployment_name || '' ('' || d.deployment_type || '')'' AS display_value,',
'    d.deployment_id AS return_value',
'FROM DEPLOYMENT_VERSIONS d',
'ORDER BY d.deployment_name'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Select Deployment A -'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(158827956074853307)
,p_name=>'P708_DATE_RANGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(158827613915853304)
,p_item_default=>'7'
,p_prompt=>'Time Period'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Last 24 Hours;1,Last 7 Days;7,Last 30 Days;30,Last 35 Days;35,Last 90 Days;90'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_colspan=>4
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158829530277853323)
,p_name=>'Load Comparison on Page Load'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158829681371853324)
,p_event_id=>wwv_flow_imp.id(158829530277853323)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>'loadComparisonWinners();'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_server_condition_type=>'ITEM_IS_NOT_NULL'
,p_server_condition_expr1=>'P708_DEPLOYMENT_A,P708_DEPLOYMENT_B'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158829784313853325)
,p_name=>'Refresh on Deployment Change'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P708_DEPLOYMENT_A'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158829817820853326)
,p_event_id=>wwv_flow_imp.id(158829784313853325)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'loadComparisonWinners();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158829904246853327)
,p_event_id=>wwv_flow_imp.id(158829784313853325)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158827587707853303)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158830031222853328)
,p_event_id=>wwv_flow_imp.id(158829784313853325)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158828746791853315)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158830944082853337)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P708_DEPLOYMENT_B'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831018334853338)
,p_event_id=>wwv_flow_imp.id(158830944082853337)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'loadComparisonWinners();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831335879853341)
,p_event_id=>wwv_flow_imp.id(158830944082853337)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158827587707853303)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831451655853342)
,p_event_id=>wwv_flow_imp.id(158830944082853337)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158828746791853315)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(158831182674853339)
,p_name=>'New_1'
,p_event_sequence=>40
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P708_DATE_RANGE'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831264445853340)
,p_event_id=>wwv_flow_imp.id(158831182674853339)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'loadComparisonWinners();'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831556272853343)
,p_event_id=>wwv_flow_imp.id(158831182674853339)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158827587707853303)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(158831684023853344)
,p_event_id=>wwv_flow_imp.id(158831182674853339)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(158828746791853315)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(158829443803853322)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'CALCULATE_WINNERS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_deployment_a_id NUMBER := TO_NUMBER(:P708_DEPLOYMENT_A);',
'    v_deployment_b_id NUMBER := TO_NUMBER(:P708_DEPLOYMENT_B);',
'    v_date_range NUMBER := TO_NUMBER(:P708_DATE_RANGE);',
'    ',
'    -- Deployment A metrics',
'    v_a_name VARCHAR2(200);',
'    v_a_calls NUMBER := 0;',
'    v_a_latency NUMBER := 0;',
'    v_a_cost NUMBER := 0;',
'    v_a_success NUMBER := 0;',
'    ',
'    -- Deployment B metrics',
'    v_b_name VARCHAR2(200);',
'    v_b_calls NUMBER := 0;',
'    v_b_latency NUMBER := 0;',
'    v_b_cost NUMBER := 0;',
'    v_b_success NUMBER := 0;',
'    ',
'    -- Winners',
'    v_latency_winner VARCHAR2(200);',
'    v_cost_winner VARCHAR2(200);',
'    v_success_winner VARCHAR2(200);',
'    v_overall_winner VARCHAR2(200);',
'    ',
'    -- Differences',
'    v_latency_diff NUMBER;',
'    v_cost_diff NUMBER;',
'    v_success_diff NUMBER;',
'    ',
'    -- Statistical significance',
'    v_p_value NUMBER;',
'BEGIN',
'    -- Get Deployment A metrics',
'    SELECT ',
'        d.deployment_name,',
'        COUNT(m.message_id),',
'        ROUND(AVG(m.processing_time_ms), 2),',
'        ROUND(SUM(m.tokens_used) * 0.002 / 1000, 4),',
'        ROUND(SUM(CASE WHEN m.message_content IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / ',
'              NULLIF(COUNT(m.message_id), 0), 2)',
'    INTO v_a_name, v_a_calls, v_a_latency, v_a_cost, v_a_success',
'    FROM DEPLOYMENT_VERSIONS d',
'    LEFT JOIN AI_CHAT_MESSAGES m ON m.deployment_id = d.deployment_id',
'        AND m.created_at >= TRUNC(SYSDATE) - v_date_range',
'    WHERE d.deployment_id = v_deployment_a_id',
'    GROUP BY d.deployment_name;',
'    ',
'    -- Get Deployment B metrics',
'    SELECT ',
'        d.deployment_name,',
'        COUNT(m.message_id),',
'        ROUND(AVG(m.processing_time_ms), 2),',
'        ROUND(SUM(m.tokens_used) * 0.002 / 1000, 4),',
'        ROUND(SUM(CASE WHEN m.message_content IS NOT NULL THEN 1 ELSE 0 END) * 100.0 / ',
'              NULLIF(COUNT(m.message_id), 0), 2)',
'    INTO v_b_name, v_b_calls, v_b_latency, v_b_cost, v_b_success',
'    FROM DEPLOYMENT_VERSIONS d',
'    LEFT JOIN AI_CHAT_MESSAGES m ON m.deployment_id = d.deployment_id',
'        AND m.created_at >= TRUNC(SYSDATE) - v_date_range',
'    WHERE d.deployment_id = v_deployment_b_id',
'    GROUP BY d.deployment_name;',
'    ',
'    -- Determine winners (lower is better for latency and cost, higher for success)',
'    v_latency_winner := CASE WHEN v_a_latency <= v_b_latency THEN v_a_name ELSE v_b_name END;',
'    v_cost_winner := CASE WHEN v_a_cost <= v_b_cost THEN v_a_name ELSE v_b_name END;',
'    v_success_winner := CASE WHEN v_a_success >= v_b_success THEN v_a_name ELSE v_b_name END;',
'    ',
'    -- Calculate differences',
'    v_latency_diff := ROUND(ABS(v_a_latency - v_b_latency), 2);',
'    v_cost_diff := ROUND(ABS(v_a_cost - v_b_cost), 6);',
'    v_success_diff := ROUND(ABS(v_a_success - v_b_success), 2);',
'    ',
'    -- Calculate statistical significance',
'    v_p_value := DEPLOYMENT_MANAGER_PKG.calculate_statistical_significance(',
'        v_deployment_a_id,',
'        v_deployment_b_id,',
'        ''latency''',
'    );',
'    ',
'    -- Determine overall recommendation',
'    IF v_latency_winner = v_cost_winner AND v_latency_winner = v_success_winner THEN',
'        v_overall_winner := v_latency_winner;',
'    ELSIF v_latency_winner = v_cost_winner THEN',
'        v_overall_winner := v_latency_winner;',
'    ELSE',
'        v_overall_winner := ''Mixed Results'';',
'    END IF;',
'    ',
'    -- Return JSON',
'    apex_json.open_object;',
'    apex_json.write(''latency_winner'', v_latency_winner);',
'    apex_json.write(''cost_winner'', v_cost_winner);',
'    apex_json.write(''success_winner'', v_success_winner);',
'    apex_json.write(''overall_winner'', v_overall_winner);',
'    apex_json.write(''latency_diff'', v_latency_diff);',
'    apex_json.write(''cost_diff'', v_cost_diff);',
'    apex_json.write(''success_diff'', v_success_diff);',
'    apex_json.write(''p_value'', NVL(v_p_value, 0.99));',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_internal_uid=>158829443803853322
);
wwv_flow_imp.component_end;
end;
/
