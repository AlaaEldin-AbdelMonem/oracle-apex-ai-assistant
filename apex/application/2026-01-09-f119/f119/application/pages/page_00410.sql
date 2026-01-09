prompt --application/pages/page_00410
begin
--   Manifest
--     PAGE: 00410
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
 p_id=>410
,p_name=>'Registry Assigned Roles'
,p_alias=>'REGISTRY-ASSIGNED-ROLES'
,p_step_title=>'Registry Assigned Roles'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(140871331382818198)
,p_plug_name=>'Registry Assigned Roles'
,p_plug_display_sequence=>10
,p_plug_grid_column_span=>6
,p_plug_display_column=>3
,p_query_type=>'TABLE'
,p_query_table=>'ROLES'
,p_include_rowid_column=>false
,p_plug_source_type=>'NATIVE_IR'
,p_prn_page_header=>'Registry Assigned Roles'
);
wwv_flow_imp_page.create_worksheet(
 p_id=>wwv_flow_imp.id(140871420695818198)
,p_name=>'Registry Assigned Roles'
,p_max_row_count_message=>'The maximum row count for this report is #MAX_ROW_COUNT# rows.  Please apply a filter to reduce the number of records in your query.'
,p_no_data_found_message=>'No data found.'
,p_base_pk1=>'ROLE_ID'
,p_pagination_type=>'ROWS_X_TO_Y'
,p_pagination_display_pos=>'BOTTOM_RIGHT'
,p_report_list_mode=>'TABS'
,p_lazy_loading=>false
,p_show_detail_link=>'C'
,p_show_notify=>'Y'
,p_download_formats=>'CSV:HTML:XLSX:PDF'
,p_enable_mail_download=>'Y'
,p_detail_link=>'f?p=&APP_ID.:411:&APP_SESSION.::&DEBUG.:RP:P411_ROLE_ID:\#ROLE_ID#\'
,p_detail_link_text=>'<span role="img" aria-label="Edit" class="fa fa-edit" title="Edit"></span>'
,p_owner=>'AI'
,p_internal_uid=>140871420695818198
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(140872143374818204)
,p_db_column_name=>'ROLE_ID'
,p_display_order=>0
,p_is_primary_key=>'Y'
,p_column_identifier=>'A'
,p_column_label=>'Role ID'
,p_column_type=>'NUMBER'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(140872548257818207)
,p_db_column_name=>'ROLE_CODE'
,p_display_order=>2
,p_column_identifier=>'B'
,p_column_label=>'Role Code'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(140872962433818208)
,p_db_column_name=>'ROLE_NAME'
,p_display_order=>3
,p_column_identifier=>'C'
,p_column_label=>'Role Name'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(140873317266818209)
,p_db_column_name=>'DESCRIPTION'
,p_display_order=>4
,p_column_identifier=>'D'
,p_column_label=>'Description'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_tz_dependent=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(140873714488818210)
,p_db_column_name=>'IS_ACTIVE'
,p_display_order=>5
,p_column_identifier=>'E'
,p_column_label=>'Is Active'
,p_column_type=>'STRING'
,p_display_text_as=>'LOV_ESCAPE_SC'
,p_heading_alignment=>'LEFT'
,p_rpt_named_lov=>wwv_flow_imp.id(124111059557222693)
,p_rpt_show_filter_lov=>'1'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(140892198861819718)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1408922'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'ROLE_ID:ROLE_CODE:ROLE_NAME:DESCRIPTION:IS_ACTIVE'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(140874913493818215)
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
 p_id=>wwv_flow_imp.id(140874284019818212)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(140871331382818198)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:411:&APP_SESSION.::&DEBUG.:411::'
);
wwv_flow_imp.component_end;
end;
/
