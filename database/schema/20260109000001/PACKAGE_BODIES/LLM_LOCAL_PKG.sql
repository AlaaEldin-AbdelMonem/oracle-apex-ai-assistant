--------------------------------------------------------
--  DDL for Package Body LLM_LOCAL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_LOCAL_PKG" AS

/*=============================================================================
 Local Provider Adapter (Unified Request/Response Version)
 Enterprise Production Grade — Minimal Runtime Noise
 Uses llm_types.t_llm_request and t_llm_response
 Native Ollama Mode Only
=============================================================================*/
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------------------------
c_buffer_size  CONSTANT PLS_INTEGER := 32767;
c_default_url  CONSTANT VARCHAR2(200) := 'http://localhost:11434';
c_endpoint     CONSTANT VARCHAR2(200) := '/api/generate';


 


PROCEDURE validate_request(p_req llm_types.t_llm_request) IS
  vcaller constant varchar2(70):= c_package_name ||'.validate_request'; 
BEGIN
    IF p_req.response_format IS NOT NULL THEN
        RAISE_APPLICATION_ERROR(
            -20301,
            'response_format is not supported by LOCAL/Ollama provider.'
        );
    END IF;

    IF p_req.response_schema IS NOT NULL THEN
       debug_util.error('response_schema is not supported by LOCAL/Ollama provider.',vcaller);  
        RAISE_APPLICATION_ERROR(
            -20302,
            'response_schema is not supported by LOCAL/Ollama provider.'
        );
    END IF;

    IF p_req.frequency_penalty IS NOT NULL THEN
     debug_util.error( 'frequency_penalty is not supported by LOCAL/Ollama provider.',vcaller);  
        RAISE_APPLICATION_ERROR(
            -20303,
            'frequency_penalty is not supported by LOCAL/Ollama provider.'
        );
    END IF;

    IF p_req.presence_penalty IS NOT NULL THEN
     debug_util.error( 'presence_penalty is not supported by LOCAL/Ollama provider.',vcaller);  
        RAISE_APPLICATION_ERROR(
            -20304,
            'presence_penalty is not supported by LOCAL/Ollama provider.'
        );
    END IF;

    IF p_req.seed IS NOT NULL THEN
         debug_util.error( 'seed is not supported by LOCAL/Ollama provider.',vcaller);  
        RAISE_APPLICATION_ERROR(
            -20305,
            'seed is not supported by LOCAL/Ollama provider.'
        );
    END IF;

    IF p_req.top_k IS NOT NULL THEN
      debug_util.error( 'top_k is not supported by LOCAL/Ollama provider.',vcaller);  
        RAISE_APPLICATION_ERROR(
            -20306,
            'top_k is not supported by LOCAL/Ollama provider.'
        );
    END IF;
END validate_request;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- INTERNAL: Build Unified Prompt (SYSTEM + HISTORY + USER)
------------------------------------------------------------------------------
FUNCTION build_full_prompt(p_req llm_types.t_llm_request)
RETURN CLOB IS
  vcaller constant varchar2(70):= c_package_name ||'.build_full_prompt'; 
    v_prompt CLOB;
BEGIN
    DBMS_LOB.CREATETEMPORARY(v_prompt, TRUE);

    IF p_req.system_instructions IS NOT NULL THEN
        DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH('<<SYSTEM>>'||CHR(10)),
                             '<<SYSTEM>>'||CHR(10));
        DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH(p_req.system_instructions||CHR(10)),
                             p_req.system_instructions||CHR(10));
    END IF;

    IF p_req.conversation_history IS NOT NULL THEN
        DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH(CHR(10)||'<<HISTORY>>'||CHR(10)),
                             CHR(10)||'<<HISTORY>>'||CHR(10));
        DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH(p_req.conversation_history||CHR(10)),
                             p_req.conversation_history||CHR(10));
    END IF;

    DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH(CHR(10)||'<<USER>>'||CHR(10)),
                         CHR(10)||'<<USER>>'||CHR(10));
    DBMS_LOB.WRITEAPPEND(v_prompt, LENGTH(p_req.user_prompt),
                         p_req.user_prompt);

    RETURN v_prompt;
END build_full_prompt;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- INTERNAL: Build Ollama Native Payload
------------------------------------------------------------------------------

FUNCTION build_payload( p_req llm_types.t_llm_request,
                        p_cfg llm_provider_models%ROWTYPE) return clob IS
     vcaller constant varchar2(70):= c_package_name ||'.build_payload'; 
    v_json    JSON_OBJECT_T := JSON_OBJECT_T();
    v_options JSON_OBJECT_T := JSON_OBJECT_T();
    v_arr     JSON_ARRAY_T;
    v_payload CLOB;
BEGIN
    -- Ollama native:
    v_json.put('model', p_req.model);
    v_json.put('prompt', p_req.user_prompt);
    v_json.put('stream', FALSE);

    -- Options
    v_options.put('temperature', NVL(p_req.temperature, 0.7));
    v_options.put('top_p', NVL(p_req.top_p, 1.0));
    v_options.put('num_predict', NVL(p_req.max_tokens, 2048));

    IF p_req.stop IS NOT NULL THEN
        v_arr := JSON_ARRAY_T();
        v_arr.append(p_req.stop);
        v_options.put('stop', v_arr);
    END IF;

    v_json.put('options', v_options);

    v_payload := v_json.to_clob;
    RETURN v_payload;
END build_payload;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- INTERNAL: Send HTTP Request to Ollama
------------------------------------------------------------------------------
FUNCTION send_http(
    p_payload CLOB,
    p_base_url VARCHAR2
) RETURN CLOB IS
    vcaller constant varchar2(70):= c_package_name ||'.send_http'; 
    v_req    UTL_HTTP.req;
    v_resp   UTL_HTTP.resp;
    v_chunk  VARCHAR2(32767);
    v_out    CLOB;
    v_url    VARCHAR2(500);
BEGIN
    v_url := p_base_url || c_endpoint;

    v_req := UTL_HTTP.begin_request(v_url, 'POST', 'HTTP/1.1');
    UTL_HTTP.set_header(v_req, 'Content-Type', 'application/json');

    UTL_HTTP.write_text(v_req, p_payload);
    v_resp := UTL_HTTP.get_response(v_req);

    DBMS_LOB.createtemporary(v_out, TRUE);

    BEGIN
        LOOP
            UTL_HTTP.read_text(v_resp, v_chunk, c_buffer_size);
            DBMS_LOB.writeappend(v_out, LENGTH(v_chunk), v_chunk);
        END LOOP;
    EXCEPTION WHEN UTL_HTTP.end_of_body THEN NULL;
    END;

    UTL_HTTP.end_response(v_resp);
    RETURN v_out;

EXCEPTION
    WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);  
        UTL_HTTP.end_response(v_resp);
        RAISE;
END send_http;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- INTERNAL: Parse Ollama Response → t_llm_response
------------------------------------------------------------------------------
FUNCTION parse_response(
    p_raw   CLOB,
    p_req   llm_types.t_llm_request
) RETURN llm_types.t_llm_response IS
    vcaller constant varchar2(70):= c_package_name ||'.parse_response'; 
    v_res         llm_types.t_llm_response;
    v_json        JSON_OBJECT_T;
BEGIN
    v_json := JSON_OBJECT_T.parse(p_raw);

    v_res.success := TRUE;
    v_res.provider_used := 'LOCAL';
    v_res.model_used := p_req.model;

    IF v_json.has('response') THEN
        v_res.response_text := v_json.get_string('response');
    END IF;

    -- Token usage mapping
    IF v_json.has('prompt_eval_count') THEN
        v_res.tokens_input := v_json.get_number('prompt_eval_count');
    END IF;

    IF v_json.has('eval_count') THEN
        v_res.tokens_output := v_json.get_number('eval_count');
    END IF;

    v_res.tokens_total :=
          NVL(v_res.tokens_input,0)
        + NVL(v_res.tokens_output,0);

    -- Cost always 0
    v_res.cost_usd := 0;

    -- Finish reason (Ollama has no direct field)
    v_res.finish_reason := 'stop';

    RETURN v_res;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.error( sqlerrm,vcaller);  
        v_res.success := FALSE;
        v_res.msg := SQLERRM;
        RETURN v_res;
END parse_response;
/*******************************************************************************
 *  
 *******************************************************************************/

------------------------------------------------------------------------------
-- PUBLIC ENTRYPOINT: Unified Local Provider Call

FUNCTION invoke_llm(
    p_req llm_types.t_llm_request
) RETURN llm_types.t_llm_response IS
    vcaller constant varchar2(70):= c_package_name ||'.invoke_llm'; 
    v_req       llm_types.t_llm_response;
    v_out       CLOB;
    v_payload   CLOB;
    v_prompt    CLOB;
    v_start     TIMESTAMP := SYSTIMESTAMP;
    v_base_url  VARCHAR2(500) := c_default_url;
    v_cfg llm_provider_models%ROWTYPE;
    v_llm_Model_Info_Req   LLM_MODEL_UTIL.t_llm_Model_Info_Req;

BEGIN
    ---------------------- 
    -- 1) Validate request

    validate_request(p_req);

    -------------------------- 
    -- 2) Build unified prompt

    v_prompt := build_full_prompt(p_req);

    ---------------------- 
    -- 3) Build payload


     v_llm_Model_Info_Req.provider :=p_req.provider ;
     v_llm_Model_Info_Req.model :=p_req.model ;
     v_llm_Model_Info_Req.tenant_id := p_req.tenant_id;
     v_cfg := LLM_MODEL_UTIL.load_model_config(v_llm_Model_Info_Req); 
    v_payload := build_payload(p_req,v_cfg);

    ------------------ 
    -- 4) Send request

    v_out := send_http(v_payload, v_base_url);

    ------------------- 
    -- 5) Parse response

    v_req := parse_response(v_out, p_req);

    ------------------- 
    -- 6) Add metadata

    v_req.processing_ms :=
        EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start)) * 1000;

   
    RETURN v_req;

EXCEPTION
    WHEN OTHERS THEN

        v_req.success := FALSE;
        v_req.msg := SQLERRM;
         debug_util.error(  v_req.msg ,vcaller);
        
        RETURN v_req;
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
            debug_util.error( sqlerrm,vcaller);  
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
       debug_util.error( sqlerrm,vcaller);  
        llm_stream_adapter_util.on_end('[OPENAI STREAM ERROR] '||SQLERRM);
        BEGIN
            UTL_HTTP.end_response(v_resp);
        EXCEPTION WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);  
         NULL;
        END;
END invoke_llm_stream;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_local_pkg;

/
