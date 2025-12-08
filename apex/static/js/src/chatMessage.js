/**
 * ============================================================================
 * NAMESPACE: chatMessage
 * All chat-message actions, handlers, utilities, and AJAX integrations
 * ============================================================================
 */
window.chatMessage = {

    /* -------------------------------------------------------------
     * REPORT MESSAGE ISSUE (opens issue dialog)
     * ------------------------------------------------------------- */
    reportMessageIssue(messageId) {
        console.log("🚨 [chatMessage] Report Message Issue →", messageId);

        if (!messageId) {
            apex.message.alert("No message selected");
            return;
        }

        if (typeof _closeAllMenus === "function") {
            _closeAllMenus();
        }

        apex.server.process(
            "GENERATE_REPORT_ISSUE_URL",
            { x01: messageId, x02: "MESSAGE" },
            {
                dataType: "json",
                success: function (response) {
                    console.log("🔎 Response:", response);

                    if (!response?.success || !response.url) {
                        apex.message.alert("❌ Invalid issue URL response");
                        return;
                    }

                    console.log("🟢 Opening:", response.url);
                    apex.navigation.redirect(response.url);
                },
                error: function (err) {
                    console.error("❌ AJAX Error:", err);
                    apex.message.alert("Failed to generate issue URL.");
                }
            }
        );
    },

    /* =============================================================
     * INITIALIZE MESSAGE ACTION BUTTONS
     * ============================================================= */
    initialize() {
        console.log("📌 Initializing chatMessage actions...");

        // COPY
        $(document).on("click", ".copy-btn", (e) => {
            e.preventDefault();
            const id = $(e.currentTarget).data("id");
            this.copyToClipboard($("#msgContent_" + id).text(), $(e.currentTarget));
        });

        // EDIT + REGENERATE
        $(document).on("click", ".edit-regen-btn", (e) => {
            e.preventDefault();
            const id = $(e.currentTarget).data("id");
            const content = $("#msgContent_" + id).text();
            this.editAndRegenerate(id, content);
        });

        // EXPORT
        $(document).on("click", ".export-btn", (e) => {
            e.preventDefault();
            this.exportMessage($(e.currentTarget).data("id"));
        });

        // SAVE TO FAVORITES
        $(document).on("click", ".save-btn", (e) => {
            e.preventDefault();
            const id = $(e.currentTarget).data("id");
            this.saveToFavorites(id, $(e.currentTarget));
        });

        // GOOD / BAD RATING
        $(document).on("click", ".rate-good-btn", (e) => {
            e.preventDefault();
            this.rateMessage($(e.currentTarget).data("id"), "good", $(e.currentTarget));
        });

        $(document).on("click", ".rate-bad-btn", (e) => {
            e.preventDefault();
            this.rateMessage($(e.currentTarget).data("id"), "bad", $(e.currentTarget));
        });

        // MENU DROPDOWN
        $(document).on("click", ".more-btn", (e) => {
            e.preventDefault();
            e.stopPropagation();
            this.toggleMoreMenu($(e.currentTarget).data("id"));
        });

        // SHARE
        $(document).on("click", ".share-btn", (e) => {
            e.preventDefault();
            this.shareMessage($(e.currentTarget).data("id"));
        });

        // PIN
        $(document).on("click", ".pin-btn", (e) => {
            e.preventDefault();
            const id = $(e.currentTarget).data("id");
            this.pinToContext(id, $(e.currentTarget));
        });

        // DELETE
        $(document).on("click", ".delete-btn", (e) => {
            e.preventDefault();
            this.deleteMessage($(e.currentTarget).data("id"));
        });

        // REPORT
        $(document).on("click", ".report-btn", (e) => {
            e.preventDefault();
            this.reportMessageIssue($(e.currentTarget).data("id"));
        });

        // CLOSE MENUS
        $(document).on("click", function (e) {
            if (!$(e.target).closest(".more-menu-wrapper").length) {
                $(".more-menu-dropdown").hide();
            }
        });

        console.log("✅ chatMessage actions initialized");
    },

    /* -------------------------------------------------------------
     * COPY
     * ------------------------------------------------------------- */
    copyToClipboard(text, button) {
        if (navigator.clipboard) {
            navigator.clipboard.writeText(text)
                .then(() => this.showButtonSuccess(button, "Copied!"))
                .catch(() => this.fallbackCopy(text, button));
        } else {
            this.fallbackCopy(text, button);
        }
    },

    fallbackCopy(text, button) {
        const textarea = $("<textarea>")
            .val(text)
            .css({ position: "fixed", opacity: 0 })
            .appendTo("body");

        textarea[0].select();
        document.execCommand("copy");
        textarea.remove();

        this.showButtonSuccess(button, "Copied!");
    },

    /* -------------------------------------------------------------
     * EDIT + REGENERATE
     * ------------------------------------------------------------- */
    editAndRegenerate(messageId, content) {
        apex.message.confirm("Edit this message and regenerate?", (yes) => {
            if (!yes) return;

            const dialogHtml = `
                <textarea id="editMessageText" rows="5" style="width:100%;">${content}</textarea>
            `;

            apex.theme.openRegion("editMessageDialog", {
                title: "Edit Message",
                content: $(dialogHtml),
                buttons: [
                    {
                        text: "Regenerate",
                        action: () => {
                            const newText = $("#editMessageText").val();
                            this.regenerateResponse(messageId, newText);
                            apex.theme.closeRegion("editMessageDialog");
                        }
                    },
                    {
                        text: "Cancel",
                        action: () => apex.theme.closeRegion("editMessageDialog")
                    }
                ]
            });
        });
    },

    regenerateResponse(messageId, newText) {
        apex.item("P115_USER_PROMPT").setValue(newText);
        apex.item("P115_IS_REGENERATION").setValue("Y");
        apex.item("P115_ORIGINAL_MESSAGE_ID").setValue(messageId);
        submitPrompt();
    },

    /* -------------------------------------------------------------
     * EXPORT
     * ------------------------------------------------------------- */
    exportMessage(messageId) {
        const content = $("#msgContent_" + messageId).text();
        const filename = `message_${messageId}_${Date.now()}.txt`;
        const blob = new Blob([content], { type: "text/plain" });
        const url = URL.createObjectURL(blob);

        const a = $("<a>").attr({ href: url, download: filename })[0];
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
        URL.revokeObjectURL(url);

        apex.message.showPageSuccess("Message exported");
    },

    /* -------------------------------------------------------------
     * FAVORITES
     * ------------------------------------------------------------- */
    saveToFavorites(messageId, button) {
        button.addClass("loading");
        apex.server.process(
            "SAVE_TO_FAVORITES",
            { x01: messageId },
            {
                success: () => {
                    button.removeClass("loading").addClass("active success");
                    setTimeout(() => button.removeClass("success"), 2000);
                }
            }
        );
    },

    /* -------------------------------------------------------------
     * RATING
     * ------------------------------------------------------------- */
    rateMessage(messageId, rating, btn) {
        if (btn.hasClass("active")) {
            btn.removeClass("active");
            rating = null;
        } else {
            btn.closest(".bubble-actions")
               .find(".rate-good-btn, .rate-bad-btn")
               .removeClass("active");
            btn.addClass("active");
        }

        apex.server.process("RATE_MESSAGE", {
            x01: messageId,
            x02: rating
        });
    },

    /* -------------------------------------------------------------
     * MORE MENU
     * ------------------------------------------------------------- */
    toggleMoreMenu(messageId) {
        const menu = $(`.more-menu-dropdown[data-id="${messageId}"]`);
        $(".more-menu-dropdown").not(menu).hide();
        menu.toggle();
    },

    /* -------------------------------------------------------------
     * SHARE
     * ------------------------------------------------------------- */
    shareMessage(messageId) {
        const content = $("#msgContent_" + messageId).text();
        const url = `${location.href}&msg=${messageId}`;

        if (navigator.share) {
            navigator.share({ title: "Chat Message", text: content, url });
        } else {
            this.copyToClipboard(url);
            apex.message.showPageSuccess("Link copied");
        }
    },

    /* -------------------------------------------------------------
     * PIN MESSAGE
     * ------------------------------------------------------------- */
    pinToContext(messageId, button) {
        button.addClass("loading");

        apex.server.process(
            "PIN_TO_CONTEXT",
            {
                x01: messageId,
                x02: apex.item("P115_CHAT_SESSION_ID").getValue()
            },
            {
                success: () => {
                    button.removeClass("loading").addClass("active");
                    button.find(".menu-icon").text("📍");
                    apex.message.showPageSuccess("Pinned");
                }
            }
        );
    },

    /* -------------------------------------------------------------
     * DELETE
     * ------------------------------------------------------------- */
    deleteMessage(messageId) {
        apex.message.confirm("Delete this message?", (yes) => {
            if (!yes) return;

            apex.server.process(
                "DELETE_MESSAGE",
                { x01: messageId },
                {
                    success: () => {
                        $(`[data-message-id="${messageId}"]`).fadeOut(200, function () {
                            $(this).remove();
                        });
                    }
                }
            );
        });
    },

    /* -------------------------------------------------------------
     * SUCCESS FEEDBACK
     * ------------------------------------------------------------- */
    showButtonSuccess(button, msg) {
        if (!button?.length) return;

        const original = button.find(".btn-text").text();
        button.addClass("success");
        button.find(".btn-text").text(msg);

        setTimeout(() => {
            button.removeClass("success");
            button.find(".btn-text").text(original);
        }, 1500);
    },

    /* -------------------------------------------------------------
     * CHAT HISTORY
     * ------------------------------------------------------------- */
    scrollChatHistoryToBottom() {
        const el = document.getElementById("chatHistoryContainer");
        if (el) el.scrollTo({ top: el.scrollHeight, behavior: "smooth" });
    },

    refreshChatHistory() {
        apex.region("chatHistoryRegion").refresh();
        setTimeout(() => this.scrollChatHistoryToBottom(), 600);
    },

    /* -------------------------------------------------------------
     * APPEND LIVE MESSAGE
     * ------------------------------------------------------------- */
    appendMessage(role, text, metadata) {
        const c = document.getElementById("mainContainer");
        if (!c) return;

        const div = document.createElement("div");
        div.className = `chat-message chat-message-${role}`;
        div.innerHTML = `
            <div class="message-header">
                <span class="message-icon">${role === "user" ? "🧑" : "🤖"}</span>
                <span class="message-role">${role}</span>
                <span class="message-time">${new Date().toLocaleTimeString()}</span>
            </div>
            <div class="message-content">${text}</div>
            ${
                role === "assistant" && metadata
                    ? `<div class="message-metadata">
                        ${metadata.processing_ms ? `⚡ ${metadata.processing_ms}ms` : ""}
                        ${metadata.tokens ? `📊 ${metadata.tokens} tokens` : ""}
                       </div>`
                    : ""
            }
        `;

        c.appendChild(div);
        c.scrollTop = c.scrollHeight;

        if (role === "assistant") {
            setTimeout(() => this.refreshChatHistory(), 1200);
        }
    }
};

/* Auto-init after page load */
document.addEventListener("DOMContentLoaded", () => chatMessage.initialize());
