prompt --application/pages/page_00007
begin
--   Manifest
--     PAGE: 00007
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
 p_id=>7
,p_name=>'ChatPot - AI Assistant'
,p_alias=>'CHATPOT-AI-ASSISTANT2'
,p_step_title=>'ChatPot - AI Assistant'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'// ============================================================================',
'// CHAT SESSION MANAGER',
'// Manages current conversation context (like ChatGPT/Claude)',
'// ============================================================================',
'',
'var chatApp = {',
'    currentSessionId: null,',
'    isInitialized: false,',
'    ',
'    // ========================================================================',
'    // INITIALIZATION',
'    // ========================================================================',
'    ',
'    /**',
'     * Initialize chat application on page load',
'     */',
'    init: function() {',
'        console.log(''ChatApp: Initializing...'');',
'        ',
'        // Check if session_id passed via page item (from navigation)',
'        const sessionIdFromItem = apex.item(''P100_SESSION_ID'').getValue();',
'        ',
'        if (sessionIdFromItem && sessionIdFromItem !== '''') {',
'            console.log(''ChatApp: Loading existing session:'', sessionIdFromItem);',
'            this.loadSession(sessionIdFromItem);',
'        } else {',
'            console.log(''ChatApp: No session found, getting or creating...'');',
'            this.getOrCreateSession();',
'        }',
'',
'        //this.updateSendButtonState();',
'    },',
'    ',
'    // ========================================================================',
'    // SESSION OPERATIONS',
'    // ========================================================================',
'    ',
'    /**',
'     * Get existing session or create new one',
'     */',
'    getOrCreateSession: function(modelProvider = ''OPENAI'') {',
'        console.log(''ChatApp: Getting or creating session...'');',
'        ',
'        apex.server.process(',
'            ''GET_OR_CREATE_SESSION'',',
'            {',
'                x01: modelProvider  // Pass model provider',
'            },',
'            {',
'                dataType: ''json'',',
'                loadingIndicator: ''#chat-container'',',
'                success: function(data) {',
'                    if (data.status === ''success'') {',
'                        console.log(''ChatApp: Session ready:'', data.session_id);',
'                        ',
'                        chatApp.currentSessionId = data.session_id;',
'                        apex.item(''P100_SESSION_ID'').setValue(data.session_id);',
'                        ',
'                        // Load messages for this session',
'                        chatApp.loadMessages();',
'                        ',
'                        // Update UI',
'                        chatApp.updateSessionInfo(data);',
'                        ',
'                        chatApp.isInitialized = true;',
'                        ',
'                        // Show success if new session',
'                        if (data.is_new === ''true'') {',
'                            apex.message.showPageSuccess(''New conversation started'');',
'                        }',
'                    } else {',
'                        console.error(''ChatApp: Session initialization failed:'', data.error_message);',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            location: ''page'',',
'                            message: ''Failed to initialize chat session: '' + data.error_message',
'                        }]);',
'                    }',
'                },',
'                error: function(jqXHR, textStatus, errorThrown) {',
'                    console.error(''ChatApp: AJAX error:'', textStatus, errorThrown);',
'                    apex.message.showErrors([{',
'                        type: ''error'',',
'                        location: ''page'',',
'                        message: ''Unable to connect to chat service. Please refresh the page.''',
'                    }]);',
'                }',
'            }',
'        );',
'    },',
'    ',
'    /**',
'     * Create new chat session (like clicking "New Chat" button)',
'     */',
'    createNewSession: function(modelProvider = ''OPENAI'') {',
'        console.log(''ChatApp: Creating new session...'');',
'        ',
'        apex.server.process(',
'            ''CREATE_NEW_SESSION'',',
'            {',
'                x01: modelProvider',
'            },',
'            {',
'                dataType: ''json'',',
'                loadingIndicator: ''#chat-container'',',
'                success: function(data) {',
'                    if (data.status === ''success'') {',
'                        console.log(''ChatApp: New session created:'', data.session_id);',
'                        ',
'                        chatApp.currentSessionId = data.session_id;',
'                        apex.item(''P100_SESSION_ID'').setValue(data.session_id);',
'                        ',
'                        // Clear message display',
'                        chatApp.clearMessages();',
'                        ',
'                        // Refresh session history sidebar',
'                        chatApp.refreshSessionList();',
'                        ',
'                        apex.message.showPageSuccess(data.message);',
'                    } else {',
'                        apex.message.showErrors([{',
'                            type: ''error'',',
'                            location: ''page'',',
'                            message: ''Failed to create new session: '' + data.error_message',
'                        }]);',
'                    }',
'                },',
'                error: function(jqXHR, textStatus, errorThrown) {',
'                    console.error(''ChatApp: New session creation failed:'', textStatus, errorThrown);',
'                    apex.message.showErrors([{',
'                        type: ''error'',',
'                        location: ''page'',',
'                        message: ''Unable to create new session.''',
'                    }]);',
'                }',
'            }',
'        );',
'    },',
'    ',
'    /**',
'     * Load specific session (when user clicks from history)',
'     */',
'    loadSession: function(sessionId) {',
'        console.log(''ChatApp: Loading session:'', sessionId);',
'        ',
'        // Update current session',
'        this.currentSessionId = sessionId;',
'        apex.item(''P100_SESSION_ID'').setValue(sessionId);',
'        ',
'        // Load messages',
'        this.loadMessages();',
'        ',
'        // Update UI (optional: load session metadata)',
'        apex.server.process(',
'            ''LOAD_SESSION_MESSAGES'',',
'            {',
'                x01: sessionId',
'            },',
'            {',
'                dataType: ''json'',',
'                success: function(data) {',
'                    if (data.status === ''success'') {',
'                        chatApp.updateSessionInfo(data);',
'                    }',
'                }',
'            }',
'        );',
'    },',
'    ',
'    // ========================================================================',
'    // MESSAGE OPERATIONS',
'    // ========================================================================',
'    ',
'    /**',
'     * Load messages for current session',
'     */',
'    loadMessages: function() {',
'        console.log(''ChatApp: Loading messages for session:'', this.currentSessionId);',
'        ',
'        // Refresh messages region (assumes region static ID = ''messages'')',
'        if (apex.region(''messages'')) {',
'            apex.region(''messages'').refresh();',
'        }',
'    },',
'    ',
'    /**',
'     * Clear message display (for new session)',
'     */',
'    clearMessages: function() {',
'        console.log(''ChatApp: Clearing messages'');',
'        ',
'        // Clear message display area',
'        $(''#messages-container'').empty();',
'        ',
'        // Or refresh region if empty',
'        if (apex.region(''messages'')) {',
'            apex.region(''messages'').refresh();',
'        }',
'    },',
'    ',
'    /**',
'     * Send user message',
'     */',
'    sendMessage: function(messageContent) {',
'        if (!this.currentSessionId) {',
'            apex.message.showErrors([{',
'                type: ''error'',',
'                location: ''page'',',
'                message: ''No active session. Please refresh the page.''',
'            }]);',
'            return;',
'        }',
'        ',
'        console.log(''ChatApp: Sending message to session:'', this.currentSessionId);',
'        ',
'        // Your existing message send logic here',
'        // This would call your RAG processing',
'    },',
'    ',
'    // ========================================================================',
'    // UI UPDATES',
'    // ========================================================================',
'    ',
'    /**',
'     * Update session info display',
'     */',
'    updateSessionInfo: function(sessionData) {',
'        // Update session title if element exists',
'        if ($(''#current-session-title'').length) {',
'            $(''#current-session-title'').text(sessionData.session_title || ''Conversation'');',
'        }',
'        ',
'        // Update message count if element exists',
'        if ($(''#message-count'').length) {',
'            $(''#message-count'').text(sessionData.message_count || 0);',
'        }',
'    },',
'    ',
'    /**',
'     * Refresh session history list',
'     */',
'    refreshSessionList: function() {',
'        if (apex.region(''session-history'')) {',
'            apex.region(''session-history'').refresh();',
'        }',
'    },',
'',
'',
'',
'    /**',
' * Enable/disable send button based on prompt content',
' */',
'updateSendButtonState: function() {',
'    const promptValue = apex.item(''P100_PROMPT'').getValue();',
'    const sendButton = $(''#SEND_BTN'');',
'    ',
'    if (promptValue && promptValue.trim().length > 0) {',
'        // Enable button',
'        sendButton.prop(''disabled'', false)',
'                 .removeClass(''is-disabled'')',
'                 .attr(''aria-disabled'', ''false'');',
'    } else {',
'        // Disable button',
'        sendButton.prop(''disabled'', true)',
'                 .addClass(''is-disabled'')',
'                 .attr(''aria-disabled'', ''true'');',
'    }',
'},',
'    ',
'    // ========================================================================',
'    // UTILITY FUNCTIONS',
'    // ========================================================================',
'    ',
'    /**',
'     * Get current session ID',
'     */',
'    getCurrentSessionId: function() {',
'        return this.currentSessionId;',
'    },',
'    ',
'    /**',
'     * Check if app is initialized',
'     */',
'    isReady: function() {',
'        return this.isInitialized && this.currentSessionId !== null;',
'    }',
'};',
'',
'// ============================================================================',
'// AUTO-INITIALIZE ON PAGE LOAD',
'// ============================================================================',
'apex.jQuery(document).ready(function() {',
'    chatApp.init();',
'});'))
,p_javascript_code_onload=>wwv_flow_string.join(wwv_flow_t_varchar2(
' document.addEventListener("DOMContentLoaded", function() {',
'  const settings = document.getElementById("advanced-settings");',
'  const toggleBtn = document.getElementById("toggle-settings");',
'  const chatArea = document.getElementById("chat-area");',
'  const sendBtn = document.getElementById("send-btn");',
'  const input = document.getElementById("chat-input");',
'',
'  // Toggle advanced settings visibility',
'  toggleBtn.addEventListener("click", () => {',
'    settings.classList.toggle("hidden");',
'  });',
'',
'  // Send chat message (simple mockup)',
'  sendBtn.addEventListener("click", () => {',
'    const msg = input.value.trim();',
'    if (!msg) return;',
'',
'    // Add user message',
'    const userMsg = document.createElement("div");',
'    userMsg.className = "chat-message user";',
'    userMsg.textContent = msg;',
'    chatArea.appendChild(userMsg);',
'',
'    // Scroll down',
'    chatArea.scrollTop = chatArea.scrollHeight;',
'',
'    input.value = "";',
'',
'    // Simulate bot reply',
'    setTimeout(() => {',
'      const botMsg = document.createElement("div");',
'      botMsg.className = "chat-message bot";',
'      botMsg.textContent = "Processing your query...";',
'      chatArea.appendChild(botMsg);',
'      chatArea.scrollTop = chatArea.scrollHeight;',
'    }, 500);',
'  });',
'});'))
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
' /* Disabled send button styling */',
'.send-message-btn.is-disabled,',
'.send-message-btn:disabled {',
'    opacity: 0.5;',
'    cursor: not-allowed;',
'    pointer-events: none;',
'}',
'',
'.send-message-btn.is-disabled .t-Icon,',
'.send-message-btn:disabled .t-Icon {',
'    opacity: 0.5;',
'}',
'',
'/*//////////////////////////////*/',
'.chat-container {',
'  display: flex;',
'  flex-direction: column;',
'  height: 90vh;',
'  background: #f9fafb;',
'  border-radius: 12px;',
'  box-shadow: 0 0 10px rgba(0,0,0,0.1);',
'  overflow: hidden;',
'  position: relative;',
'}',
'',
'.chat-area {',
'  flex: 1;',
'  padding: 1rem;',
'  overflow-y: auto;',
'  background-color: #ffffff;',
'}',
'',
'.chat-message {',
'  margin: 0.5rem 0;',
'  padding: 0.8rem 1rem;',
'  border-radius: 8px;',
'  max-width: 80%;',
'  line-height: 1.4;',
'}',
'',
'.chat-message.user {',
'  background: #dbeafe;',
'  align-self: flex-end;',
'  margin-left: auto;',
'}',
'',
'.chat-message.bot {',
'  background: #e5e7eb;',
'  align-self: flex-start;',
'}',
'',
'.chat-message-thread {',
'  display: flex;',
'  align-items: center;',
'  padding: 0.8rem;',
'  border-top: 1px solid #e5e7eb;',
'  background: #fff;',
'}',
'',
'.chat-input-bar textarea {',
'  flex: 1;',
'  resize: none;',
'  padding: 0.5rem;',
'  border-radius: 8px;',
'  border: 1px solid #ccc;',
'  font-size: 0.9rem;',
'}',
'',
'.send-message-btn, .btn-settings {',
'  background: #2563eb;',
'  color: white;',
'  border: none;',
'  border-radius: 8px;',
'  margin-left: 0.5rem;',
'  padding: 0.6rem 0.9rem;',
'  cursor: pointer;',
'}',
'',
'.btn-settings {',
'  background: #6b7280;',
'}',
'',
'.btn-send:hover, .btn-settings:hover {',
'  opacity: 0.9;',
'}',
'',
'.advanced-settings {',
'  background: #f3f4f6;',
'  padding: 1rem;',
'  border-top: 1px solid #e5e7eb;',
'}',
'',
'.settings-grid {',
'  display: grid;',
'  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));',
'  gap: 1rem;',
'}',
'',
'.hidden {',
'  display: none;',
'}',
'',
'',
'/* ============================================================================',
'   SEND BUTTON - DISABLED STATE',
'   ============================================================================ */',
'',
'/* Disabled button appearance */',
'#SEND_BTN.is-disabled,',
'#SEND_BTN:disabled,',
'#SEND_BTN.apex_disabled {',
'    opacity: 0.5 !important;',
'    cursor: not-allowed !important;',
'    pointer-events: none !important;',
'    filter: grayscale(40%);',
'    transition: all 0.2s ease;',
'}',
'',
'/* Disabled button icon */',
'#SEND_BTN.is-disabled .t-Icon,',
'#SEND_BTN:disabled .t-Icon {',
'    opacity: 0.5;',
'}',
'',
'/* Prevent hover effects on disabled button */',
'#SEND_BTN.is-disabled:hover,',
'#SEND_BTN:disabled:hover {',
'    transform: none !important;',
'    box-shadow: none !important;',
'}',
'',
'/* ============================================================================',
'   CHARACTER COUNTER',
'   ============================================================================ */',
'',
'.char-counter {',
'    font-size: 0.875rem;',
'    margin-top: 0.5rem;',
'    padding: 0.25rem 0.5rem;',
'    text-align: right;',
'    font-weight: 500;',
'    transition: all 0.3s ease;',
'    border-radius: 4px;',
'}',
'',
'/* Empty state - no text entered */',
'.char-counter-empty {',
'    color: #6c757d;',
'    background-color: #f8f9fa;',
'    font-style: italic;',
'}',
'',
'/* Warning state - below minimum */',
'.char-counter-warning {',
'    color: #ff9800;',
'    background-color: #fff3e0;',
'    font-weight: 600;',
'}',
'',
'/* Error state - above maximum */',
'.char-counter-error {',
'    color: #f44336;',
'    background-color: #ffebee;',
'    font-weight: 600;',
'    animation: pulse-error 2s ease-in-out infinite;',
'}',
'',
'/* Valid state - within acceptable range */',
'.char-counter-valid {',
'    color: #4caf50;',
'    background-color: #e8f5e9;',
'}',
'',
'/* Pulse animation for errors */',
'@keyframes pulse-error {',
'    0%, 100% { opacity: 1; }',
'    50% { opacity: 0.7; }',
'}',
'',
'/* ============================================================================',
'   RESPONSIVE DESIGN',
'   ============================================================================ */',
'',
'@media (max-width: 768px) {',
'    .char-counter {',
'        font-size: 0.75rem;',
'        padding: 0.2rem 0.4rem;',
'    }',
'}',
'',
'/* ============================================================================',
'   ACCESSIBILITY',
'   ============================================================================ */',
'',
'/* High contrast mode support */',
'@media (prefers-contrast: high) {',
'    .char-counter-warning {',
'        border: 2px solid #ff9800;',
'    }',
'    ',
'    .char-counter-error {',
'        border: 2px solid #f44336;',
'    }',
'}',
'',
'/* Reduced motion support */',
'@media (prefers-reduced-motion: reduce) {',
'    .char-counter,',
'    #SEND_BTN {',
'        transition: none;',
'    }',
'    ',
'    @keyframes pulse-error {',
'        0%, 100% { opacity: 1; }',
'    }',
'}',
'',
'/* Override Oracle''s default AVP label width on this page only */',
'.t-AVPList--fixedLabelSmall {',
'  --ut-avp-label-width: 3rem !important;',
'}',
'',
'/* ============================================================================',
'   FIX: APEX Grid Layout - Expand RIGHT when LEFT hidden',
'   ============================================================================ */',
'',
'/* LEFT PANEL parent (col col-3) */',
'#LEFT_PANEL {',
'    transition: all 0.3s ease;',
'}',
'',
'/* When LEFT_PANEL is hidden, hide its parent column */',
'body:has(#LEFT_PANEL[style*="display: none"]) .col.col-3.col-start {',
'    display: none !important;',
'    width: 0 !important;',
'    flex: 0 0 0 !important;',
'}',
'',
'/* RIGHT PANEL parent (col col-9) - expand to full width */',
'body:has(#LEFT_PANEL[style*="display: none"]) .col.col-9.apex-col-auto.col-end {',
'    flex: 1 1 100% !important;',
'    max-width: 100% !important;',
'    width: 100% !important;',
'}',
'',
'/* Smooth transitions */',
'.col.col-3.col-start,',
'.col.col-9.apex-col-auto.col-end {',
'    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);',
'}',
'/* Keep row as flex ALWAYS */',
'body .row,',
'.t-Region-body > div[class*="row"] {',
'    display: flex !important;',
'    flex-wrap: nowrap !important;',
'}',
'',
'/* Grid columns */',
'.col {',
'    flex-shrink: 0;',
'}',
'',
'',
'/* ============================================',
'   CHATGPT-STYLE PROMPT INTERFACE',
'   Oracle AI ChatPot - Page 100',
'   ============================================ */',
'',
'/* 1. CONTAINER - Main prompt wrapper */',
'.chatgpt-prompt-container {',
'  max-width: 1024px;',
'  margin: 40px auto;',
'  padding: 0 20px;',
'}',
'',
'/* 2. INPUT WRAPPER - Rounded container with shadow */',
'.prompt-input-wrapper {',
'  display: flex;',
'  align-items: center;',
'  gap: 12px;',
'  background: #ffffff;',
'  border: 1px solid #d1d5db;',
'  border-radius: 24px;',
'  padding: 12px 16px;',
'  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);',
'  transition: all 0.2s ease;',
'}',
'',
'.prompt-input-wrapper:focus-within {',
'  border-color: #3b82f6;',
'  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.15);',
'}',
'',
'/* 3. TEXTAREA - Auto-expanding input */',
'.chatgpt-prompt-input {',
'  flex: 1;',
'  border: none;',
'  outline: none;',
'  resize: none;',
'  font-size: 16px;',
'  line-height: 1.5;',
'  max-height: 200px;',
'  overflow-y: auto;',
'  font-family: -apple-system, BlinkMacSystemFont, ''Segoe UI'', Roboto, sans-serif;',
'}',
'',
'.chatgpt-prompt-input::placeholder {',
'  color: #9ca3af;',
'}',
'',
'/* 4. ACTION BUTTONS - Plus, Mic, Voice Chat */',
'.prompt-action-btn {',
'  width: 40px;',
'  height: 40px;',
'  border: none;',
'  background: transparent;',
'  border-radius: 50%;',
'  display: flex;',
'  align-items: center;',
'  justify-content: center;',
'  cursor: pointer;',
'  transition: all 0.2s ease;',
'  color: #6b7280;',
'}',
'',
'.prompt-action-btn:hover {',
'  background: #f3f4f6;',
'  color: #111827;',
'}',
'',
'.prompt-action-btn:active {',
'  transform: scale(0.95);',
'}',
'',
'/* Microphone Active State */',
'.mic-toggle[data-mic-state="on"] {',
'  background: #ef4444;',
'  color: white;',
'  animation: pulse 1.5s infinite;',
'}',
'',
'@keyframes pulse {',
'  0%, 100% { opacity: 1; }',
'  50% { opacity: 0.7; }',
'}',
'',
'/* 5. SUBMIT BUTTON - Primary action */',
'.prompt-submit-btn {',
'  width: 40px;',
'  height: 40px;',
'  border: none;',
'  background: #3b82f6;',
'  color: white;',
'  border-radius: 50%;',
'  display: flex;',
'  align-items: center;',
'  justify-content: center;',
'  cursor: pointer;',
'  transition: all 0.2s ease;',
'}',
'',
'.prompt-submit-btn:hover {',
'  background: #2563eb;',
'  transform: scale(1.05);',
'}',
'',
'.prompt-submit-btn:disabled {',
'  background: #d1d5db;',
'  cursor: not-allowed;',
'}',
'',
'/* 6. FOOTER - Clear button */',
'.prompt-footer {',
'  margin-top: 12px;',
'  text-align: center;',
'}',
'',
'.prompt-clear-btn {',
'  border: none;',
'  background: transparent;',
'  color: #6b7280;',
'  font-size: 14px;',
'  cursor: pointer;',
'  padding: 8px 16px;',
'  border-radius: 8px;',
'}',
'',
'.prompt-clear-btn:hover {',
'  background: #f3f4f6;',
'}',
'',
'/* 7. RESPONSIVE DESIGN */',
'@media (max-width: 768px) {',
'  .chatgpt-prompt-container {',
'    padding: 0 12px;',
'    margin: 20px auto;',
'  }',
'  ',
'  .prompt-input-wrapper {',
'    padding: 10px 12px;',
'  }',
'  ',
'  .prompt-action-btn,',
'  .prompt-submit-btn {',
'    width: 36px;',
'    height: 36px;',
'  }',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(272688711710330244)
,p_plug_name=>'session'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:is-collapsed:t-Region--scrollBody'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>30
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'     <div style="font-family: monospace; padding: 20px; background: #f5f5f5;">',
'         <h2>Session Variables</h2>',
'         <table border="1" cellpadding="10">',
'             <tr>',
'                 <td><strong>APP_USER</strong></td>',
'                 <td>&APP_USER.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_USER_ROLE_ID</strong></td>',
'                 <td>&G_USER_ROLE_ID.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_USER_ROLE_NAME</strong></td>',
'                 <td>&G_USER_ROLE_NAME.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_CLASSIFICATION_LEVEL</strong></td>',
'                 <td>&G_CLASSIFICATION_LEVEL.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_SESSION_START</strong></td>',
'                 <td>&G_SESSION_START.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_TENANT_ID</strong></td>',
'                 <td>&G_TENANT_ID.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_TENANT_CODE</strong></td>',
'                 <td>&G_TENANT_CODE.</td>',
'             </tr>',
'             <tr>',
'                 <td><strong>G_TENANT_NAME</strong></td>',
'                 <td>&G_TENANT_NAME.</td>',
'             </tr>',
'         </table>',
'     </div>'))
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(273708050944923746)
,p_name=>'CHAT_SESSION'
,p_title=>'Current Chat session'
,p_region_name=>'messages'
,p_parent_plug_id=>wwv_flow_imp.id(272688711710330244)
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_component_template_options=>'#DEFAULT#:t-Report--altRowsDefault:t-Report--rowHighlight'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    message_id,',
'    message_seq,',
'    message_role,',
'    message_content,',
'    TO_CHAR(message_timestamp, ''HH24:MI:SS'') as time_display,',
'    token_count_total,',
'    processing_time_ms,',
'    CASE ',
'        WHEN message_role = ''USER'' THEN ''user-message''',
'        WHEN message_role = ''ASSISTANT'' THEN ''assistant-message''',
'        ELSE ''system-message''',
'    END as css_class',
'FROM ai_chat_messages',
'WHERE  session_id = TO_NUMBER(:P7_SESSION_ID) ',
'       AND :P7_SESSION_ID IS NOT NULL   ',
'ORDER BY message_seq',
'',
'',
'        '))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P7_SESSION_ID'
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
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137236475021135435)
,p_query_column_id=>1
,p_column_alias=>'MESSAGE_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Message Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137236826268135436)
,p_query_column_id=>2
,p_column_alias=>'MESSAGE_SEQ'
,p_column_display_sequence=>20
,p_column_heading=>'Message Seq'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137237226195135437)
,p_query_column_id=>3
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>30
,p_column_heading=>'Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137237615351135438)
,p_query_column_id=>4
,p_column_alias=>'MESSAGE_CONTENT'
,p_column_display_sequence=>40
,p_column_heading=>'Message Content'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137238013597135439)
,p_query_column_id=>5
,p_column_alias=>'TIME_DISPLAY'
,p_column_display_sequence=>50
,p_column_heading=>'Time Display'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137238414329135440)
,p_query_column_id=>6
,p_column_alias=>'TOKEN_COUNT_TOTAL'
,p_column_display_sequence=>60
,p_column_heading=>'Token Count Total'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137238862808135441)
,p_query_column_id=>7
,p_column_alias=>'PROCESSING_TIME_MS'
,p_column_display_sequence=>70
,p_column_heading=>'Processing Time Ms'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137239200014135442)
,p_query_column_id=>8
,p_column_alias=>'CSS_CLASS'
,p_column_display_sequence=>80
,p_column_heading=>'Css Class'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(272688960027330247)
,p_plug_name=>'CONTAINER'
,p_region_css_classes=>'chat-container'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>20
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(272689415877330251)
,p_plug_name=>'RIGHT_PANEL'
,p_region_name=>'RIGHT_PANEL'
,p_parent_plug_id=>wwv_flow_imp.id(272688960027330247)
,p_region_template_options=>'#DEFAULT#:margin-top-none:margin-bottom-none:margin-left-none:margin-right-none'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_new_grid_row=>false
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(137178709835539921)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(272689415877330251)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'<!-- ChatGPT-Inspired Prompt Container -->',
'<div class="chatgpt-prompt-container">',
'  <div class="prompt-input-wrapper">',
'    <!-- Plus Sign (New Chat/Attachment) -->',
'    <button class="prompt-action-btn" id="btn-new-chat" title="New Chat">',
'      <i class="fa fa-plus"></i>',
'    </button>',
'    ',
'    <!-- Auto-Expanding Textarea -->',
'    <textarea id="P100_PROMPT" ',
'              class="chatgpt-prompt-input" ',
'              placeholder="Ask anything..."',
'              rows="1"></textarea>',
'    ',
'    <!-- Voice Controls Container -->',
'    <div class="prompt-voice-controls">',
'      <!-- Microphone Toggle -->',
'      <button class="prompt-action-btn mic-toggle" ',
'              id="btn-mic-toggle" ',
'              title="Toggle Microphone"',
'              data-mic-state="off">',
'        <i class="fa fa-microphone"></i>',
'      </button>',
'      ',
'      <!-- Voice Chat Mode -->',
'      <button class="prompt-action-btn voice-chat" ',
'              id="btn-voice-chat" ',
'              title="Voice Chat Mode">',
'        <svg class="voice-wave-icon" viewBox="0 0 24 24">',
'          <!-- Voice wave animation icon -->',
'        </svg>',
'      </button>',
'    </div>',
'    ',
'    <!-- Submit/Send Button -->',
'    <button class="prompt-submit-btn" id="btn-submit" title="Send">',
'      <i class="fa fa-paper-plane"></i>',
'    </button>',
'  </div>',
'  ',
'  <!-- Optional: Clear Button Below -->',
'  <div class="prompt-footer">',
'    <button class="prompt-clear-btn" id="btn-clear">',
'      <i class="fa fa-eraser"></i> Clear',
'    </button>',
'  </div>',
'</div>',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(272689211335330249)
,p_name=>'SELECTED_SESSION'
,p_parent_plug_id=>wwv_flow_imp.id(272689415877330251)
,p_template=>4501440665235496320
,p_display_sequence=>10
,p_region_css_classes=>'chat-header-bar'
,p_region_template_options=>'#DEFAULT#'
,p_component_template_options=>'#DEFAULT#:t-Report--stretch:t-Report--altRowsDefault:t-Report--rowHighlight:t-Report--noBorders'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'      message_id,',
'      session_id,',
'      message_seq,',
'      message_role,',
'      message_content,',
'      TO_CHAR(message_timestamp, ''HH24:MI:SS'') AS time_display,',
'      token_count_total,',
'      processing_time_ms,',
'      CASE ',
'          WHEN message_role = ''USER'' THEN ''user-message''',
'          WHEN message_role = ''ASSISTANT'' THEN ''assistant-message''',
'          WHEN message_role = ''SYSTEM'' THEN ''system-message''',
'      END AS message_css_class,',
'      CASE ',
unistr('          WHEN message_role = ''USER'' THEN ''\D83D\DCAC'''),
unistr('          WHEN message_role = ''ASSISTANT'' THEN ''\D83E\DD16'''),
unistr('          ELSE ''\2139\FE0F'''),
'      END AS role_icon,',
'      user_feedback,',
'      CASE ',
unistr('          WHEN user_feedback = ''POSITIVE'' THEN ''\D83D\DC4D'''),
unistr('          WHEN user_feedback = ''NEGATIVE'' THEN ''\D83D\DC4E'''),
'          ELSE ''''',
'      END AS feedback_icon',
'  FROM ai_chat_messages',
'  WHERE session_id = :P7_SESSION_ID',
'  ORDER BY message_seq'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P7_SESSION_ID'
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
 p_id=>wwv_flow_imp.id(137241437692135450)
,p_query_column_id=>1
,p_column_alias=>'MESSAGE_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137241808590135451)
,p_query_column_id=>2
,p_column_alias=>'SESSION_ID'
,p_column_display_sequence=>20
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137242276270135452)
,p_query_column_id=>3
,p_column_alias=>'MESSAGE_SEQ'
,p_column_display_sequence=>30
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137242609986135453)
,p_query_column_id=>4
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>40
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137243026883135454)
,p_query_column_id=>5
,p_column_alias=>'MESSAGE_CONTENT'
,p_column_display_sequence=>50
,p_column_heading=>'Message Content'
,p_column_html_expression=>wwv_flow_string.join(wwv_flow_t_varchar2(
' <div class="message-bubble #MESSAGE_CSS_CLASS#" data-message-id="#MESSAGE_ID#">',
'          <div class="message-header">',
'              <span class="role-label">#ROLE_ICON# #MESSAGE_ROLE#</span>',
'              <span class="message-time">#TIME_DISPLAY#</span>',
'          </div>',
'          <div class="message-body">',
'              #MESSAGE_CONTENT#',
'          </div>',
'          <div class="message-footer">',
unistr('              <button class="copy-btn" data-message-id="#MESSAGE_ID#">\D83D\DCCB Copy</button>'),
'              <button class="feedback-btn" data-message-id="#MESSAGE_ID#">#FEEDBACK_ICON#</button>',
'              <span class="token-badge">#TOKEN_COUNT_TOTAL# tokens</span>',
'          </div>',
'      </div>'))
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137243468054135455)
,p_query_column_id=>6
,p_column_alias=>'TIME_DISPLAY'
,p_column_display_sequence=>60
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137243892938135456)
,p_query_column_id=>7
,p_column_alias=>'TOKEN_COUNT_TOTAL'
,p_column_display_sequence=>70
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137244279360135457)
,p_query_column_id=>8
,p_column_alias=>'PROCESSING_TIME_MS'
,p_column_display_sequence=>80
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137244620999135458)
,p_query_column_id=>9
,p_column_alias=>'MESSAGE_CSS_CLASS'
,p_column_display_sequence=>90
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137245097478135459)
,p_query_column_id=>10
,p_column_alias=>'ROLE_ICON'
,p_column_display_sequence=>100
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137245464780135460)
,p_query_column_id=>11
,p_column_alias=>'USER_FEEDBACK'
,p_column_display_sequence=>110
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137245848228135461)
,p_query_column_id=>12
,p_column_alias=>'FEEDBACK_ICON'
,p_column_display_sequence=>120
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(272689500662330252)
,p_plug_name=>'PROMPT'
,p_parent_plug_id=>wwv_flow_imp.id(272689415877330251)
,p_region_css_classes=>'chat-message-thread'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(272689715447330254)
,p_plug_name=>'ADVANCED_SETTINGS'
,p_title=>'Advanced Settings'
,p_region_name=>'ADVANCED_SETTINGS'
,p_parent_plug_id=>wwv_flow_imp.id(272689415877330251)
,p_region_css_classes=>'advanced-settings'
,p_icon_css_classes=>'fa-sliders-h'
,p_region_template_options=>'#DEFAULT#:js-useLocalStorage:t-Region--hideShowIconsMath:t-Region--controlsPosEnd:is-collapsed:t-Region--accent12:t-Region--noUI:t-Region--scrollBody:t-Form--labelsAbove'
,p_plug_template=>2664334895415463485
,p_plug_display_sequence=>40
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(274411879979675326)
,p_plug_name=>'LEFT_PANEL'
,p_region_name=>'LEFT_PANEL'
,p_parent_plug_id=>wwv_flow_imp.id(272688960027330247)
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>10
,p_plug_new_grid_row=>false
,p_plug_grid_column_span=>3
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(272689067922330248)
,p_name=>'CHAT_HISTORY'
,p_title=>'History'
,p_region_name=>'session-history'
,p_parent_plug_id=>wwv_flow_imp.id(274411879979675326)
,p_template=>4072358936313175081
,p_display_sequence=>10
,p_region_css_classes=>'chat-sidebar'
,p_region_template_options=>'#DEFAULT#:t-Region--showIcon:t-Region--accent14:t-Region--scrollBody:t-Form--noPadding:t-Form--leftLabels'
,p_component_template_options=>'#DEFAULT#:t-AVPList--fixedLabelSmall:t-AVPList--leftAligned'
,p_display_point=>'SUB_REGIONS'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    session_id,',
'    session_title,',
'    TO_CHAR(last_activity_date, ''MM/DD HH24:MI'') as last_activity,',
'    message_count,',
'    CASE ',
'        WHEN :P7_SESSION_ID IS NOT NULL ',
'             AND session_id = TO_NUMBER(:P7_SESSION_ID) THEN ''active-session''',
'        ELSE ''''',
'    END as css_class',
'FROM ai_chat_sessions',
'WHERE user_id =  (select user_id from users u where user_name =:APP_USER )',
'  AND is_active = ''Y''',
'ORDER BY ',
'    is_pinned DESC,',
'    last_activity_date DESC',
'FETCH FIRST 20 ROWS ONLY'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P7_SESSION_ID'
,p_lazy_loading=>false
,p_query_row_template=>2100515124465797522
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_break_cols=>'1'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_break_type_flag=>'DEFAULT_BREAK_FORMATTING'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137256261194135492)
,p_query_column_id=>1
,p_column_alias=>'SESSION_ID'
,p_column_display_sequence=>10
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137256603911135493)
,p_query_column_id=>2
,p_column_alias=>'SESSION_TITLE'
,p_column_display_sequence=>30
,p_column_heading=>'Session Title'
,p_column_link=>'f?p=&APP_ID.:100:&SESSION.::&DEBUG.:RP:P100_SESSION_ID:#SESSION_ID#'
,p_column_linktext=>'#SESSION_TITLE#'
,p_heading_alignment=>'LEFT'
,p_display_as=>'WITHOUT_MODIFICATION'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137257063696135494)
,p_query_column_id=>3
,p_column_alias=>'LAST_ACTIVITY'
,p_column_display_sequence=>60
,p_column_heading=>'Last Activity'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137257489456135495)
,p_query_column_id=>4
,p_column_alias=>'MESSAGE_COUNT'
,p_column_display_sequence=>50
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(137257807382135496)
,p_query_column_id=>5
,p_column_alias=>'CSS_CLASS'
,p_column_display_sequence=>70
,p_hidden_column=>'Y'
,p_derived_column=>'N'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(274411944049675327)
,p_plug_name=>'CTRL_BTN_BAR'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>2126429139436695430
,p_plug_display_sequence=>20
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137246937804135464)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(272689500662330252)
,p_button_name=>'REGENERATE_BTN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Regenerate'
,p_button_condition=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT 1',
'  FROM ai_chat_messages',
'  WHERE session_id = :P7_SESSION_ID',
'    AND message_seq = (',
'        SELECT MAX(message_seq)',
'        FROM ai_chat_messages',
'        WHERE session_id = :P7_SESSION_ID',
'    )',
'    AND message_role = ''ASSISTANT'''))
,p_button_condition_type=>'EXISTS'
,p_icon_css_classes=>'fa-redo'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137247339345135465)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(272689500662330252)
,p_button_name=>'SEND_BTN'
,p_button_static_id=>'SEND_BTN'
,p_button_action=>'SUBMIT'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_is_hot=>'Y'
,p_button_image_alt=>unistr('\D83D\DE80 Ask ChatPot ')
,p_button_css_classes=>'send-message-btn'
,p_icon_css_classes=>'fa-paper-plane'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137247723845135466)
,p_button_sequence=>50
,p_button_plug_id=>wwv_flow_imp.id(272689500662330252)
,p_button_name=>'CLEAR_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--iconLeft'
,p_button_template_id=>2082829544945815391
,p_button_image_alt=>'Clear '
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-eraser'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137248197714135467)
,p_button_sequence=>60
,p_button_plug_id=>wwv_flow_imp.id(272689500662330252)
,p_button_name=>'REFRESH_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Refresh'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'N'
,p_grid_new_column=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137258980636135499)
,p_button_sequence=>80
,p_button_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_button_name=>'SETTINGS_BTN'
,p_button_static_id=>'SETTINGS_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--padRight:t-Button--gapTop'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Settings Btn'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-cog'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137259317280135500)
,p_button_sequence=>90
,p_button_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_button_name=>'EXPORT_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--padRight:t-Button--gapTop'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Export'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-download'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137259712304135501)
,p_button_sequence=>100
,p_button_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_button_name=>'Panel_Toggle_ptn'
,p_button_static_id=>'PANEL_TOGGLE_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_image_alt=>'Left Panel Toggle'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-arrow-circle-o-left'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(137258547166135498)
,p_button_sequence=>110
,p_button_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_button_name=>'NEW_CHAT_BTN'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#:t-Button--large:t-Button--noUI:t-Button--iconLeft:t-Button--gapTop'
,p_button_template_id=>2082829544945815391
,p_button_is_hot=>'Y'
,p_button_image_alt=>'New Chat'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-plus'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(259741962943480884)
,p_name=>'P7_PROMPT'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(272689500662330252)
,p_prompt=>'Your Question'
,p_placeholder=>'How can I help today!'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cMaxlength=>4000
,p_cHeight=>4
,p_field_template=>1609122147107268652
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'Y',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(259743117200480890)
,p_name=>'P7_PROCESSING_STATUS'
,p_item_sequence=>110
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_prompt=>'Status'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P7_PROCESSING_STATUS'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>2040785906935475274
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(259753711598480918)
,p_name=>'P7_MODEL_NAME'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT model_code  ',
'FROM LLM_PROVIDER_MODELS ',
'WHERE is_active = ''Y'' ',
'  AND provider_code = NVL(:P7_MODEL_PROVIDER, ''OPENAI'')  ',
'  AND is_default = ''Y'' ',
'  AND ROWNUM = 1'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Model'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  SELECT ',
'      provider_code || '' - '' || model_name AS display_value,',
'      model_code AS return_value',
'  FROM LLM_PROVIDER_MODELS',
'  WHERE is_active = ''Y''',
'    AND provider_code = :P7_MODEL_PROVIDER',
'  ORDER BY ',
'      CASE WHEN is_default = ''Y'' THEN 0 ELSE 1 END,',
'      display_order NULLS LAST,',
'      model_name',
' '))
,p_lov_cascade_parent_items=>'P7_MODEL_PROVIDER'
,p_ajax_optimize_refresh=>'Y'
,p_cHeight=>1
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(259754132147480922)
,p_name=>'P7_TOKEN_COUNT'
,p_item_sequence=>40
,p_item_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_item_default=>'000.000.000'
,p_prompt=>'Tokens Used'
,p_format_mask=>'999,999'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_display_when=>'P7_PROCESSING_STATUS'
,p_display_when_type=>'ITEM_IS_NOT_NULL'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(259755724357480926)
,p_name=>'P7_CONTEXT_JSON'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_protection_level=>'S'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272694761104330275)
,p_name=>'P7_SESSION_ID'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(272688960027330247)
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'N')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272694925282330276)
,p_name=>'P7_SESSION_UUID'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(272688960027330247)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT session_uuid',
'    FROM ai_chat_sessions',
'    WHERE session_id = :P7_SESSION_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_display_as=>'NATIVE_HIDDEN'
,p_is_persistent=>'N'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704495892330305)
,p_name=>'P7_TEMPERATURE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'0.7'
,p_prompt=>'Temperature'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  Controls randomness. Lower = more focused, higher = more creative.',
'  Range: 0.0 - 1.0'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '1',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'0.1'
,p_quick_pick_value_01=>'0.1'
,p_quick_pick_label_02=>'0.2'
,p_quick_pick_value_02=>'0.2'
,p_quick_pick_label_03=>'0.3'
,p_quick_pick_value_03=>'0.3'
,p_quick_pick_label_04=>'0.4'
,p_quick_pick_value_04=>'0.4'
,p_quick_pick_label_05=>'0.5'
,p_quick_pick_value_05=>'0.5'
,p_quick_pick_label_06=>'0.6'
,p_quick_pick_value_06=>'0.6'
,p_quick_pick_label_07=>'0.7'
,p_quick_pick_value_07=>'0.7'
,p_quick_pick_label_08=>'0.8'
,p_quick_pick_value_08=>'0.8'
,p_quick_pick_label_09=>'0.9'
,p_quick_pick_value_09=>'0.9'
,p_quick_pick_label_10=>'1'
,p_quick_pick_value_10=>'1'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704504496330306)
,p_name=>'P7_TOP_P'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'1.0'
,p_prompt=>'Top P (Nucleus Sampling)'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
' |',
'  Controls diversity via nucleus sampling. Recommended to alter this OR temperature, not both.',
'  Range: 0.0 - 1.0'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '1',
  'min_value', '0',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
,p_show_quick_picks=>'Y'
,p_quick_pick_label_01=>'0.05'
,p_quick_pick_value_01=>'0.05'
,p_quick_pick_label_02=>'0.10'
,p_quick_pick_value_02=>'0.10'
,p_quick_pick_label_03=>'0.20'
,p_quick_pick_value_03=>'0.20'
,p_quick_pick_label_04=>'0.30'
,p_quick_pick_value_04=>'0.30'
,p_quick_pick_label_05=>'0.40'
,p_quick_pick_value_05=>'0.40'
,p_quick_pick_label_06=>'0.50'
,p_quick_pick_value_06=>'0.50'
,p_quick_pick_label_07=>'0.60'
,p_quick_pick_value_07=>'0.60'
,p_quick_pick_label_08=>'0.70'
,p_quick_pick_value_08=>'0.70'
,p_quick_pick_label_09=>'0.80'
,p_quick_pick_value_09=>'0.80'
,p_quick_pick_label_10=>'0.90'
,p_quick_pick_value_10=>'0.90'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704668557330307)
,p_name=>'P7_MAX_TOKENS'
,p_item_sequence=>50
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'2048'
,p_prompt=>'Max Tokens'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  Maximum tokens in the response. Typical: 500-2000 for chat, 4000 for detailed responses.'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '4096',
  'min_value', '1',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704790372330308)
,p_name=>'P7_FREQUENCY_PENALTY'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'0'
,p_prompt=>'Frequency Penalty'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  Penalizes repetition of tokens. Positive = less repetition, Negative = more repetition.',
'  Range: -2.0 - 2.0'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '2',
  'min_value', '-2',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704864299330309)
,p_name=>'P7_PRESENCE_PENALTY'
,p_item_sequence=>70
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'0'
,p_prompt=>'Presence Penalty'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  Penalizes new topics. Positive = more diverse topics, Negative = stays on topic.',
'  Range: -2.0 - 2.0'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'max_value', '2',
  'min_value', '-2',
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272704926709330310)
,p_name=>'P7_SEED'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_prompt=>'Seed (Optional)'
,p_display_as=>'NATIVE_NUMBER_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  For deterministic responses. Same seed + inputs = same output.',
'  Leave blank for random responses.'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'number_alignment', 'left',
  'virtual_keyboard', 'decimal')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272705028194330311)
,p_name=>'P7_RESPONSE_FORMAT'
,p_item_sequence=>90
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_item_default=>'text'
,p_prompt=>'Response Format'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:Text (Default) ;text,JSON Object;json_object'
,p_lov_display_null=>'YES'
,p_cHeight=>1
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_lov_display_extra=>'YES'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'page_action_on_selection', 'NONE')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272705111173330312)
,p_name=>'P7_STOP_SEQUENCES'
,p_item_sequence=>100
,p_item_plug_id=>wwv_flow_imp.id(272689715447330254)
,p_prompt=>'Stop Sequences (comma-separated)'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_begin_on_new_line=>'N'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'|',
'  Stop generation when these sequences are encountered.',
'  Example: "\n\n", "END", "---"'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272715130462330334)
,p_name=>'P7_MODEL_PROVIDER'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_item_default=>'OPENAI'
,p_prompt=>'Provider'
,p_display_as=>'NATIVE_SELECT_LIST'
,p_lov=>'STATIC:OpenAI;OPENAI,Claude;CLAUDE,Gemini;GEMINI'
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
 p_id=>wwv_flow_imp.id(272716122335330344)
,p_name=>'P7_CURRENT_SESSION_TITLE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
' SELECT NVL(session_title, ''New Conversation'')',
'    FROM ai_chat_sessions',
'    WHERE session_id = :P7_SESSION_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_pre_element_text=>'Chat Title'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_css_classes=>'session-title-display '
,p_item_icon_css_classes=>'fa-map-pin-circle'
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(272716181718330345)
,p_name=>'P7_LIVE_TOKEN_COUNT'
,p_item_sequence=>60
,p_item_plug_id=>wwv_flow_imp.id(274411944049675327)
,p_item_default=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT TO_CHAR(NVL(total_tokens, 0), ''999,999'')',
'    FROM ai_chat_sessions',
'    WHERE session_id = :P7_SESSION_ID'))
,p_item_default_type=>'SQL_QUERY'
,p_prompt=>'Tokens'
,p_format_mask=>'999,999'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_icon_css_classes=>'fa-calculator'
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'N',
  'show_line_breaks', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(273679106014547366)
,p_name=>'P7_HIDE_SHOW_ADV'
,p_item_sequence=>80
,p_item_plug_id=>wwv_flow_imp.id(272689211335330249)
,p_item_display_point=>'NEXT'
,p_item_default=>'Y'
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
,p_ai_enabled=>false
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137264048350135515)
,p_name=>'Key Press'
,p_event_sequence=>30
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_PROMPT'
,p_triggering_condition_type=>'JAVASCRIPT_EXPRESSION'
,p_triggering_expression=>'this.browserEvent.key === ''Enter'' && this.browserEvent.ctrlKey'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keypress'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137264504256135516)
,p_event_id=>wwv_flow_imp.id(137264048350135515)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SUBMIT_PAGE'
,p_attribute_01=>'SEND_BTN'
,p_attribute_02=>'Y'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137264982941135517)
,p_name=>'download'
,p_event_sequence=>70
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137259317280135500)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexdoubletap'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137265472222135518)
,p_event_id=>wwv_flow_imp.id(137264982941135517)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'chat_export_&P7_SESSION_UUID..json'
,p_action=>'NATIVE_DOWNLOAD'
,p_attribute_01=>'N'
,p_attribute_03=>'ATTACHMENT'
,p_attribute_05=>'select chat_manager_pkg.export_session_json(  p_session_id => :P7_SESSION_ID ) x from dual;'
,p_attribute_06=>'P7_SESSION_ID'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137265875201135519)
,p_name=>'Clear Session State (P7_PROMPT)'
,p_event_sequence=>80
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137247723845135466)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137266829083135521)
,p_event_id=>wwv_flow_imp.id(137265875201135519)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_PROMPT'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137266389331135520)
,p_event_id=>wwv_flow_imp.id(137265875201135519)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_CLEAR'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_PROMPT'
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137267242083135522)
,p_name=>'DA_AUTO_SCROLL_CHAT'
,p_event_sequence=>90
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(272689500662330252)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'apexafterrefresh'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137267754118135523)
,p_event_id=>wwv_flow_imp.id(137267242083135522)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Scroll chat thread to bottom',
'       var chatThread = document.querySelector(''.chat-message-thread'');',
'       if (chatThread) {',
'           chatThread.scrollTop = chatThread.scrollHeight;',
'       }'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137268198888135524)
,p_name=>'DA_UPDATE_TOKEN_COUNTER'
,p_event_sequence=>100
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_PROMPT'
,p_condition_element=>'P7_PROMPT'
,p_triggering_condition_type=>'NOT_NULL'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137268634260135525)
,p_event_id=>wwv_flow_imp.id(137268198888135524)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
unistr('// Estimate tokens (rough: 1 token \2248 4 characters)'),
'       var text = apex.item(''P7_PROMPT'').getValue();',
'       var estimatedTokens = Math.ceil(text.length / 4);',
'       ',
'       apex.item(''P7_LIVE_TOKEN_COUNT'').setValue(',
'           estimatedTokens.toLocaleString()',
'       );'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137269020152135526)
,p_name=>'DA_TOGGLE_ADVANCED_CTRLS'
,p_event_sequence=>110
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137258980636135499)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137269560565135527)
,p_event_id=>wwv_flow_imp.id(137269020152135526)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Toggle Advanced Settings',
'(function() {',
'    var region = $(''#ADVANCED_SETTINGS'');',
'    var button = $(''#SETTINGS_BTN'');',
'    var icon = button.find(''.t-Icon, .fa'');',
'    ',
'    // Check elements exist',
'    if (!region.length || !button.length) {',
'        console.error(''Elements not found'');',
'        return;',
'    }',
'    ',
'    var isVisible = region.is('':visible'');',
'    ',
'    if (isVisible) {',
'        // COLLAPSE',
'        region.slideUp(300, function() {',
'            button.removeClass(''is-active'')',
'                  .attr(''aria-expanded'', ''false'')',
'                  .attr(''title'', ''Show Advanced Settings'');',
'            ',
'            if (icon.length) {',
'                icon.removeClass(''fa-chevron-up'').addClass(''fa-cog'');',
'            }',
'        });',
'    } else {',
'        // EXPAND',
'        region.slideDown(300, function() {',
'            button.addClass(''is-active'')',
'                  .attr(''aria-expanded'', ''true'')',
'                  .attr(''title'', ''Hide Advanced Settings'');',
'            ',
'            if (icon.length) {',
'                icon.removeClass(''fa-cog'').addClass(''fa-chevron-up'');',
'            }',
'        });',
'    }',
'    ',
'    // Set ARIA',
'    button.attr(''aria-controls'', ''ADVANCED_SETTINGS'');',
'})();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137269951685135528)
,p_name=>'DA_COPY_MESSAGE'
,p_event_sequence=>120
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.copy-btn'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137270491404135529)
,p_event_id=>wwv_flow_imp.id(137269951685135528)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' var messageId = $(this.triggeringElement).data(''message-id'');',
'       var messageText = $(this.triggeringElement)',
'           .closest(''.message-bubble'')',
'           .find(''.message-body'')',
'           .text();',
'       ',
'       navigator.clipboard.writeText(messageText).then(function() {',
unistr('           apex.message.showPageSuccess(''Message copied to clipboard! \D83D\DCCB'');'),
'       });'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137270881669135530)
,p_name=>'DA_MESSAGE_FEEDBACK'
,p_event_sequence=>130
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.feedback-btn'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137271388133135531)
,p_event_id=>wwv_flow_imp.id(137270881669135530)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' var messageId = $(this.triggeringElement).data(''message-id'');',
'       ',
'       // Show feedback dialog',
'       apex.item(''P7_FEEDBACK_MESSAGE_ID'').setValue(messageId);',
'       apex.theme.openRegion(''FEEDBACK_DIALOG'');'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137271716122135532)
,p_name=>'New Chat'
,p_event_sequence=>150
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137258547166135498)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137273723769135537)
,p_event_id=>wwv_flow_imp.id(137271716122135532)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Action: Execute JavaScript Code',
'',
'apex.server.process(',
'    ''CREATE_NEW_SESSION'',',
'    {},',
'    {',
'        success: function(data) {',
'            currentSessionId = data.session_id;',
'            apex.item(''P7_SESSION_ID'').setValue(currentSessionId);',
'            ',
'            // Clear message display',
'           // clearMessages();',
'            ',
'            // Update UI',
'            apex.message.showPageSuccess(''New conversation started'');',
'        }',
'    }',
');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137274299457135538)
,p_event_id=>wwv_flow_imp.id(137271716122135532)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'chatApp.createNewSession();',
''))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137272280693135533)
,p_event_id=>wwv_flow_imp.id(137271716122135532)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'Y'
,p_name=>'set empty prompt'
,p_action=>'NATIVE_SET_VALUE'
,p_affected_elements_type=>'ITEM'
,p_affected_elements=>'P7_PROMPT'
,p_attribute_01=>'STATIC_ASSIGNMENT'
,p_attribute_09=>'N'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137272754335135534)
,p_event_id=>wwv_flow_imp.id(137271716122135532)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(272689067922330248)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137273228815135536)
,p_event_id=>wwv_flow_imp.id(137271716122135532)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(273708050944923746)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137274674546135539)
,p_name=>'Session History Item Click'
,p_event_sequence=>170
,p_triggering_element_type=>'JQUERY_SELECTOR'
,p_triggering_element=>'.session-history-item'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137275137209135540)
,p_event_id=>wwv_flow_imp.id(137274674546135539)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Get session_id from clicked element''s data attribute',
'var sessionId = $(this.triggeringElement).data(''session-id'');',
'chatApp.loadSession(sessionId);',
'',
' '))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137275583089135541)
,p_name=>'LogApplicationItems'
,p_event_sequence=>1009
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137276017349135542)
,p_event_id=>wwv_flow_imp.id(137275583089135541)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Log Global Items'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'console.log(''Role ID:'', ''&G_USER_ROLE_ID.'');',
'console.log(''Role Name:'', ''&G_USER_ROLE_NAME.'');',
'console.log(''Classification:'', ''&G_CLASSIFICATION_LEVEL.'');',
'console.log(''Tenant ID:'', ''&G_TENANT_ID.'');',
'console.log(''Tenant Name:'', ''&G_TENANT_NAME.'');',
'console.log(''Tenant Code:'', ''&G_TENANT_CODE.'');',
'console.log(''Session Start:'', ''&G_SESSION_START.'');'))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137276591226135543)
,p_event_id=>wwv_flow_imp.id(137275583089135541)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Panel Structure Diagnostic'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Panel Structure Diagnostic',
unistr('console.log(''\2550\2550\2550 PANEL DIAGNOSTIC \2550\2550\2550'');'),
'',
'var left = $(''#LEFT_PANEL'');',
'var right = $(''#RIGHT_PANEL'');',
'',
'console.log(''LEFT exists:'', left.length);',
'console.log(''RIGHT exists:'', right.length);',
'',
'if (left.length && right.length) {',
unistr('    console.log(''\005Cn\D83C\DF33 STRUCTURE:'');'),
'    console.log(''LEFT parent:'', left.parent().attr(''id'') || left.parent()[0].className);',
'    console.log(''RIGHT parent:'', right.parent().attr(''id'') || right.parent()[0].className);',
'    console.log(''Same parent?'', left.parent().is(right.parent()));',
'    console.log(''Are siblings?'', left.next().is(right));',
'    ',
unistr('    console.log(''\005Cn\D83D\DCCF SIZES:'');'),
'    console.log(''LEFT width:'', left.width());',
'    console.log(''RIGHT width:'', right.width());',
'    console.log(''Parent width:'', left.parent().width());',
'    ',
unistr('    console.log(''\005Cn\D83C\DFA8 LAYOUT:'');'),
'    console.log(''Parent display:'', left.parent().css(''display''));',
'    console.log(''LEFT position:'', left.css(''position''));',
'    console.log(''RIGHT position:'', right.css(''position''));',
'    console.log(''LEFT float:'', left.css(''float''));',
'    console.log(''RIGHT float:'', right.css(''float''));',
'}',
'',
unistr('console.log(''\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550\2550'');')))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137276916001135544)
,p_name=>'New'
,p_event_sequence=>1019
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137277443898135545)
,p_event_id=>wwv_flow_imp.id(137276916001135544)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  // Initialize send button state',
'    this.updateSendButtonState();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137277831932135546)
,p_name=>'DA_KEY_RELEASE_PROMPT'
,p_event_sequence=>1029
,p_triggering_element_type=>'ITEM'
,p_triggering_element=>'P7_PROMPT'
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'keyup'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137278871005135549)
,p_event_id=>wwv_flow_imp.id(137277831932135546)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Get prompt value',
'var promptValue = apex.item(''P7_PROMPT'').getValue();',
'var sendButton = $(''#SEND_BTN'');',
'',
'// Check if prompt has content',
'if (promptValue && promptValue.trim().length > 0) {',
'    // Enable button',
'    sendButton.prop(''disabled'', false)',
'             .removeClass(''is-disabled'')',
'             .removeClass(''apex_disabled'')',
'             .attr(''aria-disabled'', ''false'');',
'    ',
'    console.log(''Send button enabled'');',
'} else {',
'    // Disable button',
'    sendButton.prop(''disabled'', true)',
'             .addClass(''is-disabled'')',
'             .addClass(''apex_disabled'')',
'             .attr(''aria-disabled'', ''true'');',
'    ',
'    console.log(''Send button disabled'');',
'}'))
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137278303651135547)
,p_event_id=>wwv_flow_imp.id(137277831932135546)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_name=>'Validate Prompt and Update Button'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'// SEND BUTTON VALIDATION WITH CHARACTER COUNT',
' ',
'(function() {',
'',
'    // CONFIGURATION (Adjust these values as needed)',
'    const CONFIG = {',
'        MIN_CHARS: 3,           // Minimum required characters',
'        MAX_CHARS: 4000,        // Maximum allowed characters',
'        SHOW_COUNTER: true,     // Show character counter',
'        DEBUG: true             // Console logging',
'    };',
'',
'    // GET VALUES',
'    const promptValue = apex.item(''P7_PROMPT'').getValue() || '''';',
'    const promptLength = promptValue.trim().length;',
'    const sendButton = $(''#SEND_BTN'');',
'    ',
'    // ========================================================================',
'    // VALIDATION LOGIC',
'    let isValid = false;',
'    let message = '''';',
'    let counterClass = '''';',
'    ',
'    if (promptLength === 0) {',
'        // Empty prompt',
'        isValid = false;',
'        message = `${CONFIG.MIN_CHARS} characters minimum`;',
'        counterClass = ''char-counter-empty'';',
unistr('        if (CONFIG.DEBUG) console.log(''\274C Validation: Empty prompt'');'),
'        ',
'    } else if (promptLength < CONFIG.MIN_CHARS) {',
'        // Too short',
'        isValid = false;',
'        const needed = CONFIG.MIN_CHARS - promptLength;',
'        message = `${promptLength}/${CONFIG.MIN_CHARS} (${needed} more needed)`;',
'        counterClass = ''char-counter-warning'';',
unistr('        if (CONFIG.DEBUG) console.log(`\26A0\FE0F Validation: Too short (${promptLength} chars)`);'),
'        ',
'    } else if (promptLength > CONFIG.MAX_CHARS) {',
'        // Too long',
'        isValid = false;',
'        const excess = promptLength - CONFIG.MAX_CHARS;',
'        message = `${promptLength}/${CONFIG.MAX_CHARS} (${excess} too many)`;',
'        counterClass = ''char-counter-error'';',
unistr('        if (CONFIG.DEBUG) console.log(`\274C Validation: Too long (${promptLength} chars)`);'),
'        ',
'    } else {',
'        // Valid!',
'        isValid = true;',
'        message = `${promptLength} characters`;',
'        counterClass = ''char-counter-valid'';',
unistr('        if (CONFIG.DEBUG) console.log(`\2705 Validation: Valid (${promptLength} chars)`);'),
'    }',
'    ',
'    // ========================================================================',
'    // UPDATE SEND BUTTON STATE',
'    // ========================================================================',
'    if (isValid) {',
'        // ENABLE button',
'        sendButton.prop(''disabled'', false)',
'                 .removeClass(''is-disabled apex_disabled'')',
'                 .attr(''aria-disabled'', ''false'')',
'                 .attr(''title'', ''Send message (Ctrl+Enter)'');',
'        ',
'    } else {',
'        // DISABLE button',
'        sendButton.prop(''disabled'', true)',
'                 .addClass(''is-disabled apex_disabled'')',
'                 .attr(''aria-disabled'', ''true'')',
'                 .attr(''title'', message);',
'    }',
'    ',
'// ========================================================================',
'    // UPDATE CHARACTER COUNTER',
'    // ========================================================================',
'    if (CONFIG.SHOW_COUNTER) {',
'        let counter = $(''#prompt-char-counter'');',
'        ',
'        // Create counter if doesn''t exist',
'        if (counter.length === 0) {',
'            $(''#P7_PROMPT'').parent().append(',
'                ''<div id="prompt-char-counter" class="char-counter"></div>''',
'            );',
'            counter = $(''#prompt-char-counter'');',
'        }',
'        ',
'        // Update counter',
'        counter.text(message)',
'              .removeClass(''char-counter-empty char-counter-warning char-counter-error char-counter-valid'')',
'              .addClass(counterClass);',
'    }',
'    ',
'})();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137279293203135549)
,p_name=>'refresh Regions'
,p_event_sequence=>1039
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137248197714135467)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137279702705135551)
,p_event_id=>wwv_flow_imp.id(137279293203135549)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(272689500662330252)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137280241953135552)
,p_event_id=>wwv_flow_imp.id(137279293203135549)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(272689211335330249)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137280742818135553)
,p_event_id=>wwv_flow_imp.id(137279293203135549)
,p_event_result=>'TRUE'
,p_action_sequence=>30
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(272689067922330248)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(137281120320135554)
,p_name=>'Show_Hidel_Left_Panel'
,p_event_sequence=>1049
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(137259712304135501)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(137281691063135555)
,p_event_id=>wwv_flow_imp.id(137281120320135554)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// Toggle with forced flex layout',
'(function() {',
'    var leftPanel = $(''#LEFT_PANEL'');',
'    var rightPanel = $(''#RIGHT_PANEL'');',
'    var button = $(''#PANEL_TOGGLE_BTN'');',
'    var icon = button.find(''.t-Icon, .fa'');',
'    ',
'    var leftContainer = leftPanel.parent();',
'    var rightContainer = rightPanel.parent();',
'    var rowContainer = leftContainer.parent();',
'    ',
'    if (!leftPanel.length || !button.length) return;',
'    ',
'    // ALWAYS force flex layout on parent',
'    rowContainer.css(''display'', ''flex'');',
'    ',
'    if (leftPanel.is('':visible'')) {',
'        // HIDE',
'        leftPanel.slideUp(300, function() {',
'            button.removeClass(''is-active'');',
'            icon.removeClass(''fa-chevron-left'').addClass(''fa-bars'');',
'            ',
'            leftContainer.hide();',
'            rightContainer.removeClass(''col-9'').addClass(''col-12'');',
'            ',
'            // Force flex again after change',
'            rowContainer.css(''display'', ''flex'');',
'            ',
unistr('            console.log(''\2705 Hidden'');'),
'        });',
'    } else {',
'        // SHOW',
'        rightContainer.removeClass(''col-12'').addClass(''col-9'');',
'        leftContainer.show();',
'        ',
'        // Force flex BEFORE animation - THIS IS KEY!',
'        rowContainer.css(''display'', ''flex'');',
'        ',
'        leftPanel.slideDown(300, function() {',
'            button.addClass(''is-active'');',
'            icon.removeClass(''fa-bars'').addClass(''fa-chevron-left'');',
unistr('            console.log(''\2705 Shown side-by-side'');'),
'        });',
'    }',
'})();'))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(137262419200135510)
,p_process_sequence=>40
,p_process_point=>'AFTER_SUBMIT'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SEND_MESSAGE_TO_AI'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_session_id       NUMBER;',
'    v_user_message_id  NUMBER;',
'    v_assistant_msg_id NUMBER;',
'    v_prompt           CLOB;',
'    v_response         CLOB;',
'    v_model_name       VARCHAR2(100);',
'    v_model_params     JSON;',
'    v_rag_context      CLOB;',
'    v_rag_doc_count    NUMBER := 0;',
'    v_token_input      NUMBER := 0;',
'    v_token_output     NUMBER := 0;',
'    v_token_total      NUMBER := 0;',
'    v_processing_time  NUMBER;',
'    v_start_time       TIMESTAMP;',
'    v_error_occurred   BOOLEAN := FALSE;',
'    v_error_message    VARCHAR2(4000);',
'BEGIN',
'    apex_debug.info(''=== SEND MESSAGE TO AI - START ==='');',
'    v_start_time := SYSTIMESTAMP;',
'     -- ==================================================================',
'-- STEP 0: VALIDATE PROMPT (ADD THIS!)',
'-- ==================================================================',
'        v_prompt := TRIM(:P7_PROMPT);',
'',
'        IF v_prompt IS NULL OR LENGTH(v_prompt) = 0 THEN',
'            apex_error.add_error(',
'                p_message          => ''Please enter a message before sending.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_debug.error(''Validation failed: Empty prompt'');',
'            RETURN; -- Exit process immediately',
'        END IF;',
'',
'        -- Minimum length validation (optional)',
'        IF LENGTH(v_prompt) < 3 THEN',
'            apex_error.add_error(',
'                p_message          => ''Message is too short. Please enter at least 3 characters.'',',
'                p_display_location => apex_error.c_inline_in_notification',
'            );',
'            apex_debug.error(''Validation failed: Prompt too short'');',
'            RETURN;',
'        END IF;',
'',
'        apex_debug.info(''<<SEND_MESSAGE_TO_AI>>Prompt validation passed: %s characters'', LENGTH(v_prompt));',
'',
'    -- ==================================================================',
'    -- STEP 1: GET OR CREATE SESSION',
'    -- ==================================================================',
'    v_session_id := :P7_SESSION_ID;',
'    ',
'    IF v_session_id IS NULL THEN',
'        v_session_id := chat_manager_pkg.get_or_create_session(',
'            p_user_id        => :APP_USER,',
'            p_model_provider => :P7_MODEL_PROVIDER',
'        );',
'        :P7_SESSION_ID := v_session_id;',
'        apex_debug.info(''Created new session: %s'', v_session_id);',
'    END IF;',
'',
'    -- ==================================================================',
'    -- STEP 2: SAVE USER MESSAGE',
'    -- ==================================================================',
'    v_prompt := :P7_PROMPT;',
'    ',
'    v_user_message_id := chat_manager_pkg.add_message(',
'        p_session_id      => v_session_id,',
'        p_message_role    => ''USER'',',
'        p_message_content => v_prompt',
'    );',
'    ',
'    apex_debug.info(''User message saved: %s'', v_user_message_id);',
'',
'    -- ==================================================================',
'    -- STEP 3: BUILD MODEL NAME',
'    -- ==================================================================',
'    v_model_name := :P7_MODEL_NAME;',
'    apex_debug.info(''Model: %s'', v_model_name);',
'',
'    -- ==================================================================',
'    -- STEP 4: RETRIEVE RAG CONTEXT (if applicable)',
'    -- ==================================================================',
'    BEGIN',
'       /* v_rag_context := rag_context_util.get_context_for_prompt(',
'            p_prompt  => v_prompt,',
'            p_user_id => :APP_USER,',
'            p_top_k   => 5',
'        );*/',
'        ',
'        IF v_rag_context IS NOT NULL THEN',
'            SELECT COUNT(*) ',
'            INTO v_rag_doc_count',
'            FROM JSON_TABLE(v_rag_context, ''$[*]'' ',
'                COLUMNS (doc_id NUMBER PATH ''$.doc_id'')',
'            );',
'            ',
unistr('            -- \D83D\DD25 INJECT RAG CONTEXT INTO PROMPT'),
'            v_prompt := ''Context:'' || CHR(10) || v_rag_context || CHR(10) || CHR(10) ||',
'                        ''User Question:'' || CHR(10) || :P7_PROMPT;',
'            ',
'            apex_debug.info(''RAG context retrieved: %s docs'', v_rag_doc_count);',
'        END IF;',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            apex_debug.warn(''RAG context retrieval failed: %s'', SQLERRM);',
'            v_rag_context   := NULL;',
'            v_rag_doc_count := 0;',
'    END;',
'',
'    -- ==================================================================',
'    -- STEP 5: BUILD MODEL PARAMETERS JSON',
'    -- ==================================================================',
'   -- ==================================================================',
'DECLARE',
'    v_stop_sequences JSON_ARRAY_T;',
'BEGIN',
'    -- Parse stop sequences if provided',
'    IF :P7_STOP_SEQUENCES IS NOT NULL THEN',
'        BEGIN',
'            -- If stored as JSON array string: ["\\n", "User:"]',
'            v_stop_sequences := JSON_ARRAY_T(:P7_STOP_SEQUENCES);',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                apex_debug.warn(''Invalid stop sequences format, ignoring: %s'', SQLERRM);',
'                v_stop_sequences := NULL;',
'        END;',
'    END IF;',
'',
'    -- Build parameters with explicit type conversions',
'   /* v_model_params := JSON_OBJECT(',
'        ''model''               VALUE v_model_name,',
'        ''temperature''         VALUE CASE ',
'                                        WHEN :P7_TEMPERATURE IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_TEMPERATURE) ',
'                                    END,',
'        ''top_p''               VALUE CASE ',
'                                        WHEN :P7_TOP_P IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_TOP_P) ',
'                                    END,',
'        ''max_tokens''          VALUE CASE ',
'                                        WHEN :P7_MAX_TOKENS IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_MAX_TOKENS) ',
'                                    END,',
'        ''frequency_penalty''   VALUE CASE ',
'                                        WHEN :P7_FREQUENCY_PENALTY IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_FREQUENCY_PENALTY) ',
'                                    END,',
'        ''presence_penalty''    VALUE CASE ',
'                                        WHEN :P7_PRESENCE_PENALTY IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_PRESENCE_PENALTY) ',
'                                    END,',
'        ''seed''                VALUE CASE ',
'                                        WHEN :P7_SEED IS NOT NULL ',
'                                        THEN TO_NUMBER(:P7_SEED) ',
'                                    END,',
'        ''response_format''     VALUE :P7_RESPONSE_FORMAT,',
'        ''stop''                VALUE v_stop_sequences',
'        ABSENT ON NULL -- Critical: removes null values from JSON',
'    );',
'    */',
'  --  apex_debug.info(''Model Parameters: %s'', v_model_params.to_string());',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_debug.error(''Failed to build model parameters: %s'', SQLERRM);',
'        -- Build minimal parameters as fallback',
'       /* v_model_params := JSON_OBJECT(',
'            ''model''      VALUE v_model_name,',
'            ''max_tokens'' VALUE 4000',
'        );*/',
'END;',
'    --apex_debug.info(''Parameters: %s'', v_model_params.to_string());',
'',
'    -- ==================================================================',
'    -- STEP 6: CALL LLM API',
'    -- ==================================================================',
'    BEGIN',
'        -- Option A: If OPENAI_PKG expects (p_prompt, p_params)',
'      /*  v_response := openai_pkg.call_openai(',
'            p_prompt => v_prompt,',
'            p_params => v_model_params',
'        );*/',
'        ',
'        -- Option B: If OPENAI_PKG expects JSON request object, use this instead:',
'        /*',
'        v_response := openai_pkg.call_openai(',
'            p_request => JSON_OBJECT(',
'                ''prompt'' VALUE v_prompt,',
'                ''model''  VALUE v_model_name,',
'                ''params'' VALUE v_model_params',
'            )',
'        );',
'        */',
'',
'        -- Extract token usage from response metadata',
'        BEGIN',
'            SELECT ',
'                NVL(JSON_VALUE(v_response, ''$.usage.prompt_tokens''), 0),',
'                NVL(JSON_VALUE(v_response, ''$.usage.completion_tokens''), 0),',
'                NVL(JSON_VALUE(v_response, ''$.usage.total_tokens''), 0)',
'            INTO ',
'                v_token_input,',
'                v_token_output,',
'                v_token_total',
'            FROM DUAL;',
'        EXCEPTION',
'            WHEN OTHERS THEN',
'                v_token_input  := 0;',
'                v_token_output := 0;',
'                v_token_total  := 0;',
'                apex_debug.warn(''Token extraction failed: %s'', SQLERRM);',
'        END;',
'',
'        apex_debug.info(''OpenAI response received: %s tokens'', v_token_total);',
'',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            v_error_occurred := TRUE;',
'            v_error_message  := SQLERRM;',
unistr('            v_response       := ''\274C Error: '' || v_error_message;'),
'            apex_debug.error(''OpenAI call failed: %s'', v_error_message);',
'    END;',
'',
'    -- ==================================================================',
'    -- STEP 7: CALCULATE PROCESSING TIME',
'    -- ==================================================================',
'    v_processing_time := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;',
'',
'    -- ==================================================================',
'    -- STEP 8: SAVE ASSISTANT RESPONSE',
'    -- ==================================================================',
'    v_assistant_msg_id := chat_manager_pkg.add_message(',
'        p_session_id      => v_session_id,',
'        p_message_role    => ''ASSISTANT'',',
'        p_message_content => v_response,',
'        p_model_params    => v_model_params,',
'        p_rag_context     => v_rag_context,',
'        p_rag_doc_count   => v_rag_doc_count,',
'        p_token_input     => v_token_input,',
'        p_token_output    => v_token_output,',
'        p_token_total     => v_token_total,',
'        p_processing_time => v_processing_time',
'    );',
'    ',
'    apex_debug.info(''Assistant message saved: %s'', v_assistant_msg_id);',
'',
'    -- ==================================================================',
'    -- STEP 9: UPDATE SESSION TOTALS',
'    -- ==================================================================',
'    chat_manager_pkg.update_session_totals(',
'        p_session_id => v_session_id',
'    );',
'',
'    -- ==================================================================',
'    -- STEP 10: COMPREHENSIVE AUDIT LOGGING',
'    -- ==================================================================',
'    BEGIN',
'        ai_log_util.log_llm_call(',
'            p_user_id            => :APP_USER,',
'            p_model_provider     => :P7_MODEL_PROVIDER,',
'            p_model_name         => v_model_name,',
'            p_call_purpose       => ''CHAT_RESPONSE'',',
'            p_query_text         => :P7_PROMPT, -- Original user prompt',
'            p_response_text      => v_response,',
'            p_token_count_input  => v_token_input,',
'            p_token_count_output => v_token_output,',
'            p_token_count_total  => v_token_total,',
'            p_processing_time_ms => v_processing_time,',
'            p_temperature        => :P7_TEMPERATURE,',
'            p_top_p              => :P7_TOP_P,',
'            p_max_tokens         => :P7_MAX_TOKENS,',
'            p_apex_session_id    => :APP_SESSION,',
'            p_is_error           => CASE WHEN v_error_occurred THEN ''Y'' ELSE ''N'' END,',
'            p_error_message      => v_error_message',
'        );',
'',
'        IF v_rag_context IS NOT NULL THEN',
'            ai_log_util.log_rag_search(',
'                p_user_id            => :APP_USER,',
'                p_query_text         => :P7_PROMPT,',
'                p_search_type        => ''HYBRID'',',
'                p_chunks_retrieved   => v_rag_doc_count,',
'                p_chunks_selected    => v_rag_doc_count,',
'                p_context_size_bytes => LENGTH(v_rag_context),',
'                p_apex_session_id    => :APP_SESSION,',
'                p_is_error           => ''N''',
'            );',
'        END IF;',
'',
'        COMMIT;',
'        ',
'    EXCEPTION',
'        WHEN OTHERS THEN',
'            apex_debug.error(''Audit logging failed: %s'', SQLERRM);',
'            -- Continue execution even if logging fails',
'    END;',
'',
'    -- ==================================================================',
'    -- STEP 11: CLEAR INPUT & SET STATUS',
'    -- ==================================================================',
'    :P7_PROMPT := NULL; -- Clear input after successful send',
'    :P7_PROCESSING_STATUS := CASE ',
unistr('        WHEN v_error_occurred THEN ''\274C Error'' '),
unistr('        ELSE ''\2705 Success'' '),
'    END;',
'',
'    apex_debug.info(''=== SEND MESSAGE TO AI - COMPLETE ==='');',
'',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_debug.error(''=== CRITICAL ERROR ==='');',
'        apex_debug.error(''Error: %s'', SQLERRM);',
'        apex_debug.error(''Backtrace: %s'', DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);',
'        ',
'        apex_error.add_error(',
'            p_message          => ''Failed to send message: '' || SQLERRM,',
'            p_display_location => apex_error.c_inline_in_notification',
'        );',
'        ',
unistr('        :P7_PROCESSING_STATUS := ''\274C Critical Error'';'),
'        ',
'        ROLLBACK;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_error_message=>'Failed to send message. Please try again.'
,p_error_display_location=>'INLINE_IN_NOTIFICATION'
,p_process_when_button_id=>wwv_flow_imp.id(137247339345135465)
,p_process_success_message=>unistr('Message sent successfully! \2705')
,p_internal_uid=>137262419200135510
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(137262819490135512)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'GET_OR_CREATE_SESSION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_session_id     NUMBER;',
'    v_session_title  VARCHAR2(200);',
'    v_message_count  NUMBER;',
'    v_model_provider VARCHAR2(50);',
'    v_user_id number;',
'BEGIN',
'     select user_id into v_user_id from users u where user_name =:APP_USER ;',
'    -- Get model provider from request or default',
'    v_model_provider := NVL(apex_application.g_x01, ''OPENAI'');',
'    ',
'    -- Get or create session (this does the DML)',
'    v_session_id := chat_manager_pkg.get_or_create_session(',
'        p_user_id        => v_user_id,',
'        p_model_provider => v_model_provider',
'    );',
'    ',
'    -- Get session details for UI',
'    BEGIN',
'        SELECT ',
'            session_title,',
'            message_count',
'        INTO ',
'            v_session_title,',
'            v_message_count',
'        FROM ai_chat_sessions',
'        WHERE session_id = v_session_id;',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            v_session_title := ''New Conversation'';',
'            v_message_count := 0;',
'    END;',
'    ',
'    -- Return JSON response',
'    apex_json.open_object;',
'    apex_json.write(''status'', ''success'');',
'    apex_json.write(''session_id'', v_session_id);',
'    apex_json.write(''session_title'', v_session_title);',
'    apex_json.write(''message_count'', v_message_count);',
'    apex_json.write(''is_new'', CASE WHEN v_message_count = 0 THEN ''true'' ELSE ''false'' END);',
'    apex_json.close_object;',
'    ',
'    -- Log for debugging',
'    apex_debug.info(''Session initialized: %s for user: %s'', v_session_id, :APP_USER);',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''status'', ''error'');',
'        apex_json.write(''error_code'', SQLCODE);',
'        apex_json.write(''error_message'', SQLERRM);',
'        apex_json.close_object;',
'        ',
'        apex_debug.error(''Session initialization failed: %s'', SQLERRM);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_process_is_stateful_y_n=>'Y'
,p_internal_uid=>137262819490135512
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(137263253044135513)
,p_process_sequence=>20
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'CREATE_NEW_SESSION'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_session_id     NUMBER;',
'    v_model_provider VARCHAR2(50);',
'    v_user_id number;',
'BEGIN',
'',
':P7_SESSION_ID := NULL;',
':P7_SESSION_UUID := NULL;',
':P7_PROMPT := NULL;         ',
':P7_PROCESSING_STATUS := NULL;',
'',
'',
'     select user_id into v_user_id from users u where user_name =:APP_USER ;',
'    -- Get model provider from request or default',
'    v_model_provider := NVL(apex_application.g_x01, ''OPENAI'');',
'    ',
'    -- Force creation of new session',
'    v_session_id := chat_manager_pkg.create_session(',
'        p_user_id        => v_user_id,',
'        p_model_provider => v_model_provider,',
'        p_session_title  => ''New Conversation'',',
'        p_apex_session_id => V(''APP_SESSION'')',
'    );',
'    ',
'    -- Return JSON response',
'    apex_json.open_object;',
'    apex_json.write(''status'', ''success'');',
'    apex_json.write(''session_id'', v_session_id);',
'    apex_json.write(''message'', ''New conversation created'');',
'    apex_json.close_object;',
'    ',
'    apex_debug.info(''New session created: %s for user: %s'', v_session_id, :APP_USER);',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''status'', ''error'');',
'        apex_json.write(''error_message'', SQLERRM);',
'        apex_json.close_object;',
'        ',
'        apex_debug.error(''New session creation failed: %s'', SQLERRM);',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>137263253044135513
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(137263604594135514)
,p_process_sequence=>30
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'LOAD_SESSION_MESSAGES'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    v_session_id     NUMBER;',
'    v_session_title  VARCHAR2(200);',
'    v_message_count  NUMBER;',
'    v_user_id        NUMBER;',
'    v_session_userid NUMBER;',
'BEGIN',
'',
' ',
'     select user_id into v_session_userid from users u where user_name =:APP_USER ;',
'    -- Get session_id from request',
'    v_session_id := TO_NUMBER(apex_application.g_x01);',
'    ',
'    -- Validate session belongs to user',
'    BEGIN',
'        SELECT ',
'            user_id,',
'            session_title,',
'            message_count',
'        INTO ',
'            v_user_id,',
'            v_session_title,',
'            v_message_count',
'        FROM ai_chat_sessions',
'        WHERE session_id = v_session_id;',
'        ',
'        -- Security check',
'        IF v_user_id != v_session_userid THEN',
'            RAISE_APPLICATION_ERROR(-20001, ''Access denied: Session belongs to different user'');',
'        END IF;',
'        ',
'    EXCEPTION',
'        WHEN NO_DATA_FOUND THEN',
'            RAISE_APPLICATION_ERROR(-20002, ''Session not found: '' || v_session_id);',
'    END;',
'    ',
'    -- Return session info',
'    apex_json.open_object;',
'    apex_json.write(''status'', ''success'');',
'    apex_json.write(''session_id'', v_session_id);',
'    apex_json.write(''session_title'', v_session_title);',
'    apex_json.write(''message_count'', v_message_count);',
'    apex_json.close_object;',
'    ',
'EXCEPTION',
'    WHEN OTHERS THEN',
'        apex_json.open_object;',
'        apex_json.write(''status'', ''error'');',
'        apex_json.write(''error_message'', SQLERRM);',
'        apex_json.close_object;',
'END;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>137263604594135514
);
wwv_flow_imp.component_end;
end;
/
