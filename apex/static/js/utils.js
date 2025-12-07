/* ==========================================================================
   Utility Functions for APEX AI Assistant
   ========================================================================== */

window.Utils = {
    uuid() {
        return Date.now().toString(16) + Math.random().toString(16).substring(2);
    },

    scrollToBottom() {
        const el = document.getElementById("chatWindow");
        if (el) el.scrollTop = el.scrollHeight;
    }
};
