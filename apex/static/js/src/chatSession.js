/* ============================================================================
   NAMESPACE: chatSession (Refactored)
   Clean, consistent, production-ready
   ============================================================================ */

window.chatSession = (function () {
    "use strict";

    // Private state
    let _originalTitle = "";

    // ------------------------------
    // Private Helper: Get elements
    // ------------------------------
    function _getElements(sessionId) {
        return {
            titleSpan: $("#sessionTitle_" + sessionId),
            editInput: $("#sessionTitleEdit_" + sessionId),
            editBtn: $(`.session-edit-btn[data-session-id="${sessionId}"]`),
            saveBtn: $("#saveBtn_" + sessionId),
            cancelBtn: $("#cancelBtn_" + sessionId),
            menu: $("#sessionMenuList_" + sessionId)
        };
    }

    // ------------------------------
    // Private Helper: Close all menus
    // ------------------------------
    function _closeAllMenus() {
        $(".apex-menu").hide();
    }

    // ------------------------------
    // PUBLIC API
    // ------------------------------
    return {

        /* ----------------------------------------------
           Toggle Edit Mode
        ---------------------------------------------- */
        toggleEditMode(sessionId) {
            console.log("✏️ [chatSession] Edit Mode →", sessionId);

            const el = _getElements(sessionId);
            if (!el.titleSpan.length || !el.editInput.length) {
                console.error("❌ Elements missing for session:", sessionId);
                return;
            }

            _originalTitle = el.titleSpan.text().trim();

            el.titleSpan.hide();
            el.editInput.val(_originalTitle).show().focus().select();

            el.editBtn.hide();
            el.saveBtn.show();
            el.cancelBtn.show();
        },

        /* ----------------------------------------------
           Cancel Edit → Restore original title
        ---------------------------------------------- */
        cancelEdit(sessionId) {
            console.log("↩️ [chatSession] Cancel Edit →", sessionId);

            const el = _getElements(sessionId);

            el.editInput.val(_originalTitle);
            el.titleSpan.show();
            el.editInput.hide();

            el.editBtn.show();
            el.saveBtn.hide();
            el.cancelBtn.hide();
        },

        /* ----------------------------------------------
           Save Title
        ---------------------------------------------- */
        saveSessionTitle(sessionId) {
            console.log("💾 [chatSession] Save →", sessionId);

            const el = _getElements(sessionId);
            const newTitle = el.editInput.val().trim();

            if (!newTitle) {
                apex.message.alert("Session title cannot be empty");
                return;
            }

            apex.server.process(
                "UPDATE_SESSION_TITLE",
                { x01: sessionId, x02: newTitle },
                {
                    dataType: "json",
                    success: function (response) {
                        if (!response.success) {
                            apex.message.alert("❌ Error: " + (response.message || "Failed"));
                            return;
                        }

                        el.titleSpan.text(newTitle);
                        _originalTitle = newTitle;

                        chatSession.cancelEdit(sessionId);
                        apex.message.showPageSuccess("Title updated");

                        if ($("#P115_SESSION_TITLE").length) {
                            apex.item("P115_SESSION_TITLE").setValue(newTitle);
                        }
                    },
                    error: function (_, __, error) {
                        apex.message.alert("❌ Update failed: " + error);
                    }
                }
            );
        },

        /* ----------------------------------------------
           Toggle Menu (3-dot menu)
        ---------------------------------------------- */
        toggleMenu(sessionId) {
            console.log("📋 [chatSession] Toggle Menu →", sessionId);

            const el = _getElements(sessionId);
            const visible = el.menu.is(":visible");

            _closeAllMenus();
            if (!visible) {
                el.menu.show();
            }
        },

        /* ----------------------------------------------
           Copy Clipboard
        ---------------------------------------------- */
        copyToClipboard(text) {
            navigator.clipboard
                .writeText(text)
                .then(() => apex.message.showPageSuccess("📋 Copied!"))
                .catch(err => apex.message.alert("❌ Copy failed: " + err));
        },

        /* ----------------------------------------------
           Report Session Issue (Page 116 modal)
        ---------------------------------------------- */
       reportSessionIssue(sessionId) {
    console.log("🚨 [chatSession] Report Issue →", sessionId);

    if (!sessionId) {
        apex.message.alert("No active session");
        return;
    }

    _closeAllMenus();

    const issueLevel = "SESSION";

    apex.server.process(
        "GENERATE_REPORT_ISSUE_URL",
        { x01: sessionId, x02: issueLevel },
        {
            dataType: "json",
            success: function (response) {

                if (!response.success || !response.url) {
                    apex.message.alert("❌ Server did not return a valid URL");
                    return;
                }

                // The URL is ONLY valid inside the callback
                const url = response.url;

                console.log("🟢 Opening dialog with URL:", url);
                 apex.navigation.redirect(url);
                // window.open(url, "_blank");   // <— FIX
            },
            error: function (err) {
                console.error("❌ AJAX Error:", err);
                apex.message.alert("Failed to generate issue URL.");
            }
        }
    );
},


        /* ----------------------------------------------
           Menu Action Dispatcher
        ---------------------------------------------- */
        handleMenuAction(action, sessionId) {
            switch (action) {
                case "edit-title":
                    this.toggleEditMode(sessionId);
                    break;

                case "copy-title":
                    this.copyToClipboard($("#sessionTitle_" + sessionId).text().trim());
                    break;

                case "report-session-issue":
                    this.reportSessionIssue(sessionId);
                    break;

                case "clear-session":
                    apex.message.confirm("Clear this session?", yes => {
                        if (yes) apex.page.submit("CLEAR_SESSION");
                    });
                    break;

                case "export-session":
                    apex.message.alert("Export feature coming soon.");
                    break;

                default:
                    console.warn("⚠️ Unknown menu action:", action);
            }
        },

          /* ----------------------------------------------
           PUBLIC: Enable buttons (called when new session created)
        ---------------------------------------------- */
          disableButtons() {
                $(".session-edit-btn, .session-menu-btn").each(function () {
                    $(this).prop("disabled", true);
                    $(this).addClass("is-disabled");
                });
            },

            enableButtons() {
                $(".session-edit-btn, .session-menu-btn").each(function () {
                    $(this).prop("disabled", false);
                    $(this).removeClass("is-disabled");
                });
            },

        /* ----------------------------------------------
           Initialize Session Header
        ---------------------------------------------- */
        init() {
            console.log("🔧 [chatSession] Initializing...");

            /* ----------------------------------------------------------
               Automatically disable when no current session exists
            ---------------------------------------------------------- */
            const sid = $v("P115_CHAT_SESSION_ID");
            if (!sid || sid === "") {
                console.log("🚫 No session detected → disabling header buttons");
                this.disableButtons();
            } else {
                console.log("🟢 Session active → enabling header buttons");
                this.enableButtons();
            }

            /* ----------------------------------------------------------
               Close menus when clicking outside
            ---------------------------------------------------------- */
            $(document).on("click", e => {
                if (!$(e.target).closest(".session-actions-menu, .apex-menu").length) {
                    _closeAllMenus();
                }
            });

            /* ----------------------------------------------------------
               Save on Enter / Cancel on Escape
            ---------------------------------------------------------- */
           $(document).on("keydown", ".session-title-edit", function (e) {
                const sessionId = $(this).data("session-id");

                if (e.key === "Enter") {
                    e.preventDefault();
                    chatSession.saveSessionTitle(sessionId);
                }

                if (e.key === "Escape") {
                    e.preventDefault();
                    chatSession.cancelEdit(sessionId);
                }
            });

            $(document).on("click", ".apex-menu-link", function (e) {
                e.preventDefault();

                const action = $(this).data("action");
                const sessionId = $(this).data("session-id");

                _closeAllMenus();
                chatSession.handleMenuAction(action, sessionId);
            });

            console.log("✅ [chatSession] Ready");
        }
    };
})();

 