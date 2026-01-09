prompt --application/pages/page_00650
begin
--   Manifest
--     PAGE: 00650
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
 p_id=>650
,p_name=>'Smart Document Search'
,p_alias=>'SMART-DOCUMENT-SEARCH'
,p_step_title=>'Smart Document Search'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/**',
' * Highlight search terms in card content',
' * @param {string} selector - CSS selector for cards',
' * @param {string} searchTerms - Comma or space separated search terms',
' */',
'function highlightSearchTerms(selector, searchTerms) {',
'    if (!searchTerms || searchTerms.trim() === '''') {',
'        return;',
'    }',
'    ',
'    // Parse search terms',
'    const terms = searchTerms',
'        .split(/[,\s]+/)',
'        .map(term => term.trim())',
'        .filter(term => term.length > 0);',
'    ',
'    if (terms.length === 0) {',
'        return;',
'    }',
'    ',
'    // Get all card elements',
'    const cards = document.querySelectorAll(selector);',
'    ',
'    cards.forEach(card => {',
'        // Get text nodes in the card',
'        highlightInElement(card, terms);',
'    });',
'}',
'',
'/**',
' * Recursively highlight terms in element',
' */',
'function highlightInElement(element, terms) {',
'    // Skip if already highlighted or script/style tag',
'    if (element.nodeType === Node.TEXT_NODE) {',
'        highlightTextNode(element, terms);',
'    } else if (element.nodeType === Node.ELEMENT_NODE && ',
'               element.tagName !== ''SCRIPT'' && ',
'               element.tagName !== ''STYLE'') {',
'        ',
'        // Skip already highlighted spans',
'        if (element.classList && element.classList.contains(''highlight-term'')) {',
'            return;',
'        }',
'        ',
'        // Process child nodes',
'        Array.from(element.childNodes).forEach(child => {',
'            highlightInElement(child, terms);',
'        });',
'    }',
'}',
'',
'/**',
' * Highlight terms in a text node',
' */',
'function highlightTextNode(textNode, terms) {',
'    const text = textNode.textContent;',
'    let highlightedText = text;',
'    ',
'    // Create regex pattern for all terms (case-insensitive)',
'    terms.forEach(term => {',
'        // Escape special regex characters',
'        const escapedTerm = term.replace(/[.*+?^${}()|[\]\\]/g, ''\\$&'');',
'        ',
'        // Match whole words (with word boundaries)',
'        const regex = new RegExp(`(\\b${escapedTerm}\\b)`, ''gi'');',
'        ',
'        highlightedText = highlightedText.replace(',
'            regex, ',
'            ''<span class="highlight-term">$1</span>''',
'        );',
'    });',
'    ',
'    // Only update if text changed',
'    if (highlightedText !== text) {',
'        const span = document.createElement(''span'');',
'        span.innerHTML = highlightedText;',
'        textNode.parentNode.replaceChild(span, textNode);',
'    }',
'}',
'',
'/**',
' * Remove all highlights',
' */',
'function removeHighlights(selector) {',
'    const highlights = document.querySelectorAll(selector + '' .highlight-term'');',
'    highlights.forEach(span => {',
'        const text = document.createTextNode(span.textContent);',
'        span.parentNode.replaceChild(text, span);',
'    });',
'}'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Highlight search terms when page loads',
'highlightSearchTerms(',
'    ''.t-Card'',  // Adjust selector based on your card class',
'    apex.item(''P650_HIGHLIGHT_TERMS'').getValue()',
');',
'',
'// Re-highlight when search terms change',
'apex.item(''P650_HIGHLIGHT_TERMS'').onChange = function() {',
'    // Remove old highlights',
'    removeHighlights(''.t-Card'');',
'    ',
'    // Apply new highlights',
'    highlightSearchTerms(',
'        ''.t-Card'',',
'        apex.item(''P650_HIGHLIGHT_TERMS'').getValue()',
'    );',
'};'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
' /* Highlight styling */',
'.highlight-term {',
'    background-color: #fff59d; /* Light yellow */',
'    color: #000;',
'    font-weight: 600;',
'    padding: 2px 4px;',
'    border-radius: 3px;',
'    box-shadow: 0 1px 3px rgba(255, 235, 59, 0.5);',
'    transition: all 0.2s ease;',
'}',
'',
'/* Hover effect */',
'.highlight-term:hover {',
'    background-color: #ffeb3b; /* Brighter yellow */',
'    box-shadow: 0 2px 6px rgba(255, 235, 59, 0.8);',
'}',
'',
'/* Alternative highlight colors for different contexts */',
'.highlight-term.primary {',
'    background-color: #bbdefb; /* Light blue */',
'    color: #1565c0;',
'}',
'',
'.highlight-term.secondary {',
'    background-color: #c8e6c9; /* Light green */',
'    color: #2e7d32;',
'}',
'',
'/* Dark mode support */',
'body.t-PageBody--dark .highlight-term {',
'    background-color: #fbc02d;',
'    color: #000;',
'}',
'',
'/* Animation for newly highlighted terms */',
'@keyframes highlight-pulse {',
'    0%, 100% { opacity: 1; }',
'    50% { opacity: 0.8; }',
'}',
'',
'.highlight-term.new {',
'    animation: highlight-pulse 0.5s ease-in-out 2;',
'}'))
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'23'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(129606414030647841)
,p_plug_name=>'Search Results'
,p_region_css_classes=>'search-results-grid'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--hideHeader js-addHiddenHeadingRoleDesc:t-CardsRegion--styleA'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>120
,p_plug_grid_column_span=>9
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    seq_id as result_number,',
'    n001 as chunk_id,',
'    n002 as doc_id,',
'    c001 as doc_title,',
'    n003 as chunk_sequence,',
'    CASE ',
'        WHEN LENGTH(clob001) > 400 ',
'        THEN SUBSTR(clob001, 1, 400) || ''...''',
'        ELSE clob001',
'    END as chunk_preview,',
'    clob001 as CHUNK_FULL_TEXT, ',
'    n004 as relevance_score,',
'    n005 as relevance_pct,',
'    CASE ',
'        WHEN n005 >= 90 THEN ''success''',
'        WHEN n005 >= 75 THEN ''warning''',
'        WHEN n005 >= 60 THEN ''info''',
'        ELSE ''default''',
'    END as badge_color,',
'    CASE ',
unistr('        WHEN n005 >= 90 THEN ''\D83E\DD47 Excellent Match'''),
unistr('        WHEN n005 >= 75 THEN ''\D83E\DD48 Very Good'''),
unistr('        WHEN n005 >= 60 THEN ''\D83E\DD49 Good Match'''),
unistr('        ELSE ''\D83D\DCC4 Relevant'''),
'    END as relevance_label,',
'    c002 as embedding_model,',
'    -- New: Add highlighting for search terms',
'    REGEXP_REPLACE(',
'        SUBSTR(clob001, 1, 400),',
'        c003, -- search query',
'        ''<mark>\1</mark>'',',
'        1, 0, ''i''',
'    ) as highlighted_preview,',
'    -- New: Calculate reading time',
' ',
'    -- New: Add chunk position indicator',
'    ROUND(n003 / 184 * 100, 0) as position_pct',
'FROM apex_collections',
'WHERE collection_name = ''SMART_SEARCH_RESULTS''',
'ORDER BY n005 DESC'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(131996172787453003)
,p_region_id=>wwv_flow_imp.id(129606414030647841)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>true
,p_title_html_expr=>'&DOC_TITLE.'
,p_sub_title_adv_formatting=>true
,p_sub_title_html_expr=>'Chunk #&CHUNK_SEQUENCE. of 184 (&POSITION_PCT.% through document)'
,p_body_adv_formatting=>true
,p_body_html_expr=>'&CHUNK_FULL_TEXT!RAW.'
,p_second_body_adv_formatting=>true
,p_second_body_html_expr=>unistr('`\D83D\DCD6 ~ &RELEVANCE_LABEL.')
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'BADGE_COLOR'
,p_icon_css_classes=>'fa-file-text-o'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(131997672938453018)
,p_card_id=>wwv_flow_imp.id(131996172787453003)
,p_action_type=>'BUTTON'
,p_position=>'PRIMARY'
,p_display_sequence=>10
,p_label=>'New'
,p_link_target_type=>'REDIRECT_PAGE'
,p_link_target=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.:::'
,p_button_display_type=>'TEXT'
,p_is_hot=>false
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(129606563135647842)
,p_plug_name=>'Search Statistics'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>130
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131979125975579931)
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
 p_id=>wwv_flow_imp.id(131997188365453013)
,p_plug_name=>'Search Input'
,p_region_css_classes=>'hero-search-region'
,p_icon_css_classes=>'fa-search'
,p_region_template_options=>'#DEFAULT#:t-Region--removeHeader js-removeLandmark:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(129606623936647843)
,p_plug_name=>'Advanced'
,p_parent_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_icon_css_classes=>'fa-cog'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131998158597453023)
,p_plug_name=>'btn'
,p_parent_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noPadding:t-ButtonRegion--noBorder'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131997234370453014)
,p_plug_name=>'Search Overview'
,p_region_css_classes=>'sidebar-stats'
,p_icon_css_classes=>'fa-dashboard'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>70
,p_plug_display_point=>'REGION_POSITION_02'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131997346041453015)
,p_plug_name=>'Statistics Cards'
,p_parent_plug_id=>wwv_flow_imp.id(131997234370453014)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="search-stats-container">',
'    <div class="stat-card">',
unistr('        <span class="stat-icon">\2705</span>'),
'        <span class="stat-value">&P650_RESULT_COUNT.</span>',
'        <span class="stat-label">Results Found</span>',
'    </div>',
'    <div class="stat-card">',
unistr('        <span class="stat-icon">\23F1\FE0F</span>'),
'        <span class="stat-value">&P650_SEARCH_TIME.s</span>',
'        <span class="stat-label">Search Time</span>',
'    </div>',
'    <div class="stat-card">',
unistr('        <span class="stat-icon">\D83C\DFAF</span>'),
'        <span class="stat-value">184</span>',
'        <span class="stat-label">Chunks Scanned</span>',
'    </div>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131997464480453016)
,p_plug_name=>'Document Filter List'
,p_parent_plug_id=>wwv_flow_imp.id(131997234370453014)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="document-filter">',
unistr('    <h4>\D83D\DCC2 Filter by Document</h4>'),
'    <ul class="doc-list">',
'        <li class="doc-item active">',
'            <input type="checkbox" id="doc_all" checked>',
'            <label for="doc_all">All Documents (184)</label>',
'        </li>',
'        <li class="doc-item">',
'            <input type="checkbox" id="doc_2">',
'            <label for="doc_2">Cobit Design 2019 (184)</label>',
'        </li>',
'    </ul>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(131997554246453017)
,p_plug_name=>'Quick Tips'
,p_parent_plug_id=>wwv_flow_imp.id(131997234370453014)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="quick-tips">',
unistr('    <h4>\D83D\DCA1 Search Tips</h4>'),
'    <ul>',
unistr('        <li>\2728 Ask in natural language</li>'),
unistr('        <li>\D83C\DFAF Be specific & clear</li>'),
unistr('        <li>\D83D\DCDD Use complete questions</li>'),
unistr('        <li>\D83D\DD04 Try different phrasings</li>'),
'    </ul>',
'    <button class="tips-more">Show Examples</button>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(131996361836453005)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(131998158597453023)
,p_button_name=>'search'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Search'
,p_icon_css_classes=>'fa-search'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(131996556527453007)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(131998158597453023)
,p_button_name=>'Clear'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Clear'
,p_icon_css_classes=>'fa-eraser'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129606734545647844)
,p_name=>'P650_SEARCH_QUERY'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_prompt=>'What are you looking for?'
,p_placeholder=>'e.g., What is COBIT framework? or Explain IT governance principles'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_colspan=>12
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Enter your question or keywords. AI will find relevant content based on meaning, not just exact matches.'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129606832387647845)
,p_name=>'P650_DOCUMENT_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_prompt=>'Document'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'SELECT doc_title, doc_id FROM docs WHERE is_active = ''Y'''
,p_lov_display_null=>'YES'
,p_lov_null_text=>unistr('\D83C\DF10 Search All Documents')
,p_cHeight=>1
,p_colspan=>3
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-book'
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129606976962647846)
,p_name=>'P650_MAX_RESULTS'
,p_is_required=>true
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_item_default=>'5'
,p_prompt=>'# of Results'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:3;3,5;5,10;10,20;20,50;50'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_colspan=>2
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'3'
,p_quick_pick_value_01=>'3'
,p_quick_pick_label_02=>'5'
,p_quick_pick_value_02=>'5'
,p_quick_pick_label_03=>'10'
,p_quick_pick_value_03=>'10'
,p_quick_pick_label_04=>'15'
,p_quick_pick_value_04=>'15'
,p_quick_pick_label_05=>'20'
,p_quick_pick_value_05=>'20'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129607122346647848)
,p_name=>'P650_THRESHOLD'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_item_default=>'0.5'
,p_prompt=>'Relevance Threshold'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>'Higher = More selective (only highly relevant), Lower = More results (less relevant)'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '1',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(129607211826647849)
,p_name=>'P650_SHOW_SCORES'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(129606623936647843)
,p_prompt=>'Show Similarity Scores'
,p_source_type=>'REGION_SOURCE_COLUMN'
,p_display_as=>'PLUGIN_RANRANGE_SLIDER'
,p_cSize=>30
,p_cHeight=>1
,p_colspan=>3
,p_field_template=>2318601014859922299
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'default_value', '0',
  'max_value', '1',
  'min_value', '0',
  'step_size', '0.1')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(131995944398453001)
,p_name=>'P650_CHUNK_CONTEXT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(129606623936647843)
,p_prompt=>'Context Window'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>unistr('STATIC:Just This Chunk;Just This Chunk,\00B11 Chunk;\00B11 Chunk,\00B12 Chunks;\00B12 Chunks')
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(131996084919453002)
,p_name=>'P650_HIGHLIGHT_TERMS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_item_default=>'Y'
,p_prompt=>'Highlight Key Terms'
,p_display_as=>'NATIVE_YES_NO'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(131996607547453008)
,p_name=>'P650_SEARCH_TIME'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_prompt=>'Search Time'
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
 p_id=>wwv_flow_imp.id(131996790384453009)
,p_name=>'P650_RESULT_COUNT'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_prompt=>'Result Count'
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
 p_id=>wwv_flow_imp.id(131996957906453011)
,p_name=>'P650_ERROR_MESSAGE'
,p_item_sequence=>140
,p_prompt=>'Error Message'
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
 p_id=>wwv_flow_imp.id(131997083345453012)
,p_name=>'P650_SUCCESS_MESSAGE'
,p_item_sequence=>150
,p_prompt=>'Error Message'
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
 p_id=>wwv_flow_imp.id(131998072952453022)
,p_name=>'P650_ORDER_BY'
,p_is_required=>true
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(131997188365453013)
,p_item_default=>'RELEVANCE_PCT'
,p_prompt=>'Order By'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC2:Relevance Pct;RELEVANCE_PCT'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_warn_on_unsaved_changes=>'I'
,p_lov_display_extra=>'NO'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(131997843004453020)
,p_name=>'init'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(131997984042453021)
,p_event_id=>wwv_flow_imp.id(131997843004453020)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// ============================================',
'// PAGE 650: SMART DOCUMENT SEARCH JAVASCRIPT',
'// ============================================',
'',
'// Initialize on page load',
'$(document).ready(function() {',
'    initializeSmartSearch();',
'});',
'',
'function initializeSmartSearch() {',
'    // 1. Add character counter to search input',
'    addCharacterCounter();',
'',
'    // 2. Initialize rotating placeholder examples',
'    rotatePlaceholderExamples();',
'',
'    // 3. Add keyboard shortcuts',
'    addKeyboardShortcuts();',
'',
'    // 4. Enhanced result card interactions',
'    enhanceResultCards();',
'',
'    // 5. Add copy to clipboard functionality',
'    addCopyToClipboard();',
'',
'    // 6. Initialize threshold slider visuals',
'    initializeThresholdSlider();',
'',
'    // 7. Add search suggestions',
'    addSearchSuggestions();',
'}',
'',
'// Character Counter',
'function addCharacterCounter() {',
'    const maxChars = 2000;',
'    const $textarea = $(''#P650_SEARCH_QUERY'');',
'    const $counter = $(''<div class="char-counter">0 / '' + maxChars + ''</div>'');',
'',
'    $textarea.after($counter);',
'',
'    $textarea.on(''input'', function() {',
'        const length = $(this).val().length;',
'        $counter.text(length + '' / '' + maxChars);',
'',
'        if (length > maxChars * 0.9) {',
'            $counter.addClass(''warning'');',
'        } else {',
'            $counter.removeClass(''warning'');',
'        }',
'    });',
'}',
'',
'// Rotating Placeholder Examples',
'function rotatePlaceholderExamples() {',
'    const examples = [',
'        "What is COBIT framework?",',
'        "Explain IT governance principles",',
'        "How to implement risk management?",',
'        "What are the key components of COBIT?",',
'        "Tell me about compliance requirements"',
'    ];',
'',
'    let currentIndex = 0;',
'    const $textarea = $(''#P650_SEARCH_QUERY'');',
'',
'    setInterval(function() {',
'        if ($textarea.val() === '''' && !$textarea.is('':focus'')) {',
'            currentIndex = (currentIndex + 1) % examples.length;',
unistr('            $textarea.attr(''placeholder'', ''\D83D\DCA1 Try: "'' + examples[currentIndex] + ''"'');'),
'        }',
'    }, 4000);',
'}',
'',
'// Keyboard Shortcuts',
'function addKeyboardShortcuts() {',
'    $(document).on(''keydown'', function(e) {',
'        // Ctrl/Cmd + Enter = Search',
'        if ((e.ctrlKey || e.metaKey) && e.key === ''Enter'') {',
'            e.preventDefault();',
'            $(''#search'').click();',
'        }',
'',
'        // Ctrl/Cmd + K = Focus search',
'        if ((e.ctrlKey || e.metaKey) && e.key === ''k'') {',
'            e.preventDefault();',
'            $(''#P650_SEARCH_QUERY'').focus();',
'        }',
'',
'        // Esc = Clear search',
'        if (e.key === ''Escape'' && $(''#P650_SEARCH_QUERY'').is('':focus'')) {',
'            $(''#Clear'').click();',
'        }',
'    });',
'',
'    // Add keyboard shortcut hints',
'    const $hint = $(''<div class="keyboard-hints">'' +',
'        ''<span><kbd>Ctrl</kbd> + <kbd>Enter</kbd> Search</span> '' +',
'        ''<span><kbd>Ctrl</kbd> + <kbd>K</kbd> Focus</span> '' +',
'        ''<span><kbd>Esc</kbd> Clear</span>'' +',
'        ''</div>'');',
'    $(''.hero-search-region'').append($hint);',
'}',
'',
'// Enhance Result Cards',
'function enhanceResultCards() {',
'    // Add hover preview',
'    $(''.t-Card'').hover(',
'        function() {',
'            $(this).find(''.card-preview-popup'').fadeIn(200);',
'        },',
'        function() {',
'            $(this).find(''.card-preview-popup'').fadeOut(200);',
'        }',
'    );',
'',
'    // Add smooth scroll to result',
'    $(''.t-Card'').on(''click'', function(e) {',
'        if (!$(e.target).is(''button, a'')) {',
'            $(this).addClass(''highlighted'');',
'            setTimeout(() => $(this).removeClass(''highlighted''), 2000);',
'        }',
'    });',
'}',
'',
'// Copy to Clipboard',
'function addCopyToClipboard() {',
'    $(''.copy-chunk-btn'').on(''click'', function(e) {',
'        e.preventDefault();',
'        const text = $(this).data(''chunk-text'');',
'',
'        navigator.clipboard.writeText(text).then(function() {',
'            // Show success message',
'            apex.message.showPageSuccess(''Copied to clipboard!'');',
'        }).catch(function(err) {',
'            apex.message.showErrors(''Failed to copy: '' + err);',
'        });',
'    });',
'}',
' '))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(131996212138453004)
,p_process_sequence=>10
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Perform Smart Search'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/*******************************************************************************',
' * CORRECTED APEX PAGE PROCESS: Perform Smart Search',
' * ',
' * Page: 650 - Smart Document Search',
' * Process Point: After Submit',
' * Button: P650_SEARCH',
' * ',
' * ISSUE FIXED: Removed APEX_ERROR calls causing stack issues',
' *******************************************************************************/',
'',
'DECLARE',
'    v_start_time TIMESTAMP := SYSTIMESTAMP;',
'    v_duration NUMBER;',
'    v_result_count NUMBER := 0;',
'    v_query CLOB;',
'    v_doc_id NUMBER;',
'    v_max_results NUMBER;',
'    v_threshold NUMBER;',
'   v_chunk_text clob;',
'BEGIN',
'    -- Get page item values',
'    v_query := :P650_SEARCH_QUERY;',
'    v_doc_id := :P650_DOCUMENT_ID;',
'    v_max_results := NVL(:P650_MAX_RESULTS, 10);',
'    v_threshold := NVL(:P650_THRESHOLD, 0.5);',
'    ',
'    -- Clear previous results',
'    BEGIN',
'        APEX_COLLECTION.DELETE_COLLECTION(''SMART_SEARCH_RESULTS'');',
'    EXCEPTION',
'        WHEN OTHERS THEN NULL; -- Collection might not exist',
'    END;',
'    ',
'    APEX_COLLECTION.CREATE_COLLECTION(''SMART_SEARCH_RESULTS'');',
'    ',
'    -- Validate input',
'    IF v_query IS NULL OR TRIM(v_query) IS NULL THEN',
'        :P650_ERROR_MESSAGE := ''Please enter a search query'';',
'        :P650_RESULT_COUNT := 0;',
'        RETURN;',
'    END IF;',
'    ',
'    -- Perform search and populate collection',
'    BEGIN',
'        FOR rec IN (',
'            SELECT * ',
'            FROM TABLE(rag_search_util.smart_search(',
'                p_query => v_query,',
'                p_doc_id => v_doc_id,',
'                p_max_results => v_max_results,',
'                p_threshold => v_threshold',
'            ))',
'        ) LOOP',
'         v_chunk_text:= null;',
'            v_result_count := v_result_count + 1;',
'            ',
'             ',
'          if  :P650_HIGHLIGHT_TERMS=''Y'' then',
'              v_chunk_text:=  RAG_SEARCH_UTIL.highlight_search_terms(rec.chunk_text, :P650_SEARCH_QUERY) ;--as chunk_text_highlighted,',
'           else ',
'           v_chunk_text :=rec.chunk_text;  end if;',
'',
'            APEX_COLLECTION.ADD_MEMBER(',
'                p_collection_name => ''SMART_SEARCH_RESULTS'',',
'                p_n001 => rec.chunk_id,',
'                p_n002 => rec.doc_id,',
'                p_c001 => rec.doc_title,',
'                p_n003 => rec.chunk_sequence,',
'                p_clob001 =>v_chunk_text ,',
'                p_n004 => rec.relevance_score,',
'                p_n005 => rec.relevance_pct,',
'                p_c002 => rec.embedding_model,',
'                p_c003 => v_query',
'            );',
'        END LOOP;',
'        ',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            :P650_ERROR_MESSAGE := ''Search error: '' || SUBSTR(SQLERRM, 1, 500);',
'            :P650_RESULT_COUNT := 0;',
'            RETURN;',
'    END;',
'    ',
'    -- Calculate duration',
'    v_duration := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time));',
'    ',
'    -- Set statistics',
'    :P650_SEARCH_TIME := ROUND(v_duration, 3);',
'    :P650_RESULT_COUNT := v_result_count;',
'    :P650_ERROR_MESSAGE := NULL; -- Clear any previous errors',
'    ',
'    -- Set success message based on results',
'    IF v_result_count = 0 THEN',
'        :P650_ERROR_MESSAGE := ''No results found. Try adjusting your search or lowering the relevance threshold.'';',
'    ELSE',
'        :P650_SUCCESS_MESSAGE := ',
'            ''Found '' || v_result_count || '' relevant result'' || ',
'            CASE WHEN v_result_count > 1 THEN ''s'' END || ',
'            '' in '' || ROUND(v_duration, 2) || '' seconds'';',
'    END IF;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        :P650_ERROR_MESSAGE := ''Unexpected error: '' || SUBSTR(SQLERRM, 1, 500);',
'        :P650_RESULT_COUNT := 0;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(131996361836453005)
,p_internal_uid=>131996212138453004
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(131996433669453006)
,p_process_sequence=>20
,p_process_point=>'ON_SUBMIT_BEFORE_COMPUTATION'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'clear'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'BEGIN',
'    APEX_COLLECTION.DELETE_COLLECTION(''SMART_SEARCH_RESULTS'');',
'    :P650_SEARCH_QUERY := NULL;',
'    :P650_RESULT_COUNT := NULL;',
'    :P650_SEARCH_TIME := NULL;',
'END;',
' '))
,p_process_clob_language=>'PLSQL'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(131996556527453007)
,p_internal_uid=>131996433669453006
);
wwv_flow_imp.component_end;
end;
/
