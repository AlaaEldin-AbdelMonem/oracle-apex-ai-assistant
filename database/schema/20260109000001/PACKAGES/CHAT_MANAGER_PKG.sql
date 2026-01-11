--------------------------------------------------------
--  DDL for Package CHAT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHAT_MANAGER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_MANAGER_PKG (Specification)
 * PURPOSE:     Session lifecycle management, message threading, and analytics.
 *
 * DESCRIPTION: Core engine for managing chat session states, user feedback/ratings,
 * and multi-format conversation exports (JSON, Text, Markdown).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 */

    -- Global Constants
    c_version            CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name       CONSTANT VARCHAR2(30) := 'CHAT_MANAGER_PKG';

    -- Message Role Constants
    c_role_user          CONSTANT VARCHAR2(20) := 'USER';
    c_role_assistant     CONSTANT VARCHAR2(20) := 'ASSISTANT';
    c_role_system        CONSTANT VARCHAR2(20) := 'SYSTEM';

    -- Feedback & Rating Constants
    c_feedback_positive  CONSTANT VARCHAR2(20) := 'LIKE';
    c_feedback_negative  CONSTANT VARCHAR2(20) := 'DISLIKE';
    c_feedback_neutral   CONSTANT VARCHAR2(20) := 'NEUTRAL';
    c_feedback_excellent CONSTANT VARCHAR2(20) := 'EXCELLENT';

    -- Export Format Constants
    c_export_json        CONSTANT VARCHAR2(10) := 'JSON';
    c_export_text        CONSTANT VARCHAR2(10) := 'TEXT';
    c_export_markdown    CONSTANT VARCHAR2(10) := 'MARKDOWN';

    /*******************************************************************************
     * CONVERSATION MANAGEMENT
     *******************************************************************************/

    /**
     * Function: regenerate_response
     * Marks the previous assistant message as regenerated and triggers a new attempt.
     * Useful for "try again" UI functionality with modified parameters.
     * @param  p_session_id - Target session identifier.
     * @param  p_new_params - Optional JSON overrides for model parameters.
     * @return NUMBER       - The ID of the newly created call/message.
     */
    FUNCTION regenerate_response(
        p_session_id IN NUMBER,
        p_new_params IN JSON DEFAULT NULL
    ) RETURN NUMBER;

    /**
     * Procedure: add_call_rating
     * Submits user feedback/rating for a specific assistant response.
     * @param p_call_id  - The unique identifier for the specific LLM call.
     * @param p_rating   - Feedback code (LIKE, DISLIKE, NEUTRAL, EXCELLENT).
     * @param p_comment  - Optional qualitative user feedback.
     */
    PROCEDURE add_call_rating(
        p_call_id IN NUMBER,
        p_rating  IN VARCHAR2,
        p_comment IN VARCHAR2 DEFAULT NULL
    );

    /*******************************************************************************
     * STATISTICS & ANALYTICS
     *******************************************************************************/

    /**
     * Function: get_user_stats
     * Aggregates usage metrics across all sessions for a specific user.
     * @param  p_user_id   - Unique user identifier.
     * @param  p_days_back - History window (Default 30 days).
     * @return JSON        - Object containing token counts, session counts, and costs.
     */
    FUNCTION get_user_stats(
        p_user_id   IN VARCHAR2,
        p_days_back IN NUMBER DEFAULT 30
    ) RETURN JSON;

    /*******************************************************************************
     * EXPORT UTILITIES
     *******************************************************************************/

    /**
     * Function: export_session_json
     * Returns a full technical dump of the session including metadata and RAG sources.
     */
    FUNCTION export_session_json(p_session_id IN NUMBER) RETURN CLOB;

    /**
     * Function: export_session_text
     * Returns a human-readable plain text transcript of the conversation.
     */
    FUNCTION export_session_text(p_session_id IN NUMBER) RETURN CLOB;

    /**
     * Function: export_session_markdown
     * Returns a Markdown-formatted transcript compatible with GitHub/Obsidian.
     */
    FUNCTION export_session_markdown(p_session_id IN NUMBER) RETURN CLOB;

    /*******************************************************************************
     * VALIDATION HELPERS
     *******************************************************************************/

    FUNCTION is_valid_role(p_role IN VARCHAR2) RETURN BOOLEAN;

    FUNCTION is_valid_rating(p_rating IN VARCHAR2) RETURN BOOLEAN;

END chat_manager_pkg;

/
