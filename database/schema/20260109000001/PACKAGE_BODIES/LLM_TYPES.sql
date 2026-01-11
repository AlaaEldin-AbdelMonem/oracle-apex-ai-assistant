--------------------------------------------------------
--  DDL for Package Body LLM_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LLM_TYPES" AS

 
/*******************************************************************************
 * SAFE COPY — REQUEST
 *  - Initializes object fields safely
 *  - Avoids ORA-30625 ("null object") exceptions
 *******************************************************************************/
FUNCTION safe_copy_request(p_source IN t_llm_request)
RETURN t_llm_request
IS
    vcaller constant varchar2(70):= c_package_name ||'.safe_copy_request'; 
    v t_llm_request;
BEGIN
    /* Initialize object types */
    v.payload := NULL;

    /* Copy all scalar fields */
    v.provider               := p_source.provider;
    v.model                  := p_source.model;
    v.user_prompt            := p_source.user_prompt;
    v.system_instructions    := p_source.system_instructions;
    v.conversation_history   := p_source.conversation_history;
    v.response_schema        := p_source.response_schema;
    v.response_format        := p_source.response_format;
    v.rag_context            := p_source.rag_context;
    /* RAG */
    v.context_domain_id      := p_source.context_domain_id;
    v.is_doc_inject_required := p_source.is_doc_inject_required;
    v.is_data_inject_required:= p_source.is_data_inject_required;
    v.rag_enabled            := p_source.rag_enabled;
    v.rag_max_chunks         := p_source.rag_max_chunks;
    v.rag_filter_mode        := p_source.rag_filter_mode;

    /* Governance */
    v.governance_enabled     := p_source.governance_enabled;

    /* Sampling */
    v.temperature            := p_source.temperature;
    v.max_tokens             := p_source.max_tokens;
    v.top_p                  := p_source.top_p;
    v.top_k                  := p_source.top_k;
    v.seed                   := p_source.seed;
    v.stop                   := p_source.stop;
    v.frequency_penalty      := p_source.frequency_penalty;
    v.presence_penalty       := p_source.presence_penalty;

    /* Routing */
    v.preferred_provider     := p_source.preferred_provider;
    v.preferred_model        := p_source.preferred_model;
    v.allow_fallback         := p_source.allow_fallback;

    /* Streaming */
    v.stream_enabled         := p_source.stream_enabled;
    v.stream_channel         := p_source.stream_channel;

    /* Trace */
    v.chat_call_id            := p_source.chat_call_id;
    v.trace_id               := p_source.trace_id;
    v.trace_parent_id        := p_source.trace_parent_id;
    v.trace_step             := p_source.trace_step;

    /* App metadata */
    v.Message_id             := p_source.Message_id;
    v.project_id             := p_source.project_id;
    v.project_title          := p_source.project_title;
    v.session_title          := p_source.session_title;
    v.user_id                := p_source.user_id;
    v.user_name              := p_source.user_name;
    v.chat_session_id        := p_source.chat_session_id;
    v.app_session_id         := p_source.app_session_id;
    v.app_page_id            := p_source.app_page_id;
    v.app_id                 := p_source.app_id;
    v.tenant_id              := p_source.tenant_id;
    v.msg                    := p_source.msg  ;

    /* Copy payload */
    IF p_source.payload IS NOT NULL THEN
        v.payload := p_source.payload;
    END IF;

    RETURN v;

EXCEPTION WHEN OTHERS THEN
    v.payload := NULL;
    RETURN v;
END;



/*******************************************************************************
 * SAFE COPY — RESPONSE
 *******************************************************************************/
FUNCTION safe_copy_response(p_source IN t_llm_response)
RETURN t_llm_response
IS   vcaller constant varchar2(70):= c_package_name ||'.safe_copy_response'; 
    v t_llm_response;
BEGIN
    /* Initialize object types */
    v.payload := NULL;
    v.safety_ratings := NULL;
      
    v.Message_id             := p_source.Message_id;
    /* Copy scalar fields */
    v.submitted_user_prompt   := p_source.submitted_user_prompt;
    v.response_text           := p_source.response_text;
    v.success                 := p_source.success;
    v.processing_status       := p_source.processing_status;

    /* RAG */
    v.rag_context             := p_source.rag_context;
    v.rag_context_doc_count   := p_source.rag_context_doc_count;
    v.rag_sources_json        := p_source.rag_sources_json;

    /* Provider routing */
    v.provider_used           := p_source.provider_used;
    v.model_used              := p_source.model_used;
    v.provider_final          := p_source.provider_final;
    v.model_final             := p_source.model_final;
    v.fallback_used           := p_source.fallback_used;
    v.msg                     := p_source.msg  ;

    v.chat_call_id            := p_source.chat_call_id  ; 
    v.trace_id                := p_source.trace_id  ; 
    v.trace_parent_id         := p_source.trace_parent_id  ; 
    v.trace_step              := p_source.trace_step  ;

    /* Token + cost */
    v.tokens_input           := p_source.tokens_input;
    v.tokens_output          := p_source.tokens_output;
    v.tokens_total           := p_source.tokens_total;
    v.cost_usd                := p_source.cost_usd;

    /* Safety */
    v.is_blocked              := p_source.is_blocked;
    v.safety_filter_applied   := p_source.safety_filter_applied;
    v.safety_block_reason     := p_source.safety_block_reason;
    v.is_refusal              := p_source.is_refusal;
    v.refusal_text            := p_source.refusal_text;
    v.refusal_raw             := p_source.refusal_raw;

    /* Stop signals */
    v.finish_reason           := p_source.finish_reason;
    v.stop_reason             := p_source.stop_reason;
    v.stop_sequence           := p_source.stop_sequence;
    v.is_truncated            := p_source.is_truncated;

    /* Timings */
    v.rag_ms                  := p_source.rag_ms;
    v.governance_ms           := p_source.governance_ms;
    v.prompt_build_ms         := p_source.prompt_build_ms;
    v.llm_call_ms             := p_source.llm_call_ms;
    v.total_pipeline_ms       := p_source.total_pipeline_ms;

    /* Governance output */
    v.governance_action       := p_source.governance_action;
    v.governance_details      := p_source.governance_details;

    /* Final prompts */
    v.final_system_prompt     := p_source.final_system_prompt;
    v.final_user_prompt       := p_source.final_user_prompt;

    /* Tools / structured output */
    v.tool_calls_json         := p_source.tool_calls_json;
    v.parsed_structured_output:= p_source.parsed_structured_output;

    /* Provider metadata */
    v.request_id              := p_source.request_id;
    v.system_fingerprint      := p_source.system_fingerprint;
    v.created_timestamp       := p_source.created_timestamp;
    v.processing_ms           := p_source.processing_ms;

    /* Copy payload */
    IF p_source.payload IS NOT NULL THEN
        v.payload := p_source.payload;
    END IF;

    /* Safety ratings object */
    IF p_source.safety_ratings IS NOT NULL THEN
        v.safety_ratings := p_source.safety_ratings;
    END IF;

    RETURN v;

EXCEPTION WHEN OTHERS THEN
    v.payload := NULL;
    v.safety_ratings := NULL;
    RETURN v;
END;
/*******************************************************************************
 *  dump the request
 *******************************************************************************/
 
 FUNCTION to_json(p_rec IN t_llm_request) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;

        -- Identity & Trace
        APEX_JSON.WRITE('trace_id',             p_rec.trace_id);
        APEX_JSON.WRITE('trace_parent_id',      p_rec.trace_parent_id);
        APEX_JSON.WRITE('trace_step',           p_rec.trace_step);
        APEX_JSON.WRITE('chat_call_id',         p_rec.chat_call_id);
        APEX_JSON.WRITE('message_id',           p_rec.message_id);
        APEX_JSON.WRITE('msg',                  p_rec.msg);

        -- Core Model Config
        APEX_JSON.WRITE('provider',             p_rec.provider);
        APEX_JSON.WRITE('model',                p_rec.model);
        
        -- Prompt Data (CLOBs)
        APEX_JSON.WRITE('user_prompt',          p_rec.user_prompt);
        APEX_JSON.WRITE('system_instructions',  p_rec.system_instructions);
        APEX_JSON.WRITE('conversation_history', p_rec.conversation_history);
        APEX_JSON.WRITE('rag_context',          p_rec.rag_context);
        
        -- Structured Output
        APEX_JSON.WRITE('response_schema',      p_rec.response_schema);
        APEX_JSON.WRITE('response_format',      p_rec.response_format);

        -- RAG Control
        APEX_JSON.WRITE('context_domain_id',       p_rec.context_domain_id);
        APEX_JSON.WRITE('is_doc_inject_required',  p_rec.is_doc_inject_required);
        APEX_JSON.WRITE('is_data_inject_required', p_rec.is_data_inject_required);
        APEX_JSON.WRITE('rag_enabled',             p_rec.rag_enabled);
        APEX_JSON.WRITE('rag_max_chunks',          p_rec.rag_max_chunks);
        APEX_JSON.WRITE('rag_filter_mode',         p_rec.rag_filter_mode);

        -- Governance
        APEX_JSON.WRITE('governance_enabled',   p_rec.governance_enabled);

        -- Model Hyperparameters
        APEX_JSON.WRITE('temperature',          p_rec.temperature);
        APEX_JSON.WRITE('max_tokens',           p_rec.max_tokens);
        APEX_JSON.WRITE('top_p',                p_rec.top_p);
        APEX_JSON.WRITE('top_k',                p_rec.top_k);
        APEX_JSON.WRITE('seed',                 p_rec.seed);
        APEX_JSON.WRITE('stop',                 p_rec.stop);
        APEX_JSON.WRITE('frequency_penalty',    p_rec.frequency_penalty);
        APEX_JSON.WRITE('presence_penalty',     p_rec.presence_penalty);

        -- Routing
        APEX_JSON.WRITE('preferred_provider',   p_rec.preferred_provider);
        APEX_JSON.WRITE('preferred_model',      p_rec.preferred_model);
        APEX_JSON.WRITE('allow_fallback',       p_rec.allow_fallback);

        -- Streaming
        APEX_JSON.WRITE('stream_enabled',       p_rec.stream_enabled);
        APEX_JSON.WRITE('stream_channel',       p_rec.stream_channel);

        -- Multi-tenancy Context
        APEX_JSON.WRITE('project_id',           p_rec.project_id);
        APEX_JSON.WRITE('project_title',        p_rec.project_title);
        APEX_JSON.WRITE('session_title',        p_rec.session_title);
        APEX_JSON.WRITE('user_id',              p_rec.user_id);
        APEX_JSON.WRITE('user_name',            p_rec.user_name);
        APEX_JSON.WRITE('chat_session_id',      p_rec.chat_session_id);
        APEX_JSON.WRITE('app_session_id',       p_rec.app_session_id);
        APEX_JSON.WRITE('app_page_id',          p_rec.app_page_id);
        APEX_JSON.WRITE('app_id',               p_rec.app_id);
        APEX_JSON.WRITE('tenant_id',            p_rec.tenant_id);

        -- Extensibility
        APEX_JSON.WRITE('payload',              p_rec.payload);

        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        RETURN l_clob;
    END to_json;


 /*******************************************************************************
 *     -- TO_JSON: RESPONSE (FULL DUMP)
 *******************************************************************************/
 
    FUNCTION to_json(p_rec IN t_llm_response) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;

        -- Identity & Status
        APEX_JSON.WRITE('message_id',           p_rec.message_id);
        APEX_JSON.WRITE('trace_id',             p_rec.trace_id);
        APEX_JSON.WRITE('trace_parent_id',      p_rec.trace_parent_id);
        APEX_JSON.WRITE('trace_step',           p_rec.trace_step);
        APEX_JSON.WRITE('chat_call_id',         p_rec.chat_call_id);
        APEX_JSON.WRITE('success',              p_rec.success);
        APEX_JSON.WRITE('processing_status',    p_rec.processing_status);
        APEX_JSON.WRITE('msg',                  p_rec.msg);

        -- Main Output
        APEX_JSON.WRITE('submitted_user_prompt', p_rec.submitted_user_prompt);
        APEX_JSON.WRITE('response_text',         p_rec.response_text);

        -- RAG Details
        APEX_JSON.WRITE('rag_context',           p_rec.rag_context);
        APEX_JSON.WRITE('rag_context_doc_count', p_rec.rag_context_doc_count);
        APEX_JSON.WRITE('rag_sources_json',      p_rec.rag_sources_json);

        -- Provider Resolution
        APEX_JSON.WRITE('provider_used',        p_rec.provider_used);
        APEX_JSON.WRITE('model_used',           p_rec.model_used);
        APEX_JSON.WRITE('provider_final',       p_rec.provider_final);
        APEX_JSON.WRITE('model_final',          p_rec.model_final);
        APEX_JSON.WRITE('fallback_used',        p_rec.fallback_used);

        -- Token Usage & Cost
        APEX_JSON.WRITE('tokens_input',         p_rec.tokens_input);
        APEX_JSON.WRITE('tokens_output',        p_rec.tokens_output);
        APEX_JSON.WRITE('tokens_total',         p_rec.tokens_total);
        APEX_JSON.WRITE('cost_usd',             p_rec.cost_usd);

        -- Safety & Governance
        APEX_JSON.WRITE('is_blocked',           p_rec.is_blocked);
        APEX_JSON.WRITE('safety_filter_applied',p_rec.safety_filter_applied);
        APEX_JSON.WRITE('safety_block_reason',  p_rec.safety_block_reason);
        -- JSON_ARRAY_T must be serialized if not supported directly by WRITE, 
        -- usually easier to to_string() it if present.
        -- Assuming safety_ratings is serialized or null handled:
        IF p_rec.safety_ratings IS NOT NULL THEN
             APEX_JSON.WRITE('safety_ratings', p_rec.safety_ratings.to_clob); 
        END IF;

        -- Refusal
        APEX_JSON.WRITE('is_refusal',           p_rec.is_refusal);
        APEX_JSON.WRITE('refusal_text',         p_rec.refusal_text);
        APEX_JSON.WRITE('refusal_raw',          p_rec.refusal_raw);

        -- Stop Reasons
        APEX_JSON.WRITE('finish_reason',        p_rec.finish_reason);
        APEX_JSON.WRITE('stop_reason',          p_rec.stop_reason);
        APEX_JSON.WRITE('stop_sequence',        p_rec.stop_sequence);
        APEX_JSON.WRITE('is_truncated',         p_rec.is_truncated);

        -- Telemetry / Timings
        APEX_JSON.WRITE('rag_ms',               p_rec.rag_ms);
        APEX_JSON.WRITE('governance_ms',        p_rec.governance_ms);
        APEX_JSON.WRITE('prompt_build_ms',      p_rec.prompt_build_ms);
        APEX_JSON.WRITE('llm_call_ms',          p_rec.llm_call_ms);
        APEX_JSON.WRITE('total_pipeline_ms',    p_rec.total_pipeline_ms);
        APEX_JSON.WRITE('processing_ms',        p_rec.processing_ms);
        APEX_JSON.WRITE('created_timestamp',    p_rec.created_timestamp);

        -- Governance Action
        APEX_JSON.WRITE('governance_action',    p_rec.governance_action);
        APEX_JSON.WRITE('governance_details',   p_rec.governance_details);

        -- Final Prompts
        APEX_JSON.WRITE('final_system_prompt',  p_rec.final_system_prompt);
        APEX_JSON.WRITE('final_user_prompt',    p_rec.final_user_prompt);

        -- Tooling
        APEX_JSON.WRITE('tool_calls_json',          p_rec.tool_calls_json);
        APEX_JSON.WRITE('parsed_structured_output', p_rec.parsed_structured_output);

        -- Provider Payload
        APEX_JSON.WRITE('request_id',           p_rec.request_id);
        APEX_JSON.WRITE('system_fingerprint',   p_rec.system_fingerprint);
        APEX_JSON.WRITE('payload',              p_rec.payload);

        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        RETURN l_clob;
    END to_json;

  /*******************************************************************************
 *  
 *******************************************************************************/
END llm_types;

/
