prompt --application/pages/page_00001
begin
--   Manifest
--     PAGE: 00001
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
 p_id=>1
,p_name=>'Home'
,p_alias=>'HOME'
,p_step_title=>'Enterprise Chatpot'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ============================================================',
unistr('   ORACLE AI CHATPOT \2014 HOME PAGE (APEX 24.2)'),
'   FINAL CLEAN CSS',
'   ============================================================ */',
'',
'',
'/* ============================================================',
'   HERO BANNER',
'   Region Static ID: homeHero',
'   ============================================================ */',
'',
'#homeHero {',
'  margin-bottom: 1.5rem;',
'}',
'',
'#homeHero .home-hero {',
'  text-align: center;',
'  padding: 2.5rem 1rem 1.75rem;',
'}',
'',
'#homeHero .home-hero h1 {',
'  font-size: 2.2rem;',
'  font-weight: 800;',
'  letter-spacing: -0.02em;',
'  margin-bottom: .4rem;',
'}',
'',
'#homeHero .home-hero h1 .fa {',
'  color: #0078D4;',
'  margin-right: .6rem;',
'}',
'',
'#homeHero .home-hero p {',
'  font-size: 1.1rem;',
'  color: #666;',
'  margin: 0;',
'}',
'',
'',
'/* ============================================================',
'   HERO CTA BUTTONS (Buttons Container)',
'   Sub-region template: Buttons Container (noUI)',
'   ============================================================ */',
'',
'/* Center the buttons container */',
'#homeHero .t-ButtonRegion {',
'  display: flex;',
'  justify-content: center;',
'  align-items: center;',
'  gap: 0.75rem;',
'  margin-top: 1.75rem;',
'}',
'',
'/* Prevent Universal Theme full-width buttons */',
'#homeHero .t-ButtonRegion .t-Button {',
'  width: auto !important;',
'  min-width: unset;',
'  flex: 0 0 auto;',
'}',
'',
'',
'/* ============================================================',
unistr('   PRIMARY CTA \2014 Start New Chat'),
'   Button ID: BTN_START_CHAT',
'   ============================================================ */',
'',
'#BTN_START_CHAT {',
'  border-radius: 999px;',
'  padding: 0.9rem 2.4rem;',
'  font-size: 1.15rem;',
'  font-weight: 600;',
'',
'  display: inline-flex;',
'  align-items: center;',
'  justify-content: center;',
'  gap: .5rem;',
'}',
'',
'#BTN_START_CHAT.t-Button--hot {',
'  box-shadow: 0 10px 28px rgba(0,120,212,.35);',
'}',
'',
'#BTN_START_CHAT.t-Button--hot:hover {',
'  transform: translateY(-2px);',
'  box-shadow: 0 14px 36px rgba(0,120,212,.45);',
'}',
'',
'',
'/* ============================================================',
unistr('   SECONDARY CTA \2014 Resume Last Chat'),
'   Button ID: BTN_RESUME_CHAT',
'   ============================================================ */',
'',
'#BTN_RESUME_CHAT {',
'  border-radius: 999px;',
'  padding: 0.85rem 2.2rem;',
'  font-size: 1.05rem;',
'  font-weight: 600;',
'',
'  background: #fff;',
'  border: 2px solid #0078D4;',
'  color: #0078D4;',
'',
'  display: inline-flex;',
'  align-items: center;',
'  justify-content: center;',
'  gap: .5rem;',
'',
'  transition: all .2s ease;',
'}',
'',
'#BTN_RESUME_CHAT:hover {',
'  background: rgba(0,120,212,.08);',
'  transform: translateY(-2px);',
'}',
'',
'',
'/* ============================================================',
'   SYSTEM STATUS STRIP',
'   Region Static ID: system-status',
'   ============================================================ */',
'',
'#system-status {',
'  margin: .75rem 0 1.75rem;',
'}',
'',
'#system-status .t-BadgeList {',
'  justify-content: center;',
'  gap: .75rem;',
'}',
'',
'#system-status .t-Badge {',
'  padding: .5rem .75rem;',
'  font-size: .85rem;',
'  font-weight: 600;',
'  border-radius: 10px;',
'}',
'',
'',
'/* ============================================================',
'   CORE ACTIONS CARDS',
'   Region Static ID: core-actions',
'   ============================================================ */',
'',
'#core-actions {',
'  margin-bottom: 2.5rem;',
'}',
'',
'#core-actions .t-Cards {',
'  padding: 0;',
'  margin: -1rem;',
'}',
'',
'#core-actions .t-Cards--row {',
'  row-gap: 2rem;',
'  column-gap: 2rem;',
'}',
'',
'',
'/* ------------------------------------------------------------',
'   BASE CARD',
'   ------------------------------------------------------------ */',
'',
'#core-actions .t-Card {',
'  position: relative;',
'  background: #fff;',
'  border: 1px solid #e8e8e8;',
'  border-radius: 16px;',
'  box-shadow: 0 2px 8px rgba(0,0,0,.04);',
'  transition: transform .25s ease,',
'              box-shadow .25s ease,',
'              border-color .25s ease;',
'  overflow: hidden;',
'}',
'',
'#core-actions .t-Card:hover {',
'  transform: translateY(-6px);',
'  box-shadow: 0 12px 28px rgba(0,0,0,.12);',
'  border-color: #d0d0d0;',
'}',
'',
'',
'/* Accent line */',
'#core-actions .t-Card::before {',
'  content: "";',
'  position: absolute;',
'  inset: 0 0 auto 0;',
'  height: 4px;',
'  background: linear-gradient(90deg, #0078D4, #106EBE);',
'  opacity: 0;',
'  transition: opacity .25s ease;',
'}',
'',
'#core-actions .t-Card:hover::before {',
'  opacity: 1;',
'}',
'',
'',
'/* ------------------------------------------------------------',
'   PRIMARY CARD (via hidden marker)',
'   ------------------------------------------------------------ */',
'',
'#core-actions .t-Card:has(.card-marker.PRIMARY) {',
'  border-left: 4px solid #0078D4;',
'  background: linear-gradient(to bottom right, #ffffff, #f0f7ff);',
'  box-shadow: 0 14px 36px rgba(0,120,212,.18);',
'  transform: translateY(-6px);',
'}',
'',
'#core-actions .t-Card:has(.card-marker.PRIMARY):hover {',
'  transform: translateY(-6px);',
'}',
'',
'#core-actions .t-Card:not(:has(.card-marker.PRIMARY)) {',
'  opacity: .95;',
'}',
'',
'',
'/* ------------------------------------------------------------',
'   ICON',
'   ------------------------------------------------------------ */',
'',
'#core-actions .t-Card-icon {',
'  width: 64px;',
'  height: 64px;',
'  margin-bottom: 1.25rem;',
'  display: flex;',
'  align-items: center;',
'  justify-content: center;',
'  border-radius: 16px;',
'  font-size: 2rem;',
'  background: linear-gradient(135deg, #f5f7fa, #c3cfe2);',
'  color: #0078D4;',
'  transition: transform .25s ease,',
'              background .25s ease,',
'              box-shadow .25s ease;',
'}',
'',
'#core-actions .t-Card:hover .t-Card-icon {',
'  transform: scale(1.08) rotate(4deg);',
'  background: linear-gradient(135deg, #667eea, #764ba2);',
'  color: #fff;',
'  box-shadow: 0 8px 16px rgba(102,126,234,.35);',
'}',
'',
'#core-actions .t-Card:has(.card-marker.PRIMARY) .t-Card-icon {',
'  background: linear-gradient(135deg, #0078D4, #106EBE);',
'  color: #fff;',
'}',
'',
'',
'/* ------------------------------------------------------------',
'   TITLE & BODY',
'   ------------------------------------------------------------ */',
'',
'#core-actions .t-Card-title {',
'  font-size: 1.25rem;',
'  font-weight: 700;',
'  color: #1a1a1a;',
'  margin-bottom: .75rem;',
'  letter-spacing: -0.02em;',
'}',
'',
'#core-actions .t-Card-body {',
'  padding: 0 1.5rem 1.5rem;',
'  font-size: .95rem;',
'  color: #555;',
'  line-height: 1.6;',
'}',
'',
'#core-actions .card-description {',
'  margin: 0;',
'}',
'',
'',
'/* ============================================================',
'   RESPONSIVE',
'   ============================================================ */',
'',
'@media (max-width: 1200px) {',
'  #core-actions .t-Cards--row {',
'    grid-template-columns: repeat(2, 1fr) !important;',
'  }',
'}',
'',
'@media (max-width: 768px) {',
'  #core-actions .t-Cards--row {',
'    grid-template-columns: 1fr !important;',
'    row-gap: 1.5rem;',
'  }',
'',
'  #core-actions .t-Card-icon {',
'    width: 56px;',
'    height: 56px;',
'    font-size: 1.75rem;',
'  }',
'',
'  #core-actions .t-Card-title {',
'    font-size: 1.1rem;',
'  }',
'}',
'',
'',
'/* ============================================================',
'   ACCESSIBILITY & PRINT',
'   ============================================================ */',
'',
'#core-actions .t-Card:focus-within {',
'  outline: 3px solid #0078D4;',
'  outline-offset: 4px;',
'}',
'',
'@media print {',
'  #core-actions .t-Card {',
'    box-shadow: none;',
'    border: 1px solid #000;',
'    break-inside: avoid;',
'  }',
'',
'  #core-actions .t-Card::before {',
'    display: none;',
'  }',
'}',
''))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'13'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(132580668266302014)
,p_plug_name=>'Hero Banner'
,p_region_name=>'homeHero'
,p_icon_css_classes=>'fa-robot'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="home-hero">',
'  <h1>',
'    <span class="fa fa-robot"></span>',
'    Oracle Enterprise AI Assistant',
'  </h1>',
'  <p>Ask. Analyze. Govern.</p>',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(152787885436832338)
,p_plug_name=>'btn'
,p_parent_plug_id=>wwv_flow_imp.id(132580668266302014)
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(152785161068832311)
,p_plug_name=>'Core Actions'
,p_region_name=>'core-actions'
,p_region_template_options=>'#DEFAULT#:t-CardsRegion--removeHeader js-removeLandmark:t-CardsRegion--styleC'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2072724515482255512
,p_plug_display_sequence=>70
,p_plug_display_column=>2
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    1 AS card_id,',
'    ''fa fa-robot'' AS icon,',
'    ''Enterprise AI Assistant'' AS title,',
'    ''Start a new AI conversation or resume your latest session.'' AS description,',
'    apex_page.get_url(p_application => :APP_ID,p_page => 114) AS target_url,',
'    ',
'    ''PRIMARY'' AS card_type',
'FROM dual',
'',
'UNION ALL',
'',
'SELECT',
'    2,',
'    ''fa fa-history'' icon,',
'    ''Conversation History'' title,',
'    ''Browse, search, and manage previous conversations.'' AS description,',
'    apex_page.get_url(p_page => 150) target_url,',
'    ''SECONDARY'' card_type',
'FROM dual',
'',
'UNION ALL',
'',
'SELECT',
'    3,',
'    ''fa fa-book''icon,',
'    ''Knowledge Base'' title,',
'    ''Documents, RAG domains, and intelligent search.'' AS description,',
'    apex_page.get_url(p_page => 600) target_url,',
'    ''SECONDARY'' card_type',
'FROM dual',
'',
'UNION ALL',
'',
'SELECT',
'    4,',
'    ''fa fa-line-chart'' icon,',
'    ''Audit & Performance'' title,',
'    ''Usage, performance, and cost analytics.'' AS description,',
'    apex_page.get_url(p_page => 721) target_url,',
'    ''OPTIONAL'' card_type',
'FROM dual;',
''))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_CARDS'
,p_plug_query_num_rows_type=>'SCROLL'
,p_show_total_row_count=>false
);
wwv_flow_imp_page.create_card(
 p_id=>wwv_flow_imp.id(152785267678832312)
,p_region_id=>wwv_flow_imp.id(152785161068832311)
,p_layout_type=>'GRID'
,p_title_adv_formatting=>false
,p_title_column_name=>'TITLE'
,p_title_css_classes=>'card-title '
,p_sub_title_adv_formatting=>false
,p_body_adv_formatting=>true
,p_body_html_expr=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<span class="card-marker &CARD_TYPE." style="display:none"></span>',
'',
'<div class="card-description">',
'  &DESCRIPTION.',
'</div>'))
,p_second_body_adv_formatting=>false
,p_icon_source_type=>'DYNAMIC_CLASS'
,p_icon_class_column_name=>'ICON'
,p_icon_css_classes=>'t-Card-icon'
,p_icon_position=>'START'
,p_media_adv_formatting=>false
,p_pk1_column_name=>'CARD_ID'
);
wwv_flow_imp_page.create_card_action(
 p_id=>wwv_flow_imp.id(152785312915832313)
,p_card_id=>wwv_flow_imp.id(152785267678832312)
,p_action_type=>'FULL_CARD'
,p_display_sequence=>10
,p_link_target_type=>'REDIRECT_URL'
,p_link_target=>'&TARGET_URL.'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(152786457582832324)
,p_plug_name=>'System Status'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>3371237801798025892
,p_plug_display_sequence=>50
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    ''System''        AS label,',
'    ''Healthy''       AS value,',
'    ''success''       AS status,',
'    1               AS ord',
'FROM dual',
'',
'UNION ALL',
'SELECT',
'    ''Chats Today'',',
'    TO_CHAR(COUNT(*)),',
'    ''info'',',
'    2',
'FROM chat_calls',
'WHERE TRUNC(db_created_at) = TRUNC(SYSDATE)',
'',
'UNION ALL',
'SELECT',
'    ''Active Users (1h)'',',
'    TO_CHAR(COUNT(DISTINCT user_id)),',
'    ''warning'',',
'    3',
'FROM chat_sessions',
'--WHERE db_created_at > SYSDATE - (1/24)',
'',
'UNION ALL',
'SELECT',
'    ''Model'',',
'    MAX(model),',
'    ''neutral'',',
'    4',
'FROM chat_calls',
'WHERE model IS NOT NULL',
'/*',
'UNION ALL',
'SELECT',
'    ''Governance'',',
'    CASE ',
'        WHEN EXISTS (',
'            SELECT 1',
'            FROM cfg_ai_policy',
'            WHERE policy_code = ''GOVERNANCE''',
'              AND is_enabled = ''Y''',
'        )',
'        THEN ''Enabled''',
'        ELSE ''Disabled''',
'    END,',
'    ''danger'',',
'    5',
'FROM dual;*/',
''))
,p_template_component_type=>'REPORT'
,p_lazy_loading=>false
,p_plug_source_type=>'TMPL_THEME_42$BADGE'
,p_plug_query_num_rows=>15
,p_plug_query_num_rows_type=>'SET'
,p_show_total_row_count=>false
,p_landmark_type=>'region'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'LABEL', '&LABEL.',
  'LABEL_DISPLAY', 'N',
  'STATE', 'STATUS',
  'VALUE', 'VALUE')).to_clob
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(152786929685832329)
,p_name=>'LABEL'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'LABEL'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>10
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(152787090518832330)
,p_name=>'VALUE'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'VALUE'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>20
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(152787106933832331)
,p_name=>'STATUS'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'STATUS'
,p_data_type=>'VARCHAR2'
,p_display_sequence=>30
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_region_column(
 p_id=>wwv_flow_imp.id(152787250564832332)
,p_name=>'ORD'
,p_source_type=>'DB_COLUMN'
,p_source_expression=>'ORD'
,p_data_type=>'NUMBER'
,p_display_sequence=>40
,p_is_group=>false
,p_is_primary_key=>false
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(152787592958832335)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(152787885436832338)
,p_button_name=>'BTN_START_CHAT'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#:t-Button--success:t-Button--iconLeft:t-Button--pillStart'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Start New Chat'
,p_button_redirect_url=>'f?p=&APP_ID.:114:&SESSION.::&DEBUG.:114::'
,p_icon_css_classes=>'fa-rocket'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(152787918839832339)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(152787885436832338)
,p_button_name=>'BTN_RESUME_CHAT'
,p_button_action=>'REDIRECT_URL'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Resume Last Chat'
,p_button_redirect_url=>'114'
,p_icon_css_classes=>'fa-history'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145720870614757236)
,p_name=>'P1_USER_ID'
,p_item_sequence=>30
,p_prompt=>'User Id'
,p_source=>'return v(''G_USER_ID'');'
,p_source_type=>'FUNCTION_BODY'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145720986854757237)
,p_name=>'P1_USER_NAME'
,p_item_sequence=>40
,p_prompt=>'Username'
,p_source=>'return v(''APP_USER'');'
,p_source_type=>'FUNCTION_BODY'
,p_source_language=>'PLSQL'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp.component_end;
end;
/
