--------------------------------------------------------
--  DDL for Package CHAT_CALL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHAT_CALL_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_CALL_PKG (Specification)
 * PURPOSE:     API for managing individual LLM interaction cycles (Calls).
 * * DESCRIPTION: Handles the lifecycle of an LLM call including request 
 * persistence, response logging, and history aggregation.
 * Integrates deeply with LLM_TYPES for standardized I/O.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 */  
    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHAT_CALL_PKG';

    /*******************************************************************************
     * UTILITY FUNCTIONS
     * Required in Specification for visibility within SQL statements.
     *******************************************************************************/




    /***********************************************************************************
     * Function: bool_to_char
     * Converts PL/SQL BOOLEAN to database CHAR(1) ('Y'/'N').
     **********************************************************************************/
    FUNCTION bool_to_char(p_bool BOOLEAN) RETURN CHAR DETERMINISTIC;

    /**
     * Function: char_to_bool
     * Converts database CHAR(1) ('Y'/'N') to PL/SQL BOOLEAN.
     */
    FUNCTION char_to_bool(p_char CHAR) RETURN BOOLEAN DETERMINISTIC;

    /*******************************************************************************
     * PUBLIC API - PERSISTENCE & RETRIEVAL
     *******************************************************************************/


      Function New_ChatCall (p_chat_session_id in number, p_trace_id in varchar2) return number;

    /*********************************************************************************
     * Function: add_call
     * Creates a new record in CHAT_CALLS.
     * @param  p_request  The standardized request object.
     * @param  p_response Optional immediate response object.
     * @return CALL_ID (Primary Key).
     ********************************************************************************/
    FUNCTION add_call(
        p_request  IN llm_types.t_llm_request,
        p_response IN llm_types.t_llm_response DEFAULT NULL
    ) RETURN NUMBER;

    /***********************************************************************************
     * Procedure: update_call_response
     * Updates an existing call ID with asynchronously received LLM data.
     **********************************************************************************/
    PROCEDURE update_call_response(
        p_call_id  IN NUMBER,
        p_response IN llm_types.t_llm_response
    );

    /***********************************************************************************
     * Function: New_traceid
     *  
     **********************************************************************************/
     Function New_traceid   return varchar2;
    /***********************************************************************************
     * Function: get_call
     * Alias for get_call_response. Fetches response data for a specific call.
     **********************************************************************************/
    FUNCTION get_call(p_call_id IN NUMBER) RETURN llm_types.t_llm_response;

    /***********************************************************************************
     * Function: get_call_request
     * Retrieves the original prompt and parameters for a specific call.
     **********************************************************************************/
    FUNCTION get_call_request(p_call_id IN NUMBER) RETURN llm_types.t_llm_request;

    /***********************************************************************************
     * Function: get_call_response
     * Retrieves the LLM result, RAG metadata, and token usage for a call.
     **********************************************************************************/
    FUNCTION get_call_response(p_call_id IN NUMBER) RETURN llm_types.t_llm_response;

    /*******************************************************************************
     * PUBLIC API - INTEGRATION & CONVERSATION
     *******************************************************************************/

    /***********************************************************************************
     * Function: list_calls
     * Returns a Ref Cursor of calls for a specific session. 
     * Optimized for APEX Classic/Interactive Reports and pagination.
     **********************************************************************************/
    FUNCTION list_calls(
        p_session_id IN NUMBER,
        p_limit      IN NUMBER DEFAULT NULL,
        p_offset     IN NUMBER DEFAULT 0
    ) RETURN SYS_REFCURSOR;

    /***********************************************************************************
     * Procedure: update_call
     * Low-level update for response text or payload metadata.
     **********************************************************************************/
    PROCEDURE update_call(
        p_call_id           IN NUMBER,
        p_response_text     IN CLOB DEFAULT NULL,
        p_response_metadata IN CLOB DEFAULT NULL
    );

    /***********************************************************************************
     * Function: regenerate
     * Triggers a new generation for the last prompt in a session.
     * @param p_new_params Optional JSON to override original parameters.
     **********************************************************************************/
    FUNCTION regenerate(
        p_session_id IN NUMBER,
        p_new_params IN JSON DEFAULT NULL
    ) RETURN NUMBER;

    /***********************************************************************************
     * Function: get_conversation_history
     * Builds a JSON Array of {role, content} for context window management.
     * @param p_max_calls Number of previous interactions to include.
     **********************************************************************************/
    FUNCTION get_conversation_history(
        p_session_id IN NUMBER,
        p_max_calls  IN NUMBER DEFAULT 10
    ) RETURN CLOB;

    /***********************************************************************************
     * Procedure: pdate_call_response
     * Low-level update for response text or payload metadata.
     **********************************************************************************/

   PROCEDURE update_call_response(
        p_call_id  IN NUMBER,
        p_trace_id IN Varchar2,
        p_user_prompt IN clob,
        p_response IN clob,
        p_status   IN varchar2 );


END chat_call_pkg;

/
