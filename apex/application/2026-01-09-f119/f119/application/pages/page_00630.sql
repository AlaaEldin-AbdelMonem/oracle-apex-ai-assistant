prompt --application/pages/page_00630
begin
--   Manifest
--     PAGE: 00630
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
 p_id=>630
,p_name=>'Document Details'
,p_alias=>'DOCUMENT-DETAILS'
,p_step_title=>'Document Details'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>' '
,p_javascript_code_onload=>' '
,p_inline_css=>' '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'18'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125605735455662109)
,p_plug_name=>'Document Information'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>3223171818405608528
,p_plug_display_sequence=>20
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125605801996662110)
,p_plug_name=>'Basic Info'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125605910514662111)
,p_plug_name=>'Chunking Configuration'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125608370085662135)
,p_plug_name=>'Current Strategy Settings'
,p_parent_plug_id=>wwv_flow_imp.id(125605910514662111)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125608997391662141)
,p_plug_name=>'Strategy Recommendation'
,p_parent_plug_id=>wwv_flow_imp.id(125605910514662111)
,p_icon_css_classes=>'fa-lightbulb-o'
,p_region_template_options=>'#DEFAULT#:t-Alert--horizontal:t-Alert--defaultIcons:t-Alert--warning'
,p_plug_template=>2040683448887306517
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125609007983662142)
,p_plug_name=>'Edit Strategy'
,p_parent_plug_id=>wwv_flow_imp.id(125605910514662111)
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125606003988662112)
,p_plug_name=>'Extracted Text'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125606157451662113)
,p_plug_name=>'Chunks & Embeddings'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>60
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125680355511257422)
,p_plug_name=>'Generate Chunks'
,p_parent_plug_id=>wwv_flow_imp.id(125606157451662113)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>30
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125680820681257427)
,p_plug_name=>'Document Chunks'
,p_region_name=>'document-chunks'
,p_parent_plug_id=>wwv_flow_imp.id(125606157451662113)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    c.DOC_CHUNK_ID,',
'    c.chunk_sequence,',
'    LENGTH(c.chunk_text) as chunk_size,',
'    CASE ',
'        WHEN LENGTH(c.chunk_text) <= 200 THEN c.chunk_text',
'        ELSE SUBSTR(c.chunk_text, 1, 197) || ''...''',
'    END as preview,',
'    c.chunk_text as full_text,  -- For modal',
'    TO_CHAR(c.created_at, ''DD-MON-YYYY HH24:MI'') as created_at,',
' ',
'    CASE ',
unistr('        WHEN c.embedding_vector IS NOT NULL THEN ''\2705 Yes'''),
unistr('        ELSE ''\274C No'''),
'    END as has_embedding',
'FROM doc_chunks c',
'WHERE c.doc_id = :P630_DOC_ID',
'ORDER BY c.chunk_sequence',
'',
'',
' '))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P630_DOC_ID'
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
 p_id=>wwv_flow_imp.id(125680937440257428)
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
,p_internal_uid=>125680937440257428
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125681025965257429)
,p_db_column_name=>'CHUNK_SEQUENCE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Chunk Sequence'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125681136428257430)
,p_db_column_name=>'CHUNK_SIZE'
,p_display_order=>30
,p_column_identifier=>'B'
,p_column_label=>'Size (chars)'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125681246207257431)
,p_db_column_name=>'PREVIEW'
,p_display_order=>40
,p_column_identifier=>'C'
,p_column_label=>'Preview'
,p_column_link=>'f?p=&APP_ID.:632:&SESSION.::&DEBUG.:632:P632_CHUNK_ID:#DOC_CHUNK_ID##CHUNK_ID#'
,p_column_linktext=>'#PREVIEW#'
,p_allow_sorting=>'N'
,p_allow_ctrl_breaks=>'N'
,p_allow_aggregations=>'N'
,p_allow_computations=>'N'
,p_allow_charting=>'N'
,p_allow_group_by=>'N'
,p_allow_pivot=>'N'
,p_column_type=>'CLOB'
,p_display_text_as=>'WITHOUT_MODIFICATION'
,p_heading_alignment=>'LEFT'
,p_rpt_show_filter_lov=>'N'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(129603574321647812)
,p_db_column_name=>'HAS_EMBEDDING'
,p_display_order=>80
,p_column_identifier=>'H'
,p_column_label=>'Has Embedding'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125681477610257433)
,p_db_column_name=>'CREATED_AT'
,p_display_order=>100
,p_column_identifier=>'E'
,p_column_label=>'Created At'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(129605498533647831)
,p_db_column_name=>'FULL_TEXT'
,p_display_order=>130
,p_column_identifier=>'M'
,p_column_label=>'Full Text'
,p_column_type=>'CLOB'
,p_display_text_as=>'HIDDEN_ESCAPE_SC'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(145721447386757242)
,p_db_column_name=>'DOC_CHUNK_ID'
,p_display_order=>140
,p_column_identifier=>'N'
,p_column_label=>'Doc Chunk Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(125702038937505007)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1257021'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'CHUNK_SEQUENCE:HAS_EMBEDDING:CHUNK_SIZE:PREVIEW:CREATED_AT:'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125606382248662115)
,p_plug_name=>'AI Summary'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125681809853257437)
,p_plug_name=>'Document Summary'
,p_parent_plug_id=>wwv_flow_imp.id(125606382248662115)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125606441541662116)
,p_plug_name=>'Related Documents'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>80
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125682358509257442)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(125606441541662116)
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2100526641005906379
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    r.relation_type,',
'    CASE ',
'        WHEN r.parent_doc_id = TO_NUMBER(:P630_DOC_ID) THEN ''Child: '' || d_child.doc_title',
'        ELSE ''Parent: '' || d_parent.doc_title',
'    END as related_document,',
'    CASE ',
'        WHEN r.parent_doc_id = TO_NUMBER(:P630_DOC_ID) THEN r.child_doc_id',
'        ELSE r.parent_doc_id',
'    END as doc_id',
'FROM doc_relations r',
'LEFT JOIN docs d_child ON r.child_doc_id = d_child.doc_id',
'LEFT JOIN docs d_parent ON r.parent_doc_id = d_parent.doc_id',
'WHERE r.parent_doc_id = TO_NUMBER(:P630_DOC_ID) ',
'   OR r.child_doc_id = TO_NUMBER(:P630_DOC_ID)'))
,p_plug_source_type=>'NATIVE_IR'
,p_ajax_items_to_submit=>'P630_DOC_ID'
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
 p_id=>wwv_flow_imp.id(125682429498257443)
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
,p_internal_uid=>125682429498257443
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125682577267257444)
,p_db_column_name=>'RELATION_TYPE'
,p_display_order=>10
,p_column_identifier=>'A'
,p_column_label=>'Relation Type'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125682608404257445)
,p_db_column_name=>'RELATED_DOCUMENT'
,p_display_order=>20
,p_column_identifier=>'B'
,p_column_label=>'Related Document'
,p_column_link=>'f?p=&APP_ID.:630:&SESSION.::&DEBUG.:630:P630_DOC_ID:#DOC_ID#'
,p_column_linktext=>'#RELATED_DOCUMENT#'
,p_column_type=>'STRING'
,p_heading_alignment=>'LEFT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_column(
 p_id=>wwv_flow_imp.id(125682769251257446)
,p_db_column_name=>'DOC_ID'
,p_display_order=>30
,p_column_identifier=>'C'
,p_column_label=>'Doc Id'
,p_column_type=>'NUMBER'
,p_heading_alignment=>'RIGHT'
,p_column_alignment=>'RIGHT'
,p_use_as_row_header=>'N'
);
wwv_flow_imp_page.create_worksheet_rpt(
 p_id=>wwv_flow_imp.id(125702588482505031)
,p_application_user=>'APXWS_DEFAULT'
,p_report_seq=>10
,p_report_alias=>'1257026'
,p_status=>'PUBLIC'
,p_is_default=>'Y'
,p_report_columns=>'RELATION_TYPE:RELATED_DOCUMENT:DOC_ID'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(125609700271662149)
,p_name=>'Strategy Information'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_template=>4072358936313175081
,p_display_sequence=>40
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    strategy_name,',
'    strategy_description,',
unistr('    ''\26A1 '' || relative_speed || ''x'' as speed,'),
unistr('    ''\D83D\DCBE '' || storage_overhead || ''x'' as storage,'),
unistr('    ''\2B50 '' || semantic_preservation as quality,'),
'    best_for',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = NVL(:P630_CHUNKING_STRATEGY, ',
'                          (SELECT chunking_strategy FROM docs WHERE doc_id = :P630_DOC_ID))'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P630_DOC_ID'
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
 p_id=>wwv_flow_imp.id(125609891332662150)
,p_query_column_id=>1
,p_column_alias=>'STRATEGY_NAME'
,p_column_display_sequence=>10
,p_column_heading=>'Strategy Name'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125678293264257401)
,p_query_column_id=>2
,p_column_alias=>'STRATEGY_DESCRIPTION'
,p_column_display_sequence=>20
,p_column_heading=>'Strategy Description'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125678372435257402)
,p_query_column_id=>3
,p_column_alias=>'SPEED'
,p_column_display_sequence=>30
,p_column_heading=>'Speed'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125678456935257403)
,p_query_column_id=>4
,p_column_alias=>'STORAGE'
,p_column_display_sequence=>40
,p_column_heading=>'Storage'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125678587968257404)
,p_query_column_id=>5
,p_column_alias=>'QUALITY'
,p_column_display_sequence=>50
,p_column_heading=>'Quality'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(125678687788257405)
,p_query_column_id=>6
,p_column_alias=>'BEST_FOR'
,p_column_display_sequence=>60
,p_column_heading=>'Best For'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125678768747257406)
,p_plug_name=>'Pros & Cons'
,p_parent_plug_id=>wwv_flow_imp.id(125605735455662109)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>50
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(125610784710811288)
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
 p_id=>wwv_flow_imp.id(125682032467257439)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(125681809853257437)
,p_button_name=>'GENERATE_SUMMARY'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Generate Summary'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-magic'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(129603655838647813)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(125681809853257437)
,p_button_name=>'View_Summary'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'View Summary'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125609595332662147)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(125609007983662142)
,p_button_name=>'SAVE_STRATEGY_CONFIG'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save Configuration'
,p_icon_css_classes=>'a-save'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125680246323257421)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(125680355511257422)
,p_button_name=>'GENERATE_CHUNKS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\D83E\DDE0 Generate Chunks (Auto Strategy)')
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-magic'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125680595723257424)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(125680355511257422)
,p_button_name=>'REGENERATE_CHUNKS'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>unistr('\D83D\DD04 Re-generate Chunks')
,p_button_position=>'NEXT'
,p_icon_css_classes=>'fa-refresh'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125709933737557126)
,p_button_sequence=>70
,p_button_plug_id=>wwv_flow_imp.id(125605910514662111)
,p_button_name=>'TEST_STRATEGY'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Test Strategy Configuration'
,p_button_position=>'NEXT'
,p_button_redirect_url=>'f?p=&APP_ID.:635:&SESSION.::&DEBUG.:635:P635_DOC_ID:&P630_DOC_ID.'
,p_icon_css_classes=>'fa-flask'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125608022267662132)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(125606003988662112)
,p_button_name=>'DOWNLOAD_TEXT'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Download as Text File'
,p_button_position=>'ORDER_BY_ITEM'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-download'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(128258704371285021)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(125606003988662112)
,p_button_name=>'ViewFullText'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\D83D\DCC4 View Full Text')
,p_button_position=>'ORDER_BY_ITEM'
,p_button_redirect_url=>'f?p=&APP_ID.:631:&SESSION.::&DEBUG.:631:P631_CURRENT_PAGE,P631_DOC_ID:1,&P630_DOC_ID.'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(132481599033108006)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(125606003988662112)
,p_button_name=>'Extract_Text'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Extract Text'
,p_button_position=>'ORDER_BY_ITEM'
,p_warn_on_unsaved_changes=>null
,p_button_condition=>'P630_DOC_ID'
,p_button_condition_type=>'ITEM_IS_NOT_NULL'
,p_icon_css_classes=>'fa-database-application'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(125682800255257447)
,p_button_sequence=>20
,p_button_name=>'CLOSE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Close'
,p_button_position=>'REGION_POSITION_01'
,p_button_redirect_url=>'f?p=&APP_ID.:610:&SESSION.::&DEBUG.:::'
);
wwv_flow_imp_page.create_page_branch(
 p_id=>wwv_flow_imp.id(125643936639811425)
,p_branch_action=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::&success_msg=#SUCCESS_MSG#'
,p_branch_point=>'AFTER_PROCESSING'
,p_branch_type=>'REDIRECT_URL'
,p_branch_sequence=>1
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125606549392662117)
,p_name=>'P630_DOC_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125606600638662118)
,p_name=>'P630_DOC_TITLE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Document Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125606736832662119)
,p_name=>'P630_LANGUAGE_CODE'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Language '
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125606898502662120)
,p_name=>'P630_DOC_CATEGORY'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Category'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125606977691662121)
,p_name=>'P630_FILE_SIZE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'File Size (KB)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607059986662122)
,p_name=>'P630_DOC_STATUS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607152582662123)
,p_name=>'P630_FILE_NAME'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'File Name'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607273540662124)
,p_name=>'P630_RAG_READY_FLAG'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Rag Ready '
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607315952662125)
,p_name=>'P630_LAST_CHUNKED_AT'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Last Chunked'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607476445662126)
,p_name=>'P630_CREATED_BY'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Created By'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607549054662127)
,p_name=>'P630_TEXT_EXTRACTED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125606003988662112)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Text Extracted'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>20
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607696672662128)
,p_name=>'P630_EMBEDDING_COUNT'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Total Chunks'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607776562662129)
,p_name=>'P630_CREATED_AT'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(125605801996662110)
,p_prompt=>'Created At'
,p_format_mask=>'DD-MON-YYYY HH24:MI'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607840720662130)
,p_name=>'P630_CURRENT_STRATEGY'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125608370085662135)
,p_prompt=>'Current Strategy'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125607964156662131)
,p_name=>'P630_LAST_STRATEGY_USED'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125608370085662135)
,p_prompt=>'Last Strategy Used'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125608432924662136)
,p_name=>'P630_RECOMMENDED_STRATEGY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125608997391662141)
,p_use_cache_before_default=>'NO'
,p_prompt=>'System Recommends'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_strategy VARCHAR2(100);',
'BEGIN',
'     SELECT s.strategy_code ',
'     INTO v_strategy',
'     FROM docs d ,lkp_chunking_strategy s  ',
'        WHERE s.strategy_code = d.recommended_strategy',
'        AND  d.doc_id = :P630_DOC_ID;',
'    RETURN v_strategy;',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        RETURN NULL;',
'END;'))
,p_source_type=>'FUNCTION_BODY'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125608527184662137)
,p_name=>'P630_RECOMMENDATION_REASON'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125608997391662141)
,p_prompt=>' Reason'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT recommendation_reason',
'FROM docs',
'WHERE doc_id = :P630_DOC_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125608638325662138)
,p_name=>'P630_CHUNKING_STRATEGY_CODE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125608370085662135)
,p_prompt=>'Chunking Strategy Code'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125609117629662143)
,p_name=>'P630_CHUNKING_STRATEGY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125609007983662142)
,p_use_cache_before_default=>'NO'
,p_prompt=>'Chunking Strategy'
,p_source=>'SELECT chunking_strategy FROM docs WHERE doc_id = :P630_DOC_ID'
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'  strategy_name || ',
unistr('  CASE WHEN is_default = ''Y'' THEN '' \2B50 (Default)'' ELSE '''' END ||'),
'  '' ('' || semantic_preservation || '' quality)'' as d,',
'  strategy_code as r',
'FROM lkp_chunking_strategy',
'WHERE is_active = ''Y''',
'ORDER BY ',
'  CASE WHEN is_default = ''Y'' THEN 0 ELSE 1 END,',
'  display_order'))
,p_lov_display_null=>'YES'
,p_lov_null_text=>'- Auto-Detect -'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125609291764662144)
,p_name=>'P630_CHUNK_SIZE_OVERRIDE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125609007983662142)
,p_prompt=>'Chunk Size Override'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '8000',
  'min_value', '50',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125609385761662145)
,p_name=>'P630_OVERLAP_PCT_OVERRIDE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125609007983662142)
,p_prompt=>'Overlap % Override'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '50',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125609498465662146)
,p_name=>'P630_CHUNKING_NOTES'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(125609007983662142)
,p_prompt=>'Configuration Notes'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>1000
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125679465871257413)
,p_name=>'P630_STRATEGY_PROS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125678768747257406)
,p_prompt=>unistr('\2705 Advantages')
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125679517746257414)
,p_name=>'P630_STRATEGY_CONS'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125678768747257406)
,p_prompt=>unistr('\26A0\FE0F Limitations')
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125679607323257415)
,p_name=>'P630_STRATEGY_USE_CASES'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125678768747257406)
,p_use_cache_before_default=>'NO'
,p_prompt=>unistr('\D83D\DCA1 Best Use Cases`')
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT use_cases',
'FROM lkp_chunking_strategy',
'WHERE strategy_code = NVL(:P630_CHUNKING_STRATEGY,',
'                        (SELECT chunking_strategy FROM docs WHERE doc_id = :P630_DOC_ID))'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125681552104257434)
,p_name=>'P630_TOTAL_CHUNKS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125680820681257427)
,p_prompt=>'Total Chunks'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125681620295257435)
,p_name=>'P630_AVG_CHUNK_SIZE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125680820681257427)
,p_prompt=>'Average Chunk Size'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125681723049257436)
,p_name=>'P630_CHUNK_SIZE_RANGE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(125680820681257427)
,p_prompt=>'Size Range'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(125681923396257438)
,p_name=>'P630_TEXT_SUMMARY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(125681809853257437)
,p_prompt=>'AI-Generated Summary'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>10
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129604072314647817)
,p_name=>'P630_RECOMMENDATION_CONFIDENCE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(125608997391662141)
,p_prompt=>'Recommendation Confidence'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT recommendation_confidence || ''%''',
'FROM docs',
'WHERE doc_id = :P630_DOC_ID'))
,p_source_type=>'QUERY'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(125608124229662133)
,p_name=>'downlaod'
,p_event_sequence=>10
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(125608022267662132)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125608215031662134)
,p_event_id=>wwv_flow_imp.id(125608124229662133)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'document_#P630_DOC_ID#.txt'
,p_action=>'NATIVE_DOWNLOAD'
,p_attribute_01=>'N'
,p_attribute_03=>'ATTACHMENT'
,p_attribute_05=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  TEXT_EXTRACTED  ',
'    , FILE_NAME --''document_#P630_DOC_ID#.txt''',
'     ,FILE_MIME_TYPE',
'FROM DOCS',
' where DOC_ID = :P630_DOC_ID',
' '))
,p_attribute_06=>'P630_DOC_ID'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(125679779457257416)
,p_name=>'Refresh'
,p_event_sequence=>20
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P630_CHUNKING_STRATEGY'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125679810632257417)
,p_event_id=>wwv_flow_imp.id(125679779457257416)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125678768747257406)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125679951842257418)
,p_event_id=>wwv_flow_imp.id(125679779457257416)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125608997391662141)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125680018920257419)
,p_event_id=>wwv_flow_imp.id(125679779457257416)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125608370085662135)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125680102517257420)
,p_event_id=>wwv_flow_imp.id(125679779457257416)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(125609700271662149)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(125682117935257440)
,p_name=>'New'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(125682032467257439)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(125682296698257441)
,p_event_id=>wwv_flow_imp.id(125682117935257440)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CONFIRM'
,p_attribute_01=>'Note: Can be implemented later with LLM integration'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(129603847806647815)
,p_name=>'New_1'
,p_event_sequence=>40
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(129603655838647813)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(129603984403647816)
,p_event_id=>wwv_flow_imp.id(129603847806647815)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// JavaScript Expression for Dynamic Action',
'apex.item("P630_TEXT_SUMMARY").setValue(',
'    apex.server.process("LOAD_TEXT_SUMMARY", {',
'        x01: apex.item("P630_DOC_ID").getValue()',
'    }).done(function(data) {',
'        apex.message.showPageSuccess("Summary loaded");',
'    })',
');'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(132481641641108007)
,p_name=>'Extract Text from blob'
,p_event_sequence=>50
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(132481599033108006)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132481716650108008)
,p_event_id=>wwv_flow_imp.id(132481641641108007)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'IF :P630_DOC_ID is not null then',
'',
'RAG_PROCESSING_PKG.Generate_DOC_TEXT(   p_doc_id=> :P630_DOC_ID, p_commit_flag =>''Y'' ) ;',
'',
'end if;'))
,p_attribute_02=>'P630_DOC_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(132481959642108010)
,p_event_id=>wwv_flow_imp.id(132481641641108007)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P630_TEXT_EXTRACTED'
,p_attribute_01=>'SQL_STATEMENT'
,p_attribute_03=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select  text_Extracted from DOCS where doc_id =:P630_DOC_ID',
'      '))
,p_attribute_07=>'P630_DOC_ID'
,p_attribute_08=>'Y'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125609658204662148)
,p_process_sequence=>10
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Save Chunking Configuration'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE docs',
'SET chunking_strategy = :P630_CHUNKING_STRATEGY,',
'chunk_size_override = :P630_CHUNK_SIZE_OVERRIDE,',
'overlap_pct_override = :P630_OVERLAP_PCT_OVERRIDE,',
'chunking_notes = :P630_CHUNKING_NOTES,',
'updated_by = :APP_USER,',
'updated_at = SYSTIMESTAMP',
'WHERE doc_id = :P630_DOC_ID;',
'',
'apex_application.g_print_success_message := ''Chunking configuration saved successfully!'';'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(125609595332662147)
,p_internal_uid=>125609658204662148
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125680684535257425)
,p_process_sequence=>20
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Generate Intelligent Chunks'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'v_chunk_count NUMBER;',
'v_strategy VARCHAR2(100);',
'BEGIN',
'-- Generate chunks based on the doc characteristics ',
'  CHUNK_PROXY_UTIL.run_chunk(p_doc_id => :P630_DOC_ID,',
'                                p_recommend_strategy   => ''Y'',',
'                                p_force_rechunk     =>TRUE,',
'                                p_commit_after      =>TRUE',
');',
'',
'v_chunk_count:=CHUNK_PROXY_UTIL.chunks_count(p_doc_id => :P630_DOC_ID);',
'',
'-- Update statistics for a specific document (use in APEX after chunking)',
'DECLARE',
'    v_stats_json VARCHAR2(1000);',
'BEGIN',
'    SELECT JSON_OBJECT(',
'        ''avg_size'' VALUE ROUND(AVG(LENGTH(chunk_text)), 0),',
'        ''min_size'' VALUE MIN(LENGTH(chunk_text)),',
'        ''max_size'' VALUE MAX(LENGTH(chunk_text)),',
'        ''count'' VALUE COUNT(*)',
'    )',
'    INTO v_stats_json',
'    FROM doc_chunks',
'    WHERE doc_id = :P630_DOC_ID',
'    HAVING COUNT(*) > 0;  -- Only if chunks exist',
'    ',
'    UPDATE docs',
'    SET chunk_stats_json = v_stats_json,',
'        chunk_stats_updated_at = SYSTIMESTAMP',
'    WHERE doc_id = :P630_DOC_ID;',
'    ',
'    COMMIT;',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        -- No chunks found, set stats to NULL',
'        UPDATE docs',
'        SET chunk_stats_json = NULL,',
'            chunk_stats_updated_at = SYSTIMESTAMP',
'        WHERE doc_id = :P630_DOC_ID;',
'        COMMIT;',
'END;',
'',
'',
'-- Get strategy that was used',
'SELECT last_chunking_strategy INTO v_strategy',
'FROM docs',
'WHERE doc_id = :P630_DOC_ID;',
'',
'',
'',
'',
'apex_application.g_print_success_message := ',
'   ''Successfully created '' || v_chunk_count || '' chunks using '' || v_strategy || '' strategy!'';',
'',
'EXCEPTION',
' WHEN OTHERS THEN',
' apex_error.add_error(p_message => ''Error generating chunks: '' || SQLERRM,',
'                      p_display_location => apex_error.c_inline_in_notification',
'                     );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(125680246323257421)
,p_internal_uid=>125680684535257425
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125680744927257426)
,p_process_sequence=>30
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Generate Intelligent Chunks_1'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'v_chunk_count NUMBER;',
'v_strategy VARCHAR2(100);',
'BEGIN',
'-- Generate chunks based on the doc characteristics ',
'   CHUNK_PROXY_UTIL.run_chunk(p_doc_id => :P630_DOC_ID,',
'                                p_recommend_strategy   => ''Y'',',
'                                p_force_rechunk     =>TRUE,',
'                                p_commit_after      =>TRUE',
');',
'',
'v_chunk_count:=CHUNK_PROXY_UTIL.chunks_count(p_doc_id => :P630_DOC_ID);',
'',
'-- Update statistics for a specific document (use in APEX after chunking)',
'DECLARE',
'    v_stats_json VARCHAR2(1000);',
'BEGIN',
'    SELECT JSON_OBJECT(',
'        ''avg_size'' VALUE ROUND(AVG(LENGTH(chunk_text)), 0),',
'        ''min_size'' VALUE MIN(LENGTH(chunk_text)),',
'        ''max_size'' VALUE MAX(LENGTH(chunk_text)),',
'        ''count'' VALUE COUNT(*)',
'    )',
'    INTO v_stats_json',
'    FROM doc_chunks',
'    WHERE doc_id = :P630_DOC_ID',
'    HAVING COUNT(*) > 0;  -- Only if chunks exist',
'    ',
'    UPDATE docs',
'    SET chunk_stats_json = v_stats_json,',
'        chunk_stats_updated_at = SYSTIMESTAMP',
'    WHERE doc_id = :P630_DOC_ID;',
'    ',
'    COMMIT;',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        -- No chunks found, set stats to NULL',
'        UPDATE docs',
'        SET chunk_stats_json = NULL,',
'            chunk_stats_updated_at = SYSTIMESTAMP',
'        WHERE doc_id = :P630_DOC_ID;',
'        COMMIT;',
'END;',
'',
'',
'-- Get strategy that was used',
'SELECT last_chunking_strategy INTO v_strategy',
'FROM docs',
'WHERE doc_id = :P630_DOC_ID;',
'',
'',
'',
'',
'apex_application.g_print_success_message := ',
'   ''Successfully created '' || v_chunk_count || '' chunks using '' || v_strategy || '' strategy!'';',
'',
'EXCEPTION',
' WHEN OTHERS THEN',
' apex_error.add_error(p_message => ''Error generating chunks: '' || SQLERRM,',
'                      p_display_location => apex_error.c_inline_in_notification',
'                     );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(125680595723257424)
,p_internal_uid=>125680744927257426
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(129603730222647814)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_TEXT_SUMMARY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_summary CLOB;',
'BEGIN',
'    SELECT text_summary',
'    INTO v_summary',
'    FROM docs',
'    WHERE doc_id = apex_application.g_x01;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''summary'', v_summary);',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(129603655838647813)
,p_internal_uid=>129603730222647814
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(125683025680257449)
,p_process_sequence=>10
,p_process_point=>'BEFORE_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Load Document Data'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_doc_id NUMBER := :P630_DOC_ID;',
'BEGIN',
'    -- ========================================',
'    -- SECTION 1: EXISTING PAGE ITEMS',
'    -- ========================================',
'    SELECT ',
'        d.doc_title,',
'        d.doc_category,',
'        d.doc_status,',
'        d.language_code,',
'        d.file_name,',
'        d.file_size,',
'        d.chunking_strategy,',
'        d.chunk_size_override,',
'        d.overlap_pct_override,',
'        d.chunking_notes,',
'        d.last_chunked_at,',
'        d.embedding_count,',
'        d.rag_ready_flag,',
'        d.created_by,',
'        d.created_at,',
'        -- d.text_extracted,--loaded directly at the item bz of size',
'        -- d.text_summary,--loaded directly at the item bz of size',
'        d.last_chunking_strategy,',
'        -- Lookup display names for existing items',
'       -- cat.category_name,',
'        NVL(chunk.strategy_name, ''Not Set'') AS chunking_strategy_name,',
'         JSON_VALUE(chunk_stats_json, ''$.avg_size'') AVG_CHUNK_SIZE,',
'         JSON_VALUE(chunk_stats_json, ''$.min_size'') || '' - '' || ',
'         JSON_VALUE(chunk_stats_json, ''$.max_size'') || '' chars''  CHUNK_SIZE_RANGE',
'        -- ========================================',
'        -- SECTION 2: FUTURE PAGE ITEMS (COMMENTED)',
'        -- Uncomment when page items are created',
'        -- ========================================',
'        /*',
'        ,d.doc_description',
'        ,d.doc_topic',
'        ,d.doc_tags',
'        ,d.file_mime_type',
'        ,d.source_system',
'        ,d.related_project',
'        ,d.file_version_no',
'        ,d.file_version_label',
'        ,d.approval_user',
'        ,d.approval_date',
'        ,d.embedding_model',
'        ,d.summary_model',
'        ,d.vector_indexed_flag',
'        ,d.retention_period_days',
'        ,d.is_active',
'        ,d.classification_level',
'        ,d.sensitivity_label',
'        ,d.updated_by',
'        ,d.updated_at',
'        -- Future lookup display names',
'        ,NVL(stat.status_name, ''Unknown'') AS status_name',
'        ,NVL(cls.classification_name, ''Unclassified'') AS classification_name',
'        ,NVL(sens.label_name, ''None'') AS sensitivity_name',
'        ,NVL(lang.language_name, ''Not Specified'') AS language_name',
'        ,NVL(last_chunk.strategy_name, ''Never Chunked'') AS last_chunking_strategy_name',
'        */',
'        ',
'    INTO ',
'        -- ========================================',
'        -- SECTION 1: EXISTING PAGE ITEMS',
'        -- ========================================',
'        :P630_DOC_TITLE,',
'        :P630_DOC_CATEGORY,',
'        :P630_DOC_STATUS,',
'        :P630_LANGUAGE_CODE,',
'        :P630_FILE_NAME,',
'        :P630_FILE_SIZE,',
'        :P630_CHUNKING_STRATEGY,',
'        :P630_CHUNK_SIZE_OVERRIDE,',
'        :P630_OVERLAP_PCT_OVERRIDE,',
'        :P630_CHUNKING_NOTES,',
'        :P630_LAST_CHUNKED_AT,',
'        :P630_EMBEDDING_COUNT,',
'        :P630_RAG_READY_FLAG,',
'        :P630_CREATED_BY,',
'        :P630_CREATED_AT,',
'        -- :P630_TEXT_EXTRACTED,',
'        -- :P630_TEXT_SUMMARY,',
'        :P630_LAST_STRATEGY_USED,  -- Uses last_chunking_strategy',
'       -- :P630_DOC_CATEGORY_DISPLAY,  -- New display item for category name',
'        :P630_CURRENT_STRATEGY,        -- New display item for current strategy name',
'        :P630_AVG_CHUNK_SIZE,',
'        :P630_CHUNK_SIZE_RANGE',
'        -- ========================================',
'        -- SECTION 2: FUTURE PAGE ITEMS (COMMENTED)',
'        -- Uncomment when corresponding page items are created',
'        -- ========================================',
'        /*',
'        ,:P630_DOC_DESCRIPTION',
'        ,:P630_DOC_TOPIC',
'        ,:P630_DOC_TAGS',
'        ,:P630_FILE_MIME_TYPE',
'        ,:P630_SOURCE_SYSTEM',
'        ,:P630_RELATED_PROJECT',
'        ,:P630_FILE_VERSION_NO',
'        ,:P630_FILE_VERSION_LABEL',
'        ,:P630_APPROVAL_USER',
'        ,:P630_APPROVAL_DATE',
'        ,:P630_EMBEDDING_MODEL',
'        ,:P630_SUMMARY_MODEL',
'        ,:P630_VECTOR_INDEXED_FLAG',
'        ,:P630_RETENTION_PERIOD_DAYS',
'        ,:P630_IS_ACTIVE',
'        ,:P630_CLASSIFICATION_LEVEL',
'        ,:P630_SENSITIVITY_LABEL',
'        ,:P630_UPDATED_BY',
'        ,:P630_UPDATED_AT',
'        -- Future display items for lookup names',
'        ,:P630_DOC_STATUS_DISPLAY',
'        ,:P630_CLASSIFICATION_DISPLAY',
'        ,:P630_SENSITIVITY_DISPLAY',
'        ,:P630_LANGUAGE_DISPLAY',
'        ,:P630_LAST_CHUNKING_DISPLAY',
'        */',
'        ',
'    FROM docs d,',
'         lkp_doc_category cat,',
'         lkp_chunking_strategy chunk',
'         -- ========================================',
'         -- FUTURE LOOKUP TABLES (COMMENTED)',
'         -- Uncomment when future page items are added',
'         -- ========================================',
'         /*',
'         ,lkp_doc_status stat',
'         ,lkp_classification_level cls',
'         ,lkp_sensitivity_label sens',
'         ,lkp_language_code lang',
'         ,lkp_chunking_strategy last_chunk',
'         */',
'    WHERE d.doc_id = v_doc_id',
'      AND cat.category_code(+) = d.doc_category',
unistr('      AND chunk.strategy_code(+) = d.chunking_strategy;  -- \2705 FIXED: Was truncated as ''strategy_cod'''),
'      ',
'    -- ========================================',
'    -- SECTION 3: LOAD LARGE TEXT FIELDS SEPARATELY',
'    -- (Loaded directly at item level due to size)',
'    -- ========================================',
'    -- Text fields are loaded via separate item source queries',
'    -- to avoid performance issues with main SELECT',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        -- Document not found - provide helpful error message',
'        apex_error.add_error(',
'            p_message => ''Document ID '' || v_doc_id || '' not found. It may have been deleted.'',',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        ',
'    WHEN TOO_MANY_ROWS THEN',
'        -- Should never happen with PK, but handle gracefully',
'        apex_error.add_error(',
'            p_message => ''Data integrity error: Multiple documents found with ID '' || v_doc_id,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        ',
'    WHEN OTHERS THEN',
'        -- Log unexpected errors with full context',
'        apex_error.add_error(',
'            p_message => ''Error loading document: '' || SQLERRM,',
'            p_additional_info => ''DOC_ID='' || v_doc_id || '', USER='' || :APP_USER,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        RAISE;',
'END;',
'',
'',
' ',
'',
'',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>125683025680257449
);
wwv_flow_imp.component_end;
end;
/
