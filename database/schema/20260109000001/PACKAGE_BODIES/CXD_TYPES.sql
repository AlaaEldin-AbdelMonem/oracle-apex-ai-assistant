--------------------------------------------------------
--  DDL for Package Body CXD_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CXD_TYPES" IS

    ----------------------------------------------------------------------------
    -- 1. REQUEST OBJECT DUMP
    ----------------------------------------------------------------------------
    FUNCTION to_json (p_rec IN t_cxd_classifier_req) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        
        -- IDs and Trace
        APEX_JSON.WRITE('trace_id',              p_rec.trace_id);
        APEX_JSON.WRITE('chat_session_id',       p_rec.chat_session_id);
        APEX_JSON.WRITE('chat_call_id',          p_rec.chat_call_id);
        APEX_JSON.WRITE('chat_project_id',       p_rec.chat_project_id);
        
        -- Logic Config
        APEX_JSON.WRITE('detection_method_code', p_rec.detection_method_code);
        APEX_JSON.WRITE('provider',              p_rec.provider);
        APEX_JSON.WRITE('model',                 p_rec.model);
        APEX_JSON.WRITE('cxd_required',          p_rec.cxd_required);
        APEX_JSON.WRITE('intent_required',       p_rec.intent_required);
        
        -- Context & Intent specifics
        APEX_JSON.WRITE('context_domain_id',     p_rec.context_domain_id);
        APEX_JSON.WRITE('intent_cxd_id',         p_rec.intent_cxd_id);
        
        -- User Context
        APEX_JSON.WRITE('user_id',               p_rec.user_id);
        APEX_JSON.WRITE('user_name',             p_rec.user_name);
        APEX_JSON.WRITE('tenant_id',             p_rec.tenant_id);
        APEX_JSON.WRITE('app_id',                p_rec.app_id);
        APEX_JSON.WRITE('app_page_id',           p_rec.app_page_id);
        APEX_JSON.WRITE('app_session_id',        p_rec.app_session_id);

        -- CLOB Content (Handled automatically by APEX_JSON)
        APEX_JSON.WRITE('user_prompt',           p_rec.user_prompt); 
        
        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        
        RETURN l_clob;
    END to_json;

    ----------------------------------------------------------------------------
    -- 2. DOMAIN RESPONSE DUMP
    ----------------------------------------------------------------------------
    FUNCTION to_json (p_rec IN t_cxd_classifier_resp) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        
        APEX_JSON.WRITE('trace_id',                    p_rec.trace_id);
        APEX_JSON.WRITE('chat_session_id',             p_rec.chat_session_id);
        APEX_JSON.WRITE('chat_call_id',                p_rec.chat_call_id);
        
        APEX_JSON.WRITE('detect_status',               p_rec.detect_status);
        APEX_JSON.WRITE('detection_method_code',       p_rec.detection_method_code);
        APEX_JSON.WRITE('final_detection_method_code', p_rec.final_detection_method_code);
        
        -- Result Details
        APEX_JSON.WRITE('context_domain_id',           p_rec.context_domain_id);
        APEX_JSON.WRITE('context_domain_code',         p_rec.context_domain_code);
        APEX_JSON.WRITE('context_domain_name',         p_rec.context_domain_name);
        APEX_JSON.WRITE('context_domain_confidence',   p_rec.context_domain_confidence);
        
        -- Metadata
        APEX_JSON.WRITE('message',                     p_rec.message);
        APEX_JSON.WRITE('search_time_ms',              p_rec.search_time_ms);
        APEX_JSON.WRITE('used_provider',               p_rec.used_provider);
        APEX_JSON.WRITE('used_model',                  p_rec.used_model);
        
        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        
        RETURN l_clob;
    END to_json;

    ----------------------------------------------------------------------------
    -- 3. INTENT RESPONSE DUMP
    ----------------------------------------------------------------------------
    FUNCTION to_json (p_rec IN t_intent_classifier_resp) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        
        APEX_JSON.WRITE('trace_id',                    p_rec.trace_id);
        APEX_JSON.WRITE('chat_session_id',             p_rec.chat_session_id);
        APEX_JSON.WRITE('chat_call_id',                p_rec.chat_call_id);
        
        APEX_JSON.WRITE('detect_status',               p_rec.detect_status);
        APEX_JSON.WRITE('detection_method_code',       p_rec.detection_method_code);
        APEX_JSON.WRITE('final_detection_method_code', p_rec.final_detection_method_code);
        
        -- Result Details
        APEX_JSON.WRITE('intent_id',                   p_rec.intent_id);
        APEX_JSON.WRITE('intent_code',                 p_rec.intent_code);
        APEX_JSON.WRITE('intent_name',                 p_rec.intent_name);
        APEX_JSON.WRITE('intent_confidence',           p_rec.intent_confidence);
        
        -- Metadata
        APEX_JSON.WRITE('message',                     p_rec.message);
        APEX_JSON.WRITE('search_time_ms',              p_rec.search_time_ms);
        APEX_JSON.WRITE('used_provider',               p_rec.used_provider);
        APEX_JSON.WRITE('used_model',                  p_rec.used_model);
        
        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        
        RETURN l_clob;
    END to_json;

END cxd_types;

/
