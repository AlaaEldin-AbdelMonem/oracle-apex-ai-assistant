--------------------------------------------------------
--  DDL for Package Body LLM_OPENAI_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_OPENAI_PKG" AS

/*=============================================================================
  OpenAI Provider Adapter (Unified Request/Response Version)
  Enterprise Production Grade – Minimal Runtime Noise
  Uses llm_types.t_llm_request and t_llm_response
=============================================================================*/

--------------- 
-- CONSTANTS
--------------- 
c_buffer_size CONSTANT PLS_INTEGER := 32767;

 
 /*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------- 
-- INTERNAL: Build JSON payload from t_llm_request
-- VERSION - Includes system message + validation
------------------------------------------------- 
FUNCTION build_payload(
    p_req llm_types.t_llm_request,
    p_cfg llm_provider_models%ROWTYPE 
)
RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.build_payload'; 
    v_root      JSON_OBJECT_T := JSON_OBJECT_T();
    v_messages  JSON_ARRAY_T  := JSON_ARRAY_T();
    v_msg       JSON_OBJECT_T;
    v_stop_arr  JSON_ARRAY_T;
    v_payload   CLOB;
    v_traceid  varchar2(200):= p_req.trace_id;
BEGIN
    DEBUG_UTIL.starting(vcaller,'', v_traceid);
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 1: VALIDATE INPUTS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Validate user_prompt (REQUIRED)
    IF p_req.user_prompt IS NULL THEN
        DEBUG_UTIL.error('user_prompt is NULL',vcaller,v_traceid);
        RAISE_APPLICATION_ERROR(-20100, 
            'build_payload: user_prompt cannot be NULL');
    END IF;
    
    IF DBMS_LOB.getlength(p_req.user_prompt) = 0 THEN
        DEBUG_UTIL.error(' user_prompt is empty',vcaller,v_traceid);
        RAISE_APPLICATION_ERROR(-20101, 'build_payload: user_prompt cannot be empty');
    END IF;
    
    DEBUG_UTIL.info(' user_prompt validated, length: ' || 
                    DBMS_LOB.getlength(p_req.user_prompt),vcaller,v_traceid);
    
    -- Validate/default system_instructions
    IF p_req.system_instructions IS NULL OR 
       DBMS_LOB.getlength(p_req.system_instructions) = 0 THEN
        DEBUG_UTIL.warn('system_instructions is NULL/empty - will use OpenAI default behavior',vcaller,v_traceid);
    ELSE
        DEBUG_UTIL.info(' system_instructions validated, length: ' || 
                       DBMS_LOB.getlength(p_req.system_instructions),vcaller,v_traceid);
    END IF;
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 2: BUILD JSON STRUCTURE
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- Model (REQUIRED)
    v_root.put('model', p_cfg.model_code);
    DEBUG_UTIL.info(' Model: ' || p_cfg.model_code,vcaller,v_traceid);
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 3: BUILD MESSAGES ARRAY
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- ADD SYSTEM MESSAGE (if provided)
    IF p_req.system_instructions IS NOT NULL AND 
       DBMS_LOB.getlength(p_req.system_instructions) > 0 THEN
        
        v_msg := JSON_OBJECT_T();
        v_msg.put('role', 'system');
        v_msg.put('content', p_req.system_instructions);
        v_messages.append(v_msg);
        
        DEBUG_UTIL.info(' System message added to messages array',vcaller,v_traceid);
    END IF;
    
    --  ADD USER MESSAGE (REQUIRED)
    v_msg := JSON_OBJECT_T();
    v_msg.put('role', 'user');
    v_msg.put('content', p_req.user_prompt);
    v_messages.append(v_msg);
    
    DEBUG_UTIL.info(' User message added to messages array',vcaller,v_traceid);
    DEBUG_UTIL.info(' Total messages in array: ' || v_messages.get_size(),vcaller,v_traceid);
    
    -- Add messages array to root
    v_root.put('messages', v_messages);
    --  
    -- STEP 4: ADD GENERATION PARAMETERS
    --  
    -- Temperature (0.0 - 2.0)
    IF p_req.temperature IS NOT NULL THEN
        v_root.put('temperature', p_req.temperature);
        DEBUG_UTIL.info('temperature: ' || p_req.temperature,vcaller,v_traceid);
    END IF;

    -- Top P (0.0 - 1.0)
    IF p_req.top_p IS NOT NULL THEN
        v_root.put('top_p', p_req.top_p);
        DEBUG_UTIL.info(' top_p: ' || p_req.top_p,vcaller,v_traceid);
    END IF;

    -- Max Tokens (MUST be >= 1 for OpenAI)
        IF p_req.max_tokens IS NOT NULL THEN
            -- ADD THIS VALIDATION:
            IF p_req.max_tokens < 1 THEN
                DEBUG_UTIL.warn(' max_tokens is ' || p_req.max_tokens || 
                               ', setting to minimum value 1',vcaller,v_traceid);
                v_root.put('max_tokens', 1);
            ELSE
                v_root.put('max_tokens', p_req.max_tokens);
            END IF;
            DEBUG_UTIL.info('max_tokens: ' || p_req.max_tokens,vcaller,v_traceid);
        ELSE
            --  If NULL, set default
            v_root.put('max_tokens', 1000);
            DEBUG_UTIL.info('max_tokens: 1000 (default)',vcaller,v_traceid);
        END IF;
        
    -- Frequency Penalty (-2.0 to 2.0)
    IF p_req.frequency_penalty IS NOT NULL THEN
        v_root.put('frequency_penalty', p_req.frequency_penalty);
        DEBUG_UTIL.info(' frequency_penalty: ' || p_req.frequency_penalty,vcaller,v_traceid);
    END IF;

    -- Presence Penalty (-2.0 to 2.0)
    IF p_req.presence_penalty IS NOT NULL THEN
        v_root.put('presence_penalty', p_req.presence_penalty);
        DEBUG_UTIL.info(' presence_penalty: ' || p_req.presence_penalty,vcaller,v_traceid);
    END IF;

    -- Seed (for deterministic outputs)
    IF p_req.seed IS NOT NULL THEN
        v_root.put('seed', p_req.seed);
        DEBUG_UTIL.info(' seed: ' || p_req.seed,vcaller,v_traceid);
    END IF;

    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 5: ADD STOP SEQUENCES (if provided)
    -- ═══════════════════════════════════════════════════════════════════════
    
    IF p_req.stop IS NOT NULL THEN
        v_stop_arr := JSON_ARRAY_T();
        
        DECLARE
            v_str VARCHAR2(4000);
            v_pos PLS_INTEGER := 1;
            v_next PLS_INTEGER;
        BEGIN
            -- Parse CSV stop sequences
            LOOP
                v_next := INSTR(p_req.stop, ',', v_pos);
                
                IF v_next = 0 THEN
                    -- Last item
                    v_str := TRIM(SUBSTR(p_req.stop, v_pos));
                    IF v_str IS NOT NULL THEN
                        v_stop_arr.append(v_str);
                    END IF;
                    EXIT;
                ELSE
                    -- Middle item
                    v_str := TRIM(SUBSTR(p_req.stop, v_pos, v_next - v_pos));
                    IF v_str IS NOT NULL THEN
                        v_stop_arr.append(v_str);
                    END IF;
                    v_pos := v_next + 1;
                END IF;
            END LOOP;
            
            IF v_stop_arr.get_size() > 0 THEN
                v_root.put('stop', v_stop_arr);
                DEBUG_UTIL.info('stop sequences added: ' || v_stop_arr.get_size(),vcaller,v_traceid);
            END IF;
        END;
    END IF;

    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 6: ADD RESPONSE FORMAT OPTIONS
    -- ═══════════════════════════════════════════════════════════════════════
    
    -- JSON mode (simple)
    IF p_req.response_format = 'json' THEN
        DECLARE
            v_obj JSON_OBJECT_T := JSON_OBJECT_T();
        BEGIN
            v_obj.put('type', 'json_object');
            v_root.put('response_format', v_obj);
            DEBUG_UTIL.info(' response_format: json_object',vcaller,v_traceid);
        END;
    END IF;

    -- Schema-based structured output (advanced)
    IF p_req.response_schema IS NOT NULL THEN
        DECLARE
            v_obj JSON_OBJECT_T := JSON_OBJECT_T();
        BEGIN
            v_obj.put('type', 'json_schema');
            v_obj.put('json_schema', JSON_OBJECT_T.parse(p_req.response_schema));
            v_root.put('response_format', v_obj);
            DEBUG_UTIL.info(' response_format: json_schema',vcaller,v_traceid);
        END;
    END IF;

    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 7: ADD EXTENSIBILITY PAYLOAD
    -- ═══════════════════════════════════════════════════════════════════════
    
    IF p_req.payload IS NOT NULL THEN
        BEGIN
            v_root.put('extra', JSON_OBJECT_T.parse(p_req.payload));
            DEBUG_UTIL.info(' Extra payload added',vcaller,v_traceid);
        EXCEPTION
            WHEN OTHERS THEN
                DEBUG_UTIL.warn(' Could not parse p_req.payload as JSON: ' || SQLERRM,vcaller,v_traceid);
        END;
    END IF;

    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 8: CONVERT TO CLOB AND VALIDATE
    -- ═══════════════════════════════════════════════════════════════════════
    
    v_payload := v_root.to_clob;
    
    DEBUG_UTIL.info(' Generated JSON payload length: ' || 
                    DBMS_LOB.getlength(v_payload),vcaller,v_traceid);
    DEBUG_UTIL.info(' Generated JSON first 500 chars: ' || 
                    SUBSTR(v_payload, 1, 500),vcaller,v_traceid);
    
    -- ═══════════════════════════════════════════════════════════════════════
    -- STEP 9: FINAL VALIDATION
    -- ═══════════════════════════════════════════════════════════════════════
    
    BEGIN
        DECLARE
            v_test JSON_OBJECT_T;
            v_test_msgs JSON_ARRAY_T;
        BEGIN
            -- Parse back to validate
            v_test := JSON_OBJECT_T.parse(v_payload);
            
            -- Check required fields
            IF NOT v_test.has('model') THEN
                 DEBUG_UTIL.error('Missing model in payload', vcaller,v_traceid );
                RAISE_APPLICATION_ERROR(-20102, 'Missing model in payload');
            END IF;
            
            IF NOT v_test.has('messages') THEN
                DEBUG_UTIL.error( 'Missing messages in payload', vcaller ,v_traceid);
                RAISE_APPLICATION_ERROR(-20103, 'Missing messages in payload');
            END IF;
            
            v_test_msgs := JSON_ARRAY_T(v_test.get('messages'));
            
            IF v_test_msgs.get_size() = 0 THEN
                DEBUG_UTIL.error( 'Messages array is empty', vcaller ,v_traceid);
                RAISE_APPLICATION_ERROR(-20104, 'Messages array is empty');
            END IF;
            
            -- Validate each message has content
            FOR i IN 0 .. v_test_msgs.get_size() - 1 LOOP
                DECLARE
                    v_m JSON_OBJECT_T := JSON_OBJECT_T(v_test_msgs.get(i));
                BEGIN
                    IF NOT v_m.has('role') THEN
                     DEBUG_UTIL.error(  'Message ' || i || ' missing role', vcaller,v_traceid );
                        RAISE_APPLICATION_ERROR(-20105, 
                            'Message ' || i || ' missing role');
                    END IF;
                    
                    IF NOT v_m.has('content') THEN
                    DEBUG_UTIL.error(   'Message ' || i || ' missing content', vcaller,v_traceid );
                        RAISE_APPLICATION_ERROR(-20106, 
                            'Message ' || i || ' missing content');
                    END IF;
                    
                    -- Check content is not null
                    IF v_m.get('content').is_null() THEN
                    DEBUG_UTIL.error(  'Message ' || i || ' content is NULL', vcaller ,v_traceid);
                        RAISE_APPLICATION_ERROR(-20107, 
                            'Message ' || i || ' content is NULL');
                    END IF;
                    
                    DEBUG_UTIL.info(' Message ' || i || ' validated: role=' || 
                                   v_m.get_string('role') || 
                                   ', content_length=' || 
                                   LENGTH(v_m.get_string('content')),vcaller,v_traceid);
                END;
            END LOOP;
            
            DEBUG_UTIL.info(' Payload validation PASSED',vcaller,v_traceid);
        END;
    EXCEPTION
        WHEN OTHERS THEN
            DEBUG_UTIL.error('Payload validation FAILED: ' || SQLERRM,vcaller,v_traceid);
            RAISE;
    END;
    
    DEBUG_UTIL.ending(vcaller,'',v_traceid);
    
    RETURN v_payload;

EXCEPTION
    WHEN OTHERS THEN
        DEBUG_UTIL.error('build_payload EXCEPTION: ' || SQLERRM,vcaller,v_traceid);
        DEBUG_UTIL.error('Stack: ' || DBMS_UTILITY.format_error_backtrace,vcaller,v_traceid);
        RAISE;
END build_payload;
/*******************************************************************************
 *  
 *******************************************************************************/
---------------------------------- 
-- INTERNAL: Send UTL_HTTP request
---------------------------------- 
FUNCTION send_http(
    p_cfg     llm_provider_models%ROWTYPE,
    p_api_key VARCHAR2,
    p_payload CLOB,
    p_trace_id IN VARCHAR2
) RETURN CLOB
IS 
    vcaller constant varchar2(70):= c_package_name ||'.send_http'; 
    v_req   UTL_HTTP.req;
    v_resp  UTL_HTTP.resp;
    v_out   CLOB;
    v_chunk VARCHAR2(32767);
    v_url   VARCHAR2(4000);
    v_offset PLS_INTEGER := 1;
    v_amount PLS_INTEGER := 8000;  -- Safe chunk size
    v_buffer VARCHAR2(32767);
BEGIN
    v_url := p_cfg.api_base_url || p_cfg.api_endpoint_path;

    DEBUG_UTIL.info(' send_http: URL = ' || v_url,vcaller,p_trace_id);
    DEBUG_UTIL.info(' send_http: Payload length = ' || DBMS_LOB.getlength(p_payload),vcaller,p_trace_id);

    v_req := UTL_HTTP.begin_request(v_url, 'POST', 'HTTP/1.1');

    UTL_HTTP.set_header(v_req, 'Content-Type', 'application/json; charset=UTF-8');
    UTL_HTTP.set_header(v_req, p_cfg.auth_header_name, 'Bearer ' || p_api_key);
    UTL_HTTP.set_header(v_req, 'Content-Length', DBMS_LOB.getlength(p_payload));

    --  FIX: Write CLOB in chunks to handle large payloads
    v_offset := 1;
    WHILE v_offset <= DBMS_LOB.getlength(p_payload) LOOP
        -- Read chunk from CLOB
        v_buffer := DBMS_LOB.substr(p_payload, v_amount, v_offset);

        -- Write chunk to HTTP request
        UTL_HTTP.write_text(v_req, v_buffer);

        v_offset := v_offset + v_amount;
    END LOOP;

    DEBUG_UTIL.info(' send_http: Payload written, getting response...',vcaller,p_trace_id);

    v_resp := UTL_HTTP.get_response(v_req);

    DEBUG_UTIL.info(' send_http: HTTP Status = ' || v_resp.status_code,vcaller,p_trace_id);

    DBMS_LOB.createtemporary(v_out, TRUE);

    BEGIN
        LOOP
            UTL_HTTP.read_text(v_resp, v_chunk, c_buffer_size);
            DBMS_LOB.writeappend(v_out, LENGTH(v_chunk), v_chunk);
        END LOOP;
    EXCEPTION 
        WHEN UTL_HTTP.end_of_body THEN 
            NULL;
    END;

    UTL_HTTP.end_response(v_resp);

    DEBUG_UTIL.info(' send_http: Response received, length = ' || DBMS_LOB.getlength(v_out),vcaller,p_trace_id);

    RETURN v_out;

EXCEPTION
    WHEN OTHERS THEN
        DEBUG_UTIL.error(' send_http: EXCEPTION: ' || SQLERRM,vcaller ,p_trace_id);
        BEGIN
            UTL_HTTP.end_response(v_resp);
        EXCEPTION 
            WHEN OTHERS THEN 
             debug_util.error( sqlerrm,vcaller,p_trace_id);  
                NULL;
        END;
        RAISE;
END send_http;
/*******************************************************************************
 *  
 *******************************************************************************/
-- INTERNAL: Parse OpenAI JSON response
---------------------------------- 
FUNCTION parse_response(
    p_raw   CLOB,
    p_model VARCHAR2,
    p_trace_id IN VARCHAR2
) RETURN llm_types.t_llm_response
IS  
     vcaller constant varchar2(70):= c_package_name ||'.get_default_provider'; 
    v_res      llm_types.t_llm_response;
    v_json     JSON_OBJECT_T;
    v_usage    JSON_OBJECT_T;
    v_choices  JSON_ARRAY_T;
    v_msg      JSON_OBJECT_T;
    v_choice0  JSON_OBJECT_T;
BEGIN
    -- Initialize object types
    v_res.payload := NULL;
    v_res.safety_ratings := NULL;

    DEBUG_UTIL.info(' parse_response: Raw response length: ' || LENGTH(p_raw),vcaller,p_trace_id);
    DEBUG_UTIL.info(' parse_response: First 500 chars: ' || SUBSTR(p_raw, 1, 500),vcaller,p_trace_id);

    v_json := JSON_OBJECT_T.parse(p_raw);

    -- Check for error in response
    IF v_json.has('error') THEN
        DEBUG_UTIL.info(' parse_response: ERROR detected in OpenAI response!',vcaller,p_trace_id);
        v_res.success := FALSE;

        DECLARE
            v_error JSON_OBJECT_T := JSON_OBJECT_T(v_json.get('error') );
        BEGIN
            IF v_error.has('message') THEN
                v_res.msg := v_error.get_string('message');
                DEBUG_UTIL.info('parse_response: Error message: ' || v_res.msg,vcaller,p_trace_id);
            END IF;

            IF v_error.has('type') THEN
                DEBUG_UTIL.info('parse_response: Error type: ' || v_error.get_string('type'),vcaller,p_trace_id);
            END IF;

            IF v_error.has('code') THEN
                DEBUG_UTIL.info('parse_response: Error code: ' || v_error.get_string('code'),vcaller,p_trace_id);
            END IF;
        END;

        RETURN v_res;
    END IF;

    v_res.success := TRUE;
    v_res.provider_used := 'OPENAI';
    v_res.model_used := p_model;

    -- Basic metadata
    IF v_json.has('id') THEN
        v_res.request_id := v_json.get_string('id');
    END IF;

    IF v_json.has('created') THEN
        v_res.created_timestamp := v_json.get_number('created');
    END IF;

    IF v_json.has('system_fingerprint') THEN
        v_res.system_fingerprint := v_json.get_string('system_fingerprint');
    END IF;

    -- Choices[0]
    IF v_json.has('choices') THEN
        v_choices := JSON_ARRAY_T(v_json.get('choices'));
        v_choice0 := JSON_OBJECT_T(v_choices.get(0));

        IF v_choice0.has('finish_reason') THEN
            v_res.finish_reason := v_choice0.get_string('finish_reason');
            v_res.is_truncated := (v_res.finish_reason = 'length');
        END IF;

        -- Message
        IF v_choice0.has('message') THEN
            v_msg := JSON_OBJECT_T(v_choice0.get('message'));

            -- Refusal detection
            IF v_msg.has('refusal') THEN
                v_res.is_refusal := TRUE;
                v_res.refusal_text := v_msg.get_string('refusal');
            ELSIF v_msg.has('content') THEN
                v_res.response_text := v_msg.get_string('content');
            END IF;
        END IF;
    END IF;



    IF v_choice0.has('message') THEN
        v_msg := JSON_OBJECT_T(v_choice0.get('message'));

        -- ALWAYS capture content first
        IF v_msg.has('content') THEN
            v_res.response_text := v_msg.get_string('content');
        END IF;

        -- Then check if there's an ACTUAL refusal (not null)
        IF v_msg.has('refusal') AND NOT v_msg.get('refusal').is_null() THEN
            v_res.is_refusal := TRUE;
            v_res.refusal_text := v_msg.get_string('refusal');
            v_res.response_text := NULL;  -- Clear content if refused
        END IF;
    END IF;
    -- Token usage
    IF v_json.has('usage') THEN
        v_usage := JSON_OBJECT_T(v_json.get('usage'));

        v_res.tokens_input  := v_usage.get_number('prompt_tokens');
        v_res.tokens_output := v_usage.get_number('completion_tokens');
        v_res.tokens_total  := v_usage.get_number('total_tokens');
    END IF;

    DEBUG_UTIL.ending( vcaller,'',p_trace_id);
    RETURN v_res;

EXCEPTION
    WHEN OTHERS THEN
        DEBUG_UTIL.error('parse_response: EXCEPTION: ' || SQLERRM,vcaller,p_trace_id);
        v_res.success := FALSE;
        v_res.msg := 'Parse error: ' || SQLERRM;
        v_res.payload := NULL;
        v_res.safety_ratings := NULL;
        RETURN v_res;
END parse_response;
/*******************************************************************************
 *  
 *******************************************************************************/
 
----------------------------------- 
-- PUBLIC ENTRYPOINT: invoke_llm
--   ENHANCED VERSION - Better validation and error handling
---------------------------------- 
FUNCTION invoke_llm(
    p_req llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS   
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_cfg       llm_provider_models%ROWTYPE;
    v_key       VARCHAR2(4000);
    v_payload   CLOB;
    v_raw       CLOB;
    v_res       llm_types.t_llm_response;
    v_start     TIMESTAMP := SYSTIMESTAMP;
    v_llm_Model_Info_Req   LLM_MODEL_UTIL.t_llm_Model_Info_Req;
    v_traceid VARCHAR2(200):=p_req.trace_id;
BEGIN
     DEBUG_UTIL.starting( vcaller,'',v_traceid);
     
     -- STEP 0: INITIALIZE RESPONSE OBJECT (CRITICAL!)
     v_res.payload := NULL;
    v_res.safety_ratings := NULL;
    v_res.success := FALSE;  -- Default to FALSE
    DEBUG_UTIL.info('Response object initialized',vcaller,v_traceid);
    
     -- STEP 1: VALIDATE INPUT REQUEST
 
    DEBUG_UTIL.info('STEP 1: Validate Input Request',vcaller,v_traceid);
     
    -- Check provider
    IF p_req.provider IS NULL OR p_req.provider = '' THEN
        v_res.msg := 'provider is NULL or empty';
        DEBUG_UTIL.error(v_res.msg,vcaller,v_traceid);
        RETURN v_res;
    END IF;
    DEBUG_UTIL.info('provider: ' || p_req.provider,vcaller,v_traceid);
    
    -- Check model
    IF p_req.model IS NULL OR p_req.model = '' THEN
        v_res.msg := 'model is NULL or empty';
        DEBUG_UTIL.error(v_res.msg,vcaller,v_traceid);
        RETURN v_res;
    END IF;
    DEBUG_UTIL.info('model: ' || p_req.model ,vcaller,v_traceid);
    
    -- Check user_prompt
    IF p_req.user_prompt IS NULL THEN
        v_res.msg := 'user_prompt is NULL';
        DEBUG_UTIL.error( v_res.msg, vcaller,v_traceid);
        RETURN v_res;
    END IF;
    
    IF DBMS_LOB.getlength(p_req.user_prompt) = 0 THEN
        v_res.msg := 'user_prompt is empty';
        DEBUG_UTIL.error( v_res.msg ,vcaller,v_traceid);
        RETURN v_res;
    END IF;
    DEBUG_UTIL.info('user_prompt length: ' || 
                    DBMS_LOB.getlength(p_req.user_prompt) , vcaller ,v_traceid);
    
    -- Check system_instructions (warn if missing)
    IF p_req.system_instructions IS NULL OR 
       DBMS_LOB.getlength(p_req.system_instructions) = 0 THEN
        DEBUG_UTIL.warn('system_instructions is NULL/empty - OpenAI will use default behavior',vcaller,v_traceid);
    ELSE
        DEBUG_UTIL.info('system_instructions length: ' || 
                       DBMS_LOB.getlength(p_req.system_instructions),vcaller,v_traceid);
    END IF;
    
    DEBUG_UTIL.info('Input validation PASSED',vcaller,v_traceid);
    
     -- STEP 2: LOAD MODEL CONFIGURATION
      DEBUG_UTIL.info('STEP 2: Load Model Configuration',vcaller,v_traceid);
     
    BEGIN
        v_llm_Model_Info_Req.provider := p_req.provider;
        v_llm_Model_Info_Req.model := p_req.model;
        v_llm_Model_Info_Req.tenant_id := p_req.tenant_id;
        
        v_cfg := LLM_MODEL_UTIL.load_model_config(v_llm_Model_Info_Req);
        
        DEBUG_UTIL.info(' Config loaded: - model_code: ' || v_cfg.model_code||
        ' - api_base_url: ' || v_cfg.api_base_url ||
        ' - api_endpoint_path: ' || v_cfg.api_endpoint_path,vcaller,v_traceid);
    EXCEPTION
        WHEN OTHERS THEN
            v_res.msg := 'Failed to load model config: ' || SQLERRM;
            DEBUG_UTIL.error( v_res.msg , vcaller);
            RETURN v_res;
    END;
    
     -- STEP 3: LOAD API KEY

      DEBUG_UTIL.info('STEP 3: Load OpenAI API Key',vcaller,v_traceid);
     
    BEGIN
        v_key := LLM_MODEL_UTIL.load_api_key(v_cfg);
        
        IF v_key IS NULL OR LENGTH(v_key) = 0 THEN
            v_res.msg := 'API key is NULL or empty';
            DEBUG_UTIL.error(' ' || v_res.msg,vcaller,v_traceid);
            RETURN v_res;
        END IF;
        
        DEBUG_UTIL.info(' API key loaded: ' || 
                       SUBSTR(v_key, 1, 7) || '...' || 
                       SUBSTR(v_key, -4) , vcaller,v_traceid);
    EXCEPTION
        WHEN OTHERS THEN
            v_res.msg := 'Failed to load API key: ' || SQLERRM;
            DEBUG_UTIL.error(  v_res.msg , vcaller,v_traceid);
            RETURN v_res;
    END;
    
     -- STEP 4: BUILD JSON PAYLOAD
      DEBUG_UTIL.info('STEP 4: Build JSON Payload',vcaller,v_traceid);
     
    BEGIN
        v_payload := build_payload(p_req, v_cfg);
        DEBUG_UTIL.info(' Payload built successfully', vcaller,v_traceid);
    EXCEPTION
        WHEN OTHERS THEN
            v_res.msg := 'build_payload failed: ' || SQLERRM;
            DEBUG_UTIL.error( v_res.msg, vcaller);
            DEBUG_UTIL.error('Stack: ' || DBMS_UTILITY.format_error_backtrace,vcaller,v_traceid);
            RETURN v_res;
    END;
    
     -- STEP 5: SEND HTTP REQUEST
      DEBUG_UTIL.info('STEP 5: Send HTTP Request to OpenAI',vcaller,v_traceid);
     
    BEGIN
        v_raw := send_http(v_cfg, v_key, v_payload , v_traceid);
        DEBUG_UTIL.info('HTTP response received',vcaller,v_traceid);
    EXCEPTION
        WHEN OTHERS THEN
            v_res.msg := 'HTTP request failed: ' || SQLERRM;
            DEBUG_UTIL.error( v_res.msg,vcaller,v_traceid);
            RETURN v_res;
    END;
    
     -- STEP 6: PARSE RESPONSE JSON
      DEBUG_UTIL.info('STEP 6: Parse OpenAI Response',vcaller,v_traceid);
     
    BEGIN
        v_res := parse_response(v_raw, p_req.model, v_traceid);
        
        IF v_res.success THEN
            DEBUG_UTIL.info('Response parsed successfully',vcaller,v_traceid);
            DEBUG_UTIL.info('   - response_text length: ' || 
                           NVL(LENGTH(v_res.response_text), 0),vcaller,v_traceid);
            DEBUG_UTIL.info('   - tokens_input: ' || 
                           NVL(v_res.tokens_input, 0),vcaller,v_traceid);
            DEBUG_UTIL.info('   - tokens_output: ' || 
                           NVL(v_res.tokens_output, 0),vcaller,v_traceid);
            DEBUG_UTIL.info('   - finish_reason: ' || 
                           NVL(v_res.finish_reason, 'NULL'),vcaller,v_traceid);
        ELSE
            DEBUG_UTIL.error(' OpenAI returned error: ' || v_res.msg,vcaller,v_traceid);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            v_res.success := FALSE;
            v_res.msg := 'parse_response failed: ' || SQLERRM;
            v_res.payload := NULL;
            v_res.safety_ratings := NULL;
            DEBUG_UTIL.error(  v_res.msg,vcaller,v_traceid);
            RETURN v_res;
    END;
    
     -- STEP 7: CALCULATE COST
 
    DEBUG_UTIL.info('STEP 7: Calculate Cost',vcaller,v_traceid);
 
    
    BEGIN
        SELECT (NVL(v_res.tokens_input, 0) / 1000) * cost_per_1k_input_tokens +
               (NVL(v_res.tokens_output, 0) / 1000) * cost_per_1k_output_tokens
        INTO   v_res.cost_usd
        FROM   llm_provider_models
        WHERE  model_code = p_req.model
        AND    provider_code = 'OPENAI'
        AND    ROWNUM = 1;
        
        DEBUG_UTIL.info('Cost calculated: $' ||  TO_CHAR(v_res.cost_usd, '0.00000000'),vcaller,v_traceid);
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            v_res.cost_usd := 0;
            DEBUG_UTIL.warn('No cost data found for model, set to 0',vcaller,v_traceid);
        WHEN OTHERS THEN 
            v_res.cost_usd := 0;
            DEBUG_UTIL.warn(' Cost calculation failed: ' || SQLERRM,vcaller,v_traceid);
    END;
    
     -- STEP 8: ADD METADATA
     DEBUG_UTIL.info('STEP 8: Add Metadata',vcaller,v_traceid);
     
    v_res.rag_context_doc_count := NULL;
    v_res.processing_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;
    
    DEBUG_UTIL.info('Processing time: ' || 
                   ROUND(v_res.processing_ms, 2) || ' ms',vcaller,v_traceid);
    
    --  
    -- STEP 9: LOG EVENT
    --  
     DEBUG_UTIL.info('STEP 9: Log Event',vcaller,v_traceid);
     
    BEGIN
        IF v_res.success THEN
            
            DEBUG_UTIL.info('OPENAI>INFO>OpenAI call successful',vcaller,v_traceid);
 
        ELSE
             DEBUG_UTIL.info('OPENAI>ERROR❌>OpenAI returned error: ' || v_res.msg,vcaller,v_traceid);
         
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DEBUG_UTIL.error('⚠️ log_event failed (non-fatal): ' || SQLERRM,vcaller,v_traceid);
            -- Continue - logging failure shouldn't break the flow
    END;
    
     -- FINAL: RETURN RESPONSE
     DEBUG_UTIL.info('  call_openai: COMPLETE',vcaller,v_traceid);
    DEBUG_UTIL.info('   Final Status: ' || 
                   CASE WHEN v_res.success THEN 'SUCCESS ✅' ELSE 'FAILED ❌' END ,vcaller,v_traceid);
    IF NOT v_res.success THEN
        DEBUG_UTIL.info('   Error Message: ' || v_res.msg,vcaller,v_traceid);
    END IF;
     
    RETURN v_res;

EXCEPTION
    WHEN OTHERS THEN
         DEBUG_UTIL.error(sqlerrm,vcaller,v_traceid);
        DEBUG_UTIL.error('   Error: ' || SQLERRM,vcaller,v_traceid);
        DEBUG_UTIL.error('   Stack: ' || DBMS_UTILITY.format_error_backtrace,vcaller,v_traceid);
   
        
        v_res.success := FALSE;
        v_res.msg := 'Unexpected error: ' || SQLERRM;
        v_res.payload := NULL;
        v_res.safety_ratings := NULL;
        v_res.processing_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;
        
        RETURN v_res;
END invoke_llm;

/*******************************************************************************
 *  
 *******************************************************************************/

---------------------------------
---------------------------------
/* ========================================================================
   STREAMING IMPLEMENTATION — SSE Token Stream via UTL_HTTP
   ========================================================================*/
/* ============================================================================
   OPENAI STREAMING IMPLEMENTATION (SSE)
   Uses LLM_STREAM_ADAPTER_UTIL for per-token callbacks
   ============================================================================ */
/*PROCEDURE call_openai_stream(
    p_req      IN llm_types.t_llm_request,
    p_trace_id IN VARCHAR2
)
IS
    v_cfg         llm_provider_models%ROWTYPE;
    v_key         VARCHAR2(4000);
    v_payload     CLOB;
    v_stream_url  VARCHAR2(4000);

    v_req         UTL_HTTP.req;
    v_resp        UTL_HTTP.resp;
    v_line        VARCHAR2(32767);
    v_json        JSON_OBJECT_T;
    v_delta       VARCHAR2(32767);

    v_final       CLOB := EMPTY_CLOB();
    v_llm_Model_Info_Req   LLM_MODEL_UTIL.t_llm_Model_Info_Req;
BEGIN
    ----------------------------------------------------------------------
    -- 1) Load config and API key
    ---------------------------------------------------------------------
     v_llm_Model_Info_Req.provider :=p_req.provider ;
     v_llm_Model_Info_Req.model :=p_req.model ;
     v_llm_Model_Info_Req.tenant_id := p_req.tenant_id;
     v_cfg := LLM_MODEL_UTIL.load_model_config(v_llm_Model_Info_Req);

    v_key     := LLM_MODEL_UTIL.load_api_key(v_cfg);
    v_payload := build_payload(p_req, v_cfg);

    IF v_payload NOT LIKE '%"stream"%' THEN
        v_payload := RTRIM(v_payload,'}')||', "stream":true}';
    END IF;

    v_stream_url := v_cfg.api_base_url || v_cfg.api_endpoint_path;

    ----------------------------------------------------------------------
    -- 2) HTTP setup
    ----------------------------------------------------------------------
    v_req := UTL_HTTP.begin_request(v_stream_url,'POST','HTTP/1.1');

    UTL_HTTP.set_header(v_req,'Content-Type','application/json');
    UTL_HTTP.set_header(v_req,v_cfg.auth_header_name,'Bearer '||v_key);
    UTL_HTTP.set_header(v_req,'Accept','text/event-stream');

    UTL_HTTP.write_text(v_req, v_payload);
    v_resp := UTL_HTTP.get_response(v_req);

    ----------------------------------------------------------------------
    -- 3) STREAM LOOP
    ----------------------------------------------------------------------
    LOOP
        BEGIN
            UTL_HTTP.read_line(v_resp, v_line, TRUE);
        EXCEPTION 
            WHEN UTL_HTTP.end_of_body THEN EXIT;
        END;

        v_line := TRIM(v_line);

        IF v_line IS NULL THEN CONTINUE; END IF;
        IF NOT v_line LIKE 'data:%' THEN CONTINUE; END IF;

        v_line := SUBSTR(v_line, 7);

        IF v_line = '[DONE]' THEN EXIT; END IF;

        BEGIN
            v_json := JSON_OBJECT_T.parse(v_line);
        EXCEPTION
            WHEN OTHERS THEN CONTINUE;
        END;

        BEGIN
            v_delta :=
                JSON_OBJECT_T(
                    JSON_ARRAY_T(
                        v_json.get('choices')
                    ).get(0)
                ).get_object('delta').get_string('content');
        EXCEPTION
            WHEN OTHERS THEN v_delta := NULL;
        END;

        IF v_delta IS NOT NULL THEN
            v_final := v_final || v_delta;

            -- 🔥 FIRE CALLBACK
            LLM_STREAM_ADAPTER_UTIL.on_token(v_delta);
        END IF;

    END LOOP;

    ----------------------------------------------------------------------
    -- 4) FINAL CALLBACK
    ----------------------------------------------------------------------
    LLM_STREAM_ADAPTER_UTIL.on_end(v_final);

    UTL_HTTP.end_response(v_resp);
    DEBUG_UTIL.info('🔍 call_openai_stream-done ');
EXCEPTION
    WHEN OTHERS THEN
         DEBUG_UTIL.error('🔍 call_openai_stream: ' || SQLERRM);
        LLM_STREAM_ADAPTER_UTIL.on_end('[OPENAI STREAM ERROR] '||SQLERRM);
        BEGIN
            UTL_HTTP.end_response(v_resp);
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
END call_openai_stream; */
--------------------------------

/*******************************************************************************
 *  
 *******************************************************************************/
/* ============================================================================
   OPENAI STREAMING IMPLEMENTATION (SSE) - WITH DIRECT DEBUG
   ============================================================================ */
PROCEDURE invoke_llm_stream(
    p_req      IN llm_types.t_llm_request,
    p_trace_id IN VARCHAR2
)
IS   vcaller constant varchar2(70):= c_package_name ||'.invoke_llm_stream'; 
    v_cfg         llm_provider_models%ROWTYPE;
    v_key         VARCHAR2(4000);
    v_payload     CLOB;
    v_stream_url  VARCHAR2(4000);

    v_req         UTL_HTTP.req;
    v_resp        UTL_HTTP.resp;
    v_line        VARCHAR2(32767);
    v_json        JSON_OBJECT_T;
    v_delta       VARCHAR2(32767);
    v_error_body  CLOB;

    v_final       CLOB := EMPTY_CLOB();
    v_llm_Model_Info_Req   LLM_MODEL_UTIL.t_llm_Model_Info_Req;

    PROCEDURE sse(p_msg VARCHAR2) IS
    BEGIN
        HTP.p('data: [OPENAI] ' || p_msg);
        HTP.p;
        HTP.flush;
       DEBUG_UTIL.info( SUBSTR(p_msg, 1, 1000),vcaller,p_trace_id);

    EXCEPTION
        WHEN OTHERS THEN NULL;
    END;

BEGIN
    sse('START streaming');

    v_llm_Model_Info_Req.provider := p_req.provider;
    v_llm_Model_Info_Req.model := p_req.model;
    v_llm_Model_Info_Req.tenant_id := p_req.tenant_id;

    sse('Loading config...');
    v_cfg := LLM_MODEL_UTIL.load_model_config(v_llm_Model_Info_Req);
    sse('Config: ' || v_cfg.model_code);

    sse('Loading API key...');
    v_key := LLM_MODEL_UTIL.load_api_key(v_cfg);
    sse('Key loaded: ' || SUBSTR(v_key, 1, 8) || '...' || SUBSTR(v_key, -4));

    sse('Building payload...');
    v_payload := build_payload(p_req, v_cfg);

    IF v_payload NOT LIKE '%"stream"%' THEN
        v_payload := RTRIM(v_payload, '}') || ', "stream":true}';
    END IF;

    sse('Payload: ' || SUBSTR(v_payload, 1, 200));

    v_stream_url := v_cfg.api_base_url || v_cfg.api_endpoint_path;
    sse('URL: ' || v_stream_url);

    sse('Auth header name: ' || v_cfg.auth_header_name);
    sse('Auth header value: Bearer ' || SUBSTR(v_key, 1, 15) || '...');

    v_req := UTL_HTTP.begin_request(v_stream_url, 'POST', 'HTTP/1.1');

    UTL_HTTP.set_header(v_req, 'Content-Type', 'application/json');
    UTL_HTTP.set_header(v_req, v_cfg.auth_header_name, 'Bearer ' || v_key);
    UTL_HTTP.set_header(v_req, 'Accept', 'text/event-stream');

    sse('Headers set, writing payload...');
    UTL_HTTP.write_text(v_req, v_payload);

    sse('Getting response...');
    v_resp := UTL_HTTP.get_response(v_req);
    sse('Status: ' || v_resp.status_code || ' ' || v_resp.reason_phrase);

    --  If 401, read error body
    IF v_resp.status_code = 401 THEN
        sse('401 ERROR - Reading error body...');
        DBMS_LOB.createtemporary(v_error_body, TRUE);

        BEGIN
            LOOP
                UTL_HTTP.read_text(v_resp, v_line, 32767);
                DBMS_LOB.writeappend(v_error_body, LENGTH(v_line), v_line);
            END LOOP;
        EXCEPTION 
            WHEN UTL_HTTP.end_of_body THEN 
                NULL;
        END;

        sse('Error body: ' || SUBSTR(v_error_body, 1, 500));
        UTL_HTTP.end_response(v_resp);

        LLM_STREAM_ADAPTER_UTIL.on_end('[401 AUTH ERROR] ' || v_error_body);
        RETURN;
    END IF;

    sse('Starting stream loop...');

    LOOP
        BEGIN
            UTL_HTTP.read_line(v_resp, v_line, TRUE);
        EXCEPTION 
            WHEN UTL_HTTP.end_of_body THEN 
                sse('End of body');
                EXIT;
        END;

        v_line := TRIM(v_line);
        IF v_line IS NULL THEN CONTINUE; END IF;
        IF NOT v_line LIKE 'data:%' THEN CONTINUE; END IF;

        v_line := SUBSTR(v_line, 7);
        IF v_line = '[DONE]' THEN EXIT; END IF;

        BEGIN
            v_json := JSON_OBJECT_T.parse(v_line);
        EXCEPTION
            WHEN OTHERS THEN CONTINUE;
        END;

        BEGIN
            v_delta := JSON_OBJECT_T(JSON_ARRAY_T(v_json.get('choices')).get(0))
                       .get_object('delta').get_string('content');
        EXCEPTION
            WHEN OTHERS THEN v_delta := NULL;
        END;

        IF v_delta IS NOT NULL THEN
            v_final := v_final || v_delta;
            LLM_STREAM_ADAPTER_UTIL.on_token(v_delta);
        END IF;
    END LOOP;

    sse('Complete. Length: ' || LENGTH(v_final));
    LLM_STREAM_ADAPTER_UTIL.on_end(v_final);
    UTL_HTTP.end_response(v_resp);

EXCEPTION
    WHEN OTHERS THEN
       debug_util.error( sqlerrm,vcaller,p_trace_id);  
        sse('EXCEPTION: ' || SQLERRM);
        LLM_STREAM_ADAPTER_UTIL.on_end('[ERROR] ' || SQLERRM);
        BEGIN
            UTL_HTTP.end_response(v_resp);
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
END invoke_llm_stream;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_openai_pkg;

/
