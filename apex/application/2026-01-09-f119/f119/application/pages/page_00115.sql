prompt --application/pages/page_00115
begin
--   Manifest
--     PAGE: 00115
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
 p_id=>115
,p_name=>'Feedback Dashboard'
,p_alias=>'FEEDBACK-DASHBOARD'
,p_step_title=>'Feedback Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* KPI Cards Styling */',
'.kpi-cards-container {',
'    display: grid;',
'    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));',
'    gap: 1.5rem;',
'    margin-bottom: 2rem;',
'}',
'',
'.kpi-card {',
'    display: flex;',
'    align-items: center;',
'    padding: 1.5rem;',
'    background: white;',
'    border-radius: 12px;',
'    box-shadow: 0 2px 8px rgba(0,0,0,0.1);',
'    transition: transform 0.2s, box-shadow 0.2s;',
'}',
'',
'.kpi-card:hover {',
'    transform: translateY(-4px);',
'    box-shadow: 0 4px 16px rgba(0,0,0,0.15);',
'}',
'',
'.kpi-card.alert-warning {',
'    border-left: 4px solid #ff9800;',
'}',
'',
'.kpi-card.alert-danger {',
'    border-left: 4px solid #f44336;',
'}',
'',
'.kpi-icon {',
'    width: 60px;',
'    height: 60px;',
'    border-radius: 12px;',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'    margin-right: 1rem;',
'    color: white;',
'}',
'',
'.kpi-content {',
'    flex: 1;',
'}',
'',
'.kpi-value {',
'    font-size: 2rem;',
'    font-weight: 700;',
'    color: #333;',
'    line-height: 1;',
'    margin-bottom: 0.5rem;',
'}',
'',
'.kpi-unit {',
'    font-size: 1.2rem;',
'    color: #666;',
'    font-weight: 400;',
'}',
'',
'.kpi-label {',
'    font-size: 0.9rem;',
'    color: #666;',
'    text-transform: uppercase;',
'    letter-spacing: 0.5px;',
'}',
'',
'/* Status Badges */',
'.status-badge {',
'    display: inline-block;',
'    padding: 0.35rem 0.75rem;',
'    border-radius: 20px;',
'    font-size: 0.85rem;',
'    font-weight: 600;',
'}',
'',
'.status-new {',
'    background: #e3f2fd;',
'    color: #1976d2;',
'}',
'',
'.status-progress {',
'    background: #fff3e0;',
'    color: #f57c00;',
'}',
'',
'.status-resolved {',
'    background: #e8f5e9;',
'    color: #388e3c;',
'}',
'',
'.status-closed {',
'    background: #f5f5f5;',
'    color: #757575;',
'}',
'',
'/* Priority Badges */',
'.badge {',
'    display: inline-block;',
'    padding: 0.25rem 0.6rem;',
'    font-size: 0.8rem;',
'    font-weight: 600;',
'    border-radius: 4px;',
'}',
'',
'.badge-danger {',
'    background: #f44336;',
'    color: white;',
'}',
'',
'.badge-warning {',
'    background: #ff9800;',
'    color: white;',
'}',
'',
'.badge-info {',
'    background: #2196f3;',
'    color: white;',
'}',
'',
'.badge-success {',
'    background: #4caf50;',
'    color: white;',
'}',
'',
'.badge-secondary {',
'    background: #9e9e9e;',
'    color: white;',
'}',
'',
'',
'',
'.quick-actions-bar {',
'    display: flex;',
'    gap: 1rem;',
'    margin-bottom: 1.5rem;',
'    padding: 1rem;',
'    background: #f8f9fa;',
'    border-radius: 8px;',
'    flex-wrap: wrap;',
'}',
'',
'.quick-actions-bar .t-Button {',
'    flex: 0 1 auto;',
'}',
'',
'@media (max-width: 768px) {',
'    .quick-actions-bar {',
'        flex-direction: column;',
'    }',
'    .quick-actions-bar .t-Button {',
'        width: 100%;',
'    }',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(155700403222219558)
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
 p_id=>wwv_flow_imp.id(161676364123437903)
,p_plug_name=>'badges'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
' SELECT ',
'    label AS list_title, ',
'    TO_CHAR(value) ||'' ''||label  AS list_badge,  -- Convert to VARCHAR2 for badge display',
'    -- Mapping Icons to #ICON_CLASS#',
'    CASE label ',
'        WHEN ''Total Issues''          THEN ''fa fa-list''',
'        WHEN ''Open Issues''           THEN ''fa fa-exclamation-circle''',
'        WHEN ''Resolved Today''        THEN ''fa fa-check-circle''',
'        WHEN ''Critical Open''         THEN ''fa fa-fire''',
'        WHEN ''My Issues''             THEN ''fa fa-user''',
'        WHEN ''With Attachments''      THEN ''fa fa-paperclip''',
'        WHEN ''Avg Resolution (Days)'' THEN ''fa fa-clock-o''',
'        WHEN ''New Today''             THEN ''fa fa-calendar-plus-o''',
'    END AS icon_class,',
'    -- Mapping Colors to #ICON_COLOR_CLASS#',
'    CASE label ',
'        WHEN ''Critical Open''         THEN ''u-color-9'' -- Red',
'        WHEN ''Resolved Today''        THEN ''u-color-5'' -- Green',
'        WHEN ''Open Issues''           THEN ''u-color-7'' -- Orange',
'        ELSE ''u-color-1''                              -- Blue',
'    END AS icon_color_class,',
'    -- Optional text for #LIST_TEXT#',
'    ''Updated just now'' AS list_text,',
'    -- Add display order for consistent badge arrangement',
'    CASE label',
'        WHEN ''Total Issues''          THEN 1',
'        WHEN ''Open Issues''           THEN 2',
'        WHEN ''Critical Open''         THEN 3',
'        WHEN ''My Issues''             THEN 4',
'        WHEN ''New Today''             THEN 5',
'        WHEN ''Resolved Today''        THEN 6',
'        WHEN ''With Attachments''      THEN 7',
'        WHEN ''Avg Resolution (Days)'' THEN 8',
'    END AS display_order ',
'FROM (',
'    SELECT ',
'        COUNT(*) AS total,',
'        COUNT(CASE ',
'            WHEN chat_issue_status_code NOT IN (',
'                SELECT chat_issue_status_code ',
'                FROM lkp_chat_issue_status ',
'                WHERE UPPER(issue_status) LIKE ''%RESOLV%'' ',
'                   OR UPPER(issue_status) LIKE ''%CLOS%''',
'            ) THEN 1 ',
'        END) AS open_iss,',
'        COUNT(CASE ',
'            WHEN TRUNC(resolved_at) = TRUNC(SYSDATE) THEN 1 ',
'        END) AS res_today,',
'        COUNT(CASE ',
'            WHEN chat_issue_priority_code IN (''CR'', ''HI'') ',
'             AND chat_issue_status_code = ''NW'' THEN 1 ',
'        END) AS crit,',
'        COUNT(CASE ',
'            WHEN user_id = :APP_USER_ID THEN 1 ',
'        END) AS mine,',
'        COUNT(CASE ',
'            WHEN attachment_count > 0 ',
'              OR has_screenshot = ''Y'' THEN 1 ',
'        END) AS attach,',
'        NVL(',
'            ROUND(',
'                AVG(CASE ',
'                    WHEN resolved_at IS NOT NULL ',
'                     AND resolved_at > SYSDATE - 30 ',
'                    THEN CAST(resolved_at AS DATE) - CAST(reported_at AS DATE) ',
'                END), ',
'                1',
'            ), ',
'            0',
'        ) AS avg_d,',
'        COUNT(CASE ',
'            WHEN TRUNC(reported_at) = TRUNC(SYSDATE) THEN 1 ',
'        END) AS today',
'    FROM chat_issues',
')',
'UNPIVOT (',
'    value FOR label IN (',
'        total     AS ''Total Issues'',',
'        open_iss  AS ''Open Issues'',',
'        res_today AS ''Resolved Today'',',
'        crit      AS ''Critical Open'',',
'        mine      AS ''My Issues'',',
'        attach    AS ''With Attachments'',',
'        avg_d     AS ''Avg Resolution (Days)'',',
'        today     AS ''New Today''',
'    )',
')',
' '))
,p_template_component_type=>'REPORT'
,p_lazy_loading=>false
,p_plug_source_type=>'TMPL_THEME_42$BADGE'
,p_plug_query_num_rows=>15
,p_plug_query_num_rows_type=>'SET'
,p_show_total_row_count=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'ICON', '&ICON_CLASS.',
  'LABEL', '&LIST_TEXT.',
  'LABEL_DISPLAY', 'N',
  'SHAPE', 't-Badge--circle',
  'SIZE', 't-Badge--lg',
  'STATE', 'LIST_TEXT',
  'STYLE', 't-Badge--subtle',
  'VALUE', 'LIST_BADGE')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161678608031437926)
,p_name=>'LIST_TITLE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LIST_TITLE'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>10
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161678700875437927)
,p_name=>'LIST_BADGE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LIST_BADGE'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>20
,p_is_group=>false
,p_use_as_row_header=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161678870612437928)
,p_name=>'ICON_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ICON_CLASS'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>30
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161678914764437929)
,p_name=>'ICON_COLOR_CLASS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ICON_COLOR_CLASS'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>40
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161679090906437930)
,p_name=>'LIST_TEXT'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LIST_TEXT'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>50
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(161679177797437931)
,p_name=>'DISPLAY_ORDER'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'DISPLAY_ORDER'
,p_data_type=>'NUMBER'
,p_display_sequence=>60
,p_is_group=>false
,p_use_as_row_header=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161676425896437904)
,p_plug_name=>'Issues Trend (Last 30 days)'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_escape_on_http_output=>'Y'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'WITH date_series AS (',
'    SELECT TRUNC(SYSDATE) - LEVEL + 1 AS report_date',
'    FROM dual',
'    CONNECT BY LEVEL <= 30',
')',
'SELECT ',
'    TO_CHAR(ds.report_date, ''MM-DD'') AS label,',
'    ds.report_date,',
'    NVL(reported.issue_count, 0) AS "Issues Reported",',
'    NVL(resolved.issue_count, 0) AS "Issues Resolved"',
'FROM date_series ds,',
'     (SELECT TRUNC(reported_at) AS report_date, ',
'             COUNT(*) AS issue_count',
'      FROM chat_issues',
'      WHERE reported_at >= TRUNC(SYSDATE) - 30',
'      GROUP BY TRUNC(reported_at)) reported,',
'     (SELECT TRUNC(resolved_at) AS report_date, ',
'             COUNT(*) AS issue_count',
'      FROM chat_issues',
'      WHERE resolved_at >= TRUNC(SYSDATE) - 30',
'      GROUP BY TRUNC(resolved_at)) resolved',
'WHERE ds.report_date = reported.report_date(+)',
'  AND ds.report_date = resolved.report_date(+)',
'ORDER BY ds.report_date'))
,p_plug_source_type=>'NATIVE_JET_CHART'
);
wwv_flow_imp_page.create_jet_chart(
 p_id=>wwv_flow_imp.id(161678082990437920)
,p_region_id=>wwv_flow_imp.id(161676425896437904)
,p_chart_type=>'bar'
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
 p_id=>wwv_flow_imp.id(161678122389437921)
,p_chart_id=>wwv_flow_imp.id(161678082990437920)
,p_seq=>10
,p_name=>'Issues reported '
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'Issues Reported'
,p_items_label_column_name=>'LABEL'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_series(
 p_id=>wwv_flow_imp.id(161678475086437924)
,p_chart_id=>wwv_flow_imp.id(161678082990437920)
,p_seq=>20
,p_name=>'Issues resolved'
,p_location=>'REGION_SOURCE'
,p_items_value_column_name=>'Issues Resolved'
,p_items_label_column_name=>'LABEL'
,p_color=>'#eb1919'
,p_assigned_to_y2=>'off'
,p_items_label_rendered=>false
);
wwv_flow_imp_page.create_jet_chart_axis(
 p_id=>wwv_flow_imp.id(161678276170437922)
,p_chart_id=>wwv_flow_imp.id(161678082990437920)
,p_axis=>'x'
,p_is_rendered=>'on'
,p_title=>'Date'
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
 p_id=>wwv_flow_imp.id(161678353434437923)
,p_chart_id=>wwv_flow_imp.id(161678082990437920)
,p_axis=>'y'
,p_is_rendered=>'on'
,p_title=>'No.Of Issues'
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
 p_id=>wwv_flow_imp.id(161676512361437905)
,p_plug_name=>'Open Issues'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>40
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    ci.chat_issue_id,',
'    ci.issue_title,',
'    SUBSTR(ci.issue_description, 1, 150) || ',
'        CASE WHEN LENGTH(ci.issue_description) > 150 THEN ''...'' ELSE '''' END AS description_preview,',
'    lit.issue_type_name,',
'    lit.icon_class,',
'    lp.priority_name,',
'    CASE ci.chat_issue_priority_code',
'        WHEN ''CR'' THEN ''#f44336''',
'        WHEN ''HI'' THEN ''#ff9800''',
'        WHEN ''ME'' THEN ''#ffc107''',
'        WHEN ''LO'' THEN ''#4caf50''',
'        ELSE ''#9e9e9e''',
'    END AS priority_color,',
'    TO_CHAR(ci.reported_at, ''YYYY-MM-DD HH24:MI'') AS reported_at_fmt,',
'    -- FIX: Cast TIMESTAMP to DATE before subtraction',
'    ROUND(SYSDATE - CAST(ci.reported_at AS DATE), 1) AS days_open,',
'    ''f?p=&APP_ID.:121:&SESSION.::&DEBUG.:RP:P121_CHAT_ISSUE_ID:'' || ci.chat_issue_id AS edit_url',
'FROM chat_issues ci,',
'     lkp_issue_types lit,',
'     lkp_chat_issue_priority lp',
'WHERE ci.chat_issue_type_code = lit.issue_type_code(+)',
'  AND ci.chat_issue_priority_code = lp.chat_issue_priority_code(+)',
'  --AND ci.chat_issue_status_code NOT IN (',
'   --  SELECT chat_issue_status_code ',
'     -- FROM lkp_chat_issue_status ',
'     -- WHERE UPPER(issue_status) LIKE ''%RESOLV%'' ',
'      --   OR UPPER(issue_status) LIKE ''%CLOS%''',
'--  )',
'ORDER BY ',
'    CASE ci.chat_issue_priority_code',
'        WHEN ''CR'' THEN 1',
'        WHEN ''HI'' THEN 2',
'        WHEN ''ME'' THEN 3',
'        WHEN ''LO'' THEN 4',
'        ELSE 5',
'    END,',
'    ci.reported_at DESC'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(161678593546437925)
,p_region_id=>wwv_flow_imp.id(161676512361437905)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'ISSUE_TITLE'
,p_sub_title_adv_formatting=>false
,p_sub_title_column_name=>'ISSUE_TYPE_NAME'
,p_body_adv_formatting=>false
,p_body_column_name=>'DESCRIPTION_PREVIEW'
,p_second_body_adv_formatting=>false
,p_second_body_column_name=>'REPORTED_AT_FMT'
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON_CLASS'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'CHAT_ISSUE_ID'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(161679393770437933)
,p_plug_name=>'Quick Actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="quick-actions-bar">',
'    <a href="f?p=&APP_ID.:120:&SESSION.::&DEBUG.:::" class="t-Button t-Button--primary t-Button--iconLeft">',
'        <span class="t-Icon t-Icon--left fa fa-bug" aria-hidden="true"></span>',
'        View All User Issues',
'    </a> ',
'    ',
'    <a href="f?p=&APP_ID.:115:&SESSION.::&DEBUG.:::" class="t-Button t-Button--simple t-Button--iconLeft">',
'        <span class="t-Icon t-Icon--left fa fa-refresh" aria-hidden="true"></span>',
'        Refresh Dashboard',
'    </a>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp.component_end;
end;
/
