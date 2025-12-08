
/* ============================================================================
   NAMESPACE: chatProject
   Handles project/session tree navigation
   ============================================================================ */
window.chatProject = (function() {
    'use strict';
    
    return {
        
        /**
         * Toggle project sessions visibility (expand/collapse)
         * @param {number} projectId - The project ID
         */
        toggleSessions: function(projectId) {
            console.log('🔄 [chatProject] Toggling project:', projectId);
            
            const projectItem = document.querySelector('[data-project-id="' + projectId + '"]');
            
            if (!projectItem) {   console.warn(⚠️ [chatProject] Project item not found:', projectId);
                return;
            }
            
            const sessionsContainer = projectItem.querySelector('.project-sessions');
            
            if (!sessionsContainer) { console.warn('⚠️ [chatProject] Sessions container not found for project:', projectId);
                return;
            }
            
            const isHidden = sessionsContainer.style.display === 'none';
            sessionsContainer.style.display = isHidden ? 'block' : 'none';
            
            const icon = projectItem.querySelector('.project-toggle-icon');
            if (icon) {
                icon.classList.toggle('fa-chevron-down', isHidden);
                icon.classList.toggle('fa-chevron-right', !isHidden);
            }
            
            console.log('✅ [chatProject] Project toggled:', projectId, isHidden ? 'expanded' : 'collapsed');
        },
        
        /**
         * Load sessions for a project via AJAX
         * @param {number} projectId - The project ID
         * @param {HTMLElement} container - Container to load sessions into
         */
       /* loadSessions: function(projectId, container) {
            console.log('📥 [chatProject] Loading sessions for project:', projectId);
            
            container.innerHTML = '<div class="sessions-loading"><div class="spinner"></div>Loading sessions...</div>';
            
            apex.server.process('GET_PROJECT_SESSIONS', {
                x01: projectId,
                pageItems: '#P115_CHAT_SESSION_ID'
            }, {
                dataType: 'html',
                success: function(sessionsHtml) {
                    console.log('✅ [chatProject] Sessions loaded for project:', projectId);
                    container.innerHTML = sessionsHtml;
                    container.dataset.loaded = 'true';
                },
                error: function(xhr, status, error) {
                    console.error('❌ [chatProject] Error loading sessions:', error);
                    container.innerHTML = 
                        '<div class="no-sessions-message">' +
                            '<p>Failed to load sessions</p>' +
                        '</div>';
                }
            });
        },
        */
        /**
         * Load a specific chat session
         * @param {number} sessionId - The session ID
         */
       /* loadSession: function(sessionId) {
            console.log('📂 [chatProject] Loading session:', sessionId);
            
            if (!sessionId) {
                console.error('❌ [chatProject] Invalid session ID');
                return;
            }
            
            apex.item('P115_CHAT_SESSION_ID').setValue(sessionId);
            
            // Refresh session header
            try {
                const sessionHeaderRegion = apex.region("myActiveSessionStaticID");
                if (sessionHeaderRegion) {
                    sessionHeaderRegion.refresh();
                }
            } catch (e) {
                console.warn('⚠️ [chatProject] Could not refresh session header:', e.message);
            }
            
            // Clear chat window
            const chatWindow = document.getElementById('chatWindow');
            if (chatWindow) {
                chatWindow.innerHTML = '';
            }
            
            // Load history if AI115 namespace exists
            if (typeof window.AI115 !== 'undefined' && window.AI115.loadHistory) {
                window.AI115.config.historyOffset = 0;
                window.AI115.loadHistory(false);
            }
            
            // Update active state
            document.querySelectorAll('.session-item').forEach(function(item) {
                item.classList.remove('active-session');
            });
            
            const activeItem = document.querySelector('.session-item[data-session-id="' + sessionId + '"]');
            if (activeItem) {
                activeItem.classList.add('active-session');
            }
            
            apex.message.showPageSuccess('Session ' + sessionId + ' loaded');
        },
        */
        /**
         * Refresh the entire projects sidebar
         */
        refresh: function() {
            console.log('🔄 [MyProjects] Refreshing sidebar');
            apex.region("myProjectsTreeStaticID").refresh();
        },
        
        /**
         * Initialize event handlers
         */
        init: function() {
            console.log('🔧 [chatProject] Initializing...');
            // Add any sidebar-specific event handlers here
            console.log('✅ [chatProject] Initialized');
        }
    };
})();

