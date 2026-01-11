--------------------------------------------------------
--  DDL for Package CHAT_SESSION_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHAT_SESSION_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_SESSION_PKG (Specification)
 * PURPOSE:     Lifecycle management for AI Chat Sessions.
 *
 * DESCRIPTION: Handles session creation, metadata updates, and cleanup tasks.
 * Optimized for Oracle APEX integration via global item defaults.
 * Supports session tracking by both ID and UUID.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  Oracle APEX (v function)
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHAT_SESSION_PKG';

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/

    /**
     * Record: t_chat_session_rec
     * Complete representation of a session row for easy PL/SQL manipulation.
     */
    TYPE t_chat_session_rec IS RECORD (
        session_id          chat_sessions.session_id%TYPE,
        session_uuid        chat_sessions.session_uuid%TYPE,
        user_id             chat_sessions.user_id%TYPE,
        session_title       chat_sessions.session_title%TYPE,
        provider            chat_sessions.provider%TYPE,
        model               chat_sessions.model%TYPE,
        created_date        chat_sessions.created_date%TYPE,
        last_activity_date  chat_sessions.last_activity_date%TYPE,
        message_count       chat_sessions.message_count%TYPE,
        total_tokens        chat_sessions.tokens_total%TYPE,
        total_cost          chat_sessions.tokens_total_cost%TYPE,
        is_active           chat_sessions.is_active%TYPE,
        app_session_id      chat_sessions.app_session_id%TYPE,
        session_metadata    chat_sessions.session_metadata%TYPE,
        context_domain_id   chat_sessions.context_domain_id%TYPE,
        tenant_id           chat_sessions.tenant_id%TYPE,
        app_page_id         chat_sessions.app_page_id%TYPE,
        project_id          chat_sessions.chat_project_id%TYPE,
        app_id              chat_sessions.app_id%TYPE,
        trace_id            chat_sessions.trace_id%TYPE
    );

    /*******************************************************************************
     * SESSION CREATION & RETRIEVAL
     *******************************************************************************/

    /**
     * Function: new_session
     * Initializes a new chat thread. Defaults are pulled from APEX session state.
     * @return session_id (Primary Key)
     */
    FUNCTION new_session(
        p_provider        IN VARCHAR2,
        p_model           IN VARCHAR2,
        p_session_title   IN VARCHAR2 DEFAULT NULL,
        p_user_id         IN NUMBER   DEFAULT v('G_USER_ID'),
        p_app_id          IN NUMBER   DEFAULT v('APP_ID'),
        p_app_page_id     IN NUMBER   DEFAULT v('APP_PAGE_ID'),
        p_project_id      IN NUMBER   DEFAULT v('G_CHAT_PROJECT_ID'),
        p_app_session_id  IN NUMBER   DEFAULT v('APP_SESSION'),
        p_tenant_id       IN NUMBER   DEFAULT v('G_TENANT_ID'),
        p_trace_id        OUT Varchar2 
    ) RETURN NUMBER;
    

    FUNCTION get_traceid_from_chatsession(p_session_id IN NUMBER,    p_trace_id   IN VARCHAR2) RETURN varchar2;
    
    FUNCTION get_session(p_session_id IN NUMBER   ,p_trace_id   IN VARCHAR2 default NULL) RETURN t_chat_session_rec;

    FUNCTION get_by_uuid(p_uuid      IN VARCHAR2  ,p_trace_id   IN VARCHAR2) RETURN t_chat_session_rec;

    FUNCTION get_session_title(p_session_id IN NUMBER , p_trace_id IN VARCHAR2 default NULL ) RETURN VARCHAR2;

    /*******************************************************************************
     * SESSION UPDATES
     *******************************************************************************/

    PROCEDURE update_session_title(
        p_session_id    IN NUMBER, 
        p_session_title IN VARCHAR2 ,  
        p_trace_id   IN VARCHAR2 
    );

    /**
     * Procedure: update_session
     * Generic update for session-level attributes and metadata.
     */
    PROCEDURE update_session(
        p_session_id     IN NUMBER,
        p_app_session_id IN NUMBER   DEFAULT v('APP_SESSION'),
        p_user_id        IN NUMBER   DEFAULT v('G_USER_ID'),
        p_is_active      IN VARCHAR2 DEFAULT NULL,
        p_provider       IN VARCHAR2 DEFAULT NULL,
        p_model          IN VARCHAR2 DEFAULT NULL,
        p_session_title  IN VARCHAR2 DEFAULT NULL,
        p_project_id     IN NUMBER   DEFAULT v('G_CHAT_PROJECT_ID') ,
        p_trace_id      IN VARCHAR2
    );

    /**
     * Procedure: update_session_totals
     * Recalculates message counts, token totals, and costs for the session.
     */
    PROCEDURE update_session_totals(p_session_id IN NUMBER ,   p_trace_id   IN VARCHAR2);

    /*******************************************************************************
     * MAINTENANCE & UTILITIES
     *******************************************************************************/

    /**
     * Procedure: delete_session
     * Supports soft-delete (setting active='N') or hard physical deletion.
     */
    PROCEDURE delete_session(
        p_session_id IN NUMBER,
        p_hard       IN VARCHAR2 DEFAULT 'N',
        p_trace_id   IN VARCHAR2
    );

    FUNCTION session_exists(p_session_id IN NUMBER,    p_trace_id   IN VARCHAR2) RETURN BOOLEAN;

    /**
     * Function: generate_session_title
     * Suggests a title for the session based on the content of the first message.
     */
    FUNCTION generate_session_title(p_first_message IN CLOB  ,  p_trace_id   IN VARCHAR2) RETURN VARCHAR2;

    /*******************************************************************************
     * BULK OPERATIONS
     *******************************************************************************/

    FUNCTION archive_old(p_days_old NUMBER DEFAULT 90,   p_trace_id   IN VARCHAR2) RETURN NUMBER;

    FUNCTION purge_old(p_days_old NUMBER DEFAULT 180 ,  p_trace_id   IN VARCHAR2) RETURN NUMBER;

END chat_session_pkg;

/
