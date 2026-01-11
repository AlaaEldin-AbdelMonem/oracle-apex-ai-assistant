--------------------------------------------------------
--  DDL for Package LLM_STREAM_ADAPTER_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_STREAM_ADAPTER_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_STREAM_ADAPTER_UTIL (Specification)
 * PURPOSE:     Unified Streaming Callback and Accumulation Adapter.
 *
 * DESCRIPTION: Acts as a central middleware for all LLM providers (OpenAI, Gemini, 
 * Claude, Local) to handle token-by-token streaming. It manages:
 * - Token accumulation for final response logging.
 * - Dynamic routing to different UI channels (APEX, ORDS, DBMS_OUTPUT).
 * - Multi-mode streaming logic (Background vs. Real-time UI).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_STREAM_ADAPTER_UTIL'; 

    /*******************************************************************************
     * PUBLIC STATE (SESSION LEVEL)
     *******************************************************************************/
    
    /** Current active channel (APEX, ORDS, DBMS_OUTPUT, or BACKEND) */
    g_stream_channel   VARCHAR2(30);
    
    /** Correlation ID for tracing this specific stream session */
    g_trace_id         VARCHAR2(200);
    
    /** Buffer used to accumulate the full text as tokens arrive */
    g_final_response   CLOB;

    /*******************************************************************************
     * STREAM LIFECYCLE API
     *******************************************************************************/

    /**
     * Procedure: init
     * Prepares the global state for a new streaming session.
     * @param p_stream_channel The destination for the tokens.
     * @param p_trace_id       Trace ID for log correlation.
     */
    PROCEDURE init(
        p_stream_channel IN VARCHAR2, 
        p_trace_id       IN VARCHAR2 
    );

    /**
     * Procedure: on_token
     * Callback triggered every time an LLM provider receives a text chunk/delta.
     * Handles both the accumulation in g_final_response and the immediate emission.
     * @param p_token The specific text fragment received from the model.
     */
    PROCEDURE on_token( p_token IN VARCHAR2 );

    /**
     * Procedure: on_end
     * Finalizes the stream session. Used to sync the final accumulated CLOB 
     * and perform any required cleanup or logging.
     * @param p_full_response The complete text received throughout the stream.
     */
    PROCEDURE on_end( p_full_response IN CLOB );

    /*******************************************************************************
     * INTERNAL CHANNEL EMITTER
     *******************************************************************************/

    /**
     * Procedure: emit
     * Responsible for the physical delivery of text to the specified channel.
     * - APEX/ORDS: Uses htp.p/w for Server-Sent Events (SSE).
     * - DBMS_OUTPUT: Useful for SQL Developer / TOAD debugging.
     * @param p_text The text to be pushed to the client.
     */
    PROCEDURE emit( p_text IN VARCHAR2 );

END llm_stream_adapter_util;

/
