prompt --application/pages/page_00420
begin
--   Manifest
--     PAGE: 00420
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
 p_id=>420
,p_name=>'Context Dashboard'
,p_alias=>'CONTEXT-DASHBOARD'
,p_step_title=>'Context Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Quick Links Container */',
'.quick-links-container {',
'    margin-bottom: 2rem;',
'}',
'',
'.quick-links-header {',
'    margin-bottom: 1.5rem;',
'    text-align: center;',
'}',
'',
'.quick-links-header h3 {',
'    font-size: 1.5rem;',
'    margin: 0 0 0.5rem 0;',
'    color: #333;',
'}',
'',
'.quick-links-header .help-text {',
'    color: #666;',
'    font-size: 0.95rem;',
'    margin: 0;',
'}',
'',
'/* Grid Layout */',
'.quick-links-grid {',
'    display: grid;',
'    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));',
'    gap: 1rem;',
'    margin-top: 1rem;',
'}',
'',
'/* Card Styling */',
'.quick-link-card {',
'    display: flex;',
'    align-items: center;',
'    padding: 1.25rem;',
'    background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);',
'    border: 1px solid #e0e0e0;',
'    border-radius: 8px;',
'    text-decoration: none;',
'    color: inherit;',
'    transition: all 0.3s ease;',
'    position: relative;',
'    overflow: hidden;',
'}',
'',
'.quick-link-card:hover {',
'    transform: translateY(-2px);',
'    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);',
'    border-color: #3f51b5;',
'}',
'',
'.quick-link-card.current-page {',
'    background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);',
'    border-color: #2196f3;',
'}',
'',
'/* Card Components */',
'.card-icon {',
'    font-size: 2rem;',
'    margin-right: 1rem;',
'    flex-shrink: 0;',
'}',
'',
'.card-content {',
'    flex: 1;',
'}',
'',
'.card-content h4 {',
'    margin: 0 0 0.25rem 0;',
'    font-size: 1.1rem;',
'    color: #333;',
'}',
'',
'.card-content p {',
'    margin: 0;',
'    font-size: 0.9rem;',
'    color: #666;',
'}',
'',
'.card-arrow {',
'    font-size: 1.5rem;',
'    color: #3f51b5;',
'    margin-left: 1rem;',
'    flex-shrink: 0;',
'    opacity: 0;',
'    transform: translateX(-10px);',
'    transition: all 0.3s ease;',
'}',
'',
'.quick-link-card:hover .card-arrow {',
'    opacity: 1;',
'    transform: translateX(0);',
'}',
'',
'/* Badges */',
'.badge-page,',
'.badge-current {',
'    display: inline-block;',
'    padding: 0.25rem 0.5rem;',
'    border-radius: 4px;',
'    font-size: 0.75rem;',
'    font-weight: 600;',
'    margin-top: 0.5rem;',
'}',
'',
'.badge-page {',
'    background: #e0e0e0;',
'    color: #555;',
'}',
'',
'.badge-current {',
'    background: #2196f3;',
'    color: white;',
'}',
'',
'/* Responsive */',
'@media (max-width: 768px) {',
'    .quick-links-grid {',
'        grid-template-columns: 1fr;',
'    }',
'}',
'',
'',
'/* Domain Health Chart Styling */',
'.domain-health-chart {',
'    padding: 1rem;',
'    background: #ffffff;',
'    border-radius: 8px;',
'}',
'',
'/* Chart container */',
'.apex-charts-theme-default .apexcharts-canvas {',
'    margin: 0 auto;',
'}',
'',
'/* Customize tooltip */',
'.apexcharts-tooltip {',
'    background: rgba(255, 255, 255, 0.95) !important;',
'    border: 1px solid #e0e0e0 !important;',
'    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;',
'}',
'',
'/* Legend styling */',
'.apexcharts-legend {',
'    padding: 0.5rem !important;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161542402391169207)
,p_plug_name=>'Domain Health Matrix '
,p_region_css_classes=>'domain-health-chart'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_escape_on_http_output=>'Y'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    cd.domain_name AS label,',
'    cd.context_domain_code,',
'    (SELECT COUNT(*)',
'     FROM domain_intents di',
'     WHERE di.context_domain_id = cd.context_domain_id',
'       AND di.is_active = ''Y'') AS intent_count,',
'    (SELECT COUNT(DISTINCT cdr.context_registry_id)',
'     FROM context_domain_registry cdr',
'     WHERE cdr.context_domain_id = cd.context_domain_id',
'       AND cdr.is_active = ''Y'') AS data_source_count,',
'    CASE ',
'        WHEN (SELECT COUNT(*) FROM domain_intents di ',
'              WHERE di.context_domain_id = cd.context_domain_id ',
'                AND di.is_active = ''Y'') = 0 THEN ''#f44336''',
'        WHEN (SELECT COUNT(*) FROM domain_intents di ',
'              WHERE di.context_domain_id = cd.context_domain_id ',
'                AND di.is_active = ''Y'') < 3 THEN ''#ff9800''',
'        ELSE ''#4caf50''',
'    END AS status_color,',
'    CASE ',
'        WHEN (SELECT COUNT(*) FROM domain_intents di ',
'              WHERE di.context_domain_id = cd.context_domain_id ',
'                AND di.is_active = ''Y'') = 0 THEN ''No Intents Defined''',
'        WHEN (SELECT COUNT(*) FROM domain_intents di ',
'              WHERE di.context_domain_id = cd.context_domain_id ',
'                AND di.is_active = ''Y'') < 3 THEN ''Low Intent Coverage''',
'        ELSE ''Good Coverage''',
'    END AS status_text,',
'    cd.display_order,',
'    ''<strong>'' || cd.domain_name || ''</strong><br>'' ||',
'    ''Intents: <strong>'' || ',
'        (SELECT COUNT(*) FROM domain_intents di ',
'         WHERE di.context_domain_id = cd.context_domain_id ',
'           AND di.is_active = ''Y'') || ''</strong><br>'' ||',
'    ''Status: <span style="color:'' || ',
'        CASE ',
'            WHEN (SELECT COUNT(*) FROM domain_intents di ',
'                  WHERE di.context_domain_id = cd.context_domain_id ',
'                    AND di.is_active = ''Y'') = 0 THEN ''#f44336''',
'            WHEN (SELECT COUNT(*) FROM domain_intents di ',
'                  WHERE di.context_domain_id = cd.context_domain_id ',
'                    AND di.is_active = ''Y'') < 3 THEN ''#ff9800''',
'            ELSE ''#4caf50''',
'        END || '';">'' || ',
'        CASE ',
'            WHEN (SELECT COUNT(*) FROM domain_intents di ',
'                  WHERE di.context_domain_id = cd.context_domain_id ',
'                    AND di.is_active = ''Y'') = 0 THEN ''No Intents Defined''',
'            WHEN (SELECT COUNT(*) FROM domain_intents di ',
'                  WHERE di.context_domain_id = cd.context_domain_id ',
'                    AND di.is_active = ''Y'') < 3 THEN ''Low Intent Coverage''',
'            ELSE ''Good Coverage''',
'        END || ''</span>'' AS tooltip,',
'    ''<strong>'' || cd.domain_name || ''</strong><br>'' ||',
'    ''Data Sources: <strong>'' || ',
'        (SELECT COUNT(DISTINCT cdr.context_registry_id) ',
'         FROM context_domain_registry cdr ',
'         WHERE cdr.context_domain_id = cd.context_domain_id ',
'           AND cdr.is_active = ''Y'') || ''</strong>'' AS tooltip2',
'FROM context_domains cd',
'WHERE cd.is_active = ''Y''',
'ORDER BY cd.display_order NULLS LAST'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(161545556984169238)
,p_region_id=>wwv_flow_imp.id(161542402391169207)
,p_chart_type=>'combo'
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
 p_id=>wwv_flow_imp.id(161545635005169239)
,p_chart_id=>wwv_flow_imp.id(161545556984169238)
,p_seq=>10
,p_name=>'Intent Count'
,p_location=>'REGION_SOURCE'
,p_series_type=>'bar'
,p_items_value_column_name=>'INTENT_COUNT'
,p_group_short_desc_column_name=>'TOOLTIP'
,p_items_label_column_name=>'LABEL'
,p_color=>'&STATUS_COLOR.'
,p_line_style=>'solid'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(161545907433169242)
,p_chart_id=>wwv_flow_imp.id(161545556984169238)
,p_seq=>20
,p_name=>'Data Sources'
,p_location=>'REGION_SOURCE'
,p_series_type=>'line'
,p_items_value_column_name=>'DATA_SOURCE_COUNT'
,p_group_short_desc_column_name=>'TOOLTIP2'
,p_items_label_column_name=>'LABEL'
,p_color=>'#2196f3'
,p_line_style=>'solid'
,p_line_type=>'auto'
,p_marker_rendered=>'auto'
,p_marker_shape=>'auto'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(161545707282169240)
,p_chart_id=>wwv_flow_imp.id(161545556984169238)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_title=>'Context Domains'
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
 p_id=>wwv_flow_imp.id(161545886634169241)
,p_chart_id=>wwv_flow_imp.id(161545556984169238)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'Count'
,p_min=>0
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
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(161546086193169243)
,p_chart_id=>wwv_flow_imp.id(161545556984169238)
,p_axis=>'y2'
,p_is_rendered=>'on'
,p_format_scaling=>'auto'
,p_scaling=>'linear'
,p_baseline_scaling=>'zero'
,p_position=>'auto'
,p_major_tick_rendered=>'on'
,p_minor_tick_rendered=>'off'
,p_tick_label_rendered=>'on'
,p_split_dual_y=>'auto'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161543714875169220)
,p_plug_name=>'Domain Configuration Cards'
,p_title=>'Domain Configuration Cards'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc:t-CardsRegion--styleC'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>60
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    cd.context_domain_id,',
'    cd.domain_name,',
'    cd.context_domain_code,',
'    cd.description,',
'    ''fa ''|| cd.icon_class icon_class,',
'    cd.is_active,',
'    COUNT(DISTINCT di.domain_intent_id) AS intent_count,',
'    COUNT(DISTINCT cdr.context_registry_id) AS source_count,',
'    ROUND(',
'        (COUNT(DISTINCT di.domain_intent_id) * 50 + ',
'         COUNT(DISTINCT cdr.context_registry_id) * 3.33) / ',
'        NULLIF((5 * 50 + 15 * 3.33), 0) * 100, ',
'        0',
'    ) AS completion_pct,',
'    ''f?p=&APP_ID.:422:&SESSION.::&DEBUG.:RP,422:P422_CONTEXT_DOMAIN_ID:'' || cd.context_domain_id AS edit_link',
'FROM context_domains cd,  domain_intents di,',
'     context_domain_registry cdr',
'WHERE cd.context_domain_id = di.context_domain_id(+)',
'  AND cd.context_domain_id = cdr.context_domain_id(+)',
'GROUP BY ',
'    cd.context_domain_id,',
'    cd.domain_name,',
'    cd.context_domain_code,',
'    cd.description,',
'    cd.icon_class,',
'    cd.is_active',
' '))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161545390717169236)
,p_region_id=>wwv_flow_imp.id(161543714875169220)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'DOMAIN_NAME'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'CONTEXT_DOMAIN_CODE'
,p_body_adv_formatting=>false
,p_body_column_name=>'DESCRIPTION'
,p_second_body_adv_formatting=>true
,p_second_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Intent Count: &INTENT_COUNT. ,',
'Source Count: &SOURCE_COUNT.  '))
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'CONTEXT_DOMAIN_ID'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161545043162169233)
,p_plug_name=>'Domain Configuration Cards '
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>70
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    ''MISSING_INTENTS'' AS alert_type,',
'    ''Warning'' AS severity,',
'    cd.domain_name || '' has no intents defined'' AS message,',
'    ''f?p=&APP_ID.:422:&SESSION.::&DEBUG.:RP:P422_CONTEXT_DOMAIN_ID:'' || cd.context_domain_id AS action_link',
'FROM context_domains cd',
'WHERE NOT EXISTS (',
'    SELECT 1 ',
'    FROM domain_intents di ',
'    WHERE di.context_domain_id = cd.context_domain_id',
')',
'  AND cd.is_active = ''Y''',
'UNION ALL',
'SELECT ',
'    ''LOW_SOURCES'' AS alert_type,',
'    ''Info'' AS severity,',
'    cd.domain_name || '' has only '' || COUNT(cdr.context_registry_id) || '' data sources'' AS message,',
'    ''f?p=&APP_ID.:424:&SESSION.::&DEBUG.:::'' AS action_link',
'FROM context_domains cd,',
'     context_domain_registry cdr',
'WHERE cd.context_domain_id = cdr.context_domain_id(+)',
'  AND cd.is_active = ''Y''',
'GROUP BY cd.context_domain_id, cd.domain_name',
'HAVING COUNT(cdr.context_registry_id) < 5',
'UNION ALL',
'SELECT ',
'    ''INACTIVE_DOMAIN'' AS alert_type,',
'    ''Warning'' AS severity,',
'    domain_name || '' is marked as inactive'' AS message,',
'    ''f?p=&APP_ID.:422:&SESSION.::&DEBUG.:RP:P422_CONTEXT_DOMAIN_ID:'' || context_domain_id AS action_link',
'FROM context_domains',
'WHERE is_active = ''N'';'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161545185615169234)
,p_region_id=>wwv_flow_imp.id(161545043162169233)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'ALERT_TYPE'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'SEVERITY'
,p_body_adv_formatting=>false
,p_body_column_name=>'MESSAGE'
,p_second_body_adv_formatting=>false
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161545288196169235)
,p_plug_name=>'links'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="quick-links-container">',
'    <div class="quick-links-header">',
unistr('        <h3>\D83E\DDE9 Context & Intent Management</h3>'),
'        <p class="help-text">Quick access to all context and intent configuration pages</p>',
'    </div>',
'    ',
'    <div class="quick-links-grid">',
'        <!-- Current Page -->',
'        <div class="quick-link-card current-page">',
unistr('            <div class="card-icon">\D83D\DCCA</div>'),
'            <div class="card-content">',
'                <h4>Context Dashboard</h4>',
'                <p>Overview and metrics</p>',
'                <span class="badge-current">Current Page</span>',
'            </div>',
'        </div>',
'        ',
'        <!-- Page 422: Intention (Domains) List -->',
'        <a href="f?p=&APP_ID.:422:&SESSION.::&DEBUG.::::" class="quick-link-card">',
unistr('            <div class="card-icon">\D83C\DFAF</div>'),
'            <div class="card-content">',
'                <h4>Intention (Domains) List</h4>',
'                <p>Manage context domains</p>',
'                <span class="badge-page">Page 422</span>',
'            </div>',
unistr('            <div class="card-arrow">\2192</div>'),
'        </a>',
'        ',
'        <!-- Page 424: Data Sources Registry -->',
'        <a href="f?p=&APP_ID.:424:&SESSION.::&DEBUG.::::" class="quick-link-card">',
unistr('            <div class="card-icon">\D83D\DCBE</div>'),
'            <div class="card-content">',
'                <h4>Data Sources Registry</h4>',
'                <p>Configure data sources</p>',
'                <span class="badge-page">Page 424</span>',
'            </div>',
unistr('            <div class="card-arrow">\2192</div>'),
'        </a>',
'        ',
'        <!-- Page 426: Intention & Data Sources -->',
'        <a href="f?p=&APP_ID.:426:&SESSION.::&DEBUG.::::" class="quick-link-card">',
unistr('            <div class="card-icon">\D83D\DD17</div>'),
'            <div class="card-content">',
'                <h4>Intention & Data Sources</h4>',
'                <p>Link domains to sources</p>',
'                <span class="badge-page">Page 426</span>',
'            </div>',
unistr('            <div class="card-arrow">\2192</div>'),
'        </a>',
'        ',
'        <!-- Page 428: Data Sources & Roles -->',
'        <a href="f?p=&APP_ID.:428:&SESSION.::&DEBUG.::::" class="quick-link-card">',
unistr('            <div class="card-icon">\D83D\DD10</div>'),
'            <div class="card-content">',
'                <h4>Data Sources & Roles</h4>',
'                <p>Role-based access control</p>',
'                <span class="badge-page">Page 428</span>',
'            </div>',
unistr('            <div class="card-arrow">\2192</div>'),
'        </a>',
'        ',
'        <!-- Page 440: Domain Retriever -->',
'        <a href="f?p=&APP_ID.:440:&SESSION.::&DEBUG.::::" class="quick-link-card">',
unistr('            <div class="card-icon">\D83D\DD0D</div>'),
'            <div class="card-content">',
'                <h4>Domain Retriever</h4>',
'                <p>Test domain detection</p>',
'                <span class="badge-page">Page 440</span>',
'            </div>',
unistr('            <div class="card-arrow">\2192</div>'),
'        </a>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161545498830169237)
,p_plug_name=>'KPI'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_plug_grid_column_span=>6
,p_plug_display_column=>5
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161541842688169201)
,p_plug_name=>unistr('KPI 1 \2014 Context Domains')
,p_parent_plug_id=>wwv_flow_imp.id(161545498830169237)
,p_region_css_classes=>'&CARD_ICON.'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''Context Domains''      AS card_title,',
'    COUNT(*)               AS card_value,',
'    ''Active: '' || SUM(CASE WHEN is_active = ''Y'' THEN 1 ELSE 0 END)',
'    || '' | Default: '' || SUM(CASE WHEN is_default = ''Y'' THEN 1 ELSE 0 END)',
'                            AS card_subtext,',
'    ''fa fa-layers''       AS card_icon,',
'    ''is-info''              AS card_color',
'FROM context_domains;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161541906268169202)
,p_region_id=>wwv_flow_imp.id(161541842688169201)
,p_layout_type=>'GRID'
,p_component_css_classes=>'&CARD_COLOR.'
,p_title_adv_formatting=>false
,p_title_column_name=>'CARD_TITLE'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>'&CARD_SUBTEXT.'
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'CARD_ICON'
,p_icon_css_classes=>'&CARD_COLOR.'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161542013312169203)
,p_plug_name=>unistr('KPI 2 \2014 Intents')
,p_parent_plug_id=>wwv_flow_imp.id(161545498830169237)
,p_region_css_classes=>'&card_color.'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''Intents''                              AS card_title,',
'    COUNT(*)                               AS card_value,',
'    ''Active: '' || SUM(CASE WHEN is_active = ''Y'' THEN 1 ELSE 0 END)',
'    || '' | Domains: '' || COUNT(DISTINCT context_domain_id)',
'                                            AS card_subtext,',
'    ''fa fa-bullseye''                          AS card_icon,',
'    ''is-success''                          AS card_color',
'FROM domain_intents;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161542146681169204)
,p_region_id=>wwv_flow_imp.id(161542013312169203)
,p_layout_type=>'GRID'
,p_component_css_classes=>'&CARD_COLOR.'
,p_title_adv_formatting=>false
,p_title_column_name=>'CARD_TITLE'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>false
,p_body_column_name=>'CARD_SUBTEXT'
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'CARD_ICON'
,p_icon_css_classes=>'&CARD_COLOR.'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161542288659169205)
,p_plug_name=>unistr('KPI 3 \2014 Data Sources')
,p_parent_plug_id=>wwv_flow_imp.id(161545498830169237)
,p_region_css_classes=>'&CARD_ICON.'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''Data Sources''                        AS card_title,',
'    COUNT(*)                              AS card_value,',
'    ''Active: '' || SUM(CASE WHEN is_active = ''Y'' THEN 1 ELSE 0 END)',
'    || '' | Types: '' || COUNT(DISTINCT registry_source_type_code)',
'                                            AS card_subtext,',
'    ''fa fa-database''                         AS card_icon,',
'    ''is-warning''                          AS card_color',
'FROM context_registry;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161542365155169206)
,p_region_id=>wwv_flow_imp.id(161542288659169205)
,p_layout_type=>'GRID'
,p_component_css_classes=>'&CARD_COLOR.'
,p_title_adv_formatting=>false
,p_title_column_name=>'CARD_TITLE'
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>false
,p_body_column_name=>'CARD_SUBTEXT'
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'CARD_ICON'
,p_icon_css_classes=>'&CARD_COLOR.'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161546132585169244)
,p_plug_name=>'Help'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>40
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>2
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<h4>Domain Health Matrix</h4>',
'   <ul>',
'       <li><strong>Bars:</strong> Number of defined intents per domain</li>',
'       <li><strong>Line:</strong> Number of data sources linked to each domain</li>',
'       <li><strong>Colors:</strong>',
'           <ul>',
unistr('               <li>\D83D\DFE2 Green: Good coverage (3+ intents)</li>'),
unistr('               <li>\D83D\DFE1 Orange: Low coverage (1-2 intents)</li>'),
unistr('               <li>\D83D\DD34 Red: No intents defined</li>'),
'           </ul>',
'       </li>',
'   </ul>',
'   <p><em>Click bars to drill down to domain details</em></p>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp.component_end;
end;
/
