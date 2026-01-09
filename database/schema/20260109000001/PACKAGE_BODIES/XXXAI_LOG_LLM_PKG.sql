--------------------------------------------------------
--  DDL for Package Body XXXAI_LOG_LLM_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."XXXAI_LOG_LLM_PKG" IS

    PROCEDURE log_event( 
        p_pipeline      IN VARCHAR2 DEFAULT 'LLM',
        p_event_type_id IN NUMBER   DEFAULT 601,
        p_req           IN llm_types.t_llm_request DEFAULT NULL,
        p_resp          IN llm_types.t_llm_response DEFAULT NULL,
        p_level         IN VARCHAR2 DEFAULT 'INFO',
        p_message       IN VARCHAR2 DEFAULT NULL,
        p_base_extra    IN JSON_OBJECT_T DEFAULT NULL,
        p_payload_extra IN JSON_OBJECT_T DEFAULT NULL
    ) 
    IS
        v_root     JSON_OBJECT_T;
        v_base     JSON_OBJECT_T;
        v_payload  JSON_OBJECT_T;
        v_clob     CLOB;
    BEGIN
        ------------- 
        -- BASE BLOCK
          
        v_base := JSON_OBJECT_T();
        v_base.put('event_type_id', p_event_type_id);
        v_base.put('log_level',     UPPER(p_level));
        v_base.put('log_message',   p_message);

        -- Add request metadata if provided
        --IF p_req IS NOT NULL THEN
            IF p_req.user_name IS NOT NULL THEN
                v_base.put('user_name', p_req.user_name);
           -- END IF;

            v_base.put('user_id',         NVL(p_req.user_id, 0));
            v_base.put('tenant_id',       NVL(p_req.tenant_id, 0));
            v_base.put('project_id',      NVL(p_req.project_id, 0));
            v_base.put('chat_session_id', NVL(p_req.chat_session_id, 0));
            v_base.put('app_session_id',  NVL(p_req.app_session_id, 0));
            v_base.put('app_page_id',     NVL(p_req.app_page_id, 0));
            v_base.put('app_id',          NVL(p_req.app_id, 0));
        END IF;

        -- Extra base fields (optional)
      --  IF p_base_extra IS NOT NULL THEN
            v_base.put('extra', p_base_extra);
       -- END IF;


        ----------------- 
        -- PAYLOAD BLOCK
         
        v_payload := JSON_OBJECT_T();

        --IF p_resp IS NOT NULL THEN
            v_payload.put('response',          p_resp.response_text);
            v_payload.put('token_count_input', NVL(p_resp.input_tokens,0));
            v_payload.put('token_count_output',NVL(p_resp.output_tokens,0));
            v_payload.put('token_count_total', NVL(p_resp.total_tokens,0));
            v_payload.put('cost_total',        NVL(p_resp.cost_usd,0));
            v_payload.put('finish_reason',     p_resp.finish_reason);

            v_payload.put('is_error',
                CASE WHEN NOT p_resp.success THEN 'Y' ELSE 'N' END
            );

            IF p_resp.payload IS NOT NULL THEN
                v_payload.put('raw', p_resp.payload);
            END IF;
       -- END IF;

        -- Extra payload fields
        IF p_payload_extra IS NOT NULL THEN
            v_payload.put('extra', p_payload_extra);
        END IF;
        ---------------------- 
        -- ROOT WRAPPER OBJECT
          
        v_root := JSON_OBJECT_T();
        v_root.put('pipeline', p_pipeline);
        v_root.put('base',     v_base);
        v_root.put('payload',  v_payload);

        ----------------------------- 
        -- Convert to CLOB and send to AI_LOG_UTIL
          
        v_clob := v_root.to_clob;

        AI_LOG_UTIL.LOG_EVENT(v_clob);

    EXCEPTION
        WHEN OTHERS THEN
            -- Fail-safe: logging must NEVER interrupt LLM execution
            NULL;
    END log_event;

END xxxai_log_llm_pkg;

/
