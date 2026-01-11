--------------------------------------------------------
--  DDL for Package Body CHAT_CALL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHAT_CALL_PKG" AS

   /*******************************************************************************
     *  
     *******************************************************************************/
    -- Validate role (USER, ASSISTANT, SYSTEM)
    FUNCTION valid_role(p_role VARCHAR2) RETURN BOOLEAN IS
      vcaller constant varchar2(70):= c_package_name ||'.valid_role';
    BEGIN
        RETURN UPPER(p_role) IN ('USER', 'ASSISTANT', 'SYSTEM');
    END valid_role;
    /*******************************************************************************
     *  
     *******************************************************************************/
    FUNCTION next_call_seq(p_chat_session_Id number) RETURN NUMBER IS
     vcaller constant varchar2(70):= c_package_name ||'.next_call_seq';
    l_max number:=0;
    BEGIN
        begin
         select max(CALL_SEQ)
         into l_max 
         from chat_calls where chat_session_Id= p_chat_session_Id;
         exception
         when others then null;
         end;
      return nvl(l_max,0) +1;
    END;
 /******************************************************************************
 *  
 *******************************************************************************/
    -- Convert BOOLEAN to CHAR(1) - MUST be in spec for SQL usage
    FUNCTION bool_to_char(p_bool BOOLEAN) RETURN CHAR DETERMINISTIC IS
        vcaller constant varchar2(70):= c_package_name ||'.bool_to_char';
    BEGIN
        RETURN CASE WHEN p_bool THEN 'Y' WHEN NOT p_bool THEN 'N' ELSE NULL END;
    END bool_to_char;
     /*******************************************************************************
     *  
     *******************************************************************************/
    -- Convert CHAR(1) to BOOLEAN - MUST be in spec for SQL usage
    FUNCTION char_to_bool(p_char CHAR) RETURN BOOLEAN DETERMINISTIC IS
      vcaller constant varchar2(70):= c_package_name ||'.char_to_bool';
    BEGIN
        RETURN CASE UPPER(p_char) WHEN 'Y' THEN TRUE WHEN 'N' THEN FALSE ELSE NULL END;
    END char_to_bool;
     /*******************************************************************************
     *  
     *******************************************************************************/

  Function New_traceid   return varchar2 is
   --  vcaller constant varchar2(70):= c_package_name ||'.New_traceid';
  begin
        return 'CALL-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
  end  New_traceid;
  /*******************************************************************************
  *  
 *******************************************************************************/
       -- ADD CALL (Primary Method using LLM_TYPES)
 
  Function New_ChatCall (p_chat_session_id in number, p_trace_id in varchar2) return number is
     vcaller constant varchar2(70):= c_package_name ||'.New_ChatCall';

    v_request    llm_types.t_llm_request;
    v_call_id  number;
    v_trace_id varchar2(200):= 'CALL-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
  begin
 
    v_request.chat_session_id:=p_chat_session_id ;
    v_request.trace_id:= nvl(p_trace_id,v_trace_id) ;

    v_call_id:= CHAT_CALL_PKG.add_call( p_request=> V_request, P_response => null);--create empty chatCall
     return v_call_id;
  
    Exception 
    when others then 
      debug_util.error(p_message=> sqlerrm, p_caller=> vcaller, p_trace_id => p_trace_id);
      return v_call_id;
    end New_ChatCall;
  /*******************************************************************************
   *  
   *******************************************************************************/

   FUNCTION add_call(
    p_request  IN llm_types.t_llm_request,
    p_response IN llm_types.t_llm_response DEFAULT NULL
        ) RETURN NUMBER
        IS
           vcaller constant varchar2(70):= c_package_name ||'.add_call';
            v_call_id     NUMBER;
            v_seq         NUMBER;
            v_chat_session_id  NUMBER;
            v_rec         chat_calls%ROWTYPE;  -- 
        BEGIN
            ------------------ 
            -- Extract session ID from request
            ------------------ 
            v_chat_session_id := p_request.chat_session_id;
            
            IF v_chat_session_id IS NULL THEN
                RAISE_APPLICATION_ERROR(-20001, 'Invalid chat session (chat_session_id is NULL)');
            END IF;

            ------------------ 
            -- Compute next sequence number
            ------------------ 
            v_seq := next_call_seq(v_chat_session_id);

            ------------------ 
            -- FILL RECORD - SESSION & SEQUENCE
            ------------------ 
            v_rec.call_id := CHAT_CALL_SEQ.NEXTVAL;
            v_rec.chat_session_id := v_chat_session_id;
            v_rec.call_seq        := v_seq;
            v_rec.source_channel  := 'UI';
            v_rec.db_created_at   := SYSTIMESTAMP;
            v_rec.is_deleted      := 'N';

            ------------------ 
            -- FILL RECORD - REQUEST FIELDS (from llm_types.t_llm_request)
            ------------------ 
            v_rec.provider               := p_request.provider;
            v_rec.model                  := p_request.model;
            v_rec.user_prompt            := p_request.user_prompt;
            v_rec.system_instructions    := p_request.system_instructions;
            v_rec.conversation_history   := p_request.conversation_history;
            v_rec.rag_context            := p_request.rag_context;
            v_rec.response_schema        := p_request.response_schema;
            v_rec.response_format        := p_request.response_format;
            v_rec.context_domain_id      := p_request.context_domain_id;
            v_rec.is_doc_inject_required := p_request.is_doc_inject_required;
            v_rec.is_data_inject_required:= p_request.is_data_inject_required;
            v_rec.rag_enabled            := p_request.rag_enabled;
            v_rec.rag_max_chunks         := p_request.rag_max_chunks;
            v_rec.rag_filter_mode        := p_request.rag_filter_mode;
            v_rec.governance_enabled     := p_request.governance_enabled;
            v_rec.temperature            := p_request.temperature;
            v_rec.max_tokens             := p_request.max_tokens;
            v_rec.top_p                  := p_request.top_p;
            v_rec.top_k                  := p_request.top_k;
            v_rec.seed                   := p_request.seed;
            v_rec.stop_seq               := p_request.stop;
            v_rec.frequency_penalty      := p_request.frequency_penalty;
            v_rec.presence_penalty       := p_request.presence_penalty;
            v_rec.message_id             := p_request.message_id;
            v_rec.preferred_provider     := p_request.preferred_provider;
            v_rec.preferred_model        := p_request.preferred_model;
            v_rec.allow_fallback         := p_request.allow_fallback;
            v_rec.stream_enabled         := bool_to_char(p_request.stream_enabled);
            v_rec.stream_channel         := p_request.stream_channel;
            v_rec.trace_id               := p_request.trace_id;
            v_rec.trace_parent_id        := p_request.trace_parent_id;
            v_rec.trace_step             := p_request.trace_step;
            v_rec.trace_msg              := p_request.msg;
            v_rec.request_payload        := p_request.payload;

            ------------------ 
            -- FILL RECORD - RESPONSE FIELDS (from llm_types.t_llm_response)
            ------------------ 
            IF p_response.response_text IS NOT NULL THEN
                v_rec.submitted_user_prompt   := p_response.submitted_user_prompt;
                v_rec.response_text           := p_response.response_text;
                v_rec.processing_status       := p_response.processing_status;
                v_rec.success                 := bool_to_char(p_response.success);
                v_rec.response_msg            := p_response.msg;
                v_rec.rag_context_doc_count   := p_response.rag_context_doc_count;
                v_rec.rag_sources_json        := p_response.rag_sources_json;
                v_rec.provider_final          := p_response.provider_final;
                v_rec.model_final             := p_response.model_final;
                v_rec.fallback_used           := p_response.fallback_used;
                v_rec.tokens_input            := p_response.tokens_input;
                v_rec.tokens_output           := p_response.tokens_output;
                v_rec.tokens_total            := p_response.tokens_total;
                v_rec.cost_usd                := p_response.cost_usd;
                v_rec.is_blocked              := bool_to_char(p_response.is_blocked);
                v_rec.safety_filter_applied   := p_response.safety_filter_applied;
                v_rec.safety_block_reason     := p_response.safety_block_reason;
                
                -- Convert JSON_ARRAY_T to CLOB
                BEGIN
                    IF p_response.safety_ratings IS NOT NULL THEN
                        v_rec.safety_ratings_json := p_response.safety_ratings.to_clob();
                    END IF;
                EXCEPTION WHEN OTHERS THEN
                    v_rec.safety_ratings_json := NULL;
                END;
                
                v_rec.is_refusal              := bool_to_char(p_response.is_refusal);
                v_rec.refusal_text            := p_response.refusal_text;
                v_rec.refusal_raw             := p_response.refusal_raw;
                v_rec.finish_reason           := p_response.finish_reason;
                v_rec.stop_reason             := p_response.stop_reason;
                v_rec.stop_seq_final          := p_response.stop_sequence;
                v_rec.is_truncated            := bool_to_char(p_response.is_truncated);
                v_rec.rag_ms                  := p_response.rag_ms;
                v_rec.governance_ms           := p_response.governance_ms;
                v_rec.prompt_build_ms         := p_response.prompt_build_ms;
                v_rec.client_llm_call_ms      := p_response.llm_call_ms;
                v_rec.total_pipeline_ms       := p_response.total_pipeline_ms;
                v_rec.governance_action       := p_response.governance_action;
                v_rec.governance_details      := p_response.governance_details;
                v_rec.final_system_prompt     := p_response.final_system_prompt;
                v_rec.final_user_prompt       := p_response.final_user_prompt;
                v_rec.tool_calls_json         := p_response.tool_calls_json;
                v_rec.parsed_struct_output    := p_response.parsed_structured_output;
                v_rec.request_id              := p_response.request_id;
                v_rec.system_fingerprint      := p_response.system_fingerprint;
                v_rec.provider_created_ts     := p_response.created_timestamp;
                v_rec.provider_processing_ms  := p_response.processing_ms;
                v_rec.response_payload        := p_response.payload;
            END IF;

            ---------------- 
            -- INSERT RECORD (single line!)
         
            INSERT INTO chat_calls VALUES v_rec
            RETURNING call_id INTO v_call_id;

            ------------- 
            -- Update session statistics
            -------------- 
           -- chat_stats_pkg.refresh_totals(v_chat_session_id);

            COMMIT;
            RETURN v_call_id;

        EXCEPTION
            WHEN OTHERS THEN
                ROLLBACK;
                debug_util.error('add_call>' ||SQLERRM, vcaller,v_chat_session_id);
                RAISE;
        END add_call;
     /*******************************************************************************
     *  -- UPDATE CALL RESPONSE 
     *******************************************************************************/

      PROCEDURE update_call_response(
        p_call_id  IN NUMBER,
        p_trace_id IN Varchar2,
        p_user_prompt IN clob,
        p_response IN clob,
        p_status   IN varchar2 )
     is 
     vcaller constant varchar2(70):= c_package_name ||'.update_call_response';
     v_msg varchar2(4000);
    begin
        v_msg :='<p_call_id>'||p_call_id||', <user_prompt>'||  DBMS_LOB.SUBSTR(p_user_prompt, 1000, 1)|| ',<response>' ||DBMS_LOB.SUBSTR(p_response, 1000, 1);
        debug_util.info(v_msg, vcaller,p_trace_id);

        UPDATE chat_calls
        SET response_text=p_response   , user_prompt = p_user_prompt  ,success='N'
        where call_id = p_call_id;
      commit;
       debug_util.info('Call Updated with final status', vcaller,p_trace_id);

    end update_call_response;

        /*******************************************************************************
     *  -- UPDATE CALL RESPONSE 
     *******************************************************************************/

    PROCEDURE update_call_response(
        p_call_id  IN NUMBER,
        p_response IN llm_types.t_llm_response
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.update_call_response';
        v_safety_json CLOB;
        v_session_id  NUMBER;
        v_success_char CHAR(1);
        v_blocked_char CHAR(1);
        v_refusal_char CHAR(1);
        v_truncated_char CHAR(1);
    BEGIN
        ------------------ 
        -- Convert BOOLEAN to CHAR(1)
        ------------------ 
        v_success_char := bool_to_char(p_response.success);
        v_blocked_char := bool_to_char(p_response.is_blocked);
        v_refusal_char := bool_to_char(p_response.is_refusal);
        v_truncated_char := bool_to_char(p_response.is_truncated);

        ------------------ 
        -- Convert safety_ratings JSON_ARRAY_T to CLOB if present
        ------------------ 
        BEGIN
            IF p_response.safety_ratings IS NOT NULL THEN
                v_safety_json := p_response.safety_ratings.to_clob();
            END IF;
        EXCEPTION WHEN OTHERS THEN
            v_safety_json := NULL;
        END;

        ------------------ 
        -- Update response fields
        ------------------ 
        UPDATE chat_calls
        SET
            submitted_user_prompt   = p_response.submitted_user_prompt,
            response_text           = p_response.response_text,
            processing_status       = p_response.processing_status,
            success                 = v_success_char,
            response_msg            = p_response.msg,
            rag_context             = COALESCE(p_response.rag_context, rag_context),
            rag_context_doc_count   = p_response.rag_context_doc_count,
            rag_sources_json        = p_response.rag_sources_json,
            provider_final          = p_response.provider_final,
            model_final             = p_response.model_final,
            fallback_used           = p_response.fallback_used,
            tokens_input            = p_response.tokens_input,
            tokens_output           = p_response.tokens_output,
            tokens_total            = p_response.tokens_total,
            cost_usd                = p_response.cost_usd,
            is_blocked              = v_blocked_char,
            safety_filter_applied   = p_response.safety_filter_applied,
            safety_block_reason     = p_response.safety_block_reason,
            safety_ratings_json     = v_safety_json,
            is_refusal              = v_refusal_char,
            refusal_text            = p_response.refusal_text,
            refusal_raw             = p_response.refusal_raw,
            finish_reason           = p_response.finish_reason,
            stop_reason             = p_response.stop_reason,
            stop_seq_final          = p_response.stop_sequence,
            is_truncated            = v_truncated_char,
            rag_ms                  = p_response.rag_ms,
            governance_ms           = p_response.governance_ms,
            prompt_build_ms         = p_response.prompt_build_ms,
            client_llm_call_ms      = p_response.llm_call_ms,
            total_pipeline_ms       = p_response.total_pipeline_ms,
            governance_action       = p_response.governance_action,
            governance_details      = p_response.governance_details,
            final_system_prompt     = p_response.final_system_prompt,
            final_user_prompt       = p_response.final_user_prompt,
            tool_calls_json         = p_response.tool_calls_json,
            parsed_struct_output    = p_response.parsed_structured_output,
            request_id              = p_response.request_id,
            system_fingerprint      = p_response.system_fingerprint,
            provider_created_ts     = p_response.created_timestamp,
            provider_processing_ms  = p_response.processing_ms,
            response_payload        = p_response.payload,
            updated_at              = SYSTIMESTAMP
        WHERE call_id = p_call_id
        RETURNING chat_session_id INTO v_session_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Call not found: ' || p_call_id);
        END IF;

        ------------------ 
        -- Update session statistics
        ------------------ 
       -- chat_stats_pkg.refresh_totals(v_session_id);

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            debug_util.error('update_call_response' ||SQLERRM, vcaller);
            RAISE;
    END update_call_response;
     /*******************************************************************************
     *  
     *******************************************************************************/
    -- GET CALL REQUEST
    FUNCTION get_call_request(p_call_id IN NUMBER)
    RETURN llm_types.t_llm_request
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_call_request';
        v_req llm_types.t_llm_request;
        v_stream_char CHAR(1);
    BEGIN
        SELECT 
            message_id,
            provider,
            model,
            user_prompt,
            system_instructions,
            conversation_history,
            rag_context,
            response_schema,
            response_format,
            context_domain_id,
            is_doc_inject_required,
            is_data_inject_required,
            rag_enabled,
            rag_max_chunks,
            rag_filter_mode,
            governance_enabled,
            temperature,
            max_tokens,
            top_p,
            top_k,
            seed,
            stop_seq,
            frequency_penalty,
            presence_penalty,
            preferred_provider,
            preferred_model,
            allow_fallback,
            stream_enabled,
            stream_channel,
            trace_id,
            trace_parent_id,
            trace_step,
            trace_msg,
            chat_session_id,
            request_payload
        INTO 
            v_req.message_id,
            v_req.provider,
            v_req.model,
            v_req.user_prompt,
            v_req.system_instructions,
            v_req.conversation_history,
            v_req.rag_context,
            v_req.response_schema,
            v_req.response_format,
            v_req.context_domain_id,
            v_req.is_doc_inject_required,
            v_req.is_data_inject_required,
            v_req.rag_enabled,
            v_req.rag_max_chunks,
            v_req.rag_filter_mode,
            v_req.governance_enabled,
            v_req.temperature,
            v_req.max_tokens,
            v_req.top_p,
            v_req.top_k,
            v_req.seed,
            v_req.stop,
            v_req.frequency_penalty,
            v_req.presence_penalty,
            v_req.preferred_provider,
            v_req.preferred_model,
            v_req.allow_fallback,
            v_stream_char,
            v_req.stream_channel,
            v_req.trace_id,
            v_req.trace_parent_id,
            v_req.trace_step,
            v_req.msg,
            v_req.chat_session_id,
            v_req.payload
        FROM chat_calls
        WHERE call_id = p_call_id;

        -- Convert CHAR to BOOLEAN
        v_req.stream_enabled := char_to_bool(v_stream_char);

        RETURN v_req;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
          debug_util.error(  SQLERRM ,vcaller);
         RETURN NULL;
        WHEN OTHERS THEN
              debug_util.error(  SQLERRM ,vcaller);
            RAISE;
    END get_call_request;
     /*******************************************************************************
     *  
     *******************************************************************************/
     -- GET CALL RESPONSE
    ------------------ ------
    FUNCTION get_call_response(p_call_id IN NUMBER)
    RETURN llm_types.t_llm_response
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_call_response';
        v_resp llm_types.t_llm_response;
        v_success CHAR(1);
        v_blocked CHAR(1);
        v_refusal CHAR(1);
        v_truncated CHAR(1);
    BEGIN
        SELECT 
            message_id,
            submitted_user_prompt,
            response_text,
            success,
            processing_status,
            response_msg,
            rag_context,
            rag_context_doc_count,
            rag_sources_json,
            provider,
            model,
            provider_final,
            model_final,
            fallback_used,
            tokens_input,
            tokens_output,
            tokens_total,
            cost_usd,
            is_blocked,
            safety_filter_applied,
            safety_block_reason,
            is_refusal,
            refusal_text,
            refusal_raw,
            finish_reason,
            stop_reason,
            stop_seq_final,
            is_truncated,
            rag_ms,
            governance_ms,
            prompt_build_ms,
            client_llm_call_ms,
            total_pipeline_ms,
            governance_action,
            governance_details,
            final_system_prompt,
            final_user_prompt,
            tool_calls_json,
            parsed_struct_output,
            request_id,
            system_fingerprint,
            provider_created_ts,
            provider_processing_ms,
            response_payload
        INTO 
            v_resp.message_id,
            v_resp.submitted_user_prompt,
            v_resp.response_text,
            v_success,
            v_resp.processing_status,
            v_resp.msg,
            v_resp.rag_context,
            v_resp.rag_context_doc_count,
            v_resp.rag_sources_json,
            v_resp.provider_used,
            v_resp.model_used,
            v_resp.provider_final,
            v_resp.model_final,
            v_resp.fallback_used,
            v_resp.tokens_input,
            v_resp.tokens_output,
            v_resp.tokens_total,
            v_resp.cost_usd,
            v_blocked,
            v_resp.safety_filter_applied,
            v_resp.safety_block_reason,
            v_refusal,
            v_resp.refusal_text,
            v_resp.refusal_raw,
            v_resp.finish_reason,
            v_resp.stop_reason,
            v_resp.stop_sequence,
            v_truncated,
            v_resp.rag_ms,
            v_resp.governance_ms,
            v_resp.prompt_build_ms,
            v_resp.llm_call_ms,
            v_resp.total_pipeline_ms,
            v_resp.governance_action,
            v_resp.governance_details,
            v_resp.final_system_prompt,
            v_resp.final_user_prompt,
            v_resp.tool_calls_json,
            v_resp.parsed_structured_output,
            v_resp.request_id,
            v_resp.system_fingerprint,
            v_resp.created_timestamp,
            v_resp.processing_ms,
            v_resp.payload
        FROM chat_calls
        WHERE call_id = p_call_id;

        -- Convert CHAR to BOOLEAN
        v_resp.success      := char_to_bool(v_success);
        v_resp.is_blocked   := char_to_bool(v_blocked);
        v_resp.is_refusal   := char_to_bool(v_refusal);
        v_resp.is_truncated := char_to_bool(v_truncated);

        -- TODO: Parse safety_ratings_json back to JSON_ARRAY_T if needed
        v_resp.safety_ratings := NULL;

        RETURN v_resp;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN 
         debug_util.error('NO_DATA_FOUND'  , vcaller);
        RETURN NULL;
        WHEN OTHERS THEN
              debug_util.error( SQLERRM, vcaller);
            RAISE;
    END get_call_response;

     /*******************************************************************************
     *  
     *******************************************************************************/
       -- GET CALL (Alias for get_call_response for backward compatibility)
 
    FUNCTION get_call(p_call_id IN NUMBER)
    RETURN llm_types.t_llm_response
    IS
     vcaller constant varchar2(70):= c_package_name ||'.get_call';
    BEGIN
        RETURN get_call_response(p_call_id);
    END get_call;

     /*******************************************************************************
     *  
     *******************************************************************************/
       -- LIST CALLS (ref cursor, for APEX flexibility)
    ------------------ ------
    FUNCTION list_calls(
        p_session_id IN NUMBER,
        p_limit      IN NUMBER DEFAULT NULL,
        p_offset     IN NUMBER DEFAULT 0
    ) RETURN SYS_REFCURSOR
    IS
         vcaller constant varchar2(70):= c_package_name ||'.list_calls';
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT *
            FROM (
                SELECT c.*,
                       ROW_NUMBER() OVER (ORDER BY call_seq) rn
                FROM chat_calls c
                WHERE chat_session_id = p_session_id
                  AND NVL(is_deleted, 'N') = 'N'
            )
            WHERE rn > p_offset
              AND (p_limit IS NULL OR rn <= p_offset + p_limit)
            ORDER BY rn;

        RETURN rc;

    EXCEPTION WHEN OTHERS THEN
          debug_util.error( SQLERRM, vcaller, p_session_id);
        RAISE;
    END list_calls;
     /*******************************************************************************
     *  
     *******************************************************************************/
       -- UPDATE CALL
    ------------------ ------
    PROCEDURE update_call(
        p_call_id           IN NUMBER,
        p_response_text     IN CLOB DEFAULT NULL,
        p_response_metadata IN CLOB DEFAULT NULL
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.update_call';
    BEGIN
        UPDATE chat_calls
        SET response_text     = COALESCE(p_response_text, response_text),
            response_payload  = COALESCE(p_response_metadata, response_payload),
            updated_at        = SYSTIMESTAMP
        WHERE call_id = p_call_id;

        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Call not found');
        END IF;

        COMMIT;

    EXCEPTION WHEN OTHERS THEN
        debug_util.error( SQLERRM, vcaller );
        ROLLBACK;
        RAISE;
    END update_call;
     /*******************************************************************************
     *  
     *******************************************************************************/
       -- REGENERATE RESPONSE
    ------------------ ------
 FUNCTION regenerate(
    p_session_id IN NUMBER,
    p_new_params IN JSON DEFAULT NULL
) RETURN NUMBER
IS
     vcaller constant varchar2(70):= c_package_name ||'.regenerate';
    v_last_call_id  NUMBER;
    v_last_request  llm_types.t_llm_request;
    v_new_call_id   NUMBER;
    v_params_clob   CLOB;
BEGIN
 
       
    -- Fetch last call for the session
    ----------- 
    SELECT call_id
    INTO v_last_call_id
    FROM chat_calls
    WHERE chat_session_id = p_session_id
      AND NVL(is_deleted, 'N') = 'N'
    ORDER BY call_seq DESC
    FETCH FIRST 1 ROW ONLY;

     
    -- Get original request
    ------------------ 
    v_last_request := get_call_request(v_last_call_id);

    ------------------ 
    -- Update parameters if provided
    ------------------ 
    IF p_new_params IS NOT NULL THEN
        BEGIN
            v_params_clob := JSON_SERIALIZE(p_new_params);
            v_last_request.payload := v_params_clob;
        EXCEPTION WHEN OTHERS THEN
            NULL; -- Keep original payload
        END;
    END IF;

    ------------------ 
    -- Create new call with updated request
    ------------------ 
    v_new_call_id := add_call(
        p_request  => v_last_request,
        p_response => NULL
    );

    RETURN v_new_call_id;

EXCEPTION WHEN OTHERS THEN
    ROLLBACK;
      debug_util.error( SQLERRM ,vcaller, p_session_id);
    RAISE;
END regenerate;
     /*******************************************************************************
     *  
     *******************************************************************************/
    -- GET CONVERSATION HISTORY (for LLM context building)
    FUNCTION get_conversation_history(
        p_session_id IN NUMBER,
        p_max_calls  IN NUMBER DEFAULT 10
    ) RETURN CLOB
    IS
         vcaller constant varchar2(70):= c_package_name ||'.get_conversation_history';
        v_history CLOB;
    BEGIN
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'role' VALUE CASE 
                    WHEN user_prompt IS NOT NULL THEN 'user'
                    WHEN response_text IS NOT NULL THEN 'assistant'
                    WHEN system_instructions IS NOT NULL THEN 'system'
                END,
                'content' VALUE COALESCE(user_prompt, response_text, system_instructions)
            )
            ORDER BY call_seq
        )
        INTO v_history
        FROM (
            SELECT user_prompt, response_text, system_instructions, call_seq
            FROM chat_calls
            WHERE chat_session_id = p_session_id
              AND NVL(is_deleted, 'N') = 'N'
            ORDER BY call_seq DESC
            FETCH FIRST p_max_calls ROWS ONLY
        );

        RETURN v_history;

    EXCEPTION WHEN OTHERS THEN
          debug_util.error( SQLERRM ,vcaller , p_session_id);
        RAISE;
    END get_conversation_history;
     /*******************************************************************************
     *  
     *******************************************************************************/

END chat_call_pkg;

/
