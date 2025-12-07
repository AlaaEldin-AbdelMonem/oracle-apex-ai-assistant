/* ==========================================================================
   Chat UI Script – Oracle APEX AI Assistant
   ========================================================================== */

window.ChatUI = {
    init() {
        console.log("ChatUI Loaded");
    },

    showTyping() {
        $("#typingIndicator").show();
    },

    hideTyping() {
        $("#typingIndicator").hide();
    },

    appendUserMessage(text) {
        $("#chatWindow").append(`
            <div class="message-user">${text}</div>
        `);
    },

    appendAIMessage(text) {
        $("#chatWindow").append(`
            <div class="message-ai">${text}</div>
        `);
    }
};

document.addEventListener("DOMContentLoaded", () => ChatUI.init());
