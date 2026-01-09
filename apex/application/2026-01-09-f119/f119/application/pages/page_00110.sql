prompt --application/pages/page_00110
begin
--   Manifest
--     PAGE: 00110
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
 p_id=>110
,p_name=>'Enterprise AI Assistant'
,p_alias=>'ENTERPRISE-AI-ASSISTANT'
,p_step_title=>'Enterprise AI Assistant'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// ========================================================',
'// GLOBAL variables',
'// ========================================================',
'let historyOffset = 0;',
'let historyPageSize = 50;',
'',
'let chatWindow;',
'let txtMessage;',
'let btnSend;',
'let typing;',
'',
'function addBubble() {}         // placeholder (real version in page load)',
'function loadHistory() {}       // placeholder',
'function sendMessageSSE() {}    // placeholder',
'function regenerateLLM() {}     // placeholder',
''))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
'apex.jQuery(function () {',
'',
unistr('    console.log("\D83D\DD35 Page 110 init start");'),
'',
'    // ============= DOM =============',
'    chatWindow = document.getElementById("chatWindow");',
'    txtMessage = document.getElementById("txtMessage");',
'    btnSend    = document.getElementById("btnSend");',
'    typing     = document.getElementById("typingIndicator");',
'',
'    function checkDOM(id, el) {',
unistr('        if (!el) console.error("\274C MISSING DOM ELEMENT:", id);'),
unistr('        else console.log("\2714 Found:", id);'),
'    }',
'',
'    checkDOM("chatWindow", chatWindow);',
'    checkDOM("txtMessage", txtMessage);',
'    checkDOM("btnSend", btnSend);',
'    checkDOM("typingIndicator", typing);',
'',
'    // STOP if critical missing',
'    if (!chatWindow || !btnSend || !txtMessage) {',
unistr('        console.error("\274C STOP \2014 Critical DOM missing");'),
'        return;',
'    }',
'',
'    // ============= addBubble =============',
'    addBubble = function(role, text, rag = null, parentId = null, regenerated = null) {',
'        try {',
'            const div = document.createElement("div");',
'            div.className = "chat-bubble " + (role === "USER" ? "chat-user" : "chat-assistant");',
'',
'            const content = document.createElement("div");',
'            content.innerText = text;',
'            div.appendChild(content);',
'',
'            if (rag) {',
'                const badge = document.createElement("div");',
'                badge.className = "rag-badge";',
unistr('                badge.innerText = "RAG \2022 " + rag;'),
'                div.appendChild(badge);',
'            }',
'',
'            if (regenerated === "Y") {',
'                const info = document.createElement("div");',
'                info.style.fontSize = "11px";',
'                info.style.color = "#888";',
'                info.innerText = "Regenerated from #" + parentId;',
'                div.appendChild(info);',
'            }',
'',
'            if (role === "ASSISTANT") {',
'                const btn = document.createElement("button");',
'                btn.className = "regen-btn";',
unistr('                btn.innerText = "\21BA Regenerate";'),
'                btn.onclick = () => regenerateLLM(parentId);',
'                div.appendChild(btn);',
'            }',
'',
'            chatWindow.appendChild(div);',
'            chatWindow.scrollTop = chatWindow.scrollHeight;',
'',
'        } catch (e) {',
unistr('            console.error("\274C ERROR in addBubble:", e);'),
'        }',
'    };',
'',
'    // ============= loadHistory =============',
'    loadHistory = function(append = false) {',
'',
unistr('        console.log("\D83D\DD35 loadHistory called\2026 offset=", historyOffset);'),
'',
'        apex.server.process("LOAD_CHAT_HISTORY", {',
'            x01: historyOffset,',
'            x02: historyPageSize',
'        }, {',
'            dataType: "json",',
'            success: function (data) {',
'                try {',
'',
'                    if (!data || !data.rows) {',
unistr('                        console.warn("\26A0 No history returned");'),
'                        return;',
'                    }',
'',
'                    if (!append) chatWindow.innerHTML = "";',
'',
'                    data.rows.reverse().forEach(m => {',
'                        addBubble(m.role, m.content, m.rag_context, m.parent_id, m.regenerated);',
'                    });',
'',
'                    historyOffset += data.rows.length;',
'',
'                    document.getElementById("loadMoreBtn").style.display =',
'                        (data.rows.length === historyPageSize ? "block" : "none");',
'',
'                } catch (e) {',
unistr('                    console.error("\274C ERROR in loadHistory:", e);'),
'                }',
'            },',
'            error: function(err){',
unistr('                console.error("\274C APEX loadHistory Ajax error:", err);'),
'            }',
'        });',
'    };',
'',
'    // ============= regenerate =============',
'    regenerateLLM = function(parentId) {',
unistr('        console.log("\D83D\DD35 regenerateLLM called\2026", parentId);'),
'',
'        apex.server.process("REGENERATE_ASSISTANT", {}, {',
'            dataType: "json",',
'            success: function (data) {',
'',
'                addBubble("ASSISTANT",',
'                    "[Regenerating...]", null, parentId, "Y"',
'                );',
'',
'                sendMessageSSE("regenerate");',
'            }',
'        });',
'    };',
'',
'    // ============= SSE =============',
' sendMessageSSE = async function(userText) {',
'    try {',
'        typing.style.display = "block";',
'        addBubble("USER", userText);',
'',
'        const payload = {',
'            provider: $v("P110_PROVIDER"),',
'            model: $v("P110_MODEL"),',
'            prompt: userText,',
'            user_id: "APEX_USER",',
'            user_name: "APEX_USER",',
'            app_session_id: $v("P110_CHAT_SESSION_ID"),',
'',
'            temperature: Number($v("P110_TEMPERATURE")),',
'            max_tokens: Number($v("P110_MAX_TOKENS")),',
'            top_p: Number($v("P110_TOP_P")),',
'            top_k: Number($v("P110_TOP_K")),',
'            json_mode: $v("P110_JSON_MODE")',
'        };',
'',
'        const response = await fetch("/ords/ai/ai/stream/chat", {',
'            method: "POST",',
'            headers: {',
'                "Content-Type": "application/json",',
'                "Accept": "text/event-stream"',
'            },',
'            body: JSON.stringify(payload)',
'        });',
'',
'        const reader = response.body.getReader();',
'        const decoder = new TextDecoder();',
'        let fullText = "";',
'',
'        while (true) {',
'            const {value, done} = await reader.read();',
'            if (done) break;',
'',
'            const chunk = decoder.decode(value, {stream: true});',
'            const lines = chunk.split("\n");',
'',
'            lines.forEach(line => {',
'                if (!line.startsWith("data:")) return;',
'                const data = line.substring(5).trim();',
'',
'                if (data === "[[END]]") {',
'                    typing.style.display = "none";',
'                    addBubble("ASSISTANT", fullText);',
'',
'                    apex.server.process("SAVE_ASSISTANT_MESSAGE", {x01: fullText});',
'',
'                    return;',
'                }',
'',
'                fullText += data;',
'            });',
'        }',
'    }',
'    catch (err) {',
unistr('        console.error("\274C SSE POST ERROR:", err);'),
'        typing.style.display = "none";',
'    }',
'};',
'',
'    // ============= SEND BUTTON =============',
'        btnSend.addEventListener("click", function(){',
'            const msg = txtMessage.value.trim();',
'            if (msg.length === 0) return;',
'',
'            txtMessage.value = "";',
'',
'            apex.server.process("SAVE_USER_MESSAGE", {x01: msg});',
'',
'            sendMessageSSE(msg);',
'        });',
'',
'    // ===========================================',
'    // INITIAL LOAD',
'    // ===========================================',
'    setTimeout(() => {',
unistr('        console.log("\D83D\DD35 Initial history load\2026");'),
'        loadHistory();',
'    }, 300);',
'',
'});',
''))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'.chat-window {',
'    max-width: 1200px;',
'    margin: 0 auto;',
'    padding: 16px;',
'    display: flex;',
'    flex-direction: column;',
'    gap: 14px;',
'}',
'',
'.chat-bubble {',
'    padding: 14px 18px;',
'    border-radius: 12px;',
'    max-width: 85%;',
'    font-size: 15px;',
'    line-height: 1.55;',
'    white-space: pre-line;',
'}',
'',
'.chat-user {',
'    background: #d0e8ff;',
'    align-self: flex-end;',
'    color: #003366;',
'}',
'',
'.chat-assistant {',
'    background: #f5f5f5;',
'    border: 1px solid #ddd;',
'    align-self: flex-start;',
'}',
'',
'.chat-system {',
'    background: #efefef;',
'    border-left: 4px solid #666;',
'    font-size: 13px;',
'    color: #555;',
'}',
'',
'/* RAG context badge */',
'.rag-badge {',
'    font-size: 11px;',
'    padding: 2px 6px;',
'    background: #eee;',
'    color: #666;',
'    border-radius: 4px;',
'    margin-top: 4px;',
'    display: inline-block;',
'}',
'',
'/* Typing indicator */',
'.typing-indicator {',
'    display: flex;',
'    gap: 6px;',
'    margin: 12px;',
'    padding-left: 6px;',
'}',
'',
'.typing-indicator .dot {',
'    width: 8px;',
'    height: 8px;',
'    background: #888;',
'    border-radius: 50%;',
'    animation: blink 1s infinite;',
'}',
'',
'@keyframes blink {',
'    0%   { opacity: 0.2; }',
'    50%  { opacity: 1; }',
'    100% { opacity: 0.2; }',
'}',
'',
'.typing-holder {',
'  display: flex;',
'  gap: 6px;',
'  margin-left: 20px;',
'}',
'.typing-holder .dot {',
'  width: 8px;',
'  height: 8px;',
'  border-radius: 50%;',
'  background: #999;',
'  animation: blink 1.2s infinite ease-in-out;',
'}',
'@keyframes blink {',
'  0% { opacity: 0.2; }',
'  50% { opacity: 1; }',
'  100% { opacity: 0.2; }',
'}',
'',
'.chat-window {',
'    height: 70vh;',
'    overflow-y: auto;',
'    padding: 15px;',
'    background: #fafafa;',
'    border-radius: 8px;',
'}',
'',
'.chat-bubble {',
'    margin: 10px 0;',
'    max-width: 80%;',
'}',
'',
'.chat-bubble.user {',
'    text-align: right;',
'}',
'',
'.chat-bubble.user .user-msg {',
'    background: #d1e7ff;',
'    display: inline-block;',
'    padding: 10px 14px;',
'    border-radius: 12px;',
'    color: #003366;',
'}',
'',
'.chat-bubble.assistant .assistant-msg {',
'    background: #ffffff;',
'    border: 1px solid #ddd;',
'    padding: 10px 14px;',
'    border-radius: 12px;',
'    display: inline-block;',
'}',
'',
'.chat-bubble.system-msg {',
'    text-align: center;',
'    color: #666;',
'    font-style: italic;',
'    padding: 5px;',
'}',
'.settings-panel {',
'    position: fixed;',
'    top: 0;',
'    right: -350px;',
'    width: 350px;',
'    height: 100vh;',
'    background: #ffffff;',
'    border-left: 1px solid #ddd;',
'    padding: 20px;',
'    transition: right 0.35s ease;',
'    overflow-y: auto;',
'    z-index: 900;',
'}',
'',
'.settings-panel.open {',
'    right: 0;',
'}',
'',
'.chat-history {',
'    max-height: 75vh;',
'    overflow-y: auto;',
'    padding: 15px;',
'}',
'',
'.chat-bubble {',
'    padding: 12px 15px;',
'    border-radius: 12px;',
'    margin: 10px 0;',
'    max-width: 80%;',
'    line-height: 1.4em;',
'}',
'',
'.chat-user {',
'    background: #2563eb;',
'    color: white;',
'    margin-left: auto;',
'}',
'',
'.chat-assistant {',
'    background: #e5e7eb;',
'    color: #111;',
'    margin-right: auto;',
'}',
'',
'.typing-indicator span {',
'    height: 8px;',
'    width: 8px;',
'    background: #999;',
'    border-radius: 50%;',
'    display: inline-block;',
'    margin-right: 4px;',
'    animation: blink 1.2s infinite;',
'}',
'',
'@keyframes blink {',
'    0% { opacity: .2 }',
'    20% { opacity: 1 }',
'    100% { opacity: .2 }',
'} ',
'',
'',
'',
'/******************************************************',
unistr('    \D83C\DFA8 Enterprise AI Assistant \2014 Premium Chat Theme'),
'    Author: ChatGPT',
'******************************************************/',
'',
'/* ---------------------------------------------------',
'   GLOBAL COLORS & VARIABLES',
'--------------------------------------------------- */',
':root {',
'    --bg-main: #f6f7f9;',
'    --bg-panel: rgba(255,255,255,0.8);',
'    --border-color: rgba(0,0,0,0.05);',
'    --text-color: #111;',
'    --assistant-bg: #ffffff;',
'    --assistant-border: #e2e2e2;',
'    --user-bg: #2563eb;',
'    --user-text: #fff;',
'',
'    --bubble-radius: 14px;',
'    --transition-fast: 0.15s ease;',
'    --transition-med: 0.25s ease;',
'',
'    --shadow-soft: 0 3px 12px rgba(0,0,0,0.08);',
'    --shadow-medium: 0 6px 20px rgba(0,0,0,0.12);',
'}',
'',
'/* ---------------------------------------------------',
'   PAGE BACKGROUND WITH SOFT GRADIENT',
'--------------------------------------------------- */',
'body#t_PageBody {',
'    background: linear-gradient(135deg, #e9eef7, #f8f9fc);',
'    backdrop-filter: blur(5px);',
'}',
'',
'/* ---------------------------------------------------',
'   CHAT HEADER',
'--------------------------------------------------- */',
'.chat-title {',
'    font-size: 1.8rem;',
'    font-weight: 600;',
'    color: #1e293b;',
'    padding: 10px 0 5px 0;',
'    border-bottom: 1px solid var(--border-color);',
'}',
'',
'/* ---------------------------------------------------',
'   CHAT HISTORY SCROLL AREA',
'--------------------------------------------------- */',
'#chatHistory {',
'    max-height: calc(75vh);',
'    overflow-y: auto;',
'    padding: 20px;',
'    scroll-behavior: smooth;',
'}',
'',
'/* Custom scrollbar */',
'#chatHistory::-webkit-scrollbar {',
'    width: 10px;',
'}',
'#chatHistory::-webkit-scrollbar-track {',
'    background: rgba(0,0,0,0.05);',
'    border-radius: 5px;',
'}',
'#chatHistory::-webkit-scrollbar-thumb {',
'    background: rgba(0,0,0,0.15);',
'    border-radius: 5px;',
'}',
'',
'/* ---------------------------------------------------',
'   CHAT BUBBLES',
'--------------------------------------------------- */',
'.chat-bubble {',
'    padding: 14px 18px;',
'    margin: 12px 0;',
'    font-size: 15px;',
'    max-width: 80%;',
'    line-height: 1.6;',
'    border-radius: var(--bubble-radius);',
'    box-shadow: var(--shadow-soft);',
'    position: relative;',
'    animation: fadeInUp 0.3s ease;',
'}',
'',
'/* User bubble */',
'.chat-user {',
'    background: var(--user-bg);',
'    color: var(--user-text);',
'    margin-left: auto;',
'}',
'',
'/* Assistant bubble */',
'.chat-assistant {',
'    background: var(--assistant-bg);',
'    border: 1px solid var(--assistant-border);',
'    margin-right: auto;',
'}',
'',
'/* Bubble fade animation */',
'@keyframes fadeInUp {',
'    from {',
'        opacity: 0; ',
'        transform: translateY(6px);',
'    }',
'    to {',
'        opacity: 1;',
'        transform: translateY(0);',
'    }',
'}',
'',
'/* ---------------------------------------------------',
'   TYPING INDICATOR (3 dots)',
'--------------------------------------------------- */',
'.typing-indicator {',
'    margin: 5px;',
'    padding: 10px 14px;',
'    background: #fff;',
'    border-radius: var(--bubble-radius);',
'    box-shadow: var(--shadow-soft);',
'    width: fit-content;',
'}',
'',
'.typing-indicator span {',
'    height: 8px;',
'    width: 8px;',
'    background: #bbb;',
'    border-radius: 50%;',
'    display: inline-block;',
'    margin-right: 5px;',
'    animation: typingBlink 1.3s infinite ease-in-out;',
'}',
'',
'.typing-indicator span:nth-child(2) { animation-delay: 0.2s; }',
'.typing-indicator span:nth-child(3) { animation-delay: 0.4s; }',
'',
'@keyframes typingBlink {',
'    0%, 100% { opacity: 0.2 }',
'    50% { opacity: 1 }',
'}',
'',
'/* ---------------------------------------------------',
'   MESSAGE ENTRY BAR',
'--------------------------------------------------- */',
'.chat-input-container {',
'    display: flex;',
'    align-items: center;',
'    gap: 10px;',
'    padding: 14px 18px;',
'    background: var(--bg-panel);',
'    backdrop-filter: blur(10px);',
'    border-top: 1px solid var(--border-color);',
'    position: sticky;',
'    bottom: 0;',
'    z-index: 100;',
'}',
'',
'.chat-input {',
'    flex: 1;',
'    border: 1px solid var(--border-color);',
'    padding: 10px 14px;',
'    border-radius: 10px;',
'    font-size: 15px;',
'    resize: none;',
'    box-shadow: inset 0 0 4px rgba(0,0,0,0.04);',
'    transition: var(--transition-fast);',
'}',
'',
'.chat-input:focus {',
'    outline: none;',
'    border-color: #2563eb;',
'    box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.15);',
'}',
'',
'/* Send button */',
'#btnSend {',
'    background: #2563eb;',
'    color: #fff !important;',
'    border-radius: 10px;',
'    padding: 10px 18px;',
'    font-size: 15px;',
'    box-shadow: var(--shadow-soft);',
'    border: none !important;',
'    transition: var(--transition-fast);',
'}',
'',
'#btnSend:hover {',
'    background: #1d4ed8;',
'    box-shadow: var(--shadow-medium);',
'}',
'',
'/* ---------------------------------------------------',
'   MODEL SETTINGS PANEL',
'--------------------------------------------------- */',
'#region_modelSettings {',
'    background: var(--bg-panel);',
'    padding: 15px;',
'    border-radius: 12px;',
'    box-shadow: var(--shadow-soft);',
'    border: 1px solid var(--border-color);',
'}',
'',
'/* Field labels inside settings panel */',
'#region_modelSettings .t-Form-label {',
'    font-weight: 600;',
'    color: #374151;',
'}',
'',
'/* ---------------------------------------------------',
'   FILE UPLOAD (future support)',
'--------------------------------------------------- */',
'.file-upload-placeholder {',
'    border: 2px dashed #cbd5e1;',
'    padding: 20px;',
'    text-align: center;',
'    border-radius: 12px;',
'    color: #64748b;',
'    margin-top: 12px;',
'    transition: var(--transition-fast);',
'}',
'.file-upload-placeholder:hover {',
'    border-color: #2563eb;',
'    color: #2563eb;',
'}',
'',
'/******************************************************',
'    END OF THEME',
'******************************************************/',
'.rag-badge {',
'    background: #eef0f3;',
'    color: #555;',
'    padding: 3px 6px;',
'    border-radius: 4px;',
'    font-size: 11px;',
'    display: inline-block;',
'    margin-top: 4px;',
'}',
'',
'.regen-btn {',
'    margin-top: 6px;',
'    background: #f1f1f1;',
'    border: 1px solid #ccc;',
'    padding: 4px 8px;',
'    font-size: 12px;',
'    border-radius: 6px;',
'    cursor: pointer;',
'}',
'.regen-btn:hover {',
'    background: #e3e3e3;',
'}',
''))
,p_step_template=>2526646919027767344
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(143301088258236514)
,p_plug_name=>'MAIN CONTAINER'
,p_title=>'AI Assistant'
,p_region_name=>'AI_CHAT_CONTAINER'
,p_icon_css_classes=>'fa-ai-sparkle-enlarge'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
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
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(144731657740653631)
,p_plug_name=>'messageEntry'
,p_region_name=>'messageEntry'
,p_parent_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<div class="chat-input-container">',
'    <textarea id="txtMessage" class="chat-input" placeholder="Write your message..."></textarea>',
'',
'    <button id="btnSend" class="a-Button a-Button--hot" type="button">Send</button>',
'',
'    <div id="localTypingIndicator" class="typing-indicator" style="display:none;">',
'        <span></span><span></span><span></span>',
'    </div>',
'</div>',
'',
'',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(144721608987178655)
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
 p_id=>wwv_flow_imp.id(144730710914653622)
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
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(144731729778653632)
,p_plug_name=>'Right Panel'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_03'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(144732353491653638)
,p_plug_name=>'JS Loader'
,p_region_name=>'chatScripts'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>80
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(144730847986653623)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(144730710914653622)
,p_button_name=>'BTN_SETTINGS'
,p_button_static_id=>'btnSettings'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>unistr('\2699 Settings')
,p_warn_on_unsaved_changes=>null
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(144731177919653626)
,p_button_sequence=>20
,p_button_plug_id=>wwv_flow_imp.id(144730710914653622)
,p_button_name=>'BTN_CLOSE_SETTINGS'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'  Close Settings'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-window-close-o'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143301234329236516)
,p_name=>'P110_CHAT_SESSION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143301391772236517)
,p_name=>'P110_STREAM_CHANNEL'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_item_default=>'APEX$CHAT110'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143301462720236518)
,p_name=>'P110_TYPING_FLAG'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_item_default=>'N'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143301687321236520)
,p_name=>'P110_PROVIDER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
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
 p_id=>wwv_flow_imp.id(143301790226236521)
,p_name=>'P110_MODEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Model'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT model_name AS display_value,',
'       model_code AS return_value',
'FROM   llm_provider_models',
'WHERE  is_active = ''Y''',
'  AND provider_code = :P110_PROVIDER',
'ORDER BY display_order;'))
,p_lov_cascade_parent_items=>'P110_PROVIDER'
,p_ajax_items_to_submit=>'P110_PROVIDER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143301848431236522)
,p_name=>'P110_UPLOADED_FILE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Uploaded File'
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
 p_id=>wwv_flow_imp.id(143304079750236544)
,p_name=>'P110_LLM_RESPONSE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Llm Response'
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
 p_id=>wwv_flow_imp.id(143304138113236545)
,p_name=>'P110_USER_PROMPT'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731657740653631)
,p_prompt=>'User Prompt'
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
 p_id=>wwv_flow_imp.id(143304209931236546)
,p_name=>'P110_SELECTED_PROVIDER'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Selected Provider'
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
 p_id=>wwv_flow_imp.id(143304349119236547)
,p_name=>'P110_SELECTED_MODEL'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Selected Model'
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
 p_id=>wwv_flow_imp.id(143304410457236548)
,p_name=>'P110_STREAM_ENABLED'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_item_default=>'Y'
,p_prompt=>'Stream Enabled'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(143304571259236549)
,p_name=>'P110_SESSION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Session Id'
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
 p_id=>wwv_flow_imp.id(143304605958236550)
,p_name=>'P110_CONTEXT_DOMAIN_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_prompt=>'Context Domain Id'
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
 p_id=>wwv_flow_imp.id(144729850111653613)
,p_name=>'P110_CHAT_HISTORY_JSON'
,p_item_sequence=>140
,p_item_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(144730249009653617)
,p_name=>'P110_TEMPERATURE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
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
 p_id=>wwv_flow_imp.id(144730325476653618)
,p_name=>'P110_TOP_P'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
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
 p_id=>wwv_flow_imp.id(144730474014653619)
,p_name=>'P110_MAX_TOKENS'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT default_temperature FROM llm_provider_models',
' WHERE model_code = :P110_MODEL;'))
,p_item_default_type=>'SQL_QUERY'
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
 p_id=>wwv_flow_imp.id(144730557304653620)
,p_name=>'P110_TOP_K'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144731729778653632)
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
 p_id=>wwv_flow_imp.id(144730618214653621)
,p_name=>'P110_JSON_MODE'
,p_item_sequence=>190
,p_item_plug_id=>wwv_flow_imp.id(143301088258236514)
,p_item_default=>'Y'
,p_prompt=>'Json Mode'
,p_display_as=>'NATIVE_YES_NO'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'use_defaults', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_computation(
 p_id=>wwv_flow_imp.id(144732476687653639)
,p_computation_sequence=>10
,p_computation_item=>'P110_CHAT_SESSION_ID'
,p_computation_point=>'BEFORE_HEADER'
,p_computation_type=>'EXPRESSION'
,p_computation_language=>'PLSQL'
,p_computation=>'RAWTOHEX(SYS_GUID())'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(144729418948653609)
,p_process_sequence=>80
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_USER_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_msg_id NUMBER;',
'BEGIN',
'    v_msg_id :=',
'        chat_message_pkg.add_message(',
'            p_session_id     => :P110_CHAT_SESSION_ID,',
'            p_message_role   => ''USER'',',
'            p_content        => apex_application.g_x01,',
'            p_params         => NULL,',
'            p_rag_context    => NULL,',
'            p_rag_doc_count  => NULL,',
'            p_input_tokens   => NULL,',
'            p_output_tokens  => NULL,',
'            p_total_tokens   => NULL,',
'            p_processing_ms  => NULL,',
'            p_metadata       => NULL',
'        );',
'',
'    HTP.p( JSON_OBJECT(''message_id'' VALUE v_msg_id) );',
'',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>144729418948653609
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(144729790998653612)
,p_process_sequence=>90
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SAVE_ASSISTANT_MESSAGE'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_msg_id NUMBER;',
'BEGIN',
'    v_msg_id :=',
'        chat_message_pkg.add_message(',
'            p_session_id     => :P110_CHAT_SESSION_ID,',
'            p_message_role   => ''ASSISTANT'',',
'            p_content        => apex_application.g_x01,',
'            p_params         => NULL,',
'            p_rag_context    => NULL,',
'            p_rag_doc_count  => NULL,',
'            p_input_tokens   => NULL,',
'            p_output_tokens  => NULL,',
'            p_total_tokens   => NULL,',
'            p_processing_ms  => NULL,',
'            p_metadata       => NULL',
'        );',
'',
'    HTP.p( JSON_OBJECT(''message_id'' VALUE v_msg_id) );',
'',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>144729790998653612
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(144730001469653615)
,p_process_sequence=>100
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_CHAT_HISTORY'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_offset NUMBER := NVL(TO_NUMBER(apex_application.g_x01), 0);  -- starting row',
'    v_limit  NUMBER := NVL(TO_NUMBER(apex_application.g_x02), 50); -- page size',
'    v_json   CLOB;',
'BEGIN',
'    APEX_JSON.initialize_clob_output;',
'',
'    APEX_JSON.open_object;',
'    APEX_JSON.write(''offset'', v_offset);',
'    APEX_JSON.write(''limit'',  v_limit);',
'',
'    APEX_JSON.open_array(''rows'');',
'',
'    FOR rec IN (',
'        SELECT ',
'            message_id,',
'            message_role,',
'            message_content,',
'            rag_context,',
'            is_regenerated,',
'            parent_message_id,',
'            TO_CHAR(message_timestamp,''YYYY-MM-DD HH24:MI:SS'') ts',
'        FROM ai_chat_messages',
'        WHERE session_id = :P110_CHAT_SESSION_ID',
'        ORDER BY message_seq DESC   -- newest first',
'        OFFSET v_offset ROWS',
'        FETCH NEXT v_limit ROWS ONLY',
'    )',
'    LOOP',
'        APEX_JSON.open_object;',
'        APEX_JSON.write(''id'',          rec.message_id);',
'        APEX_JSON.write(''role'',        rec.message_role);',
'        APEX_JSON.write(''content'',     rec.message_content);',
'        APEX_JSON.write(''timestamp'',   rec.ts);',
'        APEX_JSON.write(''rag_context'', rec.rag_context);',
'        APEX_JSON.write(''regenerated'', rec.is_regenerated);',
'        APEX_JSON.write(''parent_id'',   rec.parent_message_id);',
'        APEX_JSON.close_object;',
'    END LOOP;',
'',
'    APEX_JSON.close_array;',
'    APEX_JSON.close_object;',
'',
'    v_json := APEX_JSON.get_clob_output;',
'    APEX_JSON.free_output;',
'',
'    HTP.p(v_json);',
'END;',
''))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>144730001469653615
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(144732539449653640)
,p_process_sequence=>110
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'REGENERATE_ASSISTANT'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_new_msg NUMBER;',
'BEGIN',
'    v_new_msg := chat_message_pkg.regenerate(:P110_CHAT_SESSION_ID);',
'    HTP.p( JSON_OBJECT(''new_message_id'' VALUE v_new_msg) );',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>144732539449653640
);
wwv_flow_imp.component_end;
end;
/
