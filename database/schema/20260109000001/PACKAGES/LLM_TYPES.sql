--------------------------------------------------------
--  DDL for Package LLM_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_TYPES" AS
   /*******************************************************************************
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_TYPES (Specification)
 * PURPOSE:     Centralized Type Definitions for the AI Orchestration Layer.
 *
 * DESCRIPTION: Provides provider-agnostic record types for LLM requests and 
 * responses. Designed to handle RAG context injection, governance, 
 * multi-tenancy metadata, and detailed pipeline telemetry.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0

 *******************************************************************************/

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_TYPES'; 
 

     /*******************************************************************************
         LLM REQUEST RECORD
       Encapsulates the complete intent, context, and configuration for an LLM call.
     *******************************************************************************/
 
    TYPE t_llm_request IS RECORD (
        message_id              NUMBER,         -- Assistant message identifier
        
        /* ---------- CORE MODEL & PROVIDER ---------- */
        provider                VARCHAR2(50),   -- Requested LLM provider (OPENAI, GEMINI, etc.)
        model                   VARCHAR2(100),  -- Requested model name (gpt-4o, claude-3, etc.)

        /* ---------- PROMPTING ---------- */
        user_prompt             CLOB,           -- Raw end-user input
        system_instructions     CLOB,           -- System rules / Persona
        conversation_history    CLOB,           -- Serialized prior turns
        rag_context             CLOB,           -- Grounding data injected into the prompt
        
        /* ---------- STRUCTURED OUTPUT ---------- */
        response_schema         CLOB,           -- JSON schema for constrained output
        response_format         VARCHAR2(50),   -- "text" | "json" | "json_schema"

        /* ---------- RAG CONTROL (User + Pipeline) ---------- */
        context_domain_id       NUMBER,         -- Business domain selected/detected
        is_doc_inject_required  CHAR(1),        -- Require document grounding? (Y/N)
        is_data_inject_required CHAR(1),        -- Require SQL/data grounding? (Y/N)
        rag_enabled             CHAR(1),        -- FULL RAG enabled? (Y/N)
        rag_max_chunks          NUMBER,         -- Max chunks to inject
        rag_filter_mode         VARCHAR2(30),   -- "STRICT" | "LOOSE" | "NONE"

        /* ---------- GOVERNANCE CONTROL ---------- */
        governance_enabled      CHAR(1),        -- Enforce classification rules? (Y/N)

        /* ---------- MODEL SAMPLING ---------- */
        temperature             NUMBER,
        max_tokens              NUMBER,
        top_p                   NUMBER,
        top_k                   NUMBER,
        seed                    NUMBER,
        stop                    VARCHAR2(4000),
        frequency_penalty       NUMBER,
        presence_penalty        NUMBER,

        /* ---------- PROVIDER ROUTING CONTROL ---------- */
        preferred_provider      VARCHAR2(50),   -- Preferred provider if router chooses
        preferred_model         VARCHAR2(100),  -- Preferred model suggestion
        allow_fallback          CHAR(1),        -- Allow fallback to backup models? (Y/N)

        /* ---------- STREAMING CONTROL ---------- */
        -- 'NONE'         : Disable UI streaming (One-shot response)
        -- 'BACKEND'      : Stream backend only (Full result assembled internally)
        -- 'APEX'         : Use APEX live region streaming (Typing animation)
        -- 'ORDS'         : Use ORDS SSE (Token-by-token typing)
        -- 'DBMS_OUTPUT'  : Debug console streaming
        stream_enabled          BOOLEAN,
        stream_channel          VARCHAR2(30),
      
        /* ---------- TRACE / OBSERVABILITY ---------- */
        chat_call_id            number,
        trace_id                VARCHAR2(200),  -- Current operation trace
        trace_parent_id         VARCHAR2(200),  -- Parent operation trace
        trace_step              VARCHAR2(100),  -- Step name ("PREP", "RAG", "LLM", etc.)
        msg                     VARCHAR2(4000), 
        
        /* ---------- MULTI-TENANT APP METADATA ---------- */
        project_id              NUMBER,
        project_title           VARCHAR2(300),
        session_title           VARCHAR2(300),
        user_id                 NUMBER,
        user_name               VARCHAR2(200),
        chat_session_id         NUMBER,
        app_session_id          NUMBER,
        app_page_id             NUMBER,
        app_id                  NUMBER,
        tenant_id               NUMBER,

        /* ---------- EXTENSIBILITY ---------- */
        payload                 CLOB            -- Provider-specific JSON (tools, safety settings, etc.)
    );
    /*******************************************************************************
       LLM RESPONSE RECORD
       Captures model output, performance metrics, and RAG attribution. 
     *******************************************************************************/

 
    TYPE t_llm_response IS RECORD (
        message_id              NUMBER,
        submitted_user_prompt   CLOB,           -- Echo of the original input

        /* ---------- FINAL MODEL OUTPUT ---------- */
        response_text           CLOB,
        success                 BOOLEAN,        -- Model returned valid text
        processing_status       VARCHAR2(100),  -- SUCCESS / ERROR / BLOCKED / PARTIAL
       
       
       
       /* ---------- TRACE / OBSERVABILITY ---------- */
        chat_call_id            number,
        trace_id                VARCHAR2(200),  -- Current operation trace
        trace_parent_id         VARCHAR2(200),  -- Parent operation trace
        trace_step              VARCHAR2(100),  -- Step name ("PREP", "RAG", "LLM", etc.)
        msg                     VARCHAR2(4000), 
        
        /* ---------- RAG RESULTS ---------- */
        rag_context             CLOB,           -- Context actually sent to model
        rag_context_doc_count   NUMBER,         -- Number of documents referenced
        rag_sources_json        CLOB,           -- JSON list of sources used

        /* ---------- PROVIDER RESOLUTION (Router) ---------- */
        provider_used           VARCHAR2(50),   -- Initial provider attempt
        model_used              VARCHAR2(100),
        provider_final          VARCHAR2(50),   -- What was ACTUALLY used
        model_final             VARCHAR2(100),
        fallback_used           CHAR(1),        -- Y/N routing fallback

        /* ---------- TOKEN + COST ---------- */
        tokens_input            NUMBER,
        tokens_output           NUMBER,
        tokens_total            NUMBER,
        cost_usd                NUMBER,         -- Calculated transaction cost

        /* ---------- SAFETY LAYERS ---------- */
        is_blocked              BOOLEAN,
        safety_filter_applied   CHAR(1),        -- Safety filter triggered? (Y/N)
        safety_block_reason     VARCHAR2(4000), -- Why?
        safety_ratings          JSON_ARRAY_T,   -- Provider-supplied safety metadata

        /* ---------- REFUSAL (Anthropic-style) ---------- */
        is_refusal              BOOLEAN,
        refusal_text            CLOB,
        refusal_raw             CLOB,           -- Raw refusal JSON/object

        /* ---------- OUTPUT CONTROL ---------- */
        finish_reason           VARCHAR2(100),
        stop_reason             VARCHAR2(100),
        stop_sequence           VARCHAR2(4000),
        is_truncated            BOOLEAN,

        /* ---------- PIPELINE TIMINGS ---------- */
        rag_ms                  NUMBER,
        governance_ms           NUMBER,
        prompt_build_ms         NUMBER,
        llm_call_ms             NUMBER,
        total_pipeline_ms       NUMBER,

        /* ---------- GOVERNANCE OUTPUT ---------- */
        governance_action       VARCHAR2(200),  -- ALLOWED / REDACTED / BLOCKED
        governance_details      CLOB,

        /* ---------- FINAL PROMPTS AFTER ALL MODIFICATIONS ---------- */
        final_system_prompt     CLOB,           -- Final prompt after RAG injection
        final_user_prompt       CLOB,

        /* ---------- TOOL + STRUCTURED OUTPUT ---------- */
        tool_calls_json         CLOB,           -- Functional calling results
        parsed_structured_output CLOB,

        /* ---------- PROVIDER-SPECIFIC PAYLOAD ---------- */
        request_id              VARCHAR2(100),
        system_fingerprint      VARCHAR2(200),
        created_timestamp       NUMBER,
        processing_ms           NUMBER,
        payload                 CLOB
    );

 /*******************************************************************************
 * Function: safe_copy_request
 * Deep-copies an LLM request record to ensure state isolation.
 *******************************************************************************/
 
    FUNCTION safe_copy_request(
        p_source IN t_llm_request
    ) RETURN t_llm_request;
 /*******************************************************************************
  * Function: safe_copy_response
  * Deep-copies an LLM response record. 
 *******************************************************************************/
    FUNCTION safe_copy_response(
        p_source IN t_llm_response
    ) RETURN t_llm_response;
 /*******************************************************************************
 -- JSON Serialization (Essential for Logging)
 *******************************************************************************/

    FUNCTION to_json(p_rec IN t_llm_request) RETURN CLOB;
    FUNCTION to_json(p_rec IN t_llm_response) RETURN CLOB;
 /*******************************************************************************
 *  
 *******************************************************************************/
    
END llm_types;

/
