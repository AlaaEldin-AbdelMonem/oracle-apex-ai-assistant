prompt --application/pages/page_00702
begin
--   Manifest
--     PAGE: 00702
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
 p_id=>702
,p_name=>'Deployment Dashboard'
,p_alias=>'DEPLOYMENT-DASHBOARD'
,p_step_title=>'Deployment Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(155691311978186649)
,p_name=>'Dashboard Statistics'
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT COUNT(*) AS value, ''active_deployments'' AS label',
'FROM DEPLOYMENT_VERSIONS',
'WHERE is_active = ''Y''',
'',
'UNION ALL',
'',
'SELECT COUNT(*) AS value, ''production_count'' AS label',
'FROM DEPLOYMENT_VERSIONS',
'WHERE deployment_type = ''PRODUCTION'' AND is_active = ''Y''',
'',
'UNION ALL',
'',
'SELECT COUNT(*) AS value, ''shadow_count'' AS label',
'FROM DEPLOYMENT_VERSIONS',
'WHERE deployment_type = ''SHADOW'' AND is_active = ''Y''',
'',
'UNION ALL',
'',
'SELECT COUNT(*) AS value, ''canary_count'' AS label',
'FROM DEPLOYMENT_VERSIONS',
'WHERE deployment_type = ''CANARY'' AND is_active = ''Y''',
'',
'UNION ALL',
'',
'SELECT COUNT(*) AS value, ''active_experiments'' AS label',
'FROM DEPLOYMENT_EXPERIMENTS',
'WHERE experiment_status = ''RUNNING''',
'',
'UNION ALL',
'',
'SELECT COUNT(DISTINCT user_id) AS value, ''users_in_segments'' AS label',
'FROM USER_SEGMENT_ASSIGNMENTS',
'WHERE is_active = ''Y''',
'',
'UNION ALL',
'',
'SELECT COUNT(*) AS value, ''shadow_calls_today'' AS label',
'FROM CHAT_CALLS',
'WHERE is_shadow_call = ''Y''',
'  AND TRUNC(db_created_at) = TRUNC(SYSDATE);',
''))
,p_ajax_enabled=>'Y'
,p_lazy_loading=>false
,p_query_row_template=>2538654340625403440
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
 p_id=>wwv_flow_imp.id(158154246047537602)
,p_query_column_id=>1
,p_column_alias=>'VALUE'
,p_column_display_sequence=>10
,p_column_heading=>'Value'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(158154367579537603)
,p_query_column_id=>2
,p_column_alias=>'LABEL'
,p_column_display_sequence=>20
,p_column_heading=>'Label'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158152754812485171)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158154428305537604)
,p_plug_name=>'Recent Deployment Activity'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    e.event_id,',
'    e.deployment_id,',
'    d.deployment_name,',
'    d.deployment_type,',
'    e.event_type,',
'    e.old_value,',
'    e.new_value,',
'    TO_CHAR(e.event_timestamp, ''YYYY-MM-DD HH24:MI:SS'') AS event_time,',
'    e.triggered_by_user_id,',
'    CASE ',
'        WHEN e.event_type IN (''ACTIVATED'', ''PROMOTED'', ''ROLLOUT_INCREASED'') THEN ''success''',
'        WHEN e.event_type IN (''PAUSED'', ''DEACTIVATED'', ''ROLLOUT_DECREASED'') THEN ''warning''',
'        WHEN e.event_type IN (''METRICS_THRESHOLD_BREACH'') THEN ''danger''',
'        ELSE ''info''',
'    END AS event_severity',
'FROM DEPLOYMENT_AUDIT_LOG e',
'LEFT JOIN DEPLOYMENT_VERSIONS d ',
'    ON d.deployment_id = e.deployment_id',
'WHERE e.event_timestamp >= SYSDATE - 7',
'ORDER BY e.event_timestamp DESC',
'FETCH FIRST 50 ROWS ONLY'))
,p_plug_source_type=>'NATIVE_IR'
,p_prn_content_disposition=>'ATTACHMENT'
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
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(158154527911537605)
,p_max_row_count=>'1000000'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'AI'
,p_internal_uid=>158154527911537605
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158154652824537606)
,p_db_column_name=>'EVENT_ID'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Event Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158154749421537607)
,p_db_column_name=>'DEPLOYMENT_ID'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Deployment Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158154860873537608)
,p_db_column_name=>'DEPLOYMENT_NAME'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Deployment Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158154928167537609)
,p_db_column_name=>'DEPLOYMENT_TYPE'
,p_display_order=>40
,p_column_identifier=>'D'
,p_column_label=>'Deployment Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155043208537610)
,p_db_column_name=>'EVENT_TYPE'
,p_display_order=>50
,p_column_identifier=>'E'
,p_column_label=>'Event Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155185058537611)
,p_db_column_name=>'OLD_VALUE'
,p_display_order=>60
,p_column_identifier=>'F'
,p_column_label=>'Old Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155202432537612)
,p_db_column_name=>'NEW_VALUE'
,p_display_order=>70
,p_column_identifier=>'G'
,p_column_label=>'New Value'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155304809537613)
,p_db_column_name=>'EVENT_TIME'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Event Time'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155444226537614)
,p_db_column_name=>'TRIGGERED_BY_USER_ID'
,p_display_order=>90
,p_column_identifier=>'I'
,p_column_label=>'Triggered By User Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(158155536453537615)
,p_db_column_name=>'EVENT_SEVERITY'
,p_display_order=>100
,p_column_identifier=>'J'
,p_column_label=>'Event Severity'
,p_column_html_expression=>'<span class="badge badge-#EVENT_SEVERITY#">#EVENT_TYPE#</span>'
,p_column_type=>'STRING'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(158164445675597962)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1581645'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'EVENT_ID:DEPLOYMENT_ID:DEPLOYMENT_NAME:DEPLOYMENT_TYPE:EVENT_TYPE:OLD_VALUE:NEW_VALUE:EVENT_TIME:TRIGGERED_BY_USER_ID:EVENT_SEVERITY'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(158155629251537616)
,p_plug_name=>' Quick Actions'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158155733170537617)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'Manage-Deployments'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Manage-deployments'
,p_button_redirect_url=>'f?p=&APP_ID.:703:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-cogs'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158155850369537618)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'Manage-Experiments'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Manage-experiments'
,p_button_redirect_url=>'f?p=&APP_ID.: 704:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-flask'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158155907175537619)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'Manage-Segments'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Manage-segments'
,p_button_redirect_url=>'f?p=&APP_ID.:705:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-users'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158156018732537620)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'Monitor-Shadows'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Monitor-shadows'
,p_button_redirect_url=>'f?p=&APP_ID.: 706:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>' fa-eye'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158156189832537621)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'View-Metrics'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'View-metrics'
,p_button_redirect_url=>'f?p=&APP_ID.:707:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>'fa-chart-line'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(158156224778537622)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(158155629251537616)
,p_button_name=>'Compare-Deployments'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Compare-deployments'
,p_button_redirect_url=>'f?p=&APP_ID.:708:&SESSION.::&DEBUG.:::'
,p_icon_css_classes=>' fa-balance-scale'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155691429642186650)
,p_name=>'New'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp.component_end;
end;
/
