--------------------------------------------------------
--  DDL for Package Body LLM_MODEL_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_MODEL_UTIL" as
/*******************************************************************************
 *  
 *******************************************************************************/
----------------------
-- Load Model Configuration
---------------------------------
FUNCTION load_model_config(p_req IN LLM_MODEL_UTIL.t_llm_Model_Info_Req)
RETURN llm_provider_models%ROWTYPE
IS  vcaller constant varchar2(70):= c_package_name ||'.load_model_config'; 
    v_cfg LLM_PROVIDER_MODELS%ROWTYPE;
BEGIN
    SELECT *
      INTO v_cfg
      FROM LLM_PROVIDER_MODELS
     WHERE UPPER(model_code) = UPPER(p_req.model)
       AND provider_code = p_req.provider
       AND is_active = 'Y'
       AND is_production_ready = 'Y'
       AND ROWNUM = 1;

    RETURN v_cfg;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20130,   
            'LLM_MODEL_UTIL>load_model_config>> Model "'||p_req.model||'" not found or inactive for provider '||p_req.provider);
     WHEN OTHERS THEN   
        debug_util.error( sqlerrm,vcaller);  
        RAISE_APPLICATION_ERROR(-20131,  
            'LLM_MODEL_UTIL>load_model_config>> Error: '||SQLERRM);   
END load_model_config;
/*******************************************************************************
 *  
 *******************************************************************************/
---------------------------------
-- Load API Key
---------------------------------
FUNCTION load_api_key(p_cfg llm_provider_models%ROWTYPE)
RETURN VARCHAR2
IS vcaller constant varchar2(70):= c_package_name ||'.load_api_key'; 
    v_key VARCHAR2(4000);
    v_param_key VARCHAR2(100);
BEGIN
    -- Return embedded key if available
    IF p_cfg.api_key IS NOT NULL THEN
        RETURN p_cfg.api_key;
    END IF;

    -- Determine parameter key based on provider
    v_param_key := CASE UPPER(p_cfg.provider_code)
        WHEN 'ANTHROPIC' THEN 'ANTHROPIC_API_KEY'
        WHEN 'OPENAI'    THEN 'OPENAI_API_KEY'
        WHEN 'GEMINI'    THEN 'GEMINI_API_KEY'
        WHEN 'HUGGINGFACE' THEN 'HUGGINGFACE_API_KEY'
        ELSE p_cfg.provider_code || '_API_KEY'
    END;

    -- Retrieve from configuration
    SELECT param_value
      INTO v_key
      FROM cfg_parameters
     WHERE param_key = v_param_key
       AND is_active = 'Y'
       AND ROWNUM = 1;

    RETURN v_key;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
     debug_util.error( sqlerrm,vcaller);  
        RAISE_APPLICATION_ERROR(-20132, 
            'LLM_MODEL_UTIL>load_api_key>> API key not found for provider: ' || p_cfg.provider_code || 
            ' (param_key: ' || v_param_key || ')');
    WHEN OTHERS THEN
     debug_util.error( sqlerrm,vcaller);  
        RAISE_APPLICATION_ERROR(-20133,  
            'LLM_MODEL_UTIL>load_api_key>> Error: ' || SQLERRM);
END load_api_key;
/*******************************************************************************
 *  
 *******************************************************************************/
end LLM_MODEL_UTIL;

/
