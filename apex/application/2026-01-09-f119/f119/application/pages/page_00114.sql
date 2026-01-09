prompt --application/pages/page_00114
begin
--   Manifest
--     PAGE: 00114
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
 p_id=>114
,p_name=>'Enterprise AI Assistant'
,p_alias=>'ENTERPRISE-AI-ASSISTANT2'
,p_step_title=>'Enterprise AI Assistant'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
' /* ==========================================================================',
'   FORCE UI REFRESH FIX',
'   Ensures Page Item is synced BEFORE the refresh fires',
'   ========================================================================== */',
'(function() {',
'    const initInterval = setInterval(() => {',
'        if (window.chatPrompt && window.chatPrompt.initPage) {',
'            clearInterval(initInterval);',
'            applyHotfix();',
'        }',
'    }, 100);',
'',
'    function applyHotfix() {',
unistr('        console.log("\D83D\DD27 Applying Session State Hotfix...");'),
'',
'        // Override sendMessage with State Safety',
'        chatPrompt.sendMessage = async function(userText) {',
'            ',
'            // Basic validation',
'            if (!chatPrompt.getValue("provider") || !chatPrompt.getValue("model")) return;',
'            if (chatPrompt.state.isSending) return;',
'            ',
'            chatPrompt.state.isSending = true;',
'            let mustRefresh = true; ',
'            let activeSessionId = null; // Store ID locally to guarantee access',
'',
'            try {',
'                // UI Setup',
'                if (chatPrompt.state.typing) chatPrompt.state.typing.style.display = "block";',
'                if (chatPrompt.state.btnSend) chatPrompt.state.btnSend.disabled = true;',
'',
unistr('                // 1\FE0F\20E3 ENSURE SESSION'),
'                const session = await chatPrompt.ensureSession(userText);',
'                ',
unistr('                // \D83D\DEA8 CRITICAL FIX: Sync ID immediately upon success'),
'                if (session.success && session.sessionId) {',
'                    activeSessionId = session.sessionId;',
'                    ',
'                    // Force value into APEX Page Item so Region Refresh sees it',
'                    const sessionItem = chatPrompt.page.items.chatSessionId || "P114_CHAT_SESSION_ID";',
'                    apex.item(sessionItem).setValue(session.sessionId);',
'                    ',
unistr('                    console.log(`\2705 Session ID [${session.sessionId}] synced to UI`);'),
'                }',
'',
'                if (!session.success) return; ',
'',
unistr('                // 2\FE0F\20E3 DETECT DOMAIN'),
'                const domain = await chatPrompt.detectDomain(',
'                    { sessionId: session.sessionId, callId: session.callId, traceId: session.traceId }, ',
'                    userText',
'                );',
'                ',
'                if (!domain.success) return; ',
'',
unistr('                // 3\FE0F\20E3 INVOKE LLM'),
'                const llm = await chatPrompt.invokeLLM(',
'                    { sessionId: session.sessionId, callId: session.callId, traceId: session.traceId, contextDomainId: domain.contextDomainId }, ',
'                    userText',
'                );',
'',
'            } catch (e) {',
unistr('                console.error("\D83D\DCA5 Pipeline Error (Refreshing anyway):", e);'),
'                mustRefresh = true; ',
'            } finally {',
'                ',
'                chatPrompt.state.isSending = false;',
'                if (chatPrompt.state.typing) chatPrompt.state.typing.style.display = "none";',
'                if (chatPrompt.state.btnSend) chatPrompt.state.btnSend.disabled = false;',
'',
unistr('                // \D83D\DD04 ROBUST REFRESH'),
'                if (mustRefresh) {',
unistr('                    console.log(`\D83D\DD04 Refreshing Regions for Session: ${activeSessionId || "Existing"}`);'),
'                    ',
'                    // Safety: Ensure item is set one last time before refresh',
'                    if (activeSessionId) {',
'                         apex.item("P114_CHAT_SESSION_ID").setValue(activeSessionId);',
'                    }',
'',
'                    setTimeout(() => {',
'                        const callsRegion = chatPrompt.page.regions.chatCalls;',
'                        const sessionsRegion = chatPrompt.page.regions.chatSessions;',
'                        ',
'                        if (callsRegion) apex.region(callsRegion).refresh();',
'                        if (sessionsRegion) apex.region(sessionsRegion).refresh();',
'                        ',
'                    }, 200); // Slight delay for DB latency',
'                }',
'            }',
'        };',
unistr('        console.log("\2705 Hotfix Applied: Session ID will now sync before refresh.");'),
'    }',
'})();'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ======================================================================',
unistr('   ENTERPRISE AI ASSISTANT \2014 PAGE LOAD BOOTSTRAP'),
'   APEX 24.x Safe | DEV / PROD | Sequential Loading',
'   ====================================================================== */',
'',
'/* ------------------------------------------------------------',
'   ENV',
'------------------------------------------------------------ */',
'window.APP_ENV = ''&G_APP_ENV.''.trim();',
unistr('console.log("\D83C\DF0D APP_ENV =", window.APP_ENV);'),
'',
'/* ------------------------------------------------------------',
'   GLOBAL SEQUENTIAL SCRIPT LOADER',
'------------------------------------------------------------ */',
'window.loadSequential = function (urls, done) {',
'    if (!urls || !urls.length) {',
unistr('        console.log("\D83C\DF89 All scripts loaded");'),
'        if (typeof done === "function") done();',
'        return;',
'    }',
'',
'    const url = urls.shift();',
'    const s = document.createElement("script");',
'    s.src = url;',
'    s.type = "text/javascript";',
'',
'    s.onload = () => {',
unistr('        console.log("\D83D\DCE6 Loaded:", url);'),
'        window.loadSequential(urls, done);',
'    };',
'',
'    s.onerror = () => {',
unistr('        console.error("\274C Failed:", url);'),
'        window.loadSequential(urls, done);',
'    };',
'',
'    document.head.appendChild(s);',
'};',
'',
'/* ------------------------------------------------------------',
'   SCRIPT LIST',
'------------------------------------------------------------ */',
'const scripts = [',
'    "#WORKSPACE_FILES#chat/assistant/src/chatContext#MIN#.js",',
'    "#WORKSPACE_FILES#chat/assistant/src/chatPrompt#MIN#.js",',
'    "#WORKSPACE_FILES#chat/assistant/src/chatSession#MIN#.js",',
'    "#WORKSPACE_FILES#chat/assistant/src/chatCalls#MIN#.js"',
'];',
'',
'/* ------------------------------------------------------------',
'   LOAD + INIT (ONLY PLACE WHERE MODULES ARE TOUCHED)',
'------------------------------------------------------------ */',
'window.loadSequential(scripts, function () {',
unistr('    console.log("\D83D\DD25 Chat Assistant scripts ready");'),
'',
'    /* -----------------------------',
unistr('       1\FE0F\20E3 INIT CONTEXT FIRST'),
'    ----------------------------- */',
'    window.chatContext?.init?.();',
'',
'    /* -----------------------------',
unistr('       2\FE0F\20E3 BIND PAGE CONTRACT'),
'    ----------------------------- */',
'    window.chatPrompt?.initPage?.({',
'        items: {',
'            // --- Core Configuration ---',
'            provider:           "P114_PROVIDER",',
'            model:              "P114_MODEL",',
'            systemInstructions: "P114_SYSTEM_INSTRUCTIONS", ',
'',
'            // --- Hyperparameters ---',
'            temperature:        "P114_TEMPERATURE",',
'            maxTokens:          "P114_MAX_TOKENS",',
'            topP:               "P114_TOP_P",',
'            topK:               "P114_TOP_K",',
'            ',
'            // --- Streaming & RAG (NEW) ---',
'            streamEnabled:      "P114_STREAM_ENABLED",',
'            streamChannel:      "P114_STREAM_CHANNEL",',
'            contextDomainId:    "P114_CONTEXT_DOMAIN_ID", ',
'',
'            // --- App Metadata ---',
'            sessionTitle:       "P114_SESSION_TITLE",',
'            reportIssueUrl:     "P114_REPORT_ISSUE_URL"',
'        },',
'        regions: {',
'            chatCalls:      "ChatCallsStaticId",',
'            chatSessions:   "myActiveSessionStaticID",',
'            chatProjects:   "myProjectsTreeStaticID"',
'        }',
'    });',
'',
'    /* -----------------------------',
unistr('       3\FE0F\20E3 INIT MODULES (ORDERED)'),
'    ----------------------------- */',
'    window.chatPrompt?.init?.();',
'    window.chatSession?.init?.();',
'    window.chatCalls?.init?.();',
'',
' ',
'    /* -----------------------------',
unistr('       5\FE0F\20E3 DEBUG (DEV ONLY)'),
'    ----------------------------- */',
'    if (window.APP_ENV === "DEV") {',
unistr('        console.log("\D83E\DDEA chatPrompt API:", Object.keys(window.chatPrompt || {}));'),
unistr('        console.log("\D83E\DDE0 Current Session:", window.chatContext?.getSession?.());'),
'    }',
'});'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ============================================================',
unistr('   CHATGPT-STYLE PROMPT BAR \2014 FINAL / CLEAN / APEX SAFE'),
'   ============================================================ */',
'',
'/* ------------------------------------------------------------',
'   Sticky wrapper at bottom',
'------------------------------------------------------------ */',
'#chatPrompt.chatPrompt-wrapper {',
'    position: sticky;',
'    bottom: 0;',
'    z-index: 100;',
'    border-top: 1px solid #e5e7eb;',
'    padding: 12px 0 14px;',
'}',
'',
'/* ------------------------------------------------------------',
'   Center content (ChatGPT width)',
'------------------------------------------------------------ */',
'#chatPrompt .container {',
'    max-width: 920px;',
'    margin: 0 auto;',
'    padding: 0 12px;',
'}',
'',
'/* ------------------------------------------------------------',
'   Neutralize APEX grid + floating label spacing',
'------------------------------------------------------------ */',
'#chatPrompt .row,',
'#chatPrompt .col,',
'#chatPrompt .t-Form-fieldContainer {',
'    margin: 0 !important;',
'    padding: 0 !important;',
'}',
'',
'/* ------------------------------------------------------------',
'   Prompt container (anchor for floating send button)',
'------------------------------------------------------------ */',
'#P114_USER_PROMPT_CONTAINER {',
'    position: relative;',
'}',
'',
'/* ------------------------------------------------------------',
unistr('   Textarea \2014 ChatGPT style'),
'------------------------------------------------------------ */',
'.chatPrompt-input {',
'    width: 100%;',
'    min-height: 48px;',
'    max-height: 200px;',
'',
'    padding: 14px 56px 14px 16px;',
'    border-radius: 24px;',
'',
'    border: 1px solid #d1d5db;',
' ',
'',
'    font-size: 15px;',
'    line-height: 1.45;',
'',
'    resize: none !important;',
'    overflow-y: auto;',
'',
'    box-shadow: none;',
'    transition: border-color 0.15s ease, box-shadow 0.15s ease;',
'}',
'',
'/* Focus effect */',
'.chatPrompt-input:focus {',
'    outline: none;',
'    border-color: #2563eb;',
'    box-shadow: 0 0 0 1px #2563eb;',
'}',
'',
'/* ------------------------------------------------------------',
'   Floating SEND button (ChatGPT style)',
'------------------------------------------------------------ */',
'.chatPrompt-sendBtn {',
'    position: absolute;',
'    right: 10px;',
'    bottom: 8px;',
'',
'    width: 36px;',
'    height: 36px;',
'    padding: 0;',
'',
'    border-radius: 50%;',
'    border: none;',
'',
'    background: #2563eb;',
'    color: #ffffff;',
'',
'    display: flex;',
'    align-items: center;',
'    justify-content: center;',
'',
'    cursor: pointer;',
'',
'    box-shadow: 0 2px 6px rgba(0,0,0,0.15);',
'    transition: background 0.15s ease, transform 0.1s ease;',
'}',
'',
'/* Hide APEX button label */',
'.chatPrompt-sendBtn .t-Button-label {',
'    display: none;',
'}',
'',
'/* Arrow icon */',
'.chatPrompt-sendBtn::before {',
unistr('    content: "\27A4";'),
'    font-size: 16px;',
'    margin-left: 2px;',
'}',
'',
'/* Hover */',
'.chatPrompt-sendBtn:hover {',
'    background: #1d4ed8;',
'    transform: scale(1.05);',
'}',
'',
'/* Disabled (streaming-safe) */',
'.chatPrompt-sendBtn:disabled {',
'    background: #9ca3af;',
'    cursor: not-allowed;',
'    box-shadow: none;',
'    transform: none;',
'}',
'',
'/* ------------------------------------------------------------',
'   Typing indicator (optional)',
'------------------------------------------------------------ */',
'.chatPrompt-typingIndicator span {',
'    animation: blink 1.4s infinite both;',
'    opacity: 0.3;',
'}',
'',
'@keyframes blink {',
'    0%   { opacity: .3; }',
'    20%  { opacity: 1; }',
'    100% { opacity: .3; }',
'}',
'',
'/* ------------------------------------------------------------',
'   Mobile adjustments',
'------------------------------------------------------------ */',
'@media (max-width: 640px) {',
'    #chatPrompt .container {',
'        padding: 0 8px;',
'    }',
'',
'    .chatPrompt-input {',
'        font-size: 14px;',
'    }',
'}',
'',
' ',
' ',
' ',
'',
' /* ============================================================',
unistr('   Chat Call \22EE Menu \2014 SINGLE SOURCE OF TRUTH'),
'   ============================================================ */',
'',
'.chatCall-header {',
'    position: relative;',
'    z-index: 1;',
'}',
'',
'.chatCall-more {',
'    position: relative;',
'    z-index: 10;',
'}',
'',
'',
'.chatCall-moreDropdown {',
'    display: none;',
'    position: fixed;',
'    z-index: 2147483647;',
'',
'    min-width: 180px;',
'',
unistr('    /* \D83D\DD12 HARD BACKGROUND LOCK */'),
'    background-color: #ffffff !important;',
'    background-clip: padding-box;',
'    opacity: 1 !important;',
'',
'    border: 1px solid #dcdcdc;',
'    border-radius: 6px;',
'    padding: 6px 0;',
'',
'    box-shadow: 0 8px 20px rgba(0,0,0,0.15);',
'',
unistr('    /* \D83D\DD12 COMPOSITING + ISOLATION */'),
'    isolation: isolate;',
'    transform: translate3d(0,0,0);',
'    backface-visibility: hidden;',
'    will-change: transform;',
'',
unistr('    /* \D83D\DD12 PREVENT BLENDING */'),
'    mix-blend-mode: normal;',
'    filter: none !important;',
'',
unistr('    /* \D83D\DD12 INTERACTION SAFETY */'),
'    pointer-events: auto;',
'}',
'',
'.chatCall-menuItem {',
'    display: block;',
'    width: 100%;',
'    padding: 8px 14px;',
'    background: transparent;',
'    border: 0;',
'    text-align: left;',
'    cursor: pointer;',
'}',
'',
'.chatCall-menuItem:hover {',
'    background: #f3f4f6;',
'}',
'',
'',
'.chatCall-moreDropdown {',
'    display: none;',
'}',
'',
'.chatCall-moreDropdown.is-visible {',
'    display: block;',
'}',
'',
'',
'/* ============================================================',
unistr('   CHAT CALL CARD \2014 CLEAN & MODERN'),
'   ============================================================ */',
'',
'.chatCall-wrapper {',
'    display: flex;',
'    justify-content: center;',
'    margin: 14px 0;',
'}',
'',
'.chatCall-wrapper.is-active .chatCall-card {',
'    border-color: #2563eb;',
'    box-shadow: 0 6px 22px rgba(37, 99, 235, 0.18);',
'}',
'',
'/* Card */',
'.chatCall-card {',
'    width: 100%;',
'    max-width: 920px;',
'    background: #ffffff;',
'    border: 1px solid #e5e7eb;',
'    border-radius: 14px;',
'    padding: 14px 16px 12px;',
'    transition: box-shadow 0.2s ease, border-color 0.2s ease;',
'}',
'',
'/* ============================================================',
'   HEADER',
'   ============================================================ */',
'',
'.chatCall-header {',
'    display: flex;',
'    align-items: center;',
'    gap: 10px;',
'    font-size: 13px;',
'    color: #4b5563;',
'    margin-bottom: 8px;',
'}',
'',
'/* Domain badge */',
'.chatCall-domainBadge {',
'    background: #eef2ff;',
'    color: #3730a3;',
'    font-weight: 600;',
'    font-size: 11px;',
'    padding: 3px 10px;',
'    border-radius: 999px;',
'}',
'',
'/* Time */',
'.chatCall-time {',
'    margin-left: auto;',
'    font-size: 11px;',
'    color: #6b7280;',
'    white-space: nowrap;',
'}',
'',
'/* ============================================================',
'   CONTENT',
'   ============================================================ */',
'',
'.chatCall-content {',
'    display: flex;',
'    flex-direction: column;',
'    gap: 6px;',
'    font-size: 14px;',
'    line-height: 1.55;',
'}',
'',
'/* User */',
'.chatCall-userText {',
'    color: #111827;',
'    font-weight: 600;',
'}',
'',
'/* Assistant */',
'.chatCall-assistantText {',
'    color: #1f2937;',
'    background: #f9fafb;',
'    padding: 10px 12px;',
'    border-radius: 10px;',
'}',
'',
'/* ============================================================',
'   METADATA',
'   ============================================================ */',
'',
'.chatCall-metadataToggle {',
'    margin-top: 8px;',
'    font-size: 12px;',
'    color: #2563eb;',
'    cursor: pointer;',
'    user-select: none;',
'}',
'',
'.chatCall-metadata {',
'    display: none;',
'    margin-top: 8px;',
'    padding-top: 8px;',
'    border-top: 1px dashed #e5e7eb;',
'    font-size: 12px;',
'    color: #374151;',
'}',
'',
'/* ============================================================',
unistr('   \22EE MENU BUTTON'),
'   ============================================================ */',
'',
'.chatCall-more {',
'    position: relative;',
'}',
'',
'.chatCall-moreBtn {',
'    cursor: pointer;',
'    font-size: 18px;',
'    line-height: 1;',
'    padding: 4px 6px;',
'    border-radius: 6px;',
'    color: #6b7280;',
'}',
'',
'.chatCall-moreBtn:hover {',
'    background: #f3f4f6;',
'    color: #111827;',
'}',
'',
'/* ============================================================',
unistr('   \22EE DROPDOWN MENU'),
'   ============================================================ */',
'',
'.chatCall-moreDropdown {',
'    display: none;',
'    position: fixed;',
'    z-index: 2147483647;',
'',
'    min-width: 180px;',
'    background: #ffffff;',
'    border: 1px solid #e5e7eb;',
'    border-radius: 10px;',
'    padding: 6px 0;',
'',
'    box-shadow:',
'        0 12px 28px rgba(0,0,0,0.12),',
'        0 2px 6px rgba(0,0,0,0.08);',
'}',
'',
'/* Visible state (controlled by JS) */',
'.chatCall-moreDropdown.is-visible {',
'    display: block;',
'}',
'',
'/* ============================================================',
'   MENU ITEMS',
'   ============================================================ */',
'',
'.chatCall-menuItem {',
'    width: 100%;',
'    padding: 9px 14px;',
'    border: 0;',
'    background: transparent;',
'    font-size: 13px;',
'    color: #111827;',
'    text-align: left;',
'    cursor: pointer;',
'    display: flex;',
'    align-items: center;',
'    gap: 10px;',
'}',
'',
'.chatCall-menuItem:hover {',
'    background: #f3f4f6;',
'}',
'',
'/* Danger action */',
'.chatCall-deleteBtn {',
'    color: #dc2626;',
'}',
'',
'.chatCall-deleteBtn:hover {',
'    background: #fee2e2;',
'}',
'',
'/* ============================================================',
'   ACCESSIBILITY',
'   ============================================================ */',
'',
'.chatCall-menuItem:focus-visible,',
'.chatCall-moreBtn:focus-visible {',
'    outline: 2px solid #2563eb;',
'    outline-offset: 2px;',
'}',
'',
'/* ============================================================',
'   MOBILE TWEAKS',
'   ============================================================ */',
'',
'@media (max-width: 640px) {',
'    .chatCall-card {',
'        border-radius: 12px;',
'        padding: 12px;',
'    }',
'',
'    .chatCall-domainBadge {',
'        max-width: 120px;',
'        overflow: hidden;',
'        text-overflow: ellipsis;',
'        white-space: nowrap;',
'    }',
'}'))
,p_step_template=>2526650495349772824
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(151726325874589520)
,p_plug_name=>'dlg-Call-Rating'
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>150
,p_plug_display_point=>'REGION_POSITION_04'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(155687807448186614)
,p_plug_name=>'dlg-Move-Session'
,p_title=>'Move Session'
,p_region_name=>'moveSessionRegionId'
,p_region_template_options=>'#DEFAULT#:js-dialog-autoheight:js-dialog-size480x320'
,p_region_attributes=>'data-parent-element="#btnNewSession"'
,p_plug_template=>2672673746673652531
,p_plug_display_sequence=>140
,p_plug_display_point=>'REGION_POSITION_04'
,p_location=>null
,p_plug_source=>' '
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(155691286455186648)
,p_plug_name=>'MAIN CONTAINER'
,p_title=>'AI Assistant'
,p_icon_css_classes=>'fa-ai-sparkle-enlarge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>50
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div id="chatWindow" class="chat-window"></div>',
'',
'<button id="loadMoreBtn" style="',
'    display:none;',
'    margin: 10px auto;',
'    padding: 8px 18px;',
'    border-radius: 8px;',
'    border: 1px solid #ccc;',
'    background: #fff;',
'">Load More</button>',
'',
'<div id="typingIndicator" class="typing-indicator" style="display:none;">',
'    <span class="dot"></span><span class="dot"></span><span class="dot"></span>',
'</div>',
' ',
'<!-- Session-Level Actions -->',
'<div id="session-actions" style="position: absolute; top: 16px; right: 16px;">',
'    <div class="more-menu-container">',
'        <button class="action-btn session-more-btn" title="Session options" style="',
'            width: 36px;',
'            height: 36px;',
'            border: 1px solid #e2e8f0;',
'            border-radius: 8px;',
'            background: white;',
'            color: #64748b;',
'            cursor: pointer;',
'        ">',
'            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">',
'                <circle cx="12" cy="12" r="1"></circle>',
'                <circle cx="19" cy="12" r="1"></circle>',
'                <circle cx="5" cy="12" r="1"></circle>',
'            </svg>',
'        </button>',
'        <div class="more-menu session-more-menu" style="display: none; right: 0; left: auto;">',
'            <button class="more-menu-item report-session-issue-btn">',
'                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">',
'                    <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path>',
'                    <line x1="12" y1="9" x2="12" y2="13"></line>',
'                    <line x1="12" y1="17" x2="12.01" y2="17"></line>',
'                </svg>',
'                Report Session Issue',
'            </button>',
'            <button class="more-menu-item export-session-btn">',
'                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">',
'                    <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path>',
'                    <polyline points="7 10 12 15 17 10"></polyline>',
'                    <line x1="12" y1="15" x2="12" y2="3"></line>',
'                </svg>',
'                Export Conversation',
'            </button>',
'            <button class="more-menu-item clear-session-btn">',
'                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">',
'                    <polyline points="3 6 5 6 21 6"></polyline>',
'                    <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path>',
'                </svg>',
'                Clear Session',
'            </button>',
'        </div>',
'    </div>',
' ',
'</div>'))
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(297380456515313363)
,p_plug_name=>'Classifier'
,p_title=>'...'
,p_region_name=>'cxd_classifier'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:t-Region--hideShowIconsMath:is-collapsed:t-Region--noUI:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>70
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(299892034523071248)
,p_plug_name=>'Left_Side'
,p_region_name=>'myProjectsTreeStaticID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_plug_display_point=>'REGION_POSITION_02'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(300461147415765424)
,p_plug_name=>'MyProjectsTree'
,p_title=>'Projects'
,p_region_name=>'myProjectsTreeStaticID'
,p_parent_plug_id=>wwv_flow_imp.id(299892034523071248)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    LEVEL                                             AS tree_level,',
'    ',
'    -- Required by APEX Tree Region',
'     item_id                      AS node_id,',
'    parent_id                                         AS parent_node_id,',
unistr('    DECODE(item_type, ''PROJECT'',''\D83D\DCC1 '',''\D83D\DCAC '') '),
'        || item_title                                AS node_label,',
'    item_type||''|'' || item_id  || ''|''  || parent_id AS Node_Value_Column, --Workaround to get nodeIds',
'    -- Optional but useful for APEX config',
'    item_type                                         AS node_type,',
'    item_title                                        AS title,',
'    created_at                                        AS created_at,',
'    last_activity                                     AS last_activity,',
'    session_count                                     AS session_count,',
'    token_total                                       AS token_total,',
'    token_cost                                        AS token_cost,',
'',
'    -- For ordering inside tree',
'    created_at                                        AS order_value,',
'',
'    -- Optional icon class if needed',
'    CASE ',
'        WHEN item_type = ''PROJECT'' THEN ''icon-tree-folder''',
'        ELSE ''icon-tree-file''',
'    END                                               AS icon_css',
'',
'FROM (',
'    ----------------------------------------------------------------------',
'    -- Level 1: Projects',
'    ----------------------------------------------------------------------',
'    SELECT ',
'        ''PROJECT''                AS item_type,',
'        cp.CHAT_PROJECT_ID       AS item_id,',
'        NULL                     AS parent_id,',
'        cp.PROJECT_NAME          AS item_title,',
'        cp.IS_ACTIVE             AS is_active,',
'        cp.CREATED_AT            AS created_at,',
'        NULL                     AS last_activity,',
'        (SELECT COUNT(*) ',
'         FROM CHAT_SESSIONS cs2',
'         WHERE cs2.CHAT_PROJECT_ID = cp.CHAT_PROJECT_ID',
'           AND cs2.IS_ACTIVE = ''Y'') AS session_count,',
'        NULL                     AS token_total,',
'        NULL                     AS token_cost',
'    FROM CHAT_PROJECTS cp',
'    WHERE cp.IS_ACTIVE = ''Y''',
'    ',
'    UNION ALL',
'',
'    ----------------------------------------------------------------------',
'    -- Level 2: Sessions',
'    ----------------------------------------------------------------------',
'    SELECT',
'        ''SESSION''                AS item_type,',
'        cs.SESSION_ID            AS item_id,',
'        cs.CHAT_PROJECT_ID       AS parent_id,',
'        NVL(cs.SESSION_TITLE, ''Untitled Session'') AS item_title,',
'        cs.IS_ACTIVE             AS is_active,',
'        cs.CREATED_DATE          AS created_at,',
'        cs.LAST_ACTIVITY_DATE    AS last_activity,',
'        NULL                     AS session_count,',
'        cs.TOKENS_TOTAL          AS token_total,',
'        cs.TOKENS_TOTAL_COST     AS token_cost',
'    FROM CHAT_SESSIONS cs',
'    WHERE cs.IS_ACTIVE = ''Y''',
'      AND cs.CHAT_PROJECT_ID IS NOT NULL',
')',
'START WITH parent_id IS NULL',
'CONNECT BY PRIOR item_id = parent_id',
'ORDER SIBLINGS BY created_at DESC;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_JSTREE'
,p_ajax_items_to_submit=>'P114_ISSUE_LEVEL'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'activate_node_link_with', 'S',
  'default_icon_css_class', 'icon-tree-folder',
  'icon_css_class_column', 'ICON_CSS',
  'node_id_column', 'NODE_ID',
  'node_label_column', 'NODE_LABEL',
  'node_value_column', 'NODE_VALUE_COLUMN',
  'order_siblings_by', 'ORDER_VALUE',
  'parent_key_column', 'PARENT_NODE_ID',
  'selected_node_page_item', 'P114_ISSUE_LEVEL',
  'start_tree_with', 'NULL',
  'tooltip_column', 'NODE_ID',
  'tree_hierarchy', 'SQL',
  'tree_link', 'javascript:void(0);',
  'tree_tooltip', 'DB')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(301801575118221150)
,p_plug_name=>'Session&Project Actions'
,p_parent_plug_id=>wwv_flow_imp.id(299892034523071248)
,p_region_css_classes=>'sidebar-actions'
,p_region_template_options=>'#DEFAULT#:t-ButtonRegion--noUI'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>10
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(300501172210850030)
,p_name=>'myActiveSession'
,p_region_name=>'myActiveSessionStaticID'
,p_template=>3371237801798025892
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'select   :P114_CHAT_SESSION_ID CHAT_SESSION_ID ,',
'         :P114_CHAT_PROJECT_ID  CHAT_PROJECT_ID ,',
'         :P114_CHAT_PROJECT_TITLE CHAT_PROJECT_TITLE,',
'         :P114_SESSION_TITLE CHAT_SESSION_TITLE,',
'         ''SESSION'' as ISSUE_LEVEL,--link to page116',
'         :P114_CHAT_SESSION_ID as  ENTITY_ID --link to page116',
'from dual ',
'where :P114_CHAT_SESSION_ID is not null;',
'',
'',
''))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P114_CHAT_SESSION_ID,P114_CHAT_PROJECT_ID,P114_NEW_CHAT_PROJECT_TITLE,P114_SESSION_TITLE'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(149338202911536075)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151667862254556198)
,p_query_column_id=>1
,p_column_alias=>'CHAT_SESSION_ID'
,p_column_display_sequence=>20
,p_column_heading=>'Chat Session Id'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151668211942556199)
,p_query_column_id=>2
,p_column_alias=>'CHAT_PROJECT_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Chat Project Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151668657445556200)
,p_query_column_id=>3
,p_column_alias=>'CHAT_PROJECT_TITLE'
,p_column_display_sequence=>30
,p_column_heading=>'Chat Project Title'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151669045823556201)
,p_query_column_id=>4
,p_column_alias=>'CHAT_SESSION_TITLE'
,p_column_display_sequence=>40
,p_column_heading=>'Chat Session Title'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151669458452556202)
,p_query_column_id=>5
,p_column_alias=>'ISSUE_LEVEL'
,p_column_display_sequence=>50
,p_column_heading=>'Issue Level'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151669883169556203)
,p_query_column_id=>6
,p_column_alias=>'ENTITY_ID'
,p_column_display_sequence=>60
,p_column_heading=>'Entity Id'
,p_heading_alignment=>'LEFT'
,p_disable_sort_column=>'N'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(301798403176221119)
,p_plug_name=>'dlg-New Project'
,p_title=>'New Project'
,p_region_name=>'new_project_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
,p_region_attributes=>'data-parent-element="#btnNewProject"'
,p_plug_template=>2672673746673652531
,p_plug_display_sequence=>120
,p_plug_display_point=>'REGION_POSITION_04'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(301798572574221120)
,p_plug_name=>'dlg-New-Session'
,p_title=>'New Session'
,p_region_name=>'new_session_dialog'
,p_region_template_options=>'#DEFAULT#:js-dialog-size600x400'
,p_region_attributes=>'data-parent-element="#btnNewSession"'
,p_plug_template=>2672673746673652531
,p_plug_display_sequence=>130
,p_plug_display_point=>'REGION_POSITION_04'
,p_location=>null
,p_plug_source=>' '
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(301843113611557821)
,p_name=>'LLM Calls'
,p_region_name=>'ChatCallsStaticId'
,p_template=>4501440665235496320
,p_display_sequence=>20
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT  ',
'       -- Core Identifiers',
'       c.call_id,',
'       c.call_seq  ,',
'       ''USER'' MESSAGE_ROLE, ',
'       -- Content',
'       c.user_prompt,',
'       c.response_text ,',
'    -- Escaped for JavaScript',
'       REPLACE(REPLACE(c.response_text, ''"'', ''\"''), CHR(10), ''\n'') AS response_escaped,',
'       LENGTH(c.response_text) AS content_length,',
'       -- Token Usage',
'       NVL(c.tokens_total, 0)  AS tokens_total,',
'       NVL(c.tokens_input, 0)  AS tokens_input,',
'       NVL(c.tokens_output, 0) AS tokens_output,',
' ',
'       NVL(c.cost_usd, 0)      AS tokens_cost,',
'',
'       -- Performance Metrics',
'       NVL(c.total_pipeline_ms, 0) AS processing_time_ms,',
'',
'       -- RAG Context',
'       NVL(c.rag_context_doc_count, 0) AS rag_doc_count,',
'        ',
unistr('       CASE WHEN parent_chat_call_id IS NOT NULL THEN ''\21BB REGENERATED'''),
'        ELSE NULL',
'       END AS REGEN_TEXT,',
'     ',
'       CASE  WHEN TRUNC(c.db_created_at) = TRUNC(SYSDATE)',
'            THEN TO_CHAR(c.db_created_at, ''HH24:MI'')',
'        ELSE  TO_CHAR(c.db_created_at, ''YYYY-MM-DD HH24:MI'')',
'        END AS DISPLAY_DATE,',
'',
'       TO_CHAR(c.db_created_at, ''HH24:MI'')               AS message_time,',
'       TO_CHAR(c.db_created_at, ''YYYY-MM-DD HH24:MI:SS'') AS full_timestamp,',
'       TO_CHAR(c.db_created_at, ''Mon DD, YYYY'')          AS message_date,',
' ',
'       -- User Rating',
'       c.user_rating,',
'       c.user_rating_comment,',
'       c.user_rating_ts,',
'',
'       CASE c.USER_RATING',
unistr('            WHEN ''LIKE'' THEN ''\D83D\DC4D'''),
unistr('            WHEN ''DISLIKE'' THEN ''\D83D\DC4E'''),
unistr('            WHEN ''NEUTRAL'' THEN ''\D83D\DE10'''),
unistr('            WHEN ''EXCELLENT'' THEN ''\2B50'''),
'            ELSE ''''',
'        END AS RATING_ICON,',
' ',
'       CASE WHEN c.user_rating = ''LIKE''    THEN ''active'' ELSE '''' END AS rate_like_active,',
'       CASE WHEN c.user_rating = ''DISLIKE'' THEN ''active'' ELSE '''' END AS rate_dislike_active,',
'',
'       -- Deletion Flag',
'       NVL(c.is_deleted, ''N'') AS is_deleted,',
'',
'       -- Context Domain',
'       COALESCE(d.domain_name, ''GENERAL'') AS context_domain_name,',
'',
'       -- Parent Call (regeneration)',
'       pr.parent_chat_call_id,',
'       pc.response_text AS parent_message_content,',
'       pc.message_role  AS parent_message_role ',
' ',
' ',
'   ',
'FROM chat_calls c',
'',
'     -- Domain lookup',
'     LEFT JOIN context_domains d   ON d.context_domain_id = c.context_domain_id',
'',
'     -- Regeneration Link',
'     LEFT JOIN chat_call_regenerations pr',
'         ON pr.child_chat_call_id = c.call_id',
'',
'     -- Parent call details',
'     LEFT JOIN chat_calls pc',
'         ON pc.call_id = pr.parent_chat_call_id',
'',
'WHERE c.chat_session_id = :P114_CHAT_SESSION_ID --acive session',
' -- AND NVL(c.is_deleted, ''N'') = ''N''',
'     ',
'ORDER BY c.call_seq Asc;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P114_CHAT_SESSION_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(151729740325745780)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151680050806556232)
,p_query_column_id=>1
,p_column_alias=>'CALL_ID'
,p_column_display_sequence=>220
,p_column_heading=>'Call Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(150189180214001750)
,p_query_column_id=>2
,p_column_alias=>'CALL_SEQ'
,p_column_display_sequence=>280
,p_column_heading=>'Call Seq'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151724655461589503)
,p_query_column_id=>3
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>310
,p_column_heading=>'Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151680407164556233)
,p_query_column_id=>4
,p_column_alias=>'USER_PROMPT'
,p_column_display_sequence=>60
,p_column_heading=>'User Prompt'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151724441177589501)
,p_query_column_id=>5
,p_column_alias=>'RESPONSE_TEXT'
,p_column_display_sequence=>90
,p_column_heading=>'Response Text'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151724591892589502)
,p_query_column_id=>6
,p_column_alias=>'RESPONSE_ESCAPED'
,p_column_display_sequence=>300
,p_column_heading=>'Response Escaped'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151679650324556231)
,p_query_column_id=>7
,p_column_alias=>'CONTENT_LENGTH'
,p_column_display_sequence=>210
,p_column_heading=>'Content Length'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151726177473589518)
,p_query_column_id=>8
,p_column_alias=>'TOKENS_TOTAL'
,p_column_display_sequence=>340
,p_column_heading=>'Tokens Total'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151672808081556212)
,p_query_column_id=>9
,p_column_alias=>'TOKENS_INPUT'
,p_column_display_sequence=>70
,p_column_heading=>'Tokens Input'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151673297786556213)
,p_query_column_id=>10
,p_column_alias=>'TOKENS_OUTPUT'
,p_column_display_sequence=>80
,p_column_heading=>'Tokens Output'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151673662112556214)
,p_query_column_id=>11
,p_column_alias=>'TOKENS_COST'
,p_column_display_sequence=>100
,p_column_heading=>'Tokens Cost'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151674034883556216)
,p_query_column_id=>12
,p_column_alias=>'PROCESSING_TIME_MS'
,p_column_display_sequence=>110
,p_column_heading=>'Processing Time Ms'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151674404529556217)
,p_query_column_id=>13
,p_column_alias=>'RAG_DOC_COUNT'
,p_column_display_sequence=>120
,p_column_heading=>'Rag Doc Count'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151726052149589517)
,p_query_column_id=>14
,p_column_alias=>'REGEN_TEXT'
,p_column_display_sequence=>330
,p_column_heading=>'Regen Text'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151725668453589513)
,p_query_column_id=>15
,p_column_alias=>'DISPLAY_DATE'
,p_column_display_sequence=>320
,p_column_heading=>'Display Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151674827200556218)
,p_query_column_id=>16
,p_column_alias=>'MESSAGE_TIME'
,p_column_display_sequence=>130
,p_column_heading=>'Message Time'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151675294520556219)
,p_query_column_id=>17
,p_column_alias=>'FULL_TIMESTAMP'
,p_column_display_sequence=>140
,p_column_heading=>'Full Timestamp'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151675677166556220)
,p_query_column_id=>18
,p_column_alias=>'MESSAGE_DATE'
,p_column_display_sequence=>150
,p_column_heading=>'Message Date'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151676009115556221)
,p_query_column_id=>19
,p_column_alias=>'USER_RATING'
,p_column_display_sequence=>160
,p_column_heading=>'User Rating'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151680809541556234)
,p_query_column_id=>20
,p_column_alias=>'USER_RATING_COMMENT'
,p_column_display_sequence=>230
,p_column_heading=>'User Rating Comment'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151681206128556236)
,p_query_column_id=>21
,p_column_alias=>'USER_RATING_TS'
,p_column_display_sequence=>240
,p_column_heading=>'User Rating Ts'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151726230010589519)
,p_query_column_id=>22
,p_column_alias=>'RATING_ICON'
,p_column_display_sequence=>350
,p_column_heading=>'Rating Icon'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151681614177556237)
,p_query_column_id=>23
,p_column_alias=>'RATE_LIKE_ACTIVE'
,p_column_display_sequence=>250
,p_column_heading=>'Rate Like Active'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151682037082556238)
,p_query_column_id=>24
,p_column_alias=>'RATE_DISLIKE_ACTIVE'
,p_column_display_sequence=>260
,p_column_heading=>'Rate Dislike Active'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151676418536556222)
,p_query_column_id=>25
,p_column_alias=>'IS_DELETED'
,p_column_display_sequence=>170
,p_column_heading=>'Is Deleted'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151676860914556224)
,p_query_column_id=>26
,p_column_alias=>'CONTEXT_DOMAIN_NAME'
,p_column_display_sequence=>180
,p_column_heading=>'Context Domain Name'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151682471630556239)
,p_query_column_id=>27
,p_column_alias=>'PARENT_CHAT_CALL_ID'
,p_column_display_sequence=>270
,p_column_heading=>'Parent Chat Call Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151677673439556226)
,p_query_column_id=>28
,p_column_alias=>'PARENT_MESSAGE_CONTENT'
,p_column_display_sequence=>200
,p_column_heading=>'Parent Message Content'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(151677209072556225)
,p_query_column_id=>29
,p_column_alias=>'PARENT_MESSAGE_ROLE'
,p_column_display_sequence=>190
,p_column_heading=>'Parent Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(441655286029646467)
,p_plug_name=>'MAIN CONTAINER'
,p_title=>'AI Assistant'
,p_region_name=>'AI_CHAT_CONTAINER'
,p_icon_css_classes=>'fa-ai-sparkle-enlarge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>40
,p_location=>null
,p_plug_source=>' '
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(151725297394589509)
,p_plug_name=>'chatCall-scrollBtn'
,p_region_name=>'chatCall-scrollBtn'
,p_parent_plug_id=>wwv_flow_imp.id(441655286029646467)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>unistr('<button class="chatCall-scrollBtn">\2193 Latest</button>')
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(443085855512063584)
,p_plug_name=>'chatPrompt'
,p_region_name=>'chatPrompt'
,p_parent_plug_id=>wwv_flow_imp.id(441655286029646467)
,p_region_css_classes=>'chatPrompt-wrapper'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>' '
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(443084908686063575)
,p_plug_name=>'Settings Panel'
,p_region_template_options=>'#DEFAULT#:js-dialog-class-t-Drawer--pullOutEnd'
,p_plug_template=>1660973136434625155
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_03'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="settings-panel">',
'    <label>Temperature</label>',
'    <input type="number" id="temperature" value="0.7" step="0.1" min="0" max="2">',
'',
'    <label>Max Tokens</label>',
'    <input type="number" id="maxTokens" value="512" min="1">',
'',
'    <label>Top P</label>',
'    <input type="number" id="topP" value="1" step="0.01" min="0" max="1">',
'',
'    <label>Model</label>',
'    <select id="modelSelect"></select>',
'</div>',
''))
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(443085927550063585)
,p_plug_name=>'Right Panel'
,p_region_name=>'rightPanel'
,p_region_css_classes=>'chatRightPanel'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(151727682637589533)
,p_plug_name=>'darkModeToggle'
,p_parent_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<button id="darkModeToggle" class="darkmode-toggle-btn" type="button">',
unistr('    \D83C\DF19'),
'</button>'))
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(443086551263063591)
,p_plug_name=>'JS Loader'
,p_region_name=>'chatScripts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>60
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151666248908556190)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(301801575118221150)
,p_button_name=>'BTN_NEW_PROJECT'
,p_button_static_id=>'btnNewProject'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--primary:t-Button--iconLeft:t-Button--stretch'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'New Project'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-folder-plus'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151689139194556264)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(443084908686063575)
,p_button_name=>'BTN_SETTINGS'
,p_button_static_id=>'btnSettings'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\2699 Settings')
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151725865728589515)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(299892034523071248)
,p_button_name=>'projectPanelToggle'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\2630 Sessions')
,p_button_css_classes=>'chatLeftPanel-toggleBtn'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151666668812556192)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(301801575118221150)
,p_button_name=>'BTN_NEW_SESSION'
,p_button_static_id=>'btnNewSession'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft:t-Button--stretch'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Chat'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-comments'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151689593540556265)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(443084908686063575)
,p_button_name=>'BTN_CLOSE_SETTINGS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'  Close Settings'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151724868627589505)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(443085855512063584)
,p_button_name=>'SEND'
,p_button_static_id=>'sendBtn'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Send'
,p_warn_on_unsaved_changes=>null
,p_button_css_classes=>'chatPrompt-sendBtn'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151725791213589514)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_button_name=>'rightPanelToggle'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\2699\FE0F Parameters')
,p_button_css_classes=>'chatRightPanel-toggleBtn'
,p_button_comment=>'appears only on small screens'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(155688145084186617)
,p_button_sequence=>30
,p_button_plug_id=>wwv_flow_imp.id(155687807448186614)
,p_button_name=>'Cancel-dlg-Move-Session'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-times'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151726864927589525)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(151726325874589520)
,p_button_name=>'Close-Call-Rating-dlg'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'CLOSE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(155688052284186616)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(155687807448186614)
,p_button_name=>'Save-dlg-Move-Session'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-save'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151683235799556242)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(301798403176221119)
,p_button_name=>'Create-dlg-New-Project'
,p_button_static_id=>'SaveNewProjStaticId'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Project'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151685365208556249)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(301798572574221120)
,p_button_name=>'create-dlg-New-Session'
,p_button_static_id=>'SaveNewSessionStaticId'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create Session'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151726736642589524)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(151726325874589520)
,p_button_name=>'Save-Call-Rating-dlg'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Save'
,p_button_position=>'CREATE'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151683646737556243)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(301798403176221119)
,p_button_name=>'Close-dlg-New-Project'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(151685714152556250)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(301798572574221120)
,p_button_name=>'Close-dlg-New-Session'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Cancel'
,p_button_position=>'PREVIOUS'
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151724720828589504)
,p_name=>'P114_USER_PROMPT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(443085855512063584)
,p_placeholder=>'Ask me !!'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_tag_css_classes=>'chatUserPrompt chatPrompt-input'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151726401739589521)
,p_name=>'P114_CALL_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(151726325874589520)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151726564345589522)
,p_name=>'P114_RATING'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(151726325874589520)
,p_prompt=>'Rating'
,p_display_as=>'NATIVE_RADIOGROUP'
,p_lov=>unistr('STATIC:\2B50 Excellent;EXCELLENT,\D83D\DC4D Like;LIKE, \D83D\DE10 Neutral;NEUTRAL,\D83D\DC4E Dislike;DISLIKE')
,p_lov_display_null=>'YES'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_of_columns', '1',
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(151726696369589523)
,p_name=>'P114_COMMENT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(151726325874589520)
,p_prompt=>'Comment'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
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
 p_id=>wwv_flow_imp.id(155687913814186615)
,p_name=>'P114_MOVE_SESSION_PROJECT_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(155687807448186614)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   PROJECT_NAME ,',
'      CHAT_PROJECT_ID',
'       ',
'from   CHAT_PROJECTS   a',
'where   OWNER_USER_ID  = v(''G_USER_ID'')',
'AND IS_DELETED=''N'' ',
'AND IS_ACTIVE=''Y'';',
'-- and TENANT_ID, ',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(297379960993313387)
,p_name=>'P114_SESSION_TITLE'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Session Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(297381609994313403)
,p_name=>'P114_CXD_TRACE_ID'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Trace Id'
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
 p_id=>wwv_flow_imp.id(297381668510313404)
,p_name=>'P114_CXD_DETECTION_METHOD_CODE'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Detection Method'
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
 p_id=>wwv_flow_imp.id(297381834670313406)
,p_name=>'P114_CXD_FINAL_DETECTION_METHOD_CODE'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Final Detection Method'
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
 p_id=>wwv_flow_imp.id(299331387913666557)
,p_name=>'P114_CXD_CONTEXT_DOMAIN_ID'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Domain ID'
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
 p_id=>wwv_flow_imp.id(299331497995666558)
,p_name=>'P114_CXD_CONTEXT_DOMAIN_CODE'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Context Domain'
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
 p_id=>wwv_flow_imp.id(299331573359666559)
,p_name=>'P114_CXD_CONTEXT_DOMAIN_NAME'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Context Domain Name'
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
 p_id=>wwv_flow_imp.id(299331679733666560)
,p_name=>'P114_CXD_CONTEXT_DOMAIN_CONFIDENCE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Confidence'
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
 p_id=>wwv_flow_imp.id(299331816253666561)
,p_name=>'P114_CXD_DETECT_STATUS'
,p_item_sequence=>160
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Status'
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
 p_id=>wwv_flow_imp.id(299331880563666562)
,p_name=>'P114_CXD_MESSAGE'
,p_item_sequence=>170
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Message'
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
 p_id=>wwv_flow_imp.id(299331965895666563)
,p_name=>'P114_CXD_SEARCH_TIME_MS'
,p_item_sequence=>180
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Time (ms)'
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
 p_id=>wwv_flow_imp.id(299332037954666564)
,p_name=>'P114_CXD_USED_PROVIDER'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Provider(if LLM used)'
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
 p_id=>wwv_flow_imp.id(299332188345666565)
,p_name=>'P114_CXD_USED_MODEL'
,p_item_sequence=>150
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Model(if LLM used)'
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
 p_id=>wwv_flow_imp.id(299335955306666603)
,p_name=>'P114_REPORT_ISSUE_URL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Report Issue Url'
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
 p_id=>wwv_flow_imp.id(299892755045071284)
,p_name=>'P114_CHAT_PROJECT_ID'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Project Id'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300400855252857922)
,p_name=>'P114_SELECTED_PROJECT_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(299892034523071248)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300463293930765474)
,p_name=>'P114_CHAT_PROJECT_TITLE'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Chat Project Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300514525736850135)
,p_name=>'P114_ISSUE_LEVEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(300501172210850030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(300514675176850136)
,p_name=>'P114_ENTITY_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(300501172210850030)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301823940639221247)
,p_name=>'P114_NEW_CHAT_PROJECT_TITLE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(301798403176221119)
,p_prompt=>'Project Name'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>60
,p_cMaxlength=>200
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301826511310221272)
,p_name=>'P114_CHAT_PROJECT_INSTRUCTIONS'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(301798403176221119)
,p_prompt=>'Instructions (Optional)'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>60
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301826547800221273)
,p_name=>'P114_CHAT_PROJECT_DESCRIPTION'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(301798403176221119)
,p_prompt=>'Description  (Optional)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301826642353221259)
,p_name=>'P114_NEW_SESSION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(301798572574221120)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301826736370221260)
,p_name=>'P114_NEW_SESSION_TITLE'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(301798572574221120)
,p_prompt=>'Title'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(301827025748221263)
,p_name=>'P114_NEW_SESSION_PROJECT_ID'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(301798572574221120)
,p_prompt=>'Project'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
' select   PROJECT_NAME ,',
'      CHAT_PROJECT_ID',
'       ',
'from   CHAT_PROJECTS   a',
'where   OWNER_USER_ID  = v(''G_USER_ID'')',
'AND IS_DELETED=''N'' ',
'AND IS_ACTIVE=''Y'';',
'-- and TENANT_ID, ',
''))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441663712820646569)
,p_name=>'P114_CHAT_SESSION_ID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(297380456515313363)
,p_prompt=>'Chat Session (Id)'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441690195456646663)
,p_name=>'P114_PROVIDER'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'OPENAI'
,p_prompt=>'Provider'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT provider_name  AS display_value,',
'       provider_code  AS return_value',
'FROM   llm_providers',
'WHERE  is_active = ''Y''',
'ORDER BY display_order;'))
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441690298361646664)
,p_name=>'P114_MODEL'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_prompt=>'Model'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT model_name AS display_value,',
'       model_code AS return_value',
'FROM   llm_provider_models',
'WHERE  is_active = ''Y''',
'  AND provider_code = :P114_PROVIDER',
'ORDER BY display_order;'))
,p_lov_cascade_parent_items=>'P114_PROVIDER'
,p_ajax_items_to_submit=>'P114_PROVIDER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441691722568646671)
,p_name=>'P114_STREAM_CHANNEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(441655286029646467)
,p_item_default=>'APEX$CHAT110'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441691793516646672)
,p_name=>'P114_TYPING_FLAG'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(441655286029646467)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441692918592646691)
,p_name=>'P114_STREAM_ENABLED'
,p_item_sequence=>120
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'Y'
,p_prompt=>'Stream Enabled'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(441693079394646692)
,p_name=>'P114_APP_SESSION_ID'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'APP_SESSION'
,p_item_default_type=>'ITEM'
,p_prompt=>'App Session Id'
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
 p_id=>wwv_flow_imp.id(441693114093646693)
,p_name=>'P114_CONTEXT_DOMAIN_ID'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_prompt=>'Context Domain'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_named_lov=>'CONTEXT_DOMAINS(ID)'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443118757145063760)
,p_name=>'P114_TEMPERATURE'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'0.7'
,p_prompt=>'Temperature'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '2',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443118833612063761)
,p_name=>'P114_TOP_P'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'0.7'
,p_prompt=>'Top P'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '1',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443118982150063762)
,p_name=>'P114_MAX_TOKENS'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'4096'
,p_prompt=>'Max Tokens'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443119065440063763)
,p_name=>'P114_TOP_K'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_prompt=>'Top K'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443120180908063767)
,p_name=>'P114_CHAT_HISTORY_JSON'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(441655286029646467)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(443123862971063785)
,p_name=>'P114_JSON_MODE'
,p_item_sequence=>130
,p_item_plug_id=>wwv_flow_imp.id(443085927550063585)
,p_item_default=>'Y'
,p_prompt=>'Json Mode'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(151727572155589532)
,p_validation_name=>'ProjectNameNotEmpty'
,p_validation_sequence=>10
,p_validation=>':P114_NEW_CHAT_PROJECT_TITLE IS NOT NULL'
,p_validation2=>'PLSQL'
,p_validation_type=>'EXPRESSION'
,p_error_message=>'Project should have a name!'
,p_when_button_pressed=>wwv_flow_imp.id(151683235799556242)
,p_associated_item=>wwv_flow_imp.id(301823940639221247)
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151702503475556320)
,p_name=>'init Page'
,p_event_sequence=>20
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151703581379556324)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'init session'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P114_CHAT_SESSION_ID     :=null;',
':P114_SELECTED_PROJECT_ID :=null;',
':P114_SESSION_TITLE       :=null;  ',
':P114_CXD_TRACE_ID        :=null;',
':P114_CONTEXT_DOMAIN_ID   :=NULL;',
'',
' ',
'',
'   --  APEX_UTIL.SET_SESSION_STATE(''P114_CHAT_SESSION_ID'', :P114_CHAT_SESSION_ID );',
' --   APEX_UTIL.SET_SESSION_STATE(''P114_SELECTED_PROJECT_ID'', :P114_SELECTED_PROJECT_ID );',
'',
'',
'  :P114_CXD_TRACE_ID := null;',
'  :P114_CXD_DETECTION_METHOD_CODE := null;',
'  :P114_CXD_CONTEXT_DOMAIN_ID:= null;',
'  :P114_CXD_CONTEXT_DOMAIN_CODE := null;',
'  :P114_CXD_CONTEXT_DOMAIN_NAME:= null;',
'  :P114_CXD_CONTEXT_DOMAIN_CONFIDENCE:= null;',
'  :P114_CXD_DETECT_STATUS:= null;',
'  :P114_CXD_MESSAGE:= null;',
'  :P114_CXD_SEARCH_TIME_MS:= null;',
'  :P114_CXD_USED_PROVIDER:= null;',
'  :P114_CXD_USED_MODEL:= null;',
'  :P114_CONTEXT_DOMAIN_ID := null;',
'  :P114_CXD_FINAL_DETECTION_METHOD_CODE:= null;',
''))
,p_attribute_02=>'P114_CHAT_SESSION_ID'
,p_attribute_03=>'P114_CHAT_SESSION_ID,P114_SESSION_TITLE'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151704093404556325)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'DisableBtns'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const sid = $v("P114_CHAT_SESSION_ID");',
'',
'if (!sid || sid === "") {',
unistr('    console.log("\D83D\DEAB No session detected \2192 disabling header buttons");'),
'    SessionHeader.disableButtons();   // FIXED',
'} else {',
unistr('    console.log("\D83D\DFE2 Session active \2192 enabling header buttons");'),
'    SessionHeader.enableButtons();    // FIXED',
'}'))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151704597800556326)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_name=>'init Model'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P114_MODEL is not null then',
'',
'select  ',
'       DEFAULT_TEMPERATURE,',
'       DEFAULT_TOP_P,',
'       DEFAULT_TOP_K,',
'       MAX_OUTPUT_TOKENS,',
'       SUPPORTS_STREAMING',
'      /* ,',
'          CONTEXT_WINDOW_TOKENS,',
'       SUPPORTS_FUNCTION_CALLING,',
'       SUPPORTS_VISION,',
'       SUPPORTS_JSON_MODE,',
'       DEFAULT_FREQUENCY_PENALTY,',
'       DEFAULT_PRESENCE_PENALTY ,',
'       RATE_LIMIT_RPM,',
'       RATE_LIMIT_TPM,',
'       EMBEDDING_DIMENSIONS,',
'        IS_DEFAULT,',
'       IS_ACTIVE,',
'       IS_EMBEDDING_MODE */',
'    into :P114_TEMPERATURE,',
'    :P114_TOP_P,',
'    :P114_TOP_K,',
'    :P114_MAX_TOKENS,',
'    :P114_STREAM_ENABLED',
'',
'from "LLM_PROVIDER_MODELS" a',
'where  MODEL_CODE =:P114_MODEL ;',
'',
'end if;',
''))
,p_attribute_02=>'P114_ISSUE_LEVEL'
,p_attribute_03=>'P114_ISSUE_LEVEL'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151705008784556328)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_name=>'Create Default Project if Not Exists'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
':P114_CHAT_PROJECT_ID := CHAT_PROJECTS_PKG.default_handling(p_user_id=>v(''G_USER_ID'') );',
':P114_SELECTED_PROJECT_ID :=  :P114_CHAT_PROJECT_ID ;',
'',
' APEX_UTIL.SET_SESSION_STATE(''P114_CHAT_PROJECT_ID'',:P114_CHAT_PROJECT_ID );',
' APEX_UTIL.SET_SESSION_STATE(''P114_SELECTED_PROJECT_ID'',:P114_CHAT_PROJECT_ID );'))
,p_attribute_03=>'P114_CHAT_PROJECT_ID,P114_SELECTED_PROJECT_ID'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151705591109556330)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_name=>'Refresh project after adding Default Project'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300461147415765424)
,p_attribute_01=>'N'
,p_server_condition_type=>'FUNCTION_BODY'
,p_server_condition_expr1=>'return Not CHAT_PROJECTS_PKG.is_default_exists(p_user_id=>v(''G_USER_ID'')) ;'
,p_server_condition_expr2=>'PLSQL'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151706077961556331)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300501172210850030)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151706503134556332)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>80
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const container = document.getElementById(''ChatCallsStaticId'');',
'console.log(''Container:'', container);',
'console.log(''ScrollHeight:'', container.scrollHeight);'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151703015089556323)
,p_event_id=>wwv_flow_imp.id(151702503475556320)
,p_event_result=>'TRUE'
,p_action_sequence=>90
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('console.log("\D83D\DE80 Page 115 Execute When Page Loads...");'),
'',
'// ---------------------------------------------------------------------',
'// Resolve APEX Application Item (text is injected server-side)',
'// ---------------------------------------------------------------------',
'const env = ''&G_APP_ENV.''.trim();',
'console.log("Current Environment =", env);',
'',
'',
'',
'// ---------------------------------------------------------------------',
'// UNIVERSAL SEQUENTIAL SCRIPT LOADER  (APEX safe)',
unistr('// Ensures chatPrompt \2192 chatSession \2192 chatCalls load in correct order'),
'// ---------------------------------------------------------------------',
'function loadSequential(urls, doneCallback) {',
'    if (!urls || urls.length === 0) {',
unistr('        console.log("\D83C\DF89 All scripts loaded");'),
'        if (typeof doneCallback === "function") doneCallback();',
'        return;',
'    }',
'',
'    const url = urls.shift();',
'    const script = document.createElement("script");',
'',
'    script.src = url;',
'    script.type = "text/javascript";',
'',
'    script.onload = () => {',
unistr('        console.log("\D83D\DCE6 Loaded:", url);'),
'        loadSequential(urls, doneCallback);  // Continue loading next',
'    };',
'',
'    script.onerror = () => {',
unistr('        console.error("\274C Failed to load:", url);'),
'        loadSequential(urls, doneCallback);  // Fail-safe: continue',
'    };',
'',
'    document.head.appendChild(script);',
'}',
'',
'',
'',
'// =====================================================================',
'// MODE: DEVELOPMENT (Load individual modules in order)',
'// =====================================================================',
'if (env === "DEV") {',
'    console.log("Mode: DEVELOPMENT");',
'',
'    const devScripts = [',
'        "#WORKSPACE_FILES#chat/assistant/src/chatPrompt#MIN#.js",',
'        "#WORKSPACE_FILES#chat/assistant/src/chatSession#MIN#.js",',
'        "#WORKSPACE_FILES#chat/assistant/src/chatCalls#MIN#.js"',
'        // "#WORKSPACE_FILES#chat/assistant/src/chatProjects#MIN#.js"',
'    ];',
'',
'    loadSequential(devScripts, function () {',
unistr('        console.log("\D83D\DD25 DEV scripts ready \2014 calling init()");'),
'        if (window.chatPrompt?.init) chatPrompt.init();',
'        if (window.chatSession?.init) chatSession.init();',
'        if (window.chatCalls?.init) chatCalls.init();',
'         console.log(''[Page Load] chatCalls version: '' + chatCalls.version);',
'    });',
'}',
'',
'',
'',
'// =====================================================================',
'// MODE: PRODUCTION (Load one combined minified file)',
'// =====================================================================',
'else if (env === "PROD") {',
'    console.log("Mode: PRODUCTION");',
'',
'    loadSequential([',
'        "#WORKSPACE_FILES#chat/assistant/dist/chatAssistant#MIN#.js"',
'    ], function () {',
unistr('        console.log("\D83D\DD25 PROD bundle ready \2014 initializing...");'),
'        if (window.chatAssistant?.init) chatAssistant.init();',
'        if (window.chatCalls?.init) chatCalls.init();',
' ',
'    });',
'}',
'',
'',
''))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151706993823556333)
,p_name=>'model change'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P114_MODEL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'change'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151707407402556334)
,p_event_id=>wwv_flow_imp.id(151706993823556333)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P114_MODEL is not null then',
'',
'select  ',
'       DEFAULT_TEMPERATURE,',
'       DEFAULT_TOP_P,',
'       DEFAULT_TOP_K,',
'       MAX_OUTPUT_TOKENS,',
'       SUPPORTS_STREAMING',
'      /* ,',
'          CONTEXT_WINDOW_TOKENS,',
'       SUPPORTS_FUNCTION_CALLING,',
'       SUPPORTS_VISION,',
'       SUPPORTS_JSON_MODE,',
'       DEFAULT_FREQUENCY_PENALTY,',
'       DEFAULT_PRESENCE_PENALTY ,',
'       RATE_LIMIT_RPM,',
'       RATE_LIMIT_TPM,',
'       EMBEDDING_DIMENSIONS,',
'        IS_DEFAULT,',
'       IS_ACTIVE,',
'       IS_EMBEDDING_MODE */',
'    into :P114_TEMPERATURE,',
'    :P114_TOP_P,',
'    :P114_TOP_K,',
'    :P114_MAX_TOKENS,',
'    :P114_STREAM_ENABLED',
'',
'from "LLM_PROVIDER_MODELS" a',
'where  MODEL_CODE =:P114_MODEL ;',
'',
'end if;',
''))
,p_attribute_02=>'P114_MODEL'
,p_attribute_03=>'P114_TOP_P,P114_TOP_K,P114_MAX_TOKENS,P114_STREAM_ENABLED'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151707878399556335)
,p_name=>'ProjectTree Node Selected'
,p_event_sequence=>60
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(300461147415765424)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_JSTREE|REGION TYPE|treeviewselectionchange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151708801969556338)
,p_event_id=>wwv_flow_imp.id(151707878399556335)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var node = apex.region("myProjectsTreeStaticID").call("getSelectedNodes")[0];',
'if (!node) return;',
'',
'// Read node metadata',
'var raw = node.id;                // PROJECT|1|   or SESSION|302|2',
unistr('var label = node.label;           // "\D83D\DCC1 HR Portal"  or "\D83D\DCAC what is my salary"'),
'console.log("RAW NODE_ID:", raw);',
'console.log("label:", label);',
'',
'// Split metadata',
'var parts = raw.split("|");',
'var type   = parts[0];  // PROJECT / SESSION',
'var id     = parts[1];  // Project ID or Session ID',
'var parent = parts[2];  // Parent project ID (may be "" for root)',
'',
' ',
'// PROJECT NODE',
'if (type === "PROJECT") {',
'    apex.item("P114_CHAT_PROJECT_ID").setValue(id);',
'    apex.item("P114_SELECTED_PROJECT_ID").setValue(id);',
'    ',
'    // extract clean project title',
unistr('    var cleanTitle = label.replace("\D83D\DCC1 ", "");'),
'    apex.item("P114_CHAT_PROJECT_TITLE").setValue(cleanTitle);',
'}',
'',
'// SESSION NODE',
'if (type === "SESSION") {',
'    apex.item("P114_CHAT_SESSION_ID").setValue(id);',
'    apex.item("P114_CHAT_PROJECT_ID").setValue(parent);',
'    apex.item("P114_SELECTED_PROJECT_ID").setValue(parent);',
'',
'    // extract clean session title',
unistr('    var cleanTitle = label.replace("\D83D\DCAC ", "");'),
'    apex.item("P114_SESSION_TITLE").setValue(cleanTitle);',
'',
'',
'    // GET PROJECT TITLE FROM TREE NODE (not from items)',
'    var parentLabel = "";',
'    if (node._parent && node._parent.label) {',
unistr('        parentLabel = node._parent.label.replace("\D83D\DCC1 ", "");'),
'    }',
'',
'    console.log("PARENT PROJECT TITLE:", parentLabel);',
'',
'    // Set APEX item for UI/header',
'    apex.item("P114_CHAT_PROJECT_TITLE").setValue(parentLabel);',
'',
'',
'    // Push value to session state immediately',
'  // apex.server.process(  "", // Name of a defined AJAX Callback process',
'   // { x01: apex.item("P114_CHAT_SESSION_ID").getValue(),x02: apex.item("P114_SELECTED_PROJECT_ID").getValue() },',
'    ',
'  //  {  success: function(pData) {  console.log("Session state updated");',
'    //    } } );',
'',
'',
'',
'',
'           try {',
'            apex.server.process(',
'                "SET_SESSION_ITEM",',
'                {',
'                    pageItems: "#P114_CHAT_SESSION_ID,#P114_SELECTED_PROJECT_ID" ',
'                },',
'                {',
'                    url: window.location.href,',
'                    dataType: "text",',
unistr('                    success: () => {  console.log("\2705 Protected item synced.");  },'),
unistr('                    error: (err) => { console.error("\274C Protected Item Sync Failed:", err);'),
'                                        apex.message.alert("Failed to sync protected items.");',
'                    }',
'                }',
'            );',
unistr('        } catch (e) { console.error("\274C openReportIssueDialog Exception:", e); };'),
' ',
'}',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155687768062186613)
,p_event_id=>wwv_flow_imp.id(151707878399556335)
,p_event_result=>'TRUE'
,p_action_sequence=>50
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'const sessionId = $v("P114_CHAT_SESSION_ID");',
'if (sessionId) {',
'    chatContext.setSession(sessionId);',
'}'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151709319379556339)
,p_event_id=>wwv_flow_imp.id(151707878399556335)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300501172210850030)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151708333331556336)
,p_event_id=>wwv_flow_imp.id(151707878399556335)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301843113611557821)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151709784893556340)
,p_name=>'Menu-SESSION-Show Menu-Button Click'
,p_event_sequence=>70
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.session-actions-menu button'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151710258038556341)
,p_event_id=>wwv_flow_imp.id(151709784893556340)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const sessionId = $(this.triggeringElement).attr(''id'').replace(''sessionMenu_'', '''');',
'toggleSessionMenu(sessionId);'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151710694822556342)
,p_name=>'Menu-SESSION-Handle Item Clicks'
,p_event_sequence=>80
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.apex-menu-link'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151711120371556343)
,p_event_id=>wwv_flow_imp.id(151710694822556342)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const $link = $(this.triggeringElement);',
'const action = $link.data(''action'');',
'const sessionId = $link.data(''session-id'');',
'',
'// Close menu',
'$link.closest(''.apex-menu'').hide();',
'',
'// Handle action',
'switch(action) {',
'    case ''edit-title'':',
'        toggleEditMode(sessionId);',
'        break;',
'        ',
'    case ''copy-title'':',
'        const title = $(''#sessionTitle_'' + sessionId).text().trim();',
'        copyToClipboard(title);',
'        break;',
'        ',
'    case ''export-session'':',
'        // Set session ID and submit',
'        apex.item(''P114_CHAT_SESSION_ID'').setValue(sessionId);',
'        apex.page.submit(''EXPORT_SESSION'');',
'        break;',
'        ',
'    case ''reassign-project'':',
'        // Open dialog',
'        apex.item(''P114_REASSIGN_SESSION_ID'').setValue(sessionId);',
'        apex.theme.openRegion(''reassignProjectDialog'');',
'        break;',
'        ',
'    case ''clear-session'':',
'        apex.message.confirm(',
'            ''Are you sure you want to clear this session? This cannot be undone.'',',
'            function(okPressed) {',
'                if (okPressed) {',
'                    apex.item(''P114_CLEAR_SESSION_ID'').setValue(sessionId);',
'                    apex.page.submit(''CLEAR_SESSION'');',
'                }',
'            }',
'        );',
'        break;',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151711527146556344)
,p_name=>'Menu-SESSION- Save Session Title'
,p_event_sequence=>90
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.session-save-btn'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151712029394556345)
,p_event_id=>wwv_flow_imp.id(151711527146556344)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_session_id    NUMBER;',
'    v_new_title     VARCHAR2(200);',
'    v_user_id       NUMBER:= v(''G_USER_ID'');',
'BEGIN',
'    -- Get session ID from button data attribute via JavaScript',
'    v_session_id := apex_application.g_x01;',
'    v_new_title := apex_application.g_x02;',
'    ',
' ',
'    ',
'    -- Update session title',
'    UPDATE chat_sessions',
'    SET session_title = v_new_title,',
'        last_activity_date = SYSTIMESTAMP',
'    WHERE session_id = v_session_id',
'      AND user_id = v_user_id;',
'    ',
'    COMMIT;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_attribute_02=>'P114_ISSUE_LEVEL'
,p_attribute_03=>'P114_ISSUE_LEVEL'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151712571203556346)
,p_event_id=>wwv_flow_imp.id(151711527146556344)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const $btn = $(this.triggeringElement);',
'const sessionId = $btn.data(''session-id'');',
'const newTitle = $(''#sessionTitleEdit_'' + sessionId).val().trim();',
'',
'if (!newTitle) {',
'    apex.message.alert(''Session title cannot be empty'');',
'    return;',
'}',
'',
'// Call APEX process',
'apex.server.process(''UPDATE_SESSION_TITLE'', {',
'    x01: sessionId,',
'    x02: newTitle',
'}, {',
'    success: function(data) {',
'        if (data.success) {',
'            // Update display',
'            $(''#sessionTitle_'' + sessionId).text(newTitle);',
'            cancelEdit(sessionId);',
'            apex.message.showPageSuccess(''Session title updated'');',
'            ',
'            // Refresh region to show new title',
'            apex.region(''Session_Header'').refresh();',
'        } else {',
'            apex.message.alert(''Error: '' + data.message);',
'        }',
'    },',
'    error: function(xhr, status, error) {',
'        apex.message.alert(''Failed to update: '' + error);',
'    }',
'});'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151712993918556347)
,p_name=>'SESSION-HEADER-Save on Enter Key'
,p_event_sequence=>100
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.session-title-edit'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.key === ''Enter'''
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keypress'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151713413689556349)
,p_event_id=>wwv_flow_imp.id(151712993918556347)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const sessionId = $(this.triggeringElement).data(''session-id'');',
'$(''#saveBtn_'' + sessionId).click();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151713861017556350)
,p_name=>'SESSION-HEADER-Cancel on Escape Key'
,p_event_sequence=>110
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.session-title-edit'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.key === ''Escape'''
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keypress'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151714380142556351)
,p_event_id=>wwv_flow_imp.id(151713861017556350)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'const sessionId = $(this.triggeringElement).data(''session-id'');',
'cancelEdit(sessionId);'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151714724196556352)
,p_name=>'Cancel Region New Session Dialog'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151685714152556250)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151715236662556353)
,p_event_id=>wwv_flow_imp.id(151714724196556352)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798572574221120)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151715647293556354)
,p_name=>'Save New Project'
,p_event_sequence=>160
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151683235799556242)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151716153363556355)
,p_event_id=>wwv_flow_imp.id(151715647293556354)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_project_id NUMBER;',
'    v_user_id    NUMBER := V(''G_USER_ID'');',
'BEGIN',
'    -- Validate',
'    IF :P114_CHAT_PROJECT_TITLE IS NULL THEN',
'        apex_error.add_error(  p_message => ''~ Project name is required'',',
'            p_display_location => apex_error.c_inline_in_notification );',
'        RETURN;',
'    END IF;',
'    ',
'    -- Create project',
'       v_project_id:= CHAT_PROJECTS_PKG.add_project(',
'                                        p_project_code         => :APP_USER|| to_char(systimestamp,''YYYYMMDDHH24MISSFF3''), ',
'                                        p_project_name         => TRIM(:P114_NEW_CHAT_PROJECT_TITLE),',
'                                        p_project_description  =>  :P114_CHAT_PROJECT_DESCRIPTION,',
'                                        p_project_instructions => :P114_CHAT_PROJECT_INSTRUCTIONS,',
'                                        p_owner_user_id        => V(''G_USER_ID''),',
'                                        p_is_default           => ''N'',',
'                                        p_tenant_id            => v(''G_TENANT_ID'') );',
'    ',
'    -- Store new project ID',
'    :P114_SELECTED_PROJECT_ID := v_project_id;',
'    commit;',
unistr('    apex_application.g_print_success_message := ''\2705 Project created successfully'';'),
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_error.add_error(  p_message          => ''Error creating project: '' || SQLERRM,',
'                               p_display_location => apex_error.c_inline_in_notification );',
'END;',
'',
'',
'',
'',
'',
' '))
,p_attribute_02=>'P114_NEW_CHAT_PROJECT_TITLE,P114_CHAT_PROJECT_DESCRIPTION,P114_CHAT_PROJECT_INSTRUCTIONS,P114_CHAT_PROJECT_TITLE'
,p_attribute_03=>'P114_SELECTED_PROJECT_ID'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151716642719556356)
,p_event_id=>wwv_flow_imp.id(151715647293556354)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300461147415765424)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155690058385186636)
,p_event_id=>wwv_flow_imp.id(151715647293556354)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Refresh New S Project'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P114_NEW_SESSION_PROJECT_ID'
,p_attribute_01=>'N'
,p_da_action_comment=>wwv_flow_string.join(wwv_flow_t_varchar2(
'Refresh P114_NEW_SESSION_PROJECT_ID',
'it does have the new created project in the same session, if you create project ,you will find this in the list,so we refresh here'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151717134270556358)
,p_event_id=>wwv_flow_imp.id(151715647293556354)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798403176221119)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151717506324556358)
,p_name=>'Cancel Region New Project Dialog'
,p_event_sequence=>170
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151683646737556243)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151718045268556360)
,p_event_id=>wwv_flow_imp.id(151717506324556358)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Close Region'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798403176221119)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151718424760556360)
,p_name=>'Open New Project Dialog'
,p_event_sequence=>180
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151666248908556190)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151718977545556362)
,p_event_id=>wwv_flow_imp.id(151718424760556360)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P114_NEW_CHAT_PROJECT_TITLE,P114_CHAT_PROJECT_INSTRUCTIONS,P114_CHAT_PROJECT_DESCRIPTION'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151719481104556363)
,p_event_id=>wwv_flow_imp.id(151718424760556360)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798403176221119)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155689601267186632)
,p_name=>'Open ReAssign Session to Proj Dialog'
,p_event_sequence=>190
,p_triggering_element_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_element=>'document'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'custom'
,p_bind_event_type_custom=>'open-reassign-session'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155689732815186633)
,p_event_id=>wwv_flow_imp.id(155689601267186632)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P114_MOVE_SESSION_PROJECT_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155689804753186634)
,p_event_id=>wwv_flow_imp.id(155689601267186632)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(155687807448186614)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151719809158556364)
,p_name=>'Open New Session Dialog'
,p_event_sequence=>200
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151666668812556192)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151720388913556365)
,p_event_id=>wwv_flow_imp.id(151719809158556364)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P114_NEW_SESSION_TITLE,P114_NEW_SESSION_PROJECT_ID'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151720822480556366)
,p_event_id=>wwv_flow_imp.id(151719809158556364)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_OPEN_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798572574221120)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151721299750556367)
,p_name=>'Save new Session'
,p_event_sequence=>210
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151685365208556249)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151721772125556368)
,p_event_id=>wwv_flow_imp.id(151721299750556367)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'   --P114_NEW_SESSION_PROJECT_ID,P114_NEW_SESSION_TITLE,P114_PROVIDER,P114_MODEL',
'    vcaller  VARCHAR2(100)   := ''DYNA-PAGE''||:APP_PAGE_ID||''.''||''ADD-NEW-SESSION'';',
'    v_session_id    NUMBER;',
'    v_user_id       NUMBER          := V(''G_USER_ID'');',
'    v_project_id    NUMBER          := :P114_NEW_SESSION_PROJECT_ID;',
'    v_session_title VARCHAR2(200)   := :P114_NEW_SESSION_TITLE;',
'    v_provider  VARCHAR2(100)   := :P114_PROVIDER;',
'    v_model     VARCHAR2(100)   := :P114_MODEL;',
'    v_traceid   VARCHAR2(200) ;',
'BEGIN',
'    -- Validate',
'    IF v_session_title IS NULL THEN',
'        apex_error.add_error(   p_message          => ''Session title is required'',',
'                                p_display_location => apex_error.c_inline_in_notification );',
'        RETURN;',
'    END IF;',
'    ',
'    IF v_project_id IS NULL THEN',
'        apex_error.add_error(  p_message          => ''No active project selected'',',
'                               p_display_location => apex_error.c_inline_in_notification );',
'        RETURN;',
'    END IF;',
'',
'      -- Create new session',
'        v_session_id := chat_session_pkg.new_session(   p_provider       => v_provider,',
'                                                        p_model          => v_model,',
'                                                        p_session_title  => v_session_title,',
'                                                        p_user_id        => v_user_id,',
'                                                        p_app_session_id => :APP_SESSION,',
'                                                        p_app_id         => :APP_ID,',
'                                                        p_app_page_id    => :APP_PAGE_ID,',
'                                                        p_project_id     =>  v_project_id,',
'                                                        p_tenant_id      => v(''G_TENANT_ID''),',
'                                                        p_trace_id       => v_traceid',
'                                                    );',
'  ',
'    ',
'    COMMIT;',
'    If v_session_id is not null then',
'        :P114_SESSION_TITLE:= v_session_title;',
'        :P114_NEW_SESSION_ID  := v_session_id;',
'        :P114_CHAT_SESSION_ID := v_session_id;',
'   --P114_SESSION_TITLE,P114_NEW_SESSION_ID,P114_CHAT_SESSION_ID',
'    end if;',
'    ',
unistr('    apex_application.g_print_success_message := ''\2705 Session created successfully'';'),
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        debug_util.error(sqlerrm,vcaller,v_traceid );',
'        apex_error.add_error(  p_message          => ''Error creating session: '' || SQLERRM,',
'                               p_display_location => apex_error.c_inline_in_notification  );',
'END;',
'',
' '))
,p_attribute_02=>'P114_NEW_SESSION_PROJECT_ID,P114_NEW_SESSION_TITLE,P114_PROVIDER,P114_MODEL'
,p_attribute_03=>'P114_SESSION_TITLE,P114_NEW_SESSION_ID,P114_CHAT_SESSION_ID'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151722270518556370)
,p_event_id=>wwv_flow_imp.id(151721299750556367)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300461147415765424)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151722763772556371)
,p_event_id=>wwv_flow_imp.id(151721299750556367)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300501172210850030)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151723225218556372)
,p_event_id=>wwv_flow_imp.id(151721299750556367)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301798572574221120)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151724919967589506)
,p_name=>'Send Key Down'
,p_event_sequence=>220
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151724868627589505)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keydown'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151725027793589507)
,p_event_id=>wwv_flow_imp.id(151724919967589506)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if (event.key === "Enter" && !event.shiftKey) {',
'    event.preventDefault();',
'    $("#sendBtn").click();   // Replace with your actual Send button ID',
'}'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151725372492589510)
,p_name=>'after Region Refresh'
,p_event_sequence=>230
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(151725297394589509)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151725474059589511)
,p_event_id=>wwv_flow_imp.id(151725372492589510)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.region("chatCalls_region").onRefresh(function() {',
'    const cards = document.querySelectorAll(".chatCall-card");',
'    const lastCard = cards[cards.length - 1];',
'    if (lastCard) {',
'        lastCard.classList.add("chatCall-highlight");',
'        setTimeout(() => lastCard.classList.remove("chatCall-highlight"), 1200);',
'    }',
'});'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151726924631589526)
,p_name=>'save'
,p_event_sequence=>240
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151726736642589524)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151727014493589527)
,p_event_id=>wwv_flow_imp.id(151726924631589526)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'UPDATE chat_calls',
'SET ',
'    user_rating = :P114_RATING,',
'    user_rating_comment = :P114_COMMENT,',
'    user_rating_ts = SYSTIMESTAMP',
'WHERE call_id = :P114_CALL_ID;',
'Commit;'))
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151727487132589531)
,p_event_id=>wwv_flow_imp.id(151726924631589526)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(151726325874589520)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(151727105583589528)
,p_name=>'close Rating Dialog'
,p_event_sequence=>250
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(151726864927589525)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151727298171589529)
,p_event_id=>wwv_flow_imp.id(151727105583589528)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(151726325874589520)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(151727392964589530)
,p_event_id=>wwv_flow_imp.id(151727105583589528)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(301843113611557821)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155688250824186618)
,p_name=>'close Move'
,p_event_sequence=>260
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(155688145084186617)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155689512112186631)
,p_event_id=>wwv_flow_imp.id(155688250824186618)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$("#moveSessionRegionId").slideUp(180);'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155688384009186619)
,p_event_id=>wwv_flow_imp.id(155688250824186618)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(155687807448186614)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155688518262186621)
,p_event_id=>wwv_flow_imp.id(155688250824186618)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300461147415765424)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155688482189186620)
,p_event_id=>wwv_flow_imp.id(155688250824186618)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(300501172210850030)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155688656710186622)
,p_name=>'saveMove'
,p_event_sequence=>270
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(155688052284186616)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155688733434186623)
,p_event_id=>wwv_flow_imp.id(155688656710186622)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'if :P114_MOVE_SESSION_PROJECT_ID is not null then',
'        UPDATE chat_sessions',
'        SET chat_project_id  = :P114_MOVE_SESSION_PROJECT_ID',
'        WHERE session_id = :P114_CHAT_SESSION_ID;',
'        Commit;',
'end if;'))
,p_attribute_02=>'P114_CHAT_SESSION_ID,P114_MOVE_SESSION_PROJECT_ID'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155688834253186624)
,p_event_id=>wwv_flow_imp.id(155688656710186622)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLOSE_REGION'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(155687807448186614)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155690587766186641)
,p_name=>'Menu-chatCall-more Btn'
,p_event_sequence=>280
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.chatCall-moreBtn'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155690640317186642)
,p_event_id=>wwv_flow_imp.id(155690587766186641)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Close all open menus',
'$(".chatCall-moreDropdown").hide();',
'',
'const btn  = this.triggeringElement;',
'const rect = btn.getBoundingClientRect();',
'',
'const $menu = $(btn)',
'    .closest(".chatCall-more")',
'    .find(".chatCall-moreDropdown");',
'',
'// Position relative to viewport (FIXED)',
'$menu.css({',
'    top:  rect.bottom + 4 + "px",',
'    left: rect.left + "px"',
'});',
'',
'// Show menu',
'$menu.show();',
''))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155690754552186643)
,p_name=>'Menu-chatCall-more Btn_close'
,p_event_sequence=>290
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'document'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'!$(this.triggeringElement)',
'    .closest(".chatCall-more").length'))
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155690825690186644)
,p_event_id=>wwv_flow_imp.id(155690754552186643)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$(".chatCall-moreDropdown").hide();'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155690937302186645)
,p_name=>'Menu-chatCall-Close after Menu Action'
,p_event_sequence=>300
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.chatCall-menuItem'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
'!$(this.triggeringElement)',
'    .closest(".chatCall-more").length'))
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155691127230186647)
,p_event_id=>wwv_flow_imp.id(155690937302186645)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>'$(".chatCall-moreDropdown").hide();'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151696532903556304)
,p_process_sequence=>80
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SET_SESSION_ITEM'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'  declare  ',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.SET_SESSION_ITEM'';',
'     v_CHAT_SESSION_ID           NUMBER := TO_NUMBER(apex_application.g_x01);',
'     v_SELECTED_PROJECT_ID       NUMBER := TO_NUMBER(apex_application.g_x02);',
' --  v     NUMBER := apex_application.g_x03;',
' BEGIN',
'    APEX_UTIL.SET_SESSION_STATE(''P114_CHAT_SESSION_ID'', v_CHAT_SESSION_ID);',
'    APEX_UTIL.SET_SESSION_STATE(''P114_SELECTED_PROJECT_ID'', v_SELECTED_PROJECT_ID);',
'   -- APEX_UTIL.SET_SESSION_STATE(''P1_ITEM'', :x03);',
'END;  ',
'',
'   '))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151696532903556304
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151696943127556305)
,p_process_sequence=>90
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_ASSISTANT_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('-- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'-- CORRECTED: SAVE_ASSISTANT_MESSAGE Process',
'-- Issue: P114_CHAT_SESSION_ID was NULL after new_session call',
'-- Fix: Explicit assignment with proper NULL handling',
unistr('-- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'',
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE||''.SAVE_ASSISTANT_MESSAGE'';',
'    v_session_id NUMBER;',
'    v_msg_id NUMBER;',
'    v_check NUMBER;',
'BEGIN',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    -- STEP 1: Get or Create Session',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    ',
'    APEX_DEBUG.INFO(''STEP 1: Checking P114_CHAT_SESSION_ID = '' || ',
'                    NVL(:P114_CHAT_SESSION_ID, ''NULL''));',
'    ',
'    -- Convert to NUMBER safely',
'    BEGIN',
'        v_session_id := TO_NUMBER(:P114_CHAT_SESSION_ID);',
'    EXCEPTION',
'        WHEN VALUE_ERROR OR INVALID_NUMBER THEN',
'            v_session_id := NULL;',
'            APEX_DEBUG.WARN(''P114_CHAT_SESSION_ID is not a valid number, will create new'');',
'    END;',
'    ',
'    -- Check if session exists and is valid',
'    IF v_session_id IS NOT NULL THEN',
'        SELECT COUNT(*) INTO v_check',
'        FROM chat_sessions',
'        WHERE session_id = v_session_id;',
'        ',
'        IF v_check = 0 THEN',
'            APEX_DEBUG.WARN(''Session '' || v_session_id || '' not found, will create new'');',
'            v_session_id := NULL;',
'        ELSE',
'            APEX_DEBUG.INFO(''Using existing session: '' || v_session_id);',
'        END IF;',
'    END IF;',
'    ',
'    -- Create new session if needed',
'    IF v_session_id IS NULL THEN',
'        APEX_DEBUG.INFO(''Creating new session...'');',
'        ',
'        v_session_id := chat_session_pkg.new_session(',
'            p_user_id        => TO_NUMBER(v(''G_USER_ID'')),',
'            p_session_title  => ''Chat Session - '' || TO_CHAR(SYSDATE, ''YYYY-MM-DD HH24:MI''),',
'            p_provider       => NVL(:P114_PROVIDER, ''OPENAI''),',
'            p_model          => NVL(:P114_MODEL, ''gpt-4o-mini''),',
'            p_project_id     => TO_NUMBER(NVL(:P114_CHAT_PROJECT_ID, ''0'')),',
'            p_app_id         => TO_NUMBER(v(''APP_ID'')),',
'            p_app_page_id    => TO_NUMBER(v(''APP_PAGE_ID'')),',
'            p_app_session_id => TO_NUMBER(v(''APP_SESSION'')),',
'            p_tenant_id      => TO_NUMBER(NVL(v(''G_TENANT_ID''), ''0''))',
'        );',
'        ',
'        APEX_DEBUG.INFO(''Created new session_id: '' || NVL(TO_CHAR(v_session_id), ''NULL''));',
'        ',
'        -- CRITICAL: Update page item with new session_id',
'        :P114_CHAT_SESSION_ID := v_session_id;',
'        ',
'        -- Verify it was set',
'        APEX_DEBUG.INFO(''P114_CHAT_SESSION_ID now = '' || NVL(:P114_CHAT_SESSION_ID, ''NULL''));',
'    END IF;',
'    ',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    -- STEP 2: Final Validation',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    ',
'    IF v_session_id IS NULL THEN',
'        RAISE_APPLICATION_ERROR(-20001, ',
'            ''FATAL: Failed to create or retrieve session_id'');',
'    END IF;',
'    ',
'    -- Verify session exists in database',
'    SELECT COUNT(*) INTO v_check',
'    FROM chat_sessions',
'    WHERE session_id = v_session_id;',
'    ',
'    IF v_check = 0 THEN',
'        RAISE_APPLICATION_ERROR(-20001, ',
'            ''FATAL: Session '' || v_session_id || '' not found in chat_sessions table'');',
'    END IF;',
'    ',
unistr('    APEX_DEBUG.INFO(''\2713 Session validated: '' || v_session_id);'),
'    ',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    -- STEP 3: Save Assistant Message',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    ',
'    APEX_DEBUG.INFO(''STEP 3: Saving assistant message for session '' || v_session_id);',
'    ',
'    v_msg_id := chat_message_pkg.add_message(',
'        p_session_id     => v_session_id,',
'        p_message_role   => ''ASSISTANT'',',
'        p_content        => apex_application.g_x01,',
'        p_params         => NULL,',
'        p_rag_context    => NULL,',
'        p_rag_doc_count  => NULL,',
'        p_tokens_input   => NULL,',
'        p_tokens_output  => NULL,',
'        p_tokens_total   => NULL,',
'        p_processing_ms  => NULL,',
'        p_metadata       => NULL',
'    );',
'    ',
unistr('    APEX_DEBUG.INFO(''\2713 Message saved with ID: '' || v_msg_id);'),
'    ',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    -- STEP 4: Return Success Response',
unistr('    -- \2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'),
'    ',
'    HTP.p(JSON_OBJECT(',
'        ''success'' VALUE TRUE,',
'        ''message_id'' VALUE v_msg_id,',
'        ''session_id'' VALUE v_session_id',
'    ));',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        APEX_DEBUG.ERROR(''ERROR in SAVE_ASSISTANT_MESSAGE: '' || SQLERRM);',
'        APEX_DEBUG.ERROR(''  Session ID attempted: '' || NVL(TO_CHAR(v_session_id), ''NULL''));',
'        APEX_DEBUG.ERROR(''  P114_CHAT_SESSION_ID: '' || NVL(:P114_CHAT_SESSION_ID, ''NULL''));',
'        ',
'        HTP.p(JSON_OBJECT(',
'            ''success'' VALUE FALSE,',
'            ''error'' VALUE SQLERRM,',
'            ''session_id'' VALUE v_session_id',
'        ));',
'        ',
'        RAISE;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_internal_uid=>151696943127556305
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151695766663556301)
,p_process_sequence=>140
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'ENSURE_SESSION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'-- Process Name: ENSURE_SESSION',
'-- Point: Ajax Callback',
'',
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.ENSURE_SESSION'';',
'    v_session_id  NUMBER;',
'    v_ChatCallId  NUMBER;',
'    v_trace_id VARCHAR2(200);',
'    v_user_id NUMBER;',
'    v_suggested_title VARCHAR2(200);',
'    v_user_prompt CLOB := apex_application.g_x01;',
'    v_provider VARCHAR2(50);',
'    v_model VARCHAR2(100);',
'BEGIN',
'    v_session_id := NVL(TO_NUMBER(:P114_CHAT_SESSION_ID), NULL);',
'    -- Step 1: Get user_id',
'    v_user_id := NVL(v(''G_USER_ID''), NULL);',
'    IF  v_session_id is not null then --we will trace start from call',
'       v_trace_id:= CHAT_CALL_PKG.New_traceid;',
'    END IF;   ',
'',
'    IF v_user_id IS NULL THEN',
'        BEGIN',
'            SELECT user_id INTO v_user_id  ',
'            FROM users',
'            WHERE user_name = :APP_USER;',
'        EXCEPTION',
'            WHEN NO_DATA_FOUND THEN',
'                apex_json.open_object;',
'                apex_json.write(''success'', FALSE);',
'                apex_json.write(''error'', ''User not found: '' || :APP_USER);',
'                apex_json.close_object;',
'                debug_util.error(''User not found - '' || :APP_USER,vcaller,v_trace_id);',
'                RETURN;',
'        END;',
'    END IF;',
'    ',
'    -- Step 2: Get provider and model (with validation)',
'    v_provider := NVL(:P114_PROVIDER, ''OPENAI'');',
'    v_model := NVL(:P114_MODEL, ''gpt-4o-mini'');',
'    ',
'    -- Debug: Log what we received',
'    debug_util.info(''Provider( ''||v_provider || '' )  , Model ( '' || v_model ||'' )'',vcaller,v_trace_id);',
'    ',
'    -- Step 3: Check if session exists',
'    ',
'    IF v_session_id IS NULL THEN',
'        -- === CREATE NEW SESSION ===',
'        debug_util.info(''No Session,create a new chatsession for userid(''||v_user_id|| '') '',vcaller,v_trace_id);',
'        ',
'        -- Generate suggested title',
'        v_suggested_title := CASE ',
'            WHEN LENGTH(v_user_prompt) <= 50 THEN v_user_prompt',
'            ELSE SUBSTR(v_user_prompt, 1, 47) || ''...''    ',
'        END;',
'        ',
'        -- Create new session',
'        v_session_id := chat_session_pkg.new_session(',
'            p_provider       => v_provider,',
'            p_model          => v_model,',
'            p_session_title  => v_suggested_title,',
'            p_user_id        => v_user_id,',
'            p_app_session_id => :APP_SESSION,',
'            p_app_id         => :APP_ID,',
'            p_app_page_id    => :APP_PAGE_ID,',
'            p_project_id     => v(''G_CHAT_PROJECT_ID''),',
'            p_tenant_id      => v(''G_TENANT_ID''),',
'            p_trace_id       => v_trace_id --out',
'        );',
'',
'       -- Validate session was created',
'        IF v_session_id IS NULL THEN',
'            apex_json.open_object;',
'            apex_json.write(''success'', FALSE);',
'            apex_json.write(''error'', ''Chatsession creation returned NULL'');',
'            apex_json.close_object;',
'            debug_util.error(''ChatSession creation returned NULL'',vcaller,v_trace_id);',
'            RETURN;',
'        END IF;',
'',
'',
'        -- Persist to session state',
'        apex_util.set_session_state(  p_name  => ''P114_CHAT_SESSION_ID'',  p_value => v_session_id  );',
'        ',
'        -- Set session title if empty',
'        IF :P114_SESSION_TITLE IS NULL THEN',
'            apex_util.set_session_state(  p_name  => ''P114_SESSION_TITLE'', p_value => v_suggested_title  );',
'        END IF;',
'        ',
'        debug_util.info(''New sessionId ='' || v_session_id,vcaller,v_trace_id);',
'        ',
'    ELSE',
'        -- === REUSE EXISTING SESSION ===',
'        debug_util.info(''Reusing existing chatsessionId '' || v_session_id,vcaller,v_trace_id);',
'        ',
'        -- Get existing title',
'        v_suggested_title := NVL(:P114_SESSION_TITLE, ''Chat Session'');',
'        ',
'        -- Update last activity',
'        UPDATE chat_sessions',
'        SET last_activity_date = SYSTIMESTAMP',
'        WHERE session_id = v_session_id;',
'        debug_util.info(''Chat-Session Updated of lastActivity '',vcaller,v_trace_id);',
'        ',
'    END IF;',
'    ---New or reuse will create an call record',
'    IF v_session_id is NOT null then',
'              v_ChatCallId :=  CHAT_CALL_PKG.New_ChatCall (p_chat_session_id => v_session_id, p_trace_id => v_trace_id);',
'               debug_util.info(''new chatCall (''||v_ChatCallId|| '') for session(''||v_session_id|| '') '',vcaller,v_trace_id);',
'     End If;',
'    ',
'    -- Return JSON response',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.write(''session_id'', v_session_id);',
'    apex_json.write(''chatcall_id'', v_ChatCallId);',
'    apex_json.write(''trace_id'', v_trace_id);',
'    apex_json.write(''suggested_title'', v_suggested_title);',
'    apex_json.write(''is_new'', CASE WHEN :P114_CHAT_SESSION_ID IS NULL THEN TRUE ELSE FALSE END);',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.write(''backtrace'', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'        apex_json.close_object;',
'        debug_util.error(SQLERRM ||'' ,''|| DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,vcaller,v_trace_id);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151695766663556301
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151696154173556302)
,p_process_sequence=>150
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'DETECT_DOMAIN'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vcaller             CONSTANT VARCHAR2(70) := ''PROCESS_PAGE''||:APP_PAGE_ID||''.DETECT_DOMAIN'';',
'    v_session_id        NUMBER;',
'    v_user_prompt       CLOB;',
'    v_trace_id          VARCHAR2(200);',
'    v_chat_call_id      NUMBER;',
'    ',
'    -- Direct Input Variables',
'    v_in_provider       VARCHAR2(100);',
'    v_in_model          VARCHAR2(100);',
'    v_in_sys_inst       VARCHAR2(4000);',
'    v_in_domain_id      NUMBER;',
'',
'    v_classifier_req    CXD_TYPES.t_cxd_classifier_req;',
'    v_classifier_resp   CXD_TYPES.t_cxd_classifier_resp;',
'    v_intent_classifier_resp CXD_TYPES.t_intent_classifier_resp;',
'BEGIN',
'    apex_json.initialize_output;',
'',
'    -- 1. Map Inputs',
'    v_session_id   := TO_NUMBER(apex_application.g_x01);',
'    v_chat_call_id := TO_NUMBER(apex_application.g_x02);',
'    v_trace_id     := apex_application.g_x03;',
'    v_user_prompt  := apex_application.g_x04;',
'    ',
unistr('    -- \D83D\DE80 DIRECT READ (Bypassing potential Session State NULLs)'),
'    v_in_provider  := apex_application.g_x05;',
'    v_in_model     := apex_application.g_x06;',
'    v_in_sys_inst  := apex_application.g_x07;',
'    v_in_domain_id := TO_NUMBER(apex_application.g_x08);',
'',
'    debug_util.starting(vcaller, ''Session: ''||v_session_id||'' | Provider: ''||v_in_provider, v_trace_id);',
'',
'    -- 2. Build Request',
'    v_classifier_req.trace_id              := v_trace_id;',
'    v_classifier_req.chat_session_id       := v_session_id;',
'    v_classifier_req.chat_call_id          := v_chat_call_id;',
'    v_classifier_req.detection_Method_code := ''AUTO'';',
'    ',
'    v_classifier_req.context_domain_id     := v_in_domain_id; ',
'    v_classifier_req.provider              := v_in_provider;',
'    v_classifier_req.model                 := v_in_model;',
'    v_classifier_req.user_prompt           := v_user_prompt;',
'    ',
'    -- Standard Context',
'    v_classifier_req.user_id               := v(''G_USER_ID'');',
'    v_classifier_req.app_id                := :APP_ID;',
'    v_classifier_req.app_session_id        := :APP_SESSION;',
'    v_classifier_req.tenant_id             := v(''G_TENANT_ID'');',
'    v_classifier_req.chat_project_id       := v(''G_CHAT_PROJECT_ID'');',
'',
'    -- 3. Execute Detection',
'    cxd_classifier_pkg.detect(',
'        p_req         => v_classifier_req,',
'        P_resp_Domain => v_classifier_resp,',
'        P_resp_Intent => v_intent_classifier_resp',
'    );',
'',
'    -- 4. Process Result',
'    IF v_classifier_resp.context_domain_id IS NOT NULL THEN',
'        -- Update Session with new Domain',
'        UPDATE chat_sessions',
'           SET context_domain_id = v_classifier_resp.context_domain_id,',
'               last_activity_date = SYSTIMESTAMP',
'         WHERE session_id = v_session_id;',
'        COMMIT;',
'        ',
'        audit_util.log_event(''PROC_OK'', ''Domain Detected: ''||v_classifier_resp.context_domain_name, v_trace_id, vcaller);',
'',
'        apex_json.open_object;',
'        apex_json.write(''success'', TRUE);',
'        apex_json.write(''context_domain_id'', v_classifier_resp.context_domain_id);',
'        apex_json.write(''trace_id'', v_classifier_resp.trace_id);',
'        apex_json.close_object;',
'    ELSE',
'        -- Log Failure',
'        CHAT_CALL_PKG.update_call_response(',
'            p_call_id => v_chat_call_id, p_trace_id => v_trace_id, p_user_prompt => v_user_prompt,',
'            p_response => ''Domain detection failed: ''||v_classifier_resp.message, p_status => ''F''',
'        );',
'        COMMIT;',
'',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', ''Domain detection failed'');',
'        apex_json.close_object;',
'    END IF;',
'',
'    debug_util.ending(vcaller, ''DONE'', v_trace_id);',
'',
'EXCEPTION WHEN OTHERS THEN',
'    ROLLBACK;',
'    -- Log System Error to Call Table so user sees it',
'    CHAT_CALL_PKG.update_call_response(',
'        p_call_id => v_chat_call_id, p_trace_id => v_trace_id, p_user_prompt => v_user_prompt,',
'        p_response => ''System Error in Detection: ''||SQLERRM, p_status => ''F''',
'    );',
'    COMMIT;',
'    ',
'    debug_util.error(SQLERRM, vcaller, v_trace_id);',
'    apex_json.open_object;',
'    apex_json.write(''success'', FALSE);',
'    apex_json.write(''error'', ''System Error'');',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151696154173556302
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151695428887556300)
,p_process_sequence=>160
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'INVOKE_LLM'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    vcaller        CONSTANT VARCHAR2(70) := ''PROCESS_PAGE''||:APP_PAGE_ID||''.INVOKE_LLM'';',
'    v_req          llm_types.t_llm_request;',
'    v_resp         llm_types.t_llm_response;',
'    v_json_text    CLOB := apex_application.g_x01;',
'    v_json_obj     JSON_OBJECT_T;',
'    v_trace_id     VARCHAR2(200);',
'    v_msg          VARCHAR2(4000);',
'BEGIN',
'    apex_json.initialize_output;',
'    ',
'    -- 1. Safe JSON Parsing',
'    IF v_json_text IS NULL THEN',
'        RAISE_APPLICATION_ERROR(-20001, ''Empty Payload'');',
'    END IF;',
'',
'    BEGIN',
'        v_json_obj := JSON_OBJECT_T.parse(v_json_text);',
'    EXCEPTION WHEN OTHERS THEN',
'        -- Catch invalid JSON immediately',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', ''Invalid JSON Payload'');',
'        apex_json.close_object;',
'        RETURN;',
'    END;',
'    ',
'    -- 2. Extract Trace ID (Safe)',
'    IF v_json_obj.has(''traceid'') THEN v_trace_id := v_json_obj.get_string(''traceid'');',
'    ELSIF v_json_obj.has(''trace_id'') THEN v_trace_id := v_json_obj.get_string(''trace_id'');',
'    ELSE v_trace_id := ''MISSING-'' || TO_CHAR(SYSTIMESTAMP, ''HH24MISS''); END IF;',
'',
'    debug_util.starting(vcaller, ''Payload Size: '' || DBMS_LOB.getlength(v_json_text), v_trace_id);',
'',
'    -- 3. Map Request',
'    v_req.trace_id            := v_trace_id;',
'    v_req.chat_session_id     := v_json_obj.get_number(''chat_session_id'');',
'    v_req.chat_call_id        := v_json_obj.get_number(''chat_call_id'');',
'    v_req.context_domain_id   := v_json_obj.get_number(''context_domain_id'');',
'    ',
'    -- Safe String Extraction',
'    v_req.provider            := NVL(v_json_obj.get_string(''provider''), ''OPENAI'');',
'    v_req.model               := NVL(v_json_obj.get_string(''model''), ''gpt-4o-mini'');',
'    v_req.user_prompt         := v_json_obj.get_string(''user_prompt'');',
'    v_req.system_instructions := v_json_obj.get_string(''system_instructions'');',
'    ',
'    -- Safe Number Extraction',
'    v_req.temperature         := NVL(v_json_obj.get_number(''temperature''), 0.7);',
'    v_req.max_tokens          := NVL(v_json_obj.get_number(''max_tokens''), 1024);',
'    v_req.top_p               := NVL(v_json_obj.get_number(''top_p''), 1.0);',
'    v_req.top_k               := NVL(v_json_obj.get_number(''top_k''), 0);',
'',
'    -- Context',
'    v_req.app_id              := :APP_ID;',
'    v_req.user_id             := v(''G_USER_ID'');',
'    v_req.tenant_id           := v(''G_TENANT_ID'');',
'',
'    -- 4. Execute Engine',
'    v_resp := CHAT_ENGINE_PKG.invoke_chat(v_req);',
'',
'    -- 5. Response',
'    IF v_resp.success THEN',
'        audit_util.log_event(''PROC_OK'', ''LLM Success'', v_trace_id, vcaller);',
'        apex_json.open_object;',
'        apex_json.write(''success'', TRUE);',
'        apex_json.write(''response_text'', v_resp.response_text);',
'        apex_json.write(''trace_id'', v_trace_id);',
'        apex_json.close_object;',
'    ELSE',
'        -- Return controlled failure',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', v_resp.msg);',
'        apex_json.write(''trace_id'', v_trace_id);',
'        apex_json.close_object;',
'    END IF;',
'',
'    debug_util.ending(vcaller, ''OK'', v_trace_id);',
'',
'EXCEPTION WHEN OTHERS THEN',
'    ROLLBACK;',
'    ',
unistr('    -- \D83D\DEA8 Log Critical Error to Chat Table (so UI Refresh shows it)'),
'    BEGIN',
'        CHAT_CALL_PKG.update_call_response(',
'            p_call_id => v_req.chat_call_id, ',
'            p_trace_id => v_trace_id, ',
'            p_user_prompt => v_req.user_prompt,',
'            p_response => ''System Error: '' || SQLERRM, ',
'            p_status => ''F''',
'        );',
'        COMMIT; ',
'    EXCEPTION WHEN OTHERS THEN NULL; END;',
'',
'    debug_util.error(SQLERRM, vcaller, v_trace_id);',
'    ',
'    -- Return JSON (Prevent 500 Error)',
'    apex_json.open_object;',
'    apex_json.write(''success'', FALSE);',
'    apex_json.write(''error'', ''Internal System Error: '' || SQLERRM);',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151695428887556300
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151698110562556308)
,p_process_sequence=>170
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SYNC_PROTECTED_ITEMS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'',
'  -- Force-check protected item by assigning it to itself',
'  :P114_CHAT_SESSION_ID := :P114_CHAT_SESSION_ID;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151698110562556308
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151698561619556309)
,p_process_sequence=>180
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GENERATE_REPORT_ISSUE_URL'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.GENERATE_REPORT_ISSUE_URL'';',
'    l_url         VARCHAR2(4000);',
'    v_entity_id   NUMBER;',
'    v_issue_level VARCHAR2(20);',
'BEGIN',
'    IF apex_application.g_x01 IS NULL',
'       OR apex_application.g_x02 IS NULL',
'    THEN',
'        RAISE_APPLICATION_ERROR(-20001, ''Missing issue context'');',
'    END IF;',
'',
'    v_entity_id   := TO_NUMBER(apex_application.g_x01);',
'    v_issue_level := UPPER(apex_application.g_x02);',
'',
'    IF v_issue_level NOT IN (''SESSION'',''MESSAGE'') THEN',
'        RAISE_APPLICATION_ERROR(-20002, ''Invalid issue level'');',
'    END IF;',
'',
'    l_url := apex_page.get_url(',
'        p_page   => 116,',
'        p_items  => ''P116_ENTITY_ID,P116_ISSUE_LEVEL'',',
'        p_values => v_entity_id || '','' || v_issue_level',
'    );',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', true);',
'    apex_json.write(''url'', l_url);',
'    apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151698561619556309
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151698972720556310)
,p_process_sequence=>190
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_PROJECT_SESSIONS'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.GET_PROJECT_SESSIONS'';',
'    v_project_id    NUMBER := TO_NUMBER(apex_application.g_x01);',
'    v_current_session_id NUMBER := TO_NUMBER(NVL(:P114_CHAT_SESSION_ID, 0));',
'    v_html          CLOB := '''';',
'    ',
'    CURSOR c_sessions IS',
'        SELECT ',
'            cs.session_id,',
'            cs.session_title,',
'            cs.message_count,',
'            cs.last_activity_date,',
'            -- Format last activity',
'            CASE ',
'                WHEN cs.last_activity_date >= TRUNC(SYSDATE) THEN',
'                    ''Today '' || TO_CHAR(cs.last_activity_date, ''HH24:MI'')',
'                WHEN cs.last_activity_date >= TRUNC(SYSDATE) - 1 THEN',
'                    ''Yesterday''',
'                WHEN cs.last_activity_date >= TRUNC(SYSDATE) - 7 THEN',
'                    TO_CHAR(cs.last_activity_date, ''Day'')',
'                ELSE',
'                    TO_CHAR(cs.last_activity_date, ''Mon DD'')',
'            END AS last_activity_display',
'        FROM chat_sessions cs',
'        WHERE cs.chat_project_id = v_project_id',
'          AND cs.is_active = ''Y''',
'        ORDER BY cs.last_activity_date DESC NULLS LAST;',
'        ',
'BEGIN',
'    -- Build sessions HTML',
'    FOR rec IN c_sessions LOOP',
'        v_html := v_html || ',
'            ''<div class="session-item '' || ',
'            CASE WHEN rec.session_id = v_current_session_id THEN ''active-session'' ELSE '''' END ||',
'            ''" data-session-id="'' || rec.session_id || ',
'            ''" data-project-id="'' || v_project_id || ',
'            ''" onclick="loadSession('' || rec.session_id || '')">'' ||',
'            ''<div class="session-icon">'' ||',
'                ''<svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">'' ||',
'                    ''<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>'' ||',
'                ''</svg>'' ||',
'            ''</div>'' ||',
'            ''<div class="session-info">'' ||',
'                ''<div class="session-title">'' || APEX_ESCAPE.HTML(rec.session_title) || ''</div>'' ||',
'                ''<div class="session-meta">'' ||',
'                    ''<span class="session-date">'' || rec.last_activity_display || ''</span>'';',
'                    ',
'        -- Add message count badge if > 0',
'        IF rec.message_count > 0 THEN',
'            v_html := v_html || ''<span class="message-badge">'' || rec.message_count || ''</span>'';',
'        END IF;',
'        ',
'        v_html := v_html || ''</div></div>'';',
'        ',
'        -- Add active indicator if current session',
'        IF rec.session_id = v_current_session_id THEN',
'            v_html := v_html || ''<span class="active-indicator"></span>'';',
'        END IF;',
'        ',
'        v_html := v_html || ''</div>'';',
'    END LOOP;',
'    ',
'    -- If no sessions found',
'    IF v_html IS NULL THEN',
'        v_html := ''<div class="no-sessions-message">'' ||',
'                    ''<svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">'' ||',
'                        ''<path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>'' ||',
'                    ''</svg>'' ||',
'                    ''No sessions in this project'' ||',
'                  ''</div>'';',
'    END IF;',
'    ',
'    -- Return HTML',
'    HTP.PRN(v_html);',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        HTP.PRN(''<div class="no-sessions-message">Error loading sessions</div>'');',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151698972720556310
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151699321457556311)
,p_process_sequence=>200
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'UPDATE_SESSION_TITLE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'',
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.UPDATE_SESSION_TITLE'';',
'    v_session_id    NUMBER := TO_NUMBER(apex_application.g_x01);',
'    v_new_title     VARCHAR2(200) := apex_application.g_x02;',
'    v_user_id       NUMBER:= v(''G_USER_ID'');',
'BEGIN',
'    -- Validate title',
'    IF v_new_title IS NULL OR LENGTH(TRIM(v_new_title)) = 0 THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''Title cannot be empty'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'    ',
' ',
'    ',
'    -- Update session title',
'    UPDATE  chat_sessions',
'    SET session_title = TRIM(v_new_title),',
'        last_activity_date = SYSTIMESTAMP',
'    WHERE session_id = v_session_id',
'      AND user_id = v_user_id;',
'    ',
'    IF SQL%ROWCOUNT = 0 THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''Session not found or access denied'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'    ',
'    COMMIT;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''User not found'');',
'        apex_json.close_object;',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151699321457556311
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151700124313556313)
,p_process_sequence=>230
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_NEW_SESSION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
' DECLARE',
'      vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.SAVE_NEW_SESSION'';',
'    v_session_id    NUMBER;',
'    v_user_id       NUMBER := V(''G_USER_ID'');',
'    v_project_id    NUMBER :=  :P114_NEW_SESSION_PROJECT_ID ; -- Current project',
'  -- v_project_id    NUMBER := TO_NUMBER(apex_application.g_x01);',
'',
'    v_session_title VARCHAR2(200) := :P114_NEW_SESSION_TITLE ;',
'   -- v_session_title VARCHAR2(200) := apex_application.g_x02 ;',
'',
'BEGIN',
'    -- Validate inputs',
'    IF v_session_title IS NULL OR TRIM(v_session_title) IS NULL THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''Session title is required'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'    ',
'    IF v_project_id IS NULL THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''No active project selected'');',
'        apex_json.close_object;',
'        RETURN;',
'    END IF;',
'    ',
'           -- Create new session',
'        v_session_id := chat_session_pkg.new_session(',
'            p_provider       => :P114_MODEL,',
'            p_model          => :P114_MODEL,',
'            p_session_title  => :P114_NEW_SESSION_TITLE,',
'            p_user_id        => v(''G_USER_ID''),',
'            p_app_session_id => :APP_SESSION,',
'            p_app_id         => :APP_ID,',
'            p_app_page_id    => :APP_PAGE_ID,',
'            p_project_id     => v(''G_CHAT_PROJECT_ID''),',
'            p_tenant_id      => v(''G_TENANT_ID'')',
'        );',
'',
'        :P114_NEW_SESSION_ID :=v_session_id;',
'        :P114_CHAT_SESSION_ID :=v_session_id;',
'    ',
'    COMMIT;',
'    ',
'    -- Return success',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.write(''session_id'', v_session_id);',
'    apex_json.write(''message'', ''Session created successfully'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''Error: '' || SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151700124313556313
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151700530576556314)
,p_process_sequence=>240
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_TO_FAVORITES'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.SAVE_TO_FAVORITES'';',
'    v_message_id NUMBER := apex_application.g_x01;',
'    v_session_id NUMBER := apex_application.g_x02;',
'    v_user_id NUMBER:= v(''G_USER_ID'');',
'BEGIN',
' ',
'    ',
'    -- Save to favorites (you may need to create this table)',
'    INSERT INTO chat_favorites (',
'        favorite_id,',
'        chat_session_id,',
'        chat_message_id,',
'        user_id,',
'        created_at',
'    ) VALUES (',
'        chat_favorites_seq.NEXTVAL,',
'        v_session_id,',
'        v_message_id,',
'        v_user_id,',
'        SYSTIMESTAMP',
'    );',
'    ',
'    COMMIT;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.write(''message'', ''Message saved to favorites'');',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN DUP_VAL_ON_INDEX THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''message'', ''Message already in favorites'');',
'        apex_json.close_object;',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151700530576556314
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151701392897556316)
,p_process_sequence=>260
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'PIN_TO_CONTEXT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE_ID||''.PIN_TO_CONTEXT'';',
'    v_message_id   NUMBER := apex_application.g_x01;',
'    v_session_id   NUMBER := apex_application.g_x02;',
'',
'    v_json_array   JSON_ARRAY_T;',
'BEGIN',
'    -- 1. Load existing JSON array or create new one',
'    SELECT CASE ',
'               WHEN pinned_message_ids IS NULL THEN JSON_ARRAY_T()',
'               ELSE JSON_ARRAY_T.parse(pinned_message_ids)',
'           END',
'    INTO v_json_array',
'    FROM chat_sessions',
'    WHERE session_id = v_session_id',
'    FOR UPDATE;',
'',
'    -- 2. Append the new pinned message ID',
'    v_json_array.append(v_message_id);',
'',
'    -- 3. Save it back',
'    UPDATE chat_sessions',
'    SET pinned_message_ids = v_json_array.to_clob',
'    WHERE session_id = v_session_id;',
'',
'    COMMIT;',
'',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.close_object;',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.close_object;',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>151701392897556316
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(151701712615556317)
,p_process_sequence=>270
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>' DELETE_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'     vcaller varchar2(30):= ''PROCESS_PAGE''||:APP_PAGE||''.XXXXXXXXX'';',
'    v_message_id NUMBER := apex_application.g_x01;',
'BEGIN',
'    -- Soft delete (mark as deleted)',
'    UPDATE  chat_Calls',
'    SET is_deleted = ''Y'',',
'        DELETED_TS = SYSTIMESTAMP ',
'    WHERE message_id = v_message_id;',
'    ',
'    COMMIT;',
'    ',
'    apex_json.open_object;',
'    apex_json.write(''success'', TRUE);',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        ROLLBACK;',
'        apex_json.open_object;',
'        apex_json.write(''success'', FALSE);',
'        apex_json.write(''error'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_internal_uid=>151701712615556317
);
wwv_flow_imp.component_end;
end;
/
