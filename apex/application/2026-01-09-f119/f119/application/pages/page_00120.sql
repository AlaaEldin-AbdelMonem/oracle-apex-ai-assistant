prompt --application/pages/page_00120
begin
--   Manifest
--     PAGE: 00120
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
 p_id=>120
,p_name=>'User Issues'
,p_alias=>'USER-ISSUES1'
,p_step_title=>'User Issues'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
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
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(311721062493815126)
,p_plug_name=>'Reported Issues'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>20
,p_query_type=>'TABLE'
,p_query_table=>'CHAT_ISSUES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'My Reported Issues'
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(311721185129815126)
,p_name=>'My Reported Issues'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:121:&SESSION.::&DEBUG.:CR,121:P121_CHAT_ISSUE_ID:#CHAT_ISSUE_ID#'
,p_detail_link_text=>'<span role="img" aria-label="Edit" class="fa fa-edit" title="Edit"></span>'
,p_owner=>'AI'
,p_internal_uid=>311721185129815126
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311721859853815132)
,p_db_column_name=>'CHAT_ISSUE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Chat Issue ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322563264263682821)
,p_db_column_name=>'CHAT_ISSUE_LEVEL_CODE'
,p_display_order=>10
,p_column_identifier=>'AC'
,p_column_label=>'Issue Level '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(160973937783725467)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322563411116682822)
,p_db_column_name=>'CHAT_ISSUE_TYPE_CODE'
,p_display_order=>20
,p_column_identifier=>'AD'
,p_column_label=>'Issue Type '
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322563530739682823)
,p_db_column_name=>'CHAT_ISSUE_PRIORITY_CODE'
,p_display_order=>30
,p_column_identifier=>'AE'
,p_column_label=>'Issue Priority  '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(160973660116719895)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311722304719815133)
,p_db_column_name=>'ISSUE_UUID'
,p_display_order=>40
,p_column_identifier=>'B'
,p_column_label=>'Issue Uuid'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311724265148815139)
,p_db_column_name=>'ISSUE_TITLE'
,p_display_order=>50
,p_column_identifier=>'G'
,p_column_label=>'Issue Title'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311724724510815140)
,p_db_column_name=>'ISSUE_DESCRIPTION'
,p_display_order=>60
,p_column_identifier=>'H'
,p_column_label=>'Issue Description'
,p_column_type=>'CLOB'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311726282979815144)
,p_db_column_name=>'ATTACHMENT_COUNT'
,p_display_order=>70
,p_column_identifier=>'L'
,p_column_label=>'Attachment Count'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311726713990815146)
,p_db_column_name=>'HAS_SCREENSHOT'
,p_display_order=>90
,p_column_identifier=>'M'
,p_column_label=>'Has Screenshot'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(124111059557222693)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311730334868815156)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>100
,p_column_identifier=>'V'
,p_column_label=>'Created At'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311730733411815157)
,p_db_column_name=>'UPDATED_AT'
,p_display_order=>110
,p_column_identifier=>'W'
,p_column_label=>'Updated At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(317349287197377107)
,p_db_column_name=>'CHAT_CALL_ID'
,p_display_order=>120
,p_column_identifier=>'X'
,p_column_label=>'Chat Call Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(317349372325377108)
,p_db_column_name=>'CHAT_SESSION_ID'
,p_display_order=>130
,p_column_identifier=>'Y'
,p_column_label=>'Chat Session'
,p_column_type=>'NUMBER'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_rpt_named_lov=>wwv_flow_imp.id(160925527503637571)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311725865652815143)
,p_db_column_name=>'REPORTED_AT'
,p_display_order=>140
,p_column_identifier=>'K'
,p_column_label=>'Reported At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311727882778815149)
,p_db_column_name=>'RESOLVED_BY_USER_ID'
,p_display_order=>150
,p_column_identifier=>'P'
,p_column_label=>'Resolved By User ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311728296960815150)
,p_db_column_name=>'RESOLVED_AT'
,p_display_order=>160
,p_column_identifier=>'Q'
,p_column_label=>'Resolved At'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311728730480815151)
,p_db_column_name=>'RESOLUTION_NOTES'
,p_display_order=>170
,p_column_identifier=>'R'
,p_column_label=>'Resolution Notes'
,p_column_type=>'CLOB'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311729128151815152)
,p_db_column_name=>'BROWSER_INFO'
,p_display_order=>180
,p_column_identifier=>'S'
,p_column_label=>'Browser Info'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311729542315815153)
,p_db_column_name=>'USER_AGENT'
,p_display_order=>190
,p_column_identifier=>'T'
,p_column_label=>'User Agent'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(311729876916815154)
,p_db_column_name=>'PAGE_URL'
,p_display_order=>200
,p_column_identifier=>'U'
,p_column_label=>'Page URL'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322562423271682812)
,p_db_column_name=>'USER_ID'
,p_display_order=>210
,p_column_identifier=>'Z'
,p_column_label=>'User Id'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322562542416682813)
,p_db_column_name=>'USERNAME'
,p_display_order=>230
,p_column_identifier=>'AA'
,p_column_label=>'Username'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(322563639372682824)
,p_db_column_name=>'CHAT_ISSUE_STATUS_CODE'
,p_display_order=>240
,p_column_identifier=>'AF'
,p_column_label=>' Issue Status '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(160955045819327024)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(317373936825083408)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1557116'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ISSUE_TITLE:CHAT_ISSUE_TYPE_CODE:ATTACHMENT_COUNT:HAS_SCREENSHOT:CHAT_SESSION_ID:CHAT_ISSUE_LEVEL_CODE:CHAT_ISSUE_PRIORITY_CODE:CHAT_ISSUE_STATUS_CODE:UPDATED_AT:REPORTED_AT:RESOLVED_AT:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(466816784474912824)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(161671619721190540)
,p_name=>'Edit Report - Dialog Closed'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(311721062493815126)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterclosedialog'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(161672128301190541)
,p_event_id=>wwv_flow_imp.id(161671619721190540)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(311721062493815126)
);
wwv_flow_imp.component_end;
end;
/
