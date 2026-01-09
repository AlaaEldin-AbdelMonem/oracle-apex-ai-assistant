prompt --application/pages/page_00440
begin
--   Manifest
--     PAGE: 00440
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
 p_id=>440
,p_name=>'Domain Retriever'
,p_alias=>'DOMAIN-RETRIEVER'
,p_step_title=>'Domain Retriever'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(155717781157975540)
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
 p_id=>wwv_flow_imp.id(155718415109975542)
,p_plug_name=>'Domain Retriever'
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_query_type=>'TABLE'
,p_query_table=>'CONTEXT_DOMAINS'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Domain Retriever'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(155718565902975542)
,p_name=>'Domain Retriever'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'N'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_owner=>'AI'
,p_internal_uid=>155718565902975542
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155719849567975597)
,p_db_column_name=>'CONTEXT_DOMAIN_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Context Domain ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155720105580975598)
,p_db_column_name=>'CONTEXT_DOMAIN_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Domain'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155720581127975599)
,p_db_column_name=>'DOMAIN_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155720984577975601)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155721390217975602)
,p_db_column_name=>'CONTEXT_DOMAIN_CATEGORY_ID'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Domain Category'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(140966433950402822)
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155721730020975603)
,p_db_column_name=>'DETECTION_METHOD_CODE'
,p_display_order=>6
,p_column_identifier=>'F'
,p_column_label=>'Detection Method '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(155718684985975589)
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155722177173975604)
,p_db_column_name=>'SCOPE_TYPE_CODE'
,p_display_order=>7
,p_column_identifier=>'G'
,p_column_label=>'Scope Type '
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(155718963601975591)
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155722577148975605)
,p_db_column_name=>'IS_DEFAULT'
,p_display_order=>8
,p_column_identifier=>'H'
,p_column_label=>'Is Default'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(124111059557222693)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155723792334975609)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>11
,p_column_identifier=>'K'
,p_column_label=>'Is Active'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(124111059557222693)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155726184808975615)
,p_db_column_name=>'DOMAIN_EMBEDDING_VECTOR'
,p_display_order=>17
,p_column_identifier=>'Q'
,p_column_label=>'Domain Embedding Vector'
,p_column_type=>'CLOB'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155726508982975617)
,p_db_column_name=>'EMBEDDING_GENERATED_DATE'
,p_display_order=>18
,p_column_identifier=>'R'
,p_column_label=>'Embedding Date'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155726932120975618)
,p_db_column_name=>'EMBEDDING_MODEL_VERSION'
,p_display_order=>19
,p_column_identifier=>'S'
,p_column_label=>'Embedding Model Version'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155727342130975619)
,p_db_column_name=>'EMBEDDING_STATUS'
,p_display_order=>20
,p_column_identifier=>'T'
,p_column_label=>'Embedding Status'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155727721433975620)
,p_db_column_name=>'EMBEDDING_ERROR_MESSAGE'
,p_display_order=>21
,p_column_identifier=>'U'
,p_column_label=>'Embedding Error Message'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155728151195975621)
,p_db_column_name=>'CONTEXT_DOMAIN_KEYWORDS'
,p_display_order=>22
,p_column_identifier=>'V'
,p_column_label=>'Context Domain Keywords'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155728547456975622)
,p_db_column_name=>'IS_CONTEXT_REQUIRED'
,p_display_order=>23
,p_column_identifier=>'W'
,p_column_label=>' Context Required'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(124111059557222693)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155724138681975610)
,p_db_column_name=>'HELP_TEXT'
,p_display_order=>33
,p_column_identifier=>'L'
,p_column_label=>'Help Text'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155723394112975608)
,p_db_column_name=>'DISPLAY_ORDER'
,p_display_order=>43
,p_column_identifier=>'J'
,p_column_label=>'Display Order'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_format_mask=>'999G999G999G999G999G999G999G999G999G990'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155722933016975606)
,p_db_column_name=>'ICON_CLASS'
,p_display_order=>53
,p_column_identifier=>'I'
,p_column_label=>'Icon Class'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155724547382975611)
,p_db_column_name=>'CREATED_BY'
,p_display_order=>63
,p_column_identifier=>'M'
,p_column_label=>'Created By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155724964199975612)
,p_db_column_name=>'CREATED_ON'
,p_display_order=>73
,p_column_identifier=>'N'
,p_column_label=>'Created On'
,p_column_type=>'DATE'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_tz_dependent=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155725377088975613)
,p_db_column_name=>'UPDATED_BY'
,p_display_order=>83
,p_column_identifier=>'O'
,p_column_label=>'Updated By'
,p_column_type=>'STRING'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(155725726755975614)
,p_db_column_name=>'UPDATED_ON'
,p_display_order=>93
,p_column_identifier=>'P'
,p_column_label=>'Updated On'
,p_column_type=>'DATE'
,p_heading_alignment=>'LEFT'
,p_format_mask=>'SINCE'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(160420675927218579)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1604207'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'DOMAIN_NAME:CONTEXT_DOMAIN_CATEGORY_ID:DETECTION_METHOD_CODE:SCOPE_TYPE_CODE:IS_DEFAULT:IS_ACTIVE:UPDATED_ON:EMBEDDING_GENERATED_DATE:EMBEDDING_MODEL_VERSION:DISPLAY_ORDER:EMBEDDING_STATUS:IS_CONTEXT_REQUIRED:'
);
wwv_flow_imp.component_end;
end;
/
