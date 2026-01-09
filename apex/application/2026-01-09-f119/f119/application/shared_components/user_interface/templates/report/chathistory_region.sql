prompt --application/shared_components/user_interface/templates/report/chathistory_region
begin
--   Manifest
--     ROW TEMPLATE: CHATHISTORY_REGION
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_row_template(
 p_id=>wwv_flow_imp.id(155681777593051477)
,p_row_template_name=>'ChatHistory Region'
,p_internal_name=>'CHATHISTORY_REGION'
,p_row_template1=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="chat-turn">',
'',
'  <!-- USER -->',
'  <div class="chat-line user-line">',
unistr('    <span class="chat-icon">\D83D\DC64</span>'),
'',
'    <div class="chat-bubble user-bubble">',
'      #USER_PROMPT#',
'    </div>',
'',
'    <div class="chat-meta-right">',
'      <span class="chat-time">#DB_CREATED_AT#</span>',
unistr('      <span class="chat-menu disabled">\22EF</span>'),
'    </div>',
'  </div>',
'',
'  <!-- ASSISTANT -->',
'  <div class="chat-line ai-line">',
unistr('    <span class="chat-icon">\D83E\DD16</span>'),
'',
'    <div class="chat-bubble ai-bubble">',
'      #RESPONSE_TEXT#',
'    </div>',
'  </div>',
'',
'</div>'))
,p_row_template_before_rows=>' <div class="chat-history-container" id="chatHistoryContainer">'
,p_row_template_after_rows=>' </div>'
,p_row_template_type=>'NAMED_COLUMNS'
,p_row_template_display_cond1=>'0'
,p_row_template_display_cond2=>'0'
,p_row_template_display_cond3=>'0'
,p_row_template_display_cond4=>'0'
,p_theme_id=>42
,p_theme_class_id=>4
,p_translate_this_template=>'Y'
);
wwv_flow_imp.component_end;
end;
/
