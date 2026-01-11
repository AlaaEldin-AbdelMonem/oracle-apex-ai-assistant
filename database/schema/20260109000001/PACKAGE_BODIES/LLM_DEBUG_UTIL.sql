--------------------------------------------------------
--  DDL for Package Body LLM_DEBUG_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "LLM_DEBUG_UTIL" AS
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- Helper function: Escape JSON string values
------------------------------------------------------------------------------
FUNCTION json_escape(p_str IN CLOB) RETURN CLOB IS
   vcaller constant varchar2(70):= c_package_name ||'.json_escape'; 
    v_result CLOB;
BEGIN
    IF p_str IS NULL THEN
        RETURN 'null';
    END IF;

    v_result := REPLACE(p_str, '\', '\\');
    v_result := REPLACE(v_result, '"', '\"');
    v_result := REPLACE(v_result, CHR(10), '\n');
    v_result := REPLACE(v_result, CHR(13), '\r');
    v_result := REPLACE(v_result, CHR(9), '\t');

    RETURN '"' || v_result || '"';
END json_escape;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- Helper function: Convert number to JSON
------------------------------------------------------------------------------
FUNCTION json_number(p_num IN NUMBER) RETURN VARCHAR2 IS
   vcaller constant varchar2(70):= c_package_name ||'.json_number'; 
BEGIN
    RETURN CASE WHEN p_num IS NULL THEN 'null' ELSE TO_CHAR(p_num) END;
END json_number;
/*******************************************************************************
 *  
 *******************************************************************************/
------------------------------------------------------------------------------
-- Helper function: Convert boolean to JSON
------------------------------------------------------------------------------
FUNCTION json_boolean(p_bool IN BOOLEAN) RETURN VARCHAR2 IS
  vcaller constant varchar2(70):= c_package_name ||'.json_boolean'; 
BEGIN
    RETURN CASE WHEN p_bool THEN 'true' ELSE 'false' END;
END json_boolean;
/*******************************************************************************
 *  
 *******************************************************************************/
PROCEDURE log_request(
    p_req      IN llm_types.t_llm_request,
    p_trace_id IN VARCHAR2 DEFAULT NULL
) IS
   vcaller constant varchar2(70):= c_package_name ||'.log_request'; 
    v_json CLOB;
BEGIN
    -- Only log at DEBUG level for LLM payloads
    IF NOT debug_util.is_on(debug_util.c_debug) THEN
        RETURN;
    END IF;

    -- Build JSON manually to avoid size limits
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);

    DBMS_LOB.APPEND(v_json, '{');
    DBMS_LOB.APPEND(v_json, '"provider":' || json_escape(p_req.provider) || ',');
    DBMS_LOB.APPEND(v_json, '"model":' || json_escape(p_req.model) || ',');
    DBMS_LOB.APPEND(v_json, '"context_domain_id":' || json_number(p_req.context_domain_id) || ',');
    DBMS_LOB.APPEND(v_json, '"temperature":' || json_number(p_req.temperature) || ',');
    DBMS_LOB.APPEND(v_json, '"max_tokens":' || json_number(p_req.max_tokens) || ',');
    DBMS_LOB.APPEND(v_json, '"top_p":' || json_number(p_req.top_p) || ',');
    DBMS_LOB.APPEND(v_json, '"top_k":' || json_number(p_req.top_k) || ',');
    DBMS_LOB.APPEND(v_json, '"seed":' || json_number(p_req.seed) || ',');
    DBMS_LOB.APPEND(v_json, '"response_format":' || json_escape(p_req.response_format) || ',');
    DBMS_LOB.APPEND(v_json, '"project_id":' || json_number(p_req.project_id) || ',');
    DBMS_LOB.APPEND(v_json, '"project_title":' || json_escape(p_req.project_title) || ',');
    DBMS_LOB.APPEND(v_json, '"session_title":' || json_escape(p_req.session_title) || ',');
    DBMS_LOB.APPEND(v_json, '"user_id":' || json_number(p_req.user_id) || ',');
    DBMS_LOB.APPEND(v_json, '"user_name":' || json_escape(p_req.user_name) || ',');
    DBMS_LOB.APPEND(v_json, '"chat_session_id":' || json_number(p_req.chat_session_id) || ',');
    DBMS_LOB.APPEND(v_json, '"app_session_id":' || json_number(p_req.app_session_id) || ',');
    DBMS_LOB.APPEND(v_json, '"app_page_id":' || json_number(p_req.app_page_id) || ',');
    DBMS_LOB.APPEND(v_json, '"app_id":' || json_number(p_req.app_id) || ',');
    DBMS_LOB.APPEND(v_json, '"tenant_id":' || json_number(p_req.tenant_id) || ',');

    -- Handle large CLOB fields
    DBMS_LOB.APPEND(v_json, '"user_prompt":' || json_escape(p_req.user_prompt) || ',');
    DBMS_LOB.APPEND(v_json, '"system_instructions":' || json_escape(p_req.system_instructions) || ',');
    DBMS_LOB.APPEND(v_json, '"conversation_history":' || json_escape(p_req.conversation_history) || ',');
    DBMS_LOB.APPEND(v_json, '"response_schema":' || json_escape(p_req.response_schema) || ',');
    DBMS_LOB.APPEND(v_json, '"payload":' || json_escape(p_req.payload));

    DBMS_LOB.APPEND(v_json, '}');

    debug_util.log(
        p_level       => debug_util.c_debug,
        p_message     => 'LLM REQUEST ' || p_req.model,
        p_extra_data  => v_json,
        p_caller => 'LLM_ENGINE.call_llm',
        p_trace_id    => p_trace_id
    );

    DBMS_LOB.FREETEMPORARY(v_json);
END log_request;
/*******************************************************************************
 *  
 *******************************************************************************/
PROCEDURE log_response(
    p_res      IN llm_types.t_llm_response,
    p_trace_id IN VARCHAR2 DEFAULT NULL
) IS
    vcaller constant varchar2(70):= c_package_name ||'.log_response'; 
    v_json CLOB;
BEGIN
    IF NOT debug_util.is_on(debug_util.c_debug) THEN
        RETURN;
    END IF;

    -- Build JSON manually to avoid size limits
    DBMS_LOB.CREATETEMPORARY(v_json, TRUE);

    DBMS_LOB.APPEND(v_json, '{');
    DBMS_LOB.APPEND(v_json, '"success":' || json_boolean(p_res.success) || ',');
    DBMS_LOB.APPEND(v_json, '"provider_used":' || json_escape(p_res.provider_used) || ',');
    DBMS_LOB.APPEND(v_json, '"model_used":' || json_escape(p_res.model_used) || ',');
    DBMS_LOB.APPEND(v_json, '"tokens_input":' || json_number(p_res.tokens_input) || ',');
    DBMS_LOB.APPEND(v_json, '"tokens_output":' || json_number(p_res.tokens_output) || ',');
    DBMS_LOB.APPEND(v_json, '"tokens_total":' || json_number(p_res.tokens_total) || ',');
    DBMS_LOB.APPEND(v_json, '"cost_usd":' || json_number(p_res.cost_usd) || ',');
    DBMS_LOB.APPEND(v_json, '"processing_status":' || json_escape(p_res.processing_status) || ',');
    DBMS_LOB.APPEND(v_json, '"request_id":' || json_escape(p_res.request_id) || ',');
    DBMS_LOB.APPEND(v_json, '"finish_reason":' || json_escape(p_res.finish_reason) || ',');
    DBMS_LOB.APPEND(v_json, '"is_blocked":' || json_boolean(p_res.is_blocked) || ',');
    DBMS_LOB.APPEND(v_json, '"is_refusal":' || json_boolean(p_res.is_refusal) || ',');
    DBMS_LOB.APPEND(v_json, '"msg":' || json_escape(p_res.msg) || ',');
    DBMS_LOB.APPEND(v_json, '"created_timestamp":' || json_number(p_res.created_timestamp) || ',');
    DBMS_LOB.APPEND(v_json, '"processing_ms":' || json_number(p_res.processing_ms) || ',');

    -- Handle large CLOB fields
    DBMS_LOB.APPEND(v_json, '"submitted_user_prompt":' || json_escape(p_res.submitted_user_prompt) || ',');
    DBMS_LOB.APPEND(v_json, '"response_text":' || json_escape(p_res.response_text) || ',');
    DBMS_LOB.APPEND(v_json, '"rag_context":' || json_escape(p_res.rag_context) || ',');
    DBMS_LOB.APPEND(v_json, '"payload":' || json_escape(p_res.payload));

    DBMS_LOB.APPEND(v_json, '}');

    debug_util.log(
        p_level       => debug_util.c_debug,
        p_message     => 'LLM RESPONSE ' || NVL(p_res.model_used, 'UNKNOWN'),
        p_extra_data  => v_json,
        p_caller  => 'LLM_ENGINE.call_llm',
        p_trace_id    => p_trace_id
    );

    DBMS_LOB.FREETEMPORARY(v_json);
END log_response;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_debug_util;

/
