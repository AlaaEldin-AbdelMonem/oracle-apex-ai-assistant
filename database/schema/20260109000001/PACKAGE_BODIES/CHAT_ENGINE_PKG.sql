--------------------------------------------------------
--  DDL for Package Body CHAT_ENGINE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHAT_ENGINE_PKG" AS

 
c_trace_prefix  CONSTANT VARCHAR2(20) := 'TRACE-';


 
 /*******************************************************************************
 *  -- Generate a trace_id (UUID-based, prefixed)
 *******************************************************************************/
FUNCTION get_trace_id RETURN VARCHAR2 IS
vcaller constant varchar2(70):= c_package_name ||'.get_trace_id'; 
BEGIN
    RETURN c_trace_prefix || SYS_GUID();
END;

 
 /*******************************************************************************
 *  STREAMING SUPPORT (APEX / ORDS / DBMS_OUTPUT)
 *******************************************************************************/
 
-- DBMS_OUTPUT Streaming
PROCEDURE stream_dbms_output(p_text IN VARCHAR2) IS

 vcaller constant varchar2(70):= c_package_name ||'.stream_dbms_output';
BEGIN
    DBMS_OUTPUT.put_line(p_text);

EXCEPTION WHEN OTHERS THEN NULL;
END;
 /*******************************************************************************
 *  
 *******************************************************************************/
-- ORDS SSE Streaming
PROCEDURE stream_ords_sse(p_text IN VARCHAR2) IS
 vcaller constant varchar2(70):= c_package_name ||'.stream_ords_sse';
BEGIN
    HTP.p('data: ' || REPLACE(p_text, CHR(10), ' '));
    HTP.p;
    HTP.p; 
    HTP.flush;
EXCEPTION WHEN OTHERS THEN NULL;
END;

 /*******************************************************************************
 *  
 *******************************************************************************/
-- APEX Streaming
PROCEDURE stream_apex(p_text IN VARCHAR2) IS
 vcaller constant varchar2(70):= c_package_name ||'.stream_apex';
BEGIN
    HTP.p(p_text);
    HTP.flush;
EXCEPTION WHEN OTHERS THEN NULL;
END;

 /*******************************************************************************
 *  
 *******************************************************************************/
-- STREAM ROUTER
PROCEDURE stream_emit(
    p_text    IN VARCHAR2,
    p_channel IN VARCHAR2
) IS
 vcaller constant varchar2(70):= c_package_name ||'.stream_emit';
BEGIN
    CASE UPPER(p_channel)
        WHEN 'APEX'       THEN stream_apex(p_text);
        WHEN 'ORDS'       THEN stream_ords_sse(p_text);
        WHEN 'DBMS_OUTPUT'THEN stream_dbms_output(p_text);
        ELSE                 stream_dbms_output(p_text);
    END CASE;
END stream_emit;

 /*******************************************************************************
-- RAG PIPELINE WRAPPER (Hybrid Mode)
-- Uses: rag_enabled + rag_max_chunks
-- Medium debug instrumentation
 *******************************************************************************/
 
FUNCTION run_rag_pipeline(
    p_req IN llm_types.t_llm_request
) RETURN CLOB
IS
 vcaller constant varchar2(70):= c_package_name ||'.run_rag_pipeline';
    v_rag CLOB;
BEGIN
    IF p_req.rag_enabled = 'N' THEN
        debug_util.info('RAG disabled by request', vcaller, p_req.trace_id);
        RETURN NULL;
    END IF;

    debug_util.info('Running RAG pipeline...', vcaller, p_req.trace_id);

    v_rag :=
        cx_chunks_builder_pkg.get_context_docs(
            p_user_id           => p_req.user_id,
            p_context_domain_id => p_req.context_domain_id,
            p_query             => p_req.user_prompt,
            p_top_k             => NVL(p_req.rag_max_chunks, 5)--,
           -- p_trace_id          => null,
          --  p_call_id           => null
        );

   
    debug_util.info('RAG result length=' || NVL(DBMS_LOB.getlength(v_rag),0),  vcaller,  p_req.trace_id);

    RETURN v_rag;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error( 'RAG failure: ' || SQLERRM, vcaller, p_req.trace_id );
        RETURN   v_rag;
        --  to_error_json('run_rag_pipeline', SQLERRM, vcaller, p_req.trace_id);
END run_rag_pipeline;

 /*******************************************************************************
-- GOVERNANCE PIPELINE WRAPPER (Soft Fail)
-- Medium debug logs
-- Pseudocode only (future implementation)
 *******************************************************************************/
 
FUNCTION run_governance(
    p_req         IN llm_types.t_llm_request,
    p_rag_context IN CLOB
) RETURN CLOB
IS
 vcaller constant varchar2(70):= c_package_name ||'.run_governance';
    v_filtered CLOB;
BEGIN
    IF p_req.governance_enabled = 'N' THEN
        debug_util.info('Governance disabled by request', vcaller , p_req.trace_id);
        RETURN p_rag_context;
    END IF;

    debug_util.info('Governance validation start…', vcaller , p_req.trace_id);

    /*
        -- SAMPLE PSEUDOCODE (future implementation)

        v_filtered :=
            rag_governance_pkg.enforce_policy(
                p_context_domain_id => p_req.context_domain_id,
                p_user_id           => p_req.user_id,
                p_data_clob         => p_rag_context
            );

        IF redaction_detected THEN
            p_req.governance_action  := 'REDACTED';
            p_req.governance_details := <JSON>;
        END IF;
    */

    v_filtered := p_rag_context;

    debug_util.info('Governance complete (soft mode)', vcaller , p_req.trace_id);

    RETURN v_filtered;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error('Governance failure: ' || SQLERRM, vcaller , p_req.trace_id);
        RETURN  'governance>'|| SQLERRM ||'>traceId>'|| p_req.trace_id ;
END run_governance;

 /*******************************************************************************
 *  -- SYSTEM PROMPT BUILDER (CX Builder Wrapper)
-- Medium debug instrumentation
 *******************************************************************************/
 
FUNCTION build_full_system_prompt(
    p_req               IN llm_types.t_llm_request,
    p_behavior_code     IN VARCHAR2 DEFAULT 'STANDARD',
    p_output_format_code       IN VARCHAR2 DEFAULT 'DEFAULT' 
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.build_full_system_prompt';
    v_prompt CLOB;
BEGIN
    debug_util.info('Building system prompt…', vcaller , p_req.trace_id);

    v_prompt :=
        cx_builder_pkg.system_prompt_Injector(
            p_context_domain_id      => p_req.context_domain_id,
            p_enforce_context_domain => 'Y',
            p_user_prompt            => p_req.user_prompt,
            p_top_k                  => p_req.top_k,
            p_behavior_code          => p_behavior_code,
            p_output_format_code     => p_output_format_code,
            p_user_id                => p_req.user_id,
            p_trace_id               => null,
            p_call_Id                => null
        );
 
    debug_util.info('System prompt length=' || NVL(DBMS_LOB.getlength(v_prompt),0), vcaller , p_req.trace_id);

    RETURN v_prompt;
END build_full_system_prompt;
 /*******************************************************************************
 *-- CONTEXT DOMAIN DETECTION
-- LLM → Vector fallback
-- Medium debug detail
 *******************************************************************************/
 

FUNCTION detect_context_domain(
    p_req IN CXD_TYPES.t_cxd_classifier_req
) RETURN NUMBER
IS
    vcaller constant varchar2(70):= c_package_name ||'.detect_context_domain';
    v_domain_id NUMBER;
    v_resp_dom  CXD_TYPES.t_cxd_classifier_resp;
    v_resp_int  CXD_TYPES.t_intent_classifier_resp;
BEGIN
    debug_util.info('Domain detection started', vcaller , p_req.trace_id);

    -- 1) Try LLM classifier
    BEGIN
        cxd_classifier_pkg.detect(
            p_req         => p_req,
            p_resp_domain => v_resp_dom,
            p_resp_intent => v_resp_int
        );

        IF v_resp_dom.context_domain_id IS NOT NULL THEN
            debug_util.info('Domain detected by LLM: ' ||
                             v_resp_dom.context_domain_id, vcaller ,
                             p_req.trace_id);
            RETURN v_resp_dom.context_domain_id;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.warn('LLM domain detect failed, falling back',vcaller, p_req.trace_id);
    END;

    -- 2) Vector fallback
    BEGIN
        SELECT context_domain_id
        INTO v_domain_id
        FROM (
            SELECT cd.context_domain_id,
                   VECTOR_DISTANCE(
                       CHUNK_EMBEDDING_PKG.generate_embedding(
                           p_text  => p_req.user_prompt,
                           p_model => p_req.model
                       ),
                       cd.domain_embedding_vector,
                       COSINE
                   ) AS dist
            FROM context_domains cd
            WHERE cd.is_active = 'Y'
            ORDER BY dist
        )
        WHERE ROWNUM = 1;

        debug_util.info('Domain detected by vector: ' || v_domain_id, vcaller ,
                        p_req.trace_id);

        RETURN v_domain_id;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error('Vector domain fallback failed: ' || SQLERRM, vcaller ,p_req.trace_id);
            RETURN NULL;
    END;
END detect_context_domain;

 /*******************************************************************************
 * -- LLM ROUTER WRAPPER
-- Medium debug 
 *******************************************************************************/
 

FUNCTION call_llm(
    p_req IN llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS
    vcaller constant varchar2(70):= c_package_name ||'.call_llm';
    v_resp llm_types.t_llm_response;
BEGIN
    debug_util.info('Calling LLM provider=' || p_req.provider ||
                    ', model=' || p_req.model, vcaller ,
                    p_req.trace_id);

    v_resp := llm_router_pkg.invoke_llm(p_req);

    debug_util.info('LLM call complete', vcaller , p_req.trace_id);

    RETURN v_resp;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error(
            'LLM router failure: ' || SQLERRM, vcaller,
            p_req.trace_id
        );
        RAISE;
END call_llm;

 /*******************************************************************************
 *  -- FINAL RESPONSE ASSEMBLY  (Pattern A)
-- Only this function builds the final user-facing answer
 *******************************************************************************/
 
 
FUNCTION assemble_final_response(
    p_raw_llm_response IN llm_types.t_llm_response,
    p_req              IN llm_types.t_llm_request,
    p_rag_context      IN CLOB
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.assemble_final_response';
    v_final_text CLOB;
BEGIN
    debug_util.info('Assembling final response…',vcaller , p_req.trace_id);

    -- Get response text with proper NULL handling
    v_final_text := p_raw_llm_response.response_text;
    
    -- CRITICAL: Validate we have content
    IF v_final_text IS NULL OR DBMS_LOB.getlength(v_final_text) = 0 THEN
        debug_util.error('LLM response_text is NULL or empty!' , vcaller , p_req.trace_id);
        
        -- Check if error occurred
        IF p_raw_llm_response.success = FALSE THEN
            v_final_text := '[ERROR] LLM call failed: ' || 
                           NVL(p_raw_llm_response.msg, 'Unknown error');
        ELSE
            v_final_text := '[ERROR] LLM returned empty response';
        END IF;
        
        debug_util.warn('Using fallback response: ' || v_final_text, vcaller , p_req.trace_id);
    END IF;

    debug_util.info('Final response length: ' || 
                    NVL(DBMS_LOB.getlength(v_final_text), 0), vcaller, 
                    p_req.trace_id);

    RETURN v_final_text;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error('assemble_final_response failed: ' || SQLERRM, vcaller ,
                         p_req.trace_id);
        RETURN '[ERROR] Failed to assemble response: ' || SQLERRM;
END assemble_final_response;
 /*******************************************************************************
 
 *******************************************************************************/
PROCEDURE validate_incoming_request(p_req IN OUT llm_types.t_llm_request) IS
BEGIN
    IF p_req.user_prompt IS NULL OR DBMS_LOB.getlength(p_req.user_prompt) = 0 THEN
        RAISE_APPLICATION_ERROR(-20010, 'User prompt cannot be empty.');
    END IF;

    IF p_req.chat_session_id IS NULL THEN
        RAISE_APPLICATION_ERROR(-20011, 'Chat Session ID is required.');
    END IF;

    -- Set internal defaults
    p_req.temperature := NVL(p_req.temperature, 0.7);
    p_req.max_tokens  := NVL(p_req.max_tokens, 1000);
END;
  /*******************************************************************************
 
 *******************************************************************************/
PROCEDURE prepare_chat_context(p_req IN OUT llm_types.t_llm_request) IS
    v_rag_raw CLOB;
BEGIN
    -- 1. Build System Instructions
    p_req.system_instructions := build_full_system_prompt(p_req, 'STANDARD', 'DEFAULT');

    -- Fallback for safety
    IF DBMS_LOB.getlength(p_req.system_instructions) = 0 THEN
        p_req.system_instructions := 'You are a helpful enterprise AI assistant.';
        debug_util.warn('Using fallback system instructions', 'prepare_chat_context', p_req.trace_id);
    END IF;

    -- 2. Execute RAG
    v_rag_raw := run_rag_pipeline(p_req);

    -- 3. Apply Governance
    p_req.rag_context := run_governance(p_req, v_rag_raw);
    
    audit_util.log_event('PROC_OK', 'Context Enrichment Complete', p_trace_id => p_req.trace_id);
END;
  /*******************************************************************************
 
 *******************************************************************************/
 PROCEDURE finalize_chat_interaction(
    p_req  IN llm_types.t_llm_request, 
    p_resp IN OUT llm_types.t_llm_response
) IS
    v_final_text CLOB;
    v_costs      llm_token_calc_pkg.t_cost_breakdown;
BEGIN
    -- 1. Assemble Final Response
    v_final_text := assemble_final_response(p_resp, p_req, p_req.rag_context);
    
    -- Safety Fallback
    IF DBMS_LOB.getlength(v_final_text) = 0 THEN
        v_final_text := p_resp.response_text;
    END IF;

    -- 2. Persist to Database (ASSISTANT Message)
    p_resp.message_id := chat_call_pkg.add_call(p_req, p_resp);

    -- 3. Cost Calculation
    v_costs := llm_token_calc_pkg.calculate(
        p_provider      => p_resp.provider_used,
        p_model         => p_resp.model_used,
        p_tokens_input  => p_resp.tokens_input,
        p_tokens_output => p_resp.tokens_output
    );
    
    p_resp.cost_usd := v_costs.total_cost;
    
    -- Log to Business Tier on Page 721
    audit_util.log_event('PROC_OK', 'Chat interaction persisted. Cost: $' || p_resp.cost_usd);
END;
 
 /*******************************************************************************
 
 *******************************************************************************/

/**
 * PRIVATE PROCEDURE: execute_llm_call
 * Handles the actual routing to the AI provider and captures execution metadata.
 */
FUNCTION execute_llm_call(
    p_req IN OUT llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS
    vcaller  CONSTANT VARCHAR2(70) := c_package_name || '.execute_llm_call';
    v_resp   llm_types.t_llm_response;
    v_start  TIMESTAMP := SYSTIMESTAMP;
BEGIN
    debug_util.info('Initiating LLM Call | Provider: ' || p_req.provider || ' | Model: ' || p_req.model, vcaller, p_req.trace_id);

    -- 1. Call the Router (Dynamic Routing to OpenAI, Anthropic, etc.)
    -- This uses the dynamic routing logic we built previously
    v_resp := call_llm(p_req);

    -- 2. Capture and Sync Metadata
    -- Ensure the response reflects exactly what was used (in case of provider-level fallbacks)
    v_resp.provider_final := v_resp.provider_used;
    v_resp.model_final    := v_resp.model_used;
    
    v_resp.fallback_used  := CASE 
                                WHEN p_req.provider != v_resp.provider_used THEN 'Y' 
                                ELSE 'N' 
                             END;

    -- 3. Telemetry & Auditing for Page 721
    IF v_resp.success THEN
        debug_util.log_time(p_message=>'LLM Execution Successful', p_start_time=> v_start, p_caller=> vcaller,p_trace_id=>p_req.trace_id);     
        
        -- Log Business Success (Nature: EVNT, Group: AI KPI, Code: PROC_OK)
        audit_util.log_event(
            p_event_code => 'PROC_OK',
            p_message    => 'LLM call succeeded via ' || v_resp.provider_final,
            p_trace_id   => p_req.trace_id,
            p_caller     => vcaller
        );
    ELSE
        -- Log Functional Failure (Nature: FAIL, Group: AI KPI, Code: AI_ERR)
        audit_util.log_failure(
            p_event_code => 'AI_ERR',
            p_reason     => 'LLM Provider reported error: ' || v_resp.msg,
            p_context    => 'Target Provider: ' || p_req.provider || ' | Prompt: ' || SUBSTR(p_req.user_prompt, 1, 200),
            p_caller     => vcaller
        );
        
        debug_util.error('LLM Execution Failed: ' || v_resp.msg, vcaller, p_req.trace_id);
    END IF;

    -- 4. Pass back user prompt for lineage tracking
    v_resp.submitted_user_prompt := p_req.user_prompt;

    RETURN v_resp;

EXCEPTION
    WHEN OTHERS THEN
        -- Infrastructure/System Health Failure (Nature: FAIL, Group: System Health, Code: SYS_DEP)
        audit_util.log_failure(
            p_event_code => 'SYS_DEP',
            p_reason     => 'Critical Exception during LLM Call: ' || SQLERRM,
            p_caller     => vcaller
        );
        
        -- Build a graceful failure response so the orchestrator doesn't crash
        v_resp.success := FALSE;
        v_resp.msg     := 'A communications error occurred with the AI provider.';
        RETURN v_resp;
END execute_llm_call;
  /*******************************************************************************
 
 *******************************************************************************/
FUNCTION invoke_chat(
    p_req IN llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS
    vcaller  CONSTANT VARCHAR2(70) := c_package_name || '.invoke_chat';
    v_req    llm_types.t_llm_request := p_req;
    v_resp   llm_types.t_llm_response;
    v_start  TIMESTAMP := SYSTIMESTAMP;
    v_traceid varchar2(200):=  p_req.trace_id;
BEGIN
    -- 0. Initialize & Trace
 
    debug_util.starting(vcaller, 'Start Chat Session: ' || v_req.chat_session_id, v_traceid);

    -- 1. Pre-Flight Validation
    validate_incoming_request(v_req);

    -- 2. Context Enrichment (System Prompt + RAG + Governance)
    prepare_chat_context(v_req);

    -- 3. LLM Execution
    v_resp := execute_llm_call(v_req);

    -- 4. Post-Processing & Persistence (Persist to DB, Calc Cost)
    finalize_chat_interaction(v_req, v_resp);

    -- 5. Final Telemetry

    debug_util.log_time(p_message=>'Total Chat Latency', p_start_time=> v_start, p_caller=> vcaller,p_trace_id=>v_traceid);     
    debug_util.ending(vcaller, '', v_traceid);
    
    RETURN v_resp;

EXCEPTION
    WHEN OTHERS THEN
        -- Log to System Health Tier on Page 721
        audit_util.log_failure( p_event_code =>'SYS_DEP' ,
         p_reason =>'Chat Orchestrator Crash: ' || SQLERRM,
         p_caller => vcaller,p_trace_id=> v_traceid);
        debug_util.error(SQLERRM, vcaller,v_traceid);
        RAISE;
END invoke_chat;
 /*******************************************************************************
 *      STREAMING PIPELINE — TOKEN+FINAL STREAM OUTPUT
    Uses:
        llm_stream_adapter_util.init()
        llm_stream_adapter_util.on_token()
        llm_stream_adapter_util.on_end()
 *******************************************************************************/
 
PROCEDURE invoke_chat_stream(
    p_req              IN  llm_types.t_llm_request,
    p_response_out     OUT CLOB
)
IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_chat_stream';
    v_llm_req       llm_types.t_llm_request;
    v_trace_id      VARCHAR2(200) := p_req.trace_id;
    v_final_llm     llm_types.t_llm_response;
BEGIN
     
    -- 1) Prepare request + trace ID
     v_llm_req := p_req;

    debug_util.starting(vcaller,   '(channel=' ||
        NVL(v_llm_req.stream_channel,'NULL') || ')',   v_trace_id
    );

     -- 2) If streaming disabled → use non-stream pipeline
     
    IF NOT NVL(v_llm_req.stream_enabled, FALSE) THEN
        debug_util.info(
            'DISABLED → fallback to invoke_chat()', vcaller,
            v_trace_id
        );

        v_final_llm := invoke_chat(v_llm_req);  -- returns t_llm_response
        p_response_out := v_final_llm.response_text;

        RETURN;
    END IF;

     -- 3) Initialize the streaming adapter
     llm_stream_adapter_util.init(
        p_stream_channel => v_llm_req.stream_channel,
        p_trace_id       => v_trace_id
    );

    debug_util.info('adapter initialized', vcaller, v_trace_id);

     -- 4) Delegate streaming to provider adapter
    --    Example: OpenAI → llm_openai_pkg.call_openai_stream
     BEGIN
        llm_router_pkg.invoke_llm_stream(
            p_req      => v_llm_req,
            p_trace_id => v_trace_id
        );

        debug_util.info(
            ' provider completed normally', vcaller, 
            v_trace_id
        );

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error(  SQLERRM, vcaller,
                v_trace_id
            );

            -- Create safe error response
            p_response_out := '[STREAM ERROR] ' || SQLERRM;

            -- Ensure adapter final callback fires safely
            llm_stream_adapter_util.on_end( p_full_response => p_response_out );

            RETURN;
    END;

     
    -- 5) Return final assembled response to caller
     p_response_out := llm_stream_adapter_util.g_final_response;

    debug_util.info( ' (len=' ||  NVL(DBMS_LOB.getlength(p_response_out),0) || ')', vcaller,  v_trace_id );

END invoke_chat_stream;

------------------------------------------------------------------------------
-- REGENERATE PIPELINE — Re-run the last assistant response
-- Steps:
--   1) Get last user query
--   2) Apply new override parameters (temperature, max_tokens, etc.)
--   3) Call main NON-STREAM pipeline again
------------------------------------------------------------------------------

FUNCTION invoke_regenerate(
    p_req        IN llm_types.t_llm_request,
    p_new_params IN JSON DEFAULT NULL
) RETURN llm_types.t_llm_response
IS  
    vcaller constant varchar2(70):= c_package_name ||'.invoke_regenerate';
    v_req                 llm_types.t_llm_request;
    v_session_rec         CHAT_SESSION_PKG.t_chat_session_rec;
    v_trace_id            VARCHAR2(200):=p_req.trace_id;
    v_last_user_msg       CLOB;
    v_last_provider       VARCHAR2(100);
    v_last_model          VARCHAR2(100);
BEGIN
    v_req := p_req;
 
    v_session_rec := CHAT_SESSION_PKG.get_session(p_session_id=>v_req.chat_session_id);
    debug_util.starting(vcaller, '' , v_trace_id);

     
    -- 1. Load last user message
     SELECT user_prompt
    INTO v_last_user_msg
    FROM (
        SELECT user_prompt
        FROM chat_calls
        WHERE chat_session_id   = p_req.chat_session_id
        ORDER BY DB_CREATED_AT DESC
    )
    WHERE ROWNUM = 1;

     -- 2. Load last used provider/model
     
   
   v_last_provider:= v_session_rec.provider;
   v_last_model:= v_session_rec.model;
 

    v_req.provider := v_last_provider;
    v_req.model    := v_last_model;
    v_req.user_prompt := v_last_user_msg;

     
    -- 3. Apply new parameters (patching request)
     
    IF p_new_params IS NOT NULL THEN
        BEGIN
            v_req.temperature :=
                JSON_VALUE(p_new_params, '$.temperature' RETURNING NUMBER);

            v_req.top_p :=
                JSON_VALUE(p_new_params, '$.top_p' RETURNING NUMBER);

            v_req.top_k :=
                JSON_VALUE(p_new_params, '$.top_k' RETURNING NUMBER);

            v_req.max_tokens :=
                JSON_VALUE(p_new_params, '$.max_tokens' RETURNING NUMBER);

            v_req.payload :=
                JSON_SERIALIZE(p_new_params RETURNING CLOB);
        EXCEPTION
            WHEN OTHERS THEN
                debug_util.warn('Failed to apply override parameters', vcaller , v_trace_id);
        END;
    END IF;

     
    -- 4. Call main pipeline again
     
    debug_util.ending( vcaller, '' ,v_trace_id);

    RETURN invoke_chat(v_req);

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error(  SQLERRM, vcaller , v_trace_id);
        RAISE;
END invoke_regenerate;
 
  /*******************************************************************************
 *  -- DIRECT RAG-ONLY CALL (no LLM)
-- Useful for testing RAG relevance and governance
 *******************************************************************************/
FUNCTION invoke_rag_only(
    p_req IN llm_types.t_llm_request
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_rag_only';
    v_trace_id VARCHAR2(200):=p_req.trace_id;
    v_rag      CLOB;
BEGIN
  
    debug_util.starting(vcaller, '',  v_trace_id);

    v_rag :=
        cx_chunks_builder_pkg.get_context_docs(
            p_user_id           => p_req.user_id,
            p_context_domain_id => p_req.context_domain_id,
            p_query             => p_req.user_prompt,
            p_top_k             => p_req.rag_max_chunks
        );

      debug_util.ending(vcaller, '',  v_trace_id);

    RETURN v_rag;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error(  SQLERRM, vcaller, v_trace_id);
        RETURN NULL;
END invoke_rag_only;
 
 /*******************************************************************************
 *  -- DIRECT LLM-ONLY CALL (no RAG, no governance)
-- Used for raw model testing and comparison
 *******************************************************************************/
FUNCTION invoke_llm_only(
    p_req IN llm_types.t_llm_request
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm_only';
    v_req  llm_types.t_llm_request;
    v_resp llm_types.t_llm_response;
    v_traceid varchar2(200):= p_req.trace_id;
BEGIN
    v_req := p_req;
  
    v_req.system_instructions := NULL;

    debug_util.info('invoke_llm_only CALLING ROUTER', vcaller, v_traceid);

    v_resp := call_llm(v_req);

    RETURN v_resp.response_text;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error( SQLERRM, vcaller,  v_traceid);
        RETURN NULL;
END invoke_llm_only;
------------------------------------------------------------------------------
-- Helper — Streaming callback bridge uses this for final assembly
------------------------------------------------------------------------------
/*
PROCEDURE stream_emit(
    p_text    IN VARCHAR2,
    p_channel IN VARCHAR2
)
IS
BEGIN
    CASE UPPER(p_channel)
        WHEN 'APEX' THEN
            HTP.p(p_text);
            HTP.flush;
        WHEN 'ORDS' THEN
            HTP.p('data: ' || REPLACE(p_text, CHR(10), ' '));
            HTP.p;
            HTP.flush;
        ELSE
            DBMS_OUTPUT.put_line(p_text);
    END CASE;
END stream_emit;
 */

  /*******************************************************************************
 *  
 *******************************************************************************/
end;

/
