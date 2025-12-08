/* ============================================================================
   chatPrompt — Enterprise AI Assistant
   FINAL MERGED VERSION (A + B)
   Section 1/6 — Namespace, Config, State, Utilities
   ============================================================================ */

window.chatPrompt = {

    /* ------------------------------------------------------------------------
       CONFIGURATION (Merged from Version A + Version B)
       ------------------------------------------------------------------------ */
    config: {
        historyOffset: 0,
        historyPageSize: 50,

        PAGE_ITEMS:
            "#P115_PROVIDER,#P115_MODEL,#P115_CHAT_SESSION_ID," +
            "#P115_SESSION_TITLE,#P115_CONTEXT_DOMAIN_ID," +
            "#P115_TEMPERATURE,#P115_MAX_TOKENS,#P115_TOP_P,#P115_TOP_K",

        DETECT_DOMAIN_ITEMS:
            "#P115_PROVIDER,#P115_MODEL,#P115_CHAT_SESSION_ID,#P115_CONTEXT_DOMAIN_ID," +
            "#P115_CXD_TRACE_ID,#P115_CXD_CONTEXT_DOMAIN_ID,#P115_CXD_DETECTION_METHOD_CODE," +
            "#P115_CXD_CONTEXT_DOMAIN_CODE,#P115_CXD_CONTEXT_DOMAIN_NAME,#P115_CXD_CONTEXT_DOMAIN_CONFIDENCE," +
            "#P115_CXD_DETECT_STATUS,#P115_CXD_SEARCH_TIME_MS,#P115_CXD_USED_PROVIDER," +
            "#P115_CXD_USED_MODEL,#P115_CXD_MESSAGE,#P115_CXD_FINAL_DETECTION_METHOD_CODE"
    },

    /* ------------------------------------------------------------------------
       INTERNAL STATE (Merged)
       ------------------------------------------------------------------------ */
    state: {
        chatWindow: null,
        txtMessage: null,
        btnSend: null,
        typing: null
    },

    /* ------------------------------------------------------------------------
       HELPER — DOM VALIDATION
       ------------------------------------------------------------------------ */
    checkDOM(id, el) {
        if (!el) {
            console.error("❌ [chatPrompt] Missing DOM element:", id);
        }
    },

    /* ------------------------------------------------------------------------
       UTILITY — Clipboard
       ------------------------------------------------------------------------ */
    copyToClipboard(text) {
        try {
            navigator.clipboard.writeText(text);
            apex.message.showPageSuccess("Copied!");
        } catch (e) {
            console.error("❌ Clipboard Error:", e);
            apex.message.alert("Failed to copy text.");
        }
    },

    /* ------------------------------------------------------------------------
       UTILITY — Save Text to Client File
       ------------------------------------------------------------------------ */
    saveToFile(text, messageId) {
        try {
            const filename = `chat-${messageId || Date.now()}.txt`;
            const blob = new Blob([text], { type: "text/plain" });
            const url = URL.createObjectURL(blob);

            const a = document.createElement("a");
            a.href = url;
            a.download = filename;
            a.click();

            URL.revokeObjectURL(url);
        } catch (e) {
            console.error("❌ SaveToFile Error:", e);
            apex.message.alert("Failed to save file.");
        }
    },

    /* ------------------------------------------------------------------------
       UTILITY — Export Session (Used by Menu)
       ------------------------------------------------------------------------ */
    exportSession() {
        try {
            const messages = [...document.querySelectorAll(".chat-bubble")].map(b => {
                const role = b.classList.contains("chat-user") ? "User" : "Assistant";
                return `[${role}]\n${b.innerText}\n\n`;
            });

            chatPrompt.saveToFile(messages.join("\n"), "session");

        } catch (e) {
            console.error("❌ ExportSession Error:", e);
        }
    },
    /* =========================================================================
       SECTION 2 — BUBBLE RENDERING ENGINE
       ========================================================================= */

    addBubble(role, text, rag = null, messageId = null, regenerated = null) {
        try {
            const bubble = document.createElement("div");
            bubble.className =
                "chat-bubble " + (role === "USER" ? "chat-user" : "chat-assistant");
            bubble.dataset.messageId = messageId || "";

            /* --------------------------------------------------------------
               MAIN BUBBLE HTML
               -------------------------------------------------------------- */
            bubble.innerHTML = `
                <div class="bubble-content">${text}</div>

                ${rag ? `<div class="rag-badge">📚 RAG • ${rag}</div>` : ""}

                ${
                    regenerated === "Y"
                        ? `<div class="regenerated-info">↻ Regenerated from #${messageId}</div>`
                        : ""
                }
            `;

            /* --------------------------------------------------------------
               ONLY ASSISTANT BUBBLES HAVE ACTION BAR
               -------------------------------------------------------------- */
            if (role === "ASSISTANT") {
                const actionBar = document.createElement("div");
                actionBar.className = "action-bar";

                actionBar.innerHTML = `
                    <button class="action-btn copy-btn" title="Copy">📄</button>
                    <button class="action-btn save-btn" title="Save">💾</button>
                    <button class="action-btn rate-good-btn" title="Good">👍</button>
                    <button class="action-btn rate-bad-btn" title="Bad">👎</button>

                    <div class="more-menu-container">
                        <button class="action-btn more-btn" title="More">⋮</button>

                        <div class="more-menu">
                            <button class="more-menu-item report-issue-btn">
                                🚨 Report Issue
                            </button>
                        </div>
                    </div>
                `;

                /* ----------------------------------------------------------
                   ACTION BAR — EVENT HANDLERS
                   ---------------------------------------------------------- */

                // COPY TEXT
                actionBar.querySelector(".copy-btn").onclick =
                    () => chatPrompt.copyToClipboard(text);

                // SAVE TEXT
                actionBar.querySelector(".save-btn").onclick =
                    () => chatPrompt.saveToFile(text, messageId);

                // RATE GOOD
                actionBar.querySelector(".rate-good-btn").onclick =
                    () => chatPrompt.rateResponse(messageId, "GOOD");

                // RATE BAD
                actionBar.querySelector(".rate-bad-btn").onclick =
                    () => chatPrompt.rateResponse(messageId, "BAD");

                // MORE MENU TOGGLE
                const moreBtn = actionBar.querySelector(".more-btn");
                const moreMenu = actionBar.querySelector(".more-menu");

                moreBtn.onclick = (e) => {
                    e.stopPropagation();
                    moreMenu.style.display =
                        moreMenu.style.display === "block" ? "none" : "block";
                };

                // REPORT ISSUE BUTTON
                actionBar.querySelector(".report-issue-btn").onclick = () => {
                    moreMenu.style.display = "none";
                    chatPrompt.openReportIssueDialog("MESSAGE", messageId, text);
                };

                bubble.appendChild(actionBar);
            }

            /* --------------------------------------------------------------
               APPEND BUBBLE TO CHAT WINDOW
               -------------------------------------------------------------- */
            if (chatPrompt.state.chatWindow) {
                chatPrompt.state.chatWindow.appendChild(bubble);
                chatPrompt.state.chatWindow.scrollTop =
                    chatPrompt.state.chatWindow.scrollHeight;
            }

        } catch (e) {
            console.error("❌ [chatPrompt] addBubble error:", e);
        }
    },
    /* =========================================================================
       SECTION 3 — RATING, REPORT ISSUE, PROTECTED ITEM SYNC, EXPORT SESSION
       ========================================================================= */

    /* ------------------------------------------------------------------------
       RATE RESPONSE (GOOD/BAD)
       ------------------------------------------------------------------------ */
    rateResponse(messageId, rating) {
        try {
            apex.server.process(
                "RATE_RESPONSE",
                {
                    x01: messageId,
                    x02: rating,
                    pageItems: chatPrompt.config.PAGE_ITEMS
                },
                {
                    dataType: "json",
                    success: function () {
                        apex.message.showPageSuccess("Feedback saved!");
                    },
                    error: function (e) {
                        console.error("❌ Rating Error:", e);
                    }
                }
            );
        } catch (e) {
            console.error("❌ rateResponse Exception:", e);
        }
    },

    /* ------------------------------------------------------------------------
       REPORT ISSUE ENTRY POINT — Handles Protected Page Items
       ------------------------------------------------------------------------ */
    openReportIssueDialog(issueLevel, entityId, messageText) {
        console.log("🔄 [chatPrompt] Syncing protected items before opening dialog...");

        try {
            apex.server.process(
                "SYNC_PROTECTED_ITEMS",
                {
                    pageItems: "#P115_CHAT_SESSION_ID"
                },
                {
                    url: window.location.href,
                    dataType: "text",
                    success: () => {
                        console.log("✅ Protected item synced.");
                        chatPrompt._openDialogCore(issueLevel, entityId, messageText);
                    },
                    error: (err) => {
                        console.error("❌ Protected Item Sync Failed:", err);
                        apex.message.alert("Failed to sync protected items.");
                    }
                }
            );
        } catch (e) {
            console.error("❌ openReportIssueDialog Exception:", e);
        }
    },

    /* ------------------------------------------------------------------------
       INTERNAL — BUILD THE REPORT ISSUE POPUP URL
       ------------------------------------------------------------------------ */
    _openDialogCore(issueLevel, entityId, messageText) {
        try {
            const baseUrl = $v("P115_REPORT_ISSUE_URL");

            const fullUrl =
                baseUrl +
                "&P116_ISSUE_LEVEL=" + encodeURIComponent(issueLevel) +
                "&P116_ENTITY_ID=" + encodeURIComponent(entityId || "") +
                "&P116_MESSAGE_TEXT=" +
                    encodeURIComponent((messageText || "").substring(0, 4000)) +
                "&P116_BROWSER_INFO=" +
                    encodeURIComponent(
                        JSON.stringify({
                            ua: navigator.userAgent,
                            url: location.href,
                            timestamp: new Date().toISOString()
                        })
                    );

            apex.navigation.popup({
                url: fullUrl,
                name: "ReportIssueWin",
                width: 900,
                height: 750,
                scroll: "yes",
                resizable: "yes"
            });

        } catch (e) {
            console.error("❌ _openDialogCore Exception:", e);
            apex.message.alert("Failed to open report dialog.");
        }
    },

    /* ------------------------------------------------------------------------
       EXPORT SESSION (User Action via Menu)
       ------------------------------------------------------------------------ */
    exportSession() {
        try {
            const messages = [...document.querySelectorAll(".chat-bubble")].map(
                (b) => {
                    const role = b.classList.contains("chat-user")
                        ? "User"
                        : "Assistant";
                    return `[${role}]\n${b.innerText}\n\n`;
                }
            );

            chatPrompt.saveToFile(messages.join("\n"), "session");

        } catch (e) {
            console.error("❌ ExportSession Error:", e);
        }
    },
    /* =========================================================================
       SECTION 4 — LLM PIPELINE (ensureSession → detectDomain → invokeLLM)
       ========================================================================= */

    /* ------------------------------------------------------------------------
       STEP 1 — ENSURE SESSION EXISTS
       Creates a chat session ONLY when needed.
       Merged behavior: Version A (session title logic) + Version B (Promisified).
       ------------------------------------------------------------------------ */
    ensureSession(userText) {
        return new Promise((resolve, reject) => {
            const existingSid = $v("P115_CHAT_SESSION_ID");

            // If session exists → continue
            if (existingSid) {
                resolve({ session_id: existingSid, is_new: false });
                return;
            }

            // Otherwise create new session
            apex.server.process(
                "ENSURE_SESSION",
                {
                    x01: userText,
                    pageItems: chatPrompt.config.PAGE_ITEMS
                },
                {
                    dataType: "json",
                    success: (r) => {
                        if (!r.success) { reject(r.error);
                            return;
                        }

                        // Write new session ID
                        apex.item("P115_CHAT_SESSION_ID").setValue(r.session_id);

                        // Optional: if session title is empty, use suggested title
                        if (!$v("P115_SESSION_TITLE") && r.suggested_title) {
                            apex.item("P115_SESSION_TITLE").setValue(r.suggested_title);
                        }

                        resolve(r);
                    },
                    error: (xhr, status, err) => {
                        reject("EnsureSession Error: " + err);
                    }
                }
            );
        });
    },

    /* ------------------------------------------------------------------------
       STEP 2 — DETECT DOMAIN (Context Domain Detection)
       Uses DETECT_DOMAIN process and protected page items.
       ------------------------------------------------------------------------ */
    detectDomain(sessionId, userText) {
        return new Promise((resolve, reject) => {
            apex.server.process(
                "DETECT_DOMAIN",
                {
                    x01: sessionId,
                    x02: userText,
                    pageItems: chatPrompt.config.DETECT_DOMAIN_ITEMS
                },
                {
                    dataType: "json",
                    success: (r) => {
                        if (r.success) resolve(r);
                        else reject(r.error || "Domain detection failed");
                    },
                    error: (xhr, status, err) => {
                        reject("DetectDomain Error: " + err);
                    }
                }
            );
        });
    },

    /* ------------------------------------------------------------------------
       STEP 3 — INVOKE LLM
       Calls your backend RAG pipeline (Oracle + APEX + LLM Provider).
       Sends model settings + session ID + detected domain.
       ------------------------------------------------------------------------ */
    invokeLLM(sessionId, domainId, userText) {
        return new Promise((resolve, reject) => {
            const payload = {
                provider: $v("P115_PROVIDER"),
                model: $v("P115_MODEL"),
                user_prompt: userText,
                temperature: Number($v("P115_TEMPERATURE")) || 0.7,
                max_tokens: Number($v("P115_MAX_TOKENS")) || 1024,
                top_p: Number($v("P115_TOP_P")) || 1.0,
                top_k: Number($v("P115_TOP_K")) || 0,
                chat_session_id: sessionId,
                context_domain_id: domainId
            };

            apex.server.process(
                "INVOKE_LLM",
                {
                    x01: JSON.stringify(payload),
                    pageItems: chatPrompt.config.PAGE_ITEMS
                },
                {
                    dataType: "json",
                    success: (r) => {
                        if (r.success) resolve(r);
                        else reject(r.error || "LLM invocation failed");
                    },
                    error: (xhr, status, err) => {
                        reject("InvokeLLM Error: " + err);
                    }
                }
            );
        });
    },

    /* ------------------------------------------------------------------------
       STEP 4 — SEND MESSAGE (Full Pipeline)
       addBubble(USER) → ensureSession → detectDomain → invokeLLM → addBubble(ASSISTANT)
       ------------------------------------------------------------------------ */
    async sendMessage(userText) {
        try {
            // Show typing indicator + disable send button
            chatPrompt.state.typing.style.display = "block";
            chatPrompt.state.btnSend.disabled = true;

            // Add user bubble immediately
            chatPrompt.addBubble("USER", userText);

            // Pipeline:
            const session = await chatPrompt.ensureSession(userText);
            const domain = await chatPrompt.detectDomain(session.session_id, userText);
            const llm = await chatPrompt.invokeLLM(
                session.session_id,
                domain.context_domain_id,
                userText
            );

            // Add assistant bubble
            chatPrompt.addBubble(
                "ASSISTANT",
                llm.response_text,
                llm.rag_doc_count ? `${llm.rag_doc_count} docs` : null,
                llm.message_id
            );

        } catch (err) {
            console.error("❌ sendMessage Pipeline Error:", err);
            chatPrompt.addBubble("ASSISTANT", `⚠️ Error: ${err}`);
        }

        // Restore UI state
        chatPrompt.state.typing.style.display = "none";
        chatPrompt.state.btnSend.disabled = false;
    },
    /* =========================================================================
       SECTION 5 — HISTORY LOADING + SESSION DISPLAY + CLEAR BEHAVIOR
       ========================================================================= */

    /* ------------------------------------------------------------------------
       CLEAR CHAT WINDOW (Used when switching sessions)
       Sidebar will ALWAYS call this before loadHistory()
       ------------------------------------------------------------------------ */
    clearChatWindow() {
        if (chatPrompt.state.chatWindow) {
            chatPrompt.state.chatWindow.innerHTML = "";
        }
    },

    /* ------------------------------------------------------------------------
       LOAD CHAT HISTORY (Does NOT auto-run on page load)
       append = false → replace window  
       append = true  → infinite scroll extension (future)
       ------------------------------------------------------------------------ */
    loadHistory(append = false) {
        const sessionId = $v("P115_CHAT_SESSION_ID");

        if (!sessionId) {
            console.warn("⚠ loadHistory called without session ID");
            return;
        }

        // When loading history for a NEWLY SELECTED SESSION:
        if (!append) {
            chatPrompt.clearChatWindow();
            chatPrompt.config.historyOffset = 0;
        }

        apex.server.process(
            "LOAD_CHAT_HISTORY",
            {
                x01: chatPrompt.config.historyOffset,
                x02: chatPrompt.config.historyPageSize,
                pageItems: chatPrompt.config.PAGE_ITEMS
            },
            {
                dataType: "json",
                success: function(data) {
                    if (!data || !data.rows || data.rows.length === 0) return;

                    // Reverse so oldest → newest
                    data.rows.reverse().forEach((m) => {
                        chatPrompt.addBubble(
                            m.role,
                            m.content,
                            m.rag_context,
                            m.message_id,
                            m.regenerated
                        );
                    });

                    // Move offset forward
                    chatPrompt.config.historyOffset += data.rows.length;
                },
                error: function(err) {
                    console.error("❌ History Load Error:", err);
                }
            }
        );
    },

    /* ------------------------------------------------------------------------
       UPDATE SESSION DISPLAY (Header)
       This is called manually whenever a new session ID or title is set
       ------------------------------------------------------------------------ */
    updateSessionDisplay() {
        const sessionId = $v("P115_CHAT_SESSION_ID");
        const sessionTitle = $v("P115_SESSION_TITLE");

        const titleEl = document.getElementById("sessionTitleDisplay");
        const idEl = document.getElementById("sessionIdDisplay");

        if (titleEl) titleEl.textContent = sessionTitle || "New Conversation";
        if (idEl) idEl.textContent = sessionId || "-";
    },

     
    /* =========================================================================
       SECTION 6 — FINAL INIT + GLOBAL HANDLERS
       ========================================================================= */

    init() {
        console.log("🚀 [chatPrompt] Initializing AI Assistant UI...");

        /* --------------------------------------------------------------
           Cache DOM references
           -------------------------------------------------------------- */
        chatPrompt.state.chatWindow = document.getElementById("chatWindow");
        chatPrompt.state.txtMessage = document.getElementById("txtMessage");
        chatPrompt.state.btnSend    = document.getElementById("btnSend");
        chatPrompt.state.typing     = document.getElementById("typingIndicator");

        /* --------------------------------------------------------------
           Validate DOM
           -------------------------------------------------------------- */
        chatPrompt.checkDOM("chatWindow", chatPrompt.state.chatWindow);
        chatPrompt.checkDOM("txtMessage", chatPrompt.state.txtMessage);
        chatPrompt.checkDOM("btnSend",    chatPrompt.state.btnSend);

        /* --------------------------------------------------------------
           Send Button
           -------------------------------------------------------------- */
        if (chatPrompt.state.btnSend) {
            chatPrompt.state.btnSend.onclick = () => {
                const msg = chatPrompt.state.txtMessage.value.trim();
                if (!msg) return;

                chatPrompt.state.txtMessage.value = "";
                chatPrompt.sendMessage(msg);
            };
        }

        /* --------------------------------------------------------------
           ENTER key = Send
           SHIFT+ENTER = New line
           -------------------------------------------------------------- */
        if (chatPrompt.state.txtMessage) {
            chatPrompt.state.txtMessage.onkeypress = (e) => {
                if (e.key === "Enter" && !e.shiftKey) {
                    e.preventDefault();
                    chatPrompt.state.btnSend.click();
                }
            };
        }

        /* --------------------------------------------------------------
           Global Click: Close OPENED "More" Menus
           -------------------------------------------------------------- */
        document.addEventListener("click", () => {
            document.querySelectorAll(".more-menu").forEach((m) => {
                m.style.display = "none";
            });
        });

      
        /* --------------------------------------------------------------
           DO NOT load history here!
           Sidebar now controls session changes.
           -------------------------------------------------------------- */
      apex.region("myProjectsTreeStaticID").refresh;
      apex.region("myActiveSessionStaticID").refresh;

        console.log("🎯 [chatPrompt] Ready");
    }
};
