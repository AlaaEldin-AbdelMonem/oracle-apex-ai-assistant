--------------------------------------------------------
--  DDL for Package Body LLM_ANTHROPIC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_ANTHROPIC_PKG" AS

/*=============================================================================
  Anthropic Provider Adapter (Claude 3.x)
  Clean unified structure using ai_llm_types.t_llm_request / t_llm_response
=============================================================================*/

c_buffer_size CONSTANT PLS_INTEGER := 32767;
c_anthropic_version CONSTANT VARCHAR2(50) := '2023-06-01';

 /*******************************************************************************
 *  
 *******************************************************************************/
/*------------------------------------------------------------------------------
  Load model configuration
------------------------------------------------------------------------------*/
FUNCTION load_model_config(p_model VARCHAR2)
RETURN llm_provider_models%ROWTYPE
IS 
    vcaller constant varchar2(70):= c_package_name ||'.load_model_config'; 
    v_cfg llm_provider_models%ROWTYPE;
BEGIN
    SELECT *
      INTO v_cfg
      FROM llm_provider_models
     WHERE UPPER(provider_model_id) = UPPER(p_model)
       AND provider_code       = 'ANTHROPIC'
       AND is_active           = 'Y'
       AND is_production_ready = 'Y'
       AND ROWNUM = 1;

    RETURN v_cfg;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
       debug_util.error(sqlerrm,vcaller);  
        RAISE_APPLICATION_ERROR(-21001,
            'Anthropic model "'||p_model||'" not found in CFG_MODEL_ENDPOINTS.');
END load_model_config;

/*******************************************************************************
 *  
 *******************************************************************************/
/*------------------------------------------------------------------------------
  Build JSON Payload (Claude 3.x Messages API)
------------------------------------------------------------------------------*/
FUNCTION build_payload(
    p_req llm_types.t_llm_request,
    p_cfg llm_provider_models%ROWTYPE
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.build_payload'; 
    v_root       JSON_OBJECT_T := JSON_OBJECT_T();
    v_messages   JSON_ARRAY_T  := JSON_ARRAY_T();
    v_user_msg   JSON_OBJECT_T := JSON_OBJECT_T();
    v_stop_arr   JSON_ARRAY_T;
BEGIN
    v_root.put('model', p_cfg.model_code);

    -- User message
    v_user_msg.put('role', 'user');
    v_user_msg.put('content', p_req.user_prompt);
    v_messages.append(v_user_msg);

    v_root.put('messages', v_messages);

    -- Optional parameters
    IF p_req.max_tokens IS NOT NULL THEN
        v_root.put('max_tokens', p_req.max_tokens);
    END IF;

    IF p_req.temperature IS NOT NULL THEN
        v_root.put('temperature', p_req.temperature);
    END IF;

    IF p_req.top_p IS NOT NULL THEN
        v_root.put('top_p', p_req.top_p);
    END IF;

    IF p_req.top_k IS NOT NULL THEN
        v_root.put('top_k', p_req.top_k);
    END IF;

    -- Stop sequences
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

            v_root.put('stop_sequences', v_stop_arr);
        END;
    END IF;

    -- JSON schema output

    IF p_req.response_schema IS NOT NULL THEN
    DECLARE
        v_schema_obj JSON_OBJECT_T := JSON_OBJECT_T();
    BEGIN
        v_schema_obj.put('type', 'json_schema');
        v_schema_obj.put('json_schema', JSON_OBJECT_T.parse(p_req.response_schema));
        v_root.put('response_format', v_schema_obj);
    END;

END IF;

    RETURN v_root.to_clob();
END build_payload;
/*******************************************************************************
 *  
 *******************************************************************************/
/*------------------------------------------------------------------------------
  Send HTTP Request to Anthropic
------------------------------------------------------------------------------*/
FUNCTION send_http(
    p_cfg     llm_provider_models%ROWTYPE,
    p_api_key VARCHAR2,
    p_payload CLOB
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.send_http'; 
    v_req   UTL_HTTP.req;
    v_resp  UTL_HTTP.resp;
    v_out   CLOB;
    v_buffer VARCHAR2(32767);
    v_url    VARCHAR2(4000);
BEGIN
    v_url := p_cfg.api_base_url || p_cfg.api_endpoint_path;

    v_req := UTL_HTTP.begin_request(v_url, 'POST', 'HTTP/1.1');
    UTL_HTTP.set_header(v_req,'Content-Type','application/json');
    UTL_HTTP.set_header(v_req,'x-api-key', p_api_key);
    UTL_HTTP.set_header(v_req,'anthropic-version', c_anthropic_version);

    UTL_HTTP.write_text(v_req, p_payload);

    v_resp := UTL_HTTP.get_response(v_req);
    DBMS_LOB.createtemporary(v_out, TRUE);

    BEGIN
        LOOP
            UTL_HTTP.read_text(v_resp, v_buffer, c_buffer_size);
            DBMS_LOB.writeappend(v_out, LENGTH(v_buffer), v_buffer);
        END LOOP;
    EXCEPTION WHEN UTL_HTTP.end_of_body THEN NULL;
    END;

    UTL_HTTP.end_response(v_resp);
    RETURN v_out;

EXCEPTION
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        UTL_HTTP.end_response(v_resp);
        RAISE;
END send_http;
/*******************************************************************************
 *  
 *******************************************************************************/
/*------------------------------------------------------------------------------
  Parse Claude Response → t_llm_response
------------------------------------------------------------------------------*/
FUNCTION parse_claude_response(
    p_raw   CLOB,
    p_model VARCHAR2
) RETURN llm_types.t_llm_response
IS  vcaller constant varchar2(70):= c_package_name ||'.parse_claude_response'; 
    v_json   JSON_OBJECT_T;
    v_res    llm_types.t_llm_response;
    v_usage  JSON_OBJECT_T;
    v_cnt    JSON_ARRAY_T;
    v_block  JSON_OBJECT_T;
BEGIN
    v_json := JSON_OBJECT_T.parse(p_raw);

    v_res.success      := TRUE;
    v_res.provider_used := 'ANTHROPIC';
    v_res.model_used   := p_model;
    v_res.payload      := p_raw;

    -- Extract request_id
    IF v_json.has('id') THEN
        v_res.request_id := v_json.get_string('id');
    END IF;

    -- Extract content
    IF v_json.has('content') THEN
        v_cnt := JSON_ARRAY_T(v_json.get('content'));
        IF v_cnt.get_size() > 0 THEN
            v_block := JSON_OBJECT_T(v_cnt.get(0));
            IF v_block.has('text') THEN
                v_res.response_text := v_block.get_string('text');
            END IF;
        END IF;
    END IF;

    -- Extract usage (tokens)
    IF v_json.has('usage') THEN
        v_usage := JSON_OBJECT_T(v_json.get('usage'));

        v_res.tokens_input  := v_usage.get_number('tokens_input');
        v_res.tokens_output  := v_usage.get_number('tokens_output');
        v_res.tokens_total  := 
            NVL(v_usage.get_number('tokens_input'),0) +
            NVL(v_usage.get_number('tokens_output'),0);
    END IF;

    -- Stop reason
    IF v_json.has('stop_reason') THEN
        v_res.finish_reason := v_json.get_string('stop_reason');
        v_res.is_truncated :=
            (v_res.finish_reason = 'max_tokens');
    END IF;

    RETURN v_res;

EXCEPTION WHEN OTHERS THEN
   debug_util.error(sqlerrm,vcaller);  
    v_res.success := FALSE;
    v_res.msg := SQLERRM;
    RETURN v_res;
END parse_claude_response;
/*******************************************************************************
 *  
 *******************************************************************************/
/*------------------------------------------------------------------------------
  PUBLIC ENTRYPOINT: call_claude
------------------------------------------------------------------------------*/
FUNCTION invoke_llm(
    p_req llm_types.t_llm_request
) RETURN llm_types.t_llm_response
IS  
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_cfg      llm_provider_models%ROWTYPE;
    v_key      VARCHAR2(4000);
    v_payload  CLOB;
    v_raw      CLOB;
    v_res      llm_types.t_llm_response;
    v_start    TIMESTAMP := SYSTIMESTAMP;
    v_event   VARCHAR2(32000);
BEGIN
    -- Load model config + API key
    v_cfg := load_model_config(p_req.model);
    v_key := LLM_MODEL_UTIL.load_api_key(v_cfg);

    -- Build payload
    v_payload := build_payload(p_req, v_cfg);

    -- HTTP request
    v_raw := send_http(v_cfg, v_key, v_payload);

    -- Parse JSON
    v_res := parse_claude_response(v_raw, p_req.model);

    -- Cost calculation
    BEGIN
        SELECT (v_res.tokens_input  /1000) * cost_per_1k_input_tokens +
               (v_res.tokens_output /1000) * cost_per_1k_output_tokens
          INTO v_res.cost_usd
          FROM llm_provider_models
         WHERE model_code   = p_req.model
           AND provider_code  = 'ANTHROPIC'
           AND ROWNUM = 1;
    EXCEPTION WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        v_res.cost_usd := 0;
    END;

    -- Latency
    v_res.processing_ms :=
        EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;

   
   
    -- Logging
    v_event := 'ANTHROPIC>' || CASE WHEN v_res.success THEN 'INFO' ELSE 'ERROR' END  
       ||  ' '
       ||CASE WHEN v_res.success   THEN 'Claude call successful'
               ELSE 'Claude call failed' END ;
    debug_util.info(v_event ,vcaller);
    RETURN v_res;

EXCEPTION WHEN OTHERS THEN
    debug_util.error(sqlerrm,vcaller);  
    v_res.success := FALSE;
    v_res.msg := SQLERRM;
    v_res.processing_ms :=  EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;
    v_event :=SQLERRM ;
 
   
    RETURN v_res;
END invoke_llm;
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
BEGIN
    ----------------------------------------------------------------------
    -- 1) Load config and API key
    ----------------------------------------------------------------------
    v_cfg     :=  load_model_config(p_req.model);
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
END llm_anthropic_pkg;

/
