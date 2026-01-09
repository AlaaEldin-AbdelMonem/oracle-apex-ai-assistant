--------------------------------------------------------
--  DDL for Package CHAT_HISTORY_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CHAT_HISTORY_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_HISTORY_UTIL (Specification)
 * PURPOSE:     Utility package for managing and retrieving chat history 
 * metadata and access control.
 *
 * DESCRIPTION: Provides helper functions for authorization checks on logs,
 * user role identification, and reference data retrieval for 
 * history filters (Models and Event Types).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHAT_HISTORY_UTIL';

    /*******************************************************************************
     * AUTHORIZATION & ROLES
     *******************************************************************************/

    /**
     * Function: get_user_role_code
     * Returns the internal security role code for a given user.
     * @param  p_user_id  The unique identifier of the user (e.g., APP_USER).
     */
    FUNCTION get_user_role_code(p_user_id IN VARCHAR2) RETURN VARCHAR2;

    /**
     * Function: can_view_all_logs
     * Determines if the user has administrative privileges to view global 
     * conversation logs across all sessions.
     * @return BOOLEAN - True if user has 'ADMIN' or 'AUDITOR' level access.
     */
    FUNCTION can_view_all_logs(p_user_id IN VARCHAR2) RETURN BOOLEAN;

    /*******************************************************************************
     * REFERENCE DATA RETRIEVAL (UI/APEX Support)
     *******************************************************************************/

    /**
     * Procedure: get_model_list
     * Fetches a distinct list of AI models used in historical calls.
     * @param p_models OUT Ref Cursor containing model names and counts.
     */
    PROCEDURE get_model_list(p_models OUT SYS_REFCURSOR);

  
END chat_history_util;

/
