--------------------------------------------------------
--  DDL for Package Body LLM_GEMINI_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LLM_GEMINI_PKG" AS
/* ============================================================================
   LLM_GEMINI_PKG — Unified Gemini LLM Caller using llm_types
   Fully rewritten with Oracle 23ai JSON_OBJECT_T / JSON_ARRAY_T best-practices
   ============================================================================ */
/*******************************************************************************
 *  
 *******************************************************************************/
     
    c_buffer_size     CONSTANT NUMBER := 32767;
    c_api_key_param   CONSTANT VARCHAR2(50) := 'GOOGLE_API_KEY';

/*******************************************************************************
 *  
 *******************************************************************************/
 
FUNCTION build_payload(
    p_req llm_types.t_llm_request,
    p_cfg llm_provider_models%ROWTYPE
)
RETURN CLOB
IS  vcaller constant varchar2(70):= c_package_name ||'.build_payload'; 
    v_root      JSON_OBJECT_T := JSON_OBJECT_T();
    v_messages  JSON_ARRAY_T  := JSON_ARRAY_T();
    v_msg       JSON_OBJECT_T := JSON_OBJECT_T();
    v_stop_arr  JSON_ARRAY_T;
    v_payload   CLOB;
BEGIN
    -- Model
    v_root.put('model', p_cfg.model_code);

    -- Messages
    v_msg.put('role','user');
    v_msg.put('content', p_req.user_prompt);
    v_messages.append(v_msg);
    v_root.put('messages', v_messages);

    -- Generation parameters
    IF p_req.temperature IS NOT NULL THEN
        v_root.put('temperature', p_req.temperature);
    END IF;

    IF p_req.top_p IS NOT NULL THEN
        v_root.put('top_p', p_req.top_p);
    END IF;

    IF p_req.max_tokens IS NOT NULL THEN
        v_root.put('max_tokens', p_req.max_tokens);
    END IF;

    IF p_req.frequency_penalty IS NOT NULL THEN
        v_root.put('frequency_penalty', p_req.frequency_penalty);
    END IF;

    IF p_req.presence_penalty IS NOT NULL THEN
        v_root.put('presence_penalty', p_req.presence_penalty);
    END IF;

    IF p_req.seed IS NOT NULL THEN
        v_root.put('seed', p_req.seed);
    END IF;

    -- Stop sequences (CSV)
    IF p_req.stop IS NOT NULL THEN
        v_stop_arr := JSON_ARRAY_T();
        DECLARE
            v_str VARCHAR2(4000);
            v_pos PLS_INTEGER := 1;
            v_next PLS_INTEGER;
        BEGIN
            LOOP
                v_next := INSTR(p_req.stop, ',', v_pos);
                IF v_next = 0 THEN
                    v_str := TRIM(SUBSTR(p_req.stop, v_pos));
                    EXIT;
                ELSE
                    v_str := TRIM(SUBSTR(p_req.stop, v_pos, v_next - v_pos));
                    v_stop_arr.append(v_str);
                    v_pos := v_next+1;
                END IF;
            END LOOP;

            IF v_str IS NOT NULL THEN
                v_stop_arr.append(v_str);
            END IF;

            v_root.put('stop', v_stop_arr);
        END;
    END IF;

    -- Response format (JSON mode)
    IF p_req.response_format = 'json' THEN
        DECLARE
            v_obj JSON_OBJECT_T := JSON_OBJECT_T();
        BEGIN
            v_obj.put('type','json_object');
            v_root.put('response_format', v_obj);
        END;
    END IF;

    -- Schema-based structured output
    IF p_req.response_schema IS NOT NULL THEN
        DECLARE
            v_obj JSON_OBJECT_T := JSON_OBJECT_T();
        BEGIN
            v_obj.put('type','json_schema');
            v_obj.put('json_schema', JSON_OBJECT_T.parse(p_req.response_schema));
            v_root.put('response_format', v_obj);
        END;
    END IF;

    -- Extensibility payload (JSON blob)
    IF p_req.payload IS NOT NULL THEN
        v_root.put('extra', JSON_OBJECT_T.parse(p_req.payload));
    END IF;

    -- Convert to CLOB
    v_payload := v_root.to_clob;
    RETURN v_payload;
END build_payload;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- CLEANUP HTTP HANDLES
    ----------------------------------------------------------------------------
    PROCEDURE cleanup_http(
        p_http_req  IN OUT UTL_HTTP.req,
        p_http_resp IN OUT UTL_HTTP.resp
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.cleanup_http'; 
    BEGIN
        BEGIN
            IF p_http_resp.status_code IS NOT NULL THEN
                UTL_HTTP.end_response(p_http_resp);
            END IF;
        EXCEPTION WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
         NULL; END;

        BEGIN
            UTL_HTTP.end_request(p_http_req);
        EXCEPTION WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
         NULL; END;
    END cleanup_http;

 /*******************************************************************************
 *  
 *******************************************************************************/
    -- VALIDATE API KEY
    ----------------------------------------------------------------------------
    FUNCTION is_valid_api_key(p_api_key IN VARCHAR2)
        RETURN BOOLEAN IS
         vcaller constant varchar2(70):= c_package_name ||'.is_valid_api_key'; 
    BEGIN
        RETURN p_api_key IS NOT NULL AND LENGTH(p_api_key) > 20;
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- LOAD MODEL CONFIG
    ----------------------------------------------------------------------------
    FUNCTION load_model_config(
        p_model_code IN VARCHAR2
    ) RETURN llm_provider_models%ROWTYPE IS
       vcaller constant varchar2(70):= c_package_name ||'.load_model_config'; 
        v_cfg llm_provider_models%ROWTYPE;

    BEGIN
        SELECT *
        INTO v_cfg
        FROM llm_provider_models
        WHERE provider_code = 'GOOGLE'
          AND UPPER(model_code) = UPPER(p_model_code)
          AND is_active = 'Y'
          AND is_production_ready = 'Y';

        RETURN v_cfg;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           debug_util.error(sqlerrm,vcaller);  
            RAISE_APPLICATION_ERROR(-20010,
                'Gemini model "'||p_model_code||'" not found.');
    END load_model_config;

/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- SAFE JSON GETTERS
    ----------------------------------------------------------------------------
    FUNCTION json_get_string(
        p_obj IN JSON_OBJECT_T,
        p_key IN VARCHAR2
    ) RETURN VARCHAR2 IS
     vcaller constant varchar2(70):= c_package_name ||'.json_get_string'; 
    BEGIN
        IF p_obj IS NOT NULL AND p_obj.has(p_key) THEN
            RETURN p_obj.get_String(p_key);
        END IF;
        RETURN NULL;
    END;

    FUNCTION json_get_number(
        p_obj IN JSON_OBJECT_T,
        p_key IN VARCHAR2
    ) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.log_event'; 
    BEGIN
        IF p_obj IS NOT NULL AND p_obj.has(p_key) THEN
            RETURN p_obj.get_Number(p_key);
        END IF;
        RETURN NULL;
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- HYBRID RESOLUTION:
    -- payload → record → model default
    ----------------------------------------------------------------------------
    FUNCTION hybrid_number(
        p_payload   IN JSON_OBJECT_T,
        p_key       IN VARCHAR2,
        p_record    IN NUMBER,
        p_default   IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.hybrid_number'; 
        v_payload NUMBER;
    BEGIN
        v_payload := json_get_number(p_payload, p_key);

        IF v_payload IS NOT NULL THEN
            RETURN v_payload;
        ELSIF p_record IS NOT NULL THEN
            RETURN p_record;
        ELSE
            RETURN p_default;
        END IF;
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- COST CALCULATOR
    ----------------------------------------------------------------------------
    FUNCTION calculate_costs(
        p_prompt_tokens NUMBER,
        p_output_tokens NUMBER,
        p_model_code      VARCHAR2
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.calculate_costs'; 
        v_in_price  NUMBER := 0.075; -- fallback Flash
        v_out_price NUMBER := 0.30;
        v_total NUMBER;

    BEGIN
        BEGIN
            SELECT cost_per_1k_input_tokens,
                   cost_per_1k_output_tokens
            INTO v_in_price, v_out_price
            FROM llm_provider_models
            WHERE provider_code = 'GOOGLE'
              AND UPPER(model_code) = UPPER(p_model_code)
              AND is_active = 'Y'
              AND is_production_ready = 'Y';
        EXCEPTION WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
         NULL;
        END;

        v_total :=
              (NVL(p_prompt_tokens,0)/1000) * v_in_price
            + (NVL(p_output_tokens,0)/1000) * v_out_price;

        RETURN v_total;
    END calculate_costs;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- BUILD GEMINI PAYLOAD (SAFE JSON ONLY)
    ----------------------------------------------------------------------------
    FUNCTION build_gemini_payload(
        p_req IN llm_types.t_llm_request,
        p_cfg IN llm_provider_models%ROWTYPE
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.build_gemini_payload'; 
        v_root          JSON_OBJECT_T;
        v_contents      JSON_ARRAY_T;
        v_user_msg      JSON_OBJECT_T;
        v_user_parts    JSON_ARRAY_T;

        v_gen_cfg       JSON_OBJECT_T;

        v_req_payload   JSON_OBJECT_T;
        v_clob          CLOB;

        v_temp          NUMBER;
        v_top_p         NUMBER;
        v_top_k         NUMBER;
        v_max_tokens    NUMBER;

    BEGIN
        ----------------------------------------------------------------------
        -- Parse p_req.payload (optional override)
        ----------------------------------------------------------------------
        IF p_req.payload IS NOT NULL THEN
            BEGIN
                v_req_payload := JSON_OBJECT_T.parse(p_req.payload);
            EXCEPTION WHEN OTHERS THEN
                v_req_payload := NULL;
            END;
        END IF;

        ----------------------------------------------------------------------
        -- Resolve values with hybrid override
        ----------------------------------------------------------------------
        v_temp := hybrid_number(v_req_payload, 'temperature',
                                p_req.temperature, p_cfg.default_temperature);

        v_top_p := hybrid_number(v_req_payload, 'top_p',
                                 p_req.top_p, p_cfg.default_top_p);

        v_top_k := hybrid_number(v_req_payload, 'top_k',
                                 p_req.top_k, NVL(p_cfg.default_top_k,40));

        v_max_tokens := hybrid_number(v_req_payload, 'max_tokens',
                                      p_req.max_tokens, p_cfg.max_output_tokens);

        v_max_tokens := LEAST(v_max_tokens, p_cfg.max_output_tokens);

        ----------------------------------------------------------------------
        -- Build "contents" array
        ----------------------------------------------------------------------
        v_user_parts := JSON_ARRAY_T();

        DECLARE
            v_part JSON_OBJECT_T;
        BEGIN
            v_part := JSON_OBJECT_T();
            v_part.put('text', p_req.user_prompt);
            v_user_parts.append(v_part);
        END;

        v_user_msg := JSON_OBJECT_T();
        v_user_msg.put('role', 'user');
        v_user_msg.put('parts', v_user_parts);

        v_contents := JSON_ARRAY_T();
        v_contents.append(v_user_msg);

        -------------------------- 
        -- Build generationConfig
        ------------------------- 
        v_gen_cfg := JSON_OBJECT_T();
        v_gen_cfg.put('temperature', v_temp);
        v_gen_cfg.put('topP',        v_top_p);
        v_gen_cfg.put('topK',        v_top_k);
        v_gen_cfg.put('maxOutputTokens', v_max_tokens);

        -- Stop sequences array
        IF p_req.stop IS NOT NULL THEN
            DECLARE
                v_arr JSON_ARRAY_T := JSON_ARRAY_T();
                v_val VARCHAR2(4000);
                v_pos NUMBER := 1;
                v_next NUMBER;
            BEGIN
                LOOP
                    v_next := INSTR(p_req.stop, ',', v_pos);
                    IF v_next = 0 THEN
                        v_val := TRIM(SUBSTR(p_req.stop, v_pos));
                        EXIT;
                    ELSE
                        v_val := TRIM(SUBSTR(p_req.stop, v_pos, v_next - v_pos));
                        v_pos := v_next + 1;
                    END IF;

                    IF v_val IS NOT NULL THEN
                        v_arr.append(v_val);
                    END IF;
                END LOOP;

                v_gen_cfg.put('stopSequences', v_arr);
            END;
        END IF;

        -------------------- 
        -- Build ROOT object
        --------------------- 
        v_root := JSON_OBJECT_T();
        v_root.put('contents', v_contents);
        v_root.put('generationConfig', v_gen_cfg);

        -------------------------------- 
        -- Apply payload overrides (if valid JSON)
        ---------------------------- 
             IF v_req_payload IS NOT NULL THEN
                DECLARE
                    v_keys JSON_KEY_LIST;
                    v_key  VARCHAR2(500);
                BEGIN
                    v_keys := v_req_payload.get_keys;

                    FOR i IN 1 .. v_keys.count LOOP
                        v_key := v_keys(i);
                        v_root.put(v_key, v_req_payload.get(v_key));
                    END LOOP;

                END;
            END IF;

        ------------------- 
        -- Convert to CLOB
        ------------------ 
        v_clob := v_root.to_clob;
        RETURN v_clob;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RAISE_APPLICATION_ERROR(-20100,
                'Error building Gemini payload: '||SQLERRM);
    END build_gemini_payload;
/*******************************************************************************
 *  
 *******************************************************************************/
    -------------------- 
    -- SEND HTTP REQUEST
    --------------------- 
    FUNCTION send_gemini_http_request(
        p_cfg     IN llm_provider_models%ROWTYPE,
        p_api_key IN VARCHAR2,
        p_payload IN CLOB
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.send_gemini_http_request'; 
        v_http_req   UTL_HTTP.req;
        v_http_resp  UTL_HTTP.resp;
        v_url        VARCHAR2(4000);
        v_buffer     VARCHAR2(32767);
        v_resp       CLOB;

    BEGIN
        v_url :=
               p_cfg.api_base_url
            || '/v1beta/models/'
            || p_cfg.model_code
            || ':generateContent?key='
            || p_api_key;

        v_http_req := UTL_HTTP.begin_request(v_url, 'POST', 'HTTP/1.1');
        UTL_HTTP.set_header(v_http_req, 'Content-Type','application/json');
        UTL_HTTP.set_header(v_http_req,'Content-Length', LENGTH(p_payload));

        UTL_HTTP.write_text(v_http_req, p_payload);

        v_http_resp := UTL_HTTP.get_response(v_http_req);

        DBMS_LOB.createtemporary(v_resp, TRUE);

        BEGIN
            LOOP
                UTL_HTTP.read_text(v_http_resp, v_buffer, c_buffer_size);
                DBMS_LOB.writeappend(v_resp, LENGTH(v_buffer), v_buffer);
            END LOOP;
        EXCEPTION WHEN UTL_HTTP.end_of_body THEN
           NULL;
        END;

        UTL_HTTP.end_response(v_http_resp);

        IF v_http_resp.status_code <> 200 THEN
            RAISE_APPLICATION_ERROR(-20101,
                'Gemini HTTP '||v_http_resp.status_code
                ||': '||SUBSTR(v_resp,1,400));
        END IF;

        RETURN v_resp;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            cleanup_http(v_http_req, v_http_resp);
            RAISE_APPLICATION_ERROR(-20102,
                'Gemini HTTP request failed: '||SQLERRM);
    END send_gemini_http_request;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- PARSE GEMINI RESPONSE
    ----------------------------------------------------------------------------
    FUNCTION parse_gemini_response(
        p_raw_json IN CLOB,
        p_model_id IN VARCHAR2
    ) RETURN llm_types.t_llm_response IS
        vcaller constant varchar2(70):= c_package_name ||'.parse_gemini_response'; 
        v_resp llm_types.t_llm_response;

        v_json      JSON_OBJECT_T;
        v_candidate JSON_OBJECT_T;
        v_content   JSON_OBJECT_T;
        v_parts     JSON_ARRAY_T;
        v_part0     JSON_OBJECT_T;

        v_usage JSON_OBJECT_T;

    BEGIN
        v_json := JSON_OBJECT_T.parse(p_raw_json);

        ----------------------------------------------------------------------
        -- Extract candidate
        ----------------------------------------------------------------------
        IF v_json.has('candidates') THEN
            DECLARE
                v_arr JSON_ARRAY_T := v_json.get_Array('candidates');
            BEGIN
                IF v_arr.get_size > 0 THEN
                    v_candidate := JSON_OBJECT_T(v_arr.get(0));
                END IF;
            END;
        END IF;

        ----------------------------------------------------------------------
        -- finishReason
        ----------------------------------------------------------------------
        IF v_candidate IS NOT NULL THEN
            IF v_candidate.has('finishReason') THEN
                v_resp.finish_reason := v_candidate.get_String('finishReason');
                v_resp.is_truncated := (v_resp.finish_reason='MAX_TOKENS');
                v_resp.is_blocked   := (v_resp.finish_reason='SAFETY');
            END IF;

            IF v_candidate.has('safetyRatings') THEN
                v_resp.safety_ratings := v_candidate.get_Array('safetyRatings');
            END IF;

            ------------------------------------------------------------------
            -- Extract text
            ------------------------------------------------------------------
            IF v_candidate.has('content') THEN
                v_content := JSON_OBJECT_T(v_candidate.get('content'));

                IF v_content.has('parts') THEN
                    v_parts := v_content.get_Array('parts');

                    IF v_parts.get_size > 0 THEN
                        v_part0 := JSON_OBJECT_T(v_parts.get(0));

                        IF v_part0.has('text') THEN
                            v_resp.response_text :=
                                v_part0.get_String('text');
                        END IF;
                    END IF;
                END IF;
            END IF;
        END IF;

        ----------------------------------------------------------------------
        -- Token usage
        ----------------------------------------------------------------------
        IF v_json.has('usageMetadata') THEN
            v_usage := JSON_OBJECT_T(v_json.get('usageMetadata'));

            v_resp.tokens_input  := json_get_number(v_usage,'promptTokenCount');
            v_resp.tokens_output := json_get_number(v_usage,'candidatesTokenCount');
            v_resp.tokens_total  := json_get_number(v_usage,'totalTokenCount');
        END IF;

        ----------------------------------------------------------------------
        -- Meta
        ----------------------------------------------------------------------
        v_resp.provider_used := 'GEMINI';
        v_resp.model_used    := p_model_id;

        v_resp.success :=
            (v_resp.response_text IS NOT NULL)
            AND NOT v_resp.is_blocked;

        v_resp.payload := p_raw_json;

        RETURN v_resp;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error(sqlerrm,vcaller);  
            v_resp.success := FALSE;
            v_resp.msg := 'Parse error: '||SQLERRM;
            RETURN v_resp;
    END parse_gemini_response;

/*******************************************************************************
 *  
 *******************************************************************************/
    -------------------- 
    -- MAIN UNIFIED CALL
    -------------------- 
    FUNCTION invoke_llm(  p_req IN llm_types.t_llm_request )
       RETURN llm_types.t_llm_response IS
        vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
        v_cfg        llm_provider_models%ROWTYPE;
        v_api_key    VARCHAR2(4000);
        v_payload    CLOB;
        v_raw_resp   CLOB;
        v_resp       llm_types.t_llm_response;

        v_start      TIMESTAMP := SYSTIMESTAMP;
        v_elapsed_ms NUMBER;
        v_msg   VARCHAR2(4000);
    BEGIN
        v_cfg := load_model_config(p_req.model);
        v_api_key := LLM_MODEL_UTIL.load_api_key(v_cfg);
        v_payload := build_gemini_payload(p_req, v_cfg);
        v_raw_resp := send_gemini_http_request(v_cfg, v_api_key, v_payload);
        v_resp := parse_gemini_response(v_raw_resp, p_req.model);

        v_resp.cost_usd :=
            calculate_costs(v_resp.tokens_input,
                            v_resp.tokens_output,
                            p_req.model);

        -- timing
        v_elapsed_ms :=
            EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;

        v_resp.processing_ms := v_elapsed_ms;
        v_resp.created_timestamp :=
            (EXTRACT(DAY    FROM (SYSTIMESTAMP - DATE '1970-01-01'))*86400*1000)
          + (EXTRACT(SECOND FROM SYSTIMESTAMP)*1000);

        v_resp.submitted_user_prompt := p_req.user_prompt;
        v_resp.processing_status :=
            CASE WHEN v_resp.success THEN 'SUCCESS' ELSE 'ERROR' END;




            -- Unified logging for EXACT ONE case
            ----------------------------------------------------------------------
            IF v_resp.finish_reason = 'SAFETY' THEN

               v_resp.success := FALSE;
                -- Case 1: Safety blocked
                v_msg := 'LLM >>ERROR :Gemini blocked output due to safety reasons' ;
                 debug_util.info(v_msg ,vcaller);
            ELSIF v_resp.finish_reason = 'MAX_TOKENS' THEN

                -- Case 2: Output truncated
                  v_msg :=  'LLM >>WARNING :Gemini output truncated due to token limit' ;
                 debug_util.info(v_msg ,vcaller);
            ELSE
                -- Case 3: Normal success
                  v_msg :=  'LLM >>INFO :Gemini call successful' ;
                 debug_util.info(v_msg ,vcaller);
            END IF;

        RETURN v_resp;

    EXCEPTION WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        v_resp.success := FALSE;
        v_resp.msg := SQLERRM;
        v_resp.processing_status := 'ERROR';
        RETURN v_resp;
    END  invoke_llm;
 /*******************************************************************************
 *  
 *******************************************************************************/
/* ============================================================================
   OPENAI STREAMING IMPLEMENTATION (SSE)
   Uses llm_stream_callback_bridge for per-token callbacks
   ============================================================================ */
PROCEDURE invoke_llm_stream(
    p_req      IN llm_types.t_llm_request,
    p_trace_id IN VARCHAR2
)
IS
   vcaller constant varchar2(70):= c_package_name ||'.invoke_llm_stream'; 
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
    v_llm_Model_Info_Req LLM_MODEL_UTIL.t_llm_Model_Info_Req;
BEGIN
    ----------------------------------------------------------------------
    -- 1) Load config and API key
    ----------------------------------------------------------------------
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
            WHEN OTHERS THEN 
               debug_util.error(sqlerrm,vcaller);  
            v_delta := NULL;
        END;

        IF v_delta IS NOT NULL THEN
            v_final := v_final || v_delta;

            -- 🔥 FIRE CALLBACK
            llm_stream_adapter_util.on_token(v_delta);
        END IF;

    END LOOP;

    ----------------------------------------------------------------------
    -- 4) FINAL CALLBACK
    ----------------------------------------------------------------------
    llm_stream_adapter_util.on_end(v_final);

    UTL_HTTP.end_response(v_resp);

EXCEPTION
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        llm_stream_adapter_util.on_end('[OPENAI STREAM ERROR] '||SQLERRM);
        BEGIN
            UTL_HTTP.end_response(v_resp);
        EXCEPTION WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
         NULL;
        END;
END invoke_llm_stream;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_gemini_pkg;

/
