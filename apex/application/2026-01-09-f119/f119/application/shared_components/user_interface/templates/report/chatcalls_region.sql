prompt --application/shared_components/user_interface/templates/report/chatcalls_region
begin
--   Manifest
--     ROW TEMPLATE: CHATCALLS_REGION
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
 p_id=>wwv_flow_imp.id(151729740325745780)
,p_row_template_name=>'ChatCalls Region'
,p_internal_name=>'CHATCALLS_REGION'
,p_row_template1=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="chatCall-wrapper" data-chatcall-id="#CALL_ID#">',
'    <div class="chatCall-card">',
'',
'        <div class="chatCall-header">',
'            <span class="chatCall-domainBadge">#CONTEXT_DOMAIN_NAME#</span>',
'            <span class="chatCall-regen-flag">#REGEN_TEXT#</span>',
'            <span class="chatCall-rating">#RATING_ICON#</span>',
'            <span class="chatCall-time">#DISPLAY_DATE#</span>',
'',
unistr('            <!-- \22EE MENU -->'),
'            <div class="chatCall-more">',
unistr('                <span class="chatCall-moreBtn" role="button" aria-haspopup="true">\22EE</span>'),
'',
'                <div class="chatCall-moreDropdown">',
unistr('                    <button type="button" class="chatCall-menuItem chatCall-copyBtn"  >\D83D\DCCB Copy    </button>'),
unistr('                    <button type="button" class="chatCall-menuItem chatCall-exportBtn">\D83D\DCBE Export  </button>'),
unistr('                    <button type="button" class="chatCall-menuItem chatCall-reportBtn">\D83D\DEA8 Report </button>'),
unistr('                    <button type="button" class="chatCall-menuItem chatCall-deleteBtn">\D83D\DDD1 Delete  </button>'),
'                </div>',
'            </div>',
'        </div>',
'',
'        <div class="chatCall-content">',
unistr('            <div class="chatCall-userText">\D83E\DDD1 #USER_PROMPT#</div>'),
unistr('            <div class="chatCall-assistantText">\2728 #RESPONSE_TEXT#</div>'),
'        </div>',
'',
unistr('        <div class="chatCall-metadataToggle">Details \25BC</div>'),
'',
'        <div class="chatCall-metadata">',
'            <div>Tokens: #TOKENS_TOTAL# (in #TOKENS_INPUT# / out #TOKENS_OUTPUT#)</div>',
'            <div>Latency: #PROCESSING_TIME_MS# ms</div>',
'            <div>RAG Docs: #RAG_DOC_COUNT#</div>',
'        </div>',
'',
'    </div>',
'</div>',
''))
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
