--------------------------------------------------------
--  DDL for Package DEBUG_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."DEBUG_UTIL" AS
/*********************************************************************************
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      DEBUG_UTIL (Specification)
 * PURPOSE:     Unified Logging and Observability Framework.
 *
 * DESCRIPTION: Provides structured logging across different severity levels. 
 * Supports call-stack identification, trace ID tracking for AI requests, 
 * and lifecycle markers (starting/ending) for performance and debug analysis.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 *****************************************************************************/

    -- Log Level Constants
    c_error   CONSTANT NUMBER := 1;--❌	Fatal crashes / User blocks.
    c_warn    CONSTANT NUMBER := 2;--⚠️	Unexpected behavior / Retries.
    c_info    CONSTANT NUMBER := 3;--ℹ️	Milestones / Business Events / Flow.
    c_debug   CONSTANT NUMBER := 4;--🔍	Standard development debugging.
    c_trace   CONSTANT NUMBER := 5;--🔡Extreme detail / Loop data / Raw payloads.
    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'DEBUG_UTIL'; 

    /*******************************************************************************
     * STATE MANAGEMENT & INITIALIZATION
          * Procedure: reset_state
     * Clears session-specific debugging variables.
     *******************************************************************************/
       PROCEDURE reset_state;
    /*******************************************************************************
    * Procedure: init
     * Initializes the debugging context with session and user metadata.
     *******************************************************************************/
 
    PROCEDURE init(
        p_app_id        IN NUMBER   DEFAULT NULL,
        p_page_id       IN NUMBER   DEFAULT NULL,
        p_user_id       IN NUMBER   DEFAULT NULL,
        p_session_id    IN NUMBER   DEFAULT NULL,
        p_module_name   IN VARCHAR2 DEFAULT NULL,
        p_force_reinit  IN BOOLEAN  DEFAULT FALSE
    );

    /*******************************************************************************
     * Function: is_on
     * Checks if a specific log level is active for the current session or module.

     *******************************************************************************/
 
    FUNCTION is_on(
        p_level        IN NUMBER,
        p_module_name  IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN;

  
 /*******************************************************************************
  * CORE LOGGING INTERFACE
 *******************************************************************************/
    PROCEDURE log(
        p_message        IN VARCHAR2,
        p_level          IN NUMBER   DEFAULT c_info,
        p_extra_data     IN CLOB     DEFAULT NULL,
        p_caller         IN VARCHAR2,  
        p_trace_id       IN VARCHAR2 DEFAULT NULL,
        p_log_type       IN VARCHAR2 DEFAULT 'TECH' 
    );
/*******************************************************************************
c_error (Level 1)
Purpose: Critical failures that stop a process or produce incorrect results.

When to use: Inside WHEN OTHERS exception blocks, API connection failures, or data integrity violations.

Visibility: Always enabled in all environments (Production, UAT, Dev).

Example: "Failed to connect to OpenAI API: ORA-29273."
DEBUG_UTIL.error( p_message => , p_caller =>  ,  p_trace_id  =>   ) ;
*******************************************************************************/
    PROCEDURE error(
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    );

 /*******************************************************************************
c_warn (Level 2)
Purpose: Non-critical issues that don't stop the code but indicate something is "off."

When to use: LLM retries, fallback provider activation, or missing optional metadata.

Visibility: Usually enabled in Production to monitor system health.

Example: "OpenAI timed out; falling back to Anthropic Claude.

DEBUG_UTIL.warn( p_message => , p_caller =>  ,  p_trace_id  =>   ) ;
  *******************************************************************************/
 
    PROCEDURE warn(--c_warn log_type=TECH
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    );

 /*******************************************************************************
c_info (Level 3)
Purpose: High-level milestones in the business logic or AI pipeline.

When to use: Starting a RAG process, finishing a document embedding, or successful user authentication.

Visibility: Enabled in Production during new releases or in UAT.

Example: "RAG Pipeline: Successfully retrieved 5 document chunks for User X."
 usage: DEBUG_UTIL.info( p_message => , p_caller =>  ,  p_trace_id  =>   ) ;
     *******************************************************************************/
 PROCEDURE info( --c_info log_type=TECH
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    );

 /*******************************************************************************
c_debug (Level 4)
    Purpose: Extreme technical detail for developers to trace exact logic flow.
   
    When to use: Dumping raw JSON payloads, showing loop counters, or printing SQL variable values.
    
    Visibility: Disabled in Production to prevent performance overhead and table bloat; only enabled in Development.
    
    Example: "Raw JSON Request: { 'model': 'gpt-4o', 'messages': [...] }" 
     usage: DEBUG_UTIL.debug( p_message => , p_caller =>  ,  p_trace_id  =>   ) ;
 *******************************************************************************/
 PROCEDURE debug( --c_info, log_type=TECH
        p_message  IN VARCHAR2, 
        p_caller   IN VARCHAR2,
        p_trace_id IN VARCHAR2 DEFAULT NULL
    );
    /*******************************************************************************
     * Procedure: starting
     * Logs the entry point of a process. Used for performance profiling.
     * usage: DEBUG_UTIL.starting(p_caller =>  ,  p_message => ,  p_trace_id  =>   ) ;
     *******************************************************************************/
 
    PROCEDURE starting(  --c_info , log_type   => 'FLOW'  --Trace the path of execution.
         p_caller   IN VARCHAR2,
         p_message  IN VARCHAR2 DEFAULT NULL, 
         p_trace_id IN VARCHAR2 DEFAULT NULL
    );
    /*******************************************************************************
    * Procedure: ending
     * Logs the exit point of a process.
     * usage: DEBUG_UTIL.ending(p_caller =>  ,  p_message => ,  p_trace_id  =>   ) ;
     *******************************************************************************/
   
    PROCEDURE ending( --c_info , log_type   => 'FLOW'  --Trace the path of execution.
         p_caller   IN VARCHAR2,
         p_message  IN VARCHAR2 DEFAULT NULL, 
         p_trace_id IN VARCHAR2 DEFAULT NULL
    );

      /*******************************************************************************
     *      usage: DEBUG_UTIL.trace( p_message => , p_caller =>  ,  p_trace_id  => ,p_extra_data=>  ) ;
     *******************************************************************************/
  
    PROCEDURE trace(--c_trace   log_type=TECH
    p_message  IN VARCHAR2,
    p_caller   IN VARCHAR2,
    p_trace_id IN VARCHAR2 DEFAULT NULL,
    p_extra_data IN CLOB DEFAULT NULL );
    /*******************************************************************************
     *  DEBUG_UTIL.user_error( p_message => , p_caller => ,p_user_label=> ,  p_trace_id    ) ;
     *******************************************************************************/

   PROCEDURE user_error(
            p_message    IN VARCHAR2,
            p_caller     IN VARCHAR2,
            p_user_label IN VARCHAR2 DEFAULT 'System Notification',
            p_trace_id      IN VARCHAR2);

    /*******************************************************************************
     *usage: DEBUG_UTIL.log_time(p_message =>  ,  p_start_time => ,  p_caller  =>  ,  p_trace_id  =>  ) ;
     *******************************************************************************/
  PROCEDURE log_time(
        p_message    IN VARCHAR2,
        p_start_time IN TIMESTAMP,
        p_caller     IN VARCHAR2 ,
         p_trace_id  IN VARCHAR2 
    ) ;
    /*******************************************************************************
     * Procedure: reset_environment
     * Resets both internal state and external environment settings (e.g. NLS).
     *******************************************************************************/
   
    PROCEDURE reset_environment;

END debug_util;

/
