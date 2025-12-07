/* ==========================================================================
   Sidebar Actions – Project & Session Controls
   ========================================================================== */

window.SidebarActions = {
    newProject() {
        apex.message.showPageSuccess("Creating new project...");
    },

    newSession() {
        apex.message.showPageSuccess("Creating new chat session...");
    }
};

document.addEventListener("DOMContentLoaded", () => {
    $("#btnNewProject").click(() => SidebarActions.newProject());
    $("#btnNewSession").click(() => SidebarActions.newSession());
});
