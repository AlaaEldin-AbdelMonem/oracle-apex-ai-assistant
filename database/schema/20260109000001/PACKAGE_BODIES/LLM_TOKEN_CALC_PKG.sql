--------------------------------------------------------
--  DDL for Package Body LLM_TOKEN_CALC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_TOKEN_CALC_PKG" AS

    c_pkg CONSTANT VARCHAR2(30) := 'AI_TOKEN_CALC_PKG';
    c_default_currency CONSTANT VARCHAR2(10) := 'USD';
 
/*******************************************************************************
 *  
 *******************************************************************************/
     
    -- INTERNAL: PROVIDER DEFAULT HARDCODED PRICING (FALLBACK)
    --------------------------------------------------------------------------
FUNCTION provider_default(
    p_provider VARCHAR2
) RETURN JSON
IS
BEGIN
    CASE UPPER(p_provider)

        WHEN 'OPENAI' THEN
            RETURN JSON_OBJECT( 'input_cost'  VALUE 0.000015,  'output_cost' VALUE 0.00006
            RETURNING JSON);

        WHEN 'ANTHROPIC' THEN
            RETURN JSON_OBJECT( 'input_cost'  VALUE 0.000003,  'output_cost' VALUE 0.000015
            RETURNING JSON);

        WHEN 'GEMINI' THEN
            RETURN JSON_OBJECT( 'input_cost'  VALUE 0.00000125, 'output_cost' VALUE 0.000005
            RETURNING JSON);

        WHEN 'MISTRAL' THEN
            RETURN JSON_OBJECT( 'input_cost'  VALUE 0.000003,  'output_cost' VALUE 0.000009
            RETURNING JSON);

        WHEN 'LLAMA' THEN
            RETURN JSON_OBJECT(
                'input_cost'  VALUE 0.0000000,
                'output_cost' VALUE 0.0000000
            RETURNING JSON);

        WHEN 'OLLAMA' THEN
            RETURN JSON_OBJECT(
                'input_cost'  VALUE 0,
                'output_cost' VALUE 0
            RETURNING JSON);

        WHEN 'LOCAL' THEN
            RETURN JSON_OBJECT(
                'input_cost' VALUE 0,
                'output_cost' VALUE 0
            RETURNING JSON);

        WHEN 'OCI' THEN
            RETURN JSON_OBJECT(
                'input_cost'  VALUE 0.000002,
                'output_cost' VALUE 0.000004
            RETURNING JSON);

        ELSE
            RETURN JSON_OBJECT(
                'input_cost'  VALUE 0.000003,
                'output_cost' VALUE 0.000006
            RETURNING JSON);

    END CASE;
END provider_default;

/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- INTERNAL: LOAD PRICING FROM ai_model_pricing (REGISTRY TABLE)
    --------------------------------------------------------------------------
    FUNCTION pricing_from_table(
        p_provider    VARCHAR2,
        p_model      VARCHAR2
    ) RETURN JSON
    IS     vcaller constant varchar2(70):= c_package_name ||'.pricing_from_table'; 

        v_input_cost  NUMBER;
        v_output_cost NUMBER;
    BEGIN
        SELECT input_cost, output_cost
        INTO v_input_cost, v_output_cost
        FROM ai_model_pricing
        WHERE provider = p_provider
          AND model_name = p_model;

        -- FIX PLS-00382: Added RETURNING JSON
        RETURN JSON_OBJECT(
            'input_cost'  VALUE v_input_cost,
            'output_cost' VALUE v_output_cost
        RETURNING JSON);

    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
        WHEN OTHERS THEN
            debug_util.error('pricing_from_table'||SQLERRM ,vcaller);
            RETURN NULL;
    END pricing_from_table;

/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- INTERNAL: get pricing → priority 1: CFG_MODEL_ENDPOINTS JSON field
    --------------------------------------------------------------------------
    FUNCTION pricing_from_cfg(
        p_provider    VARCHAR2,
        p_model       VARCHAR2
    ) RETURN JSON
    IS
       vcaller constant varchar2(70):= c_package_name ||'.pricing_from_cfg'; 
        v_json JSON;
    BEGIN
        SELECT  pricing_json
        INTO v_json
        FROM LLM_PROVIDER_MODELS
        WHERE provider_CODE = p_provider
         -- AND model_name = p_model_name
          AND pricing_json IS NOT NULL;

        RETURN v_json;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN RETURN NULL;
        WHEN OTHERS THEN
             debug_util.error('pricing_from_cfg'|| SQLERRM ,vcaller );
            RETURN NULL;
    END pricing_from_cfg;

/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- PUBLIC: get_pricing() uses 3-tier lookup strategy
    --------------------------------------------------------------------------
    FUNCTION get_pricing(
        p_provider    IN VARCHAR2,
        p_model       IN VARCHAR2
    ) RETURN JSON
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_pricing'; 
        v_json JSON;
    BEGIN
        ------------------------------------------------------------------
        -- 1) Check CFG_MODEL_ENDPOINTS override
        ------------------------------------------------------------------
        v_json := pricing_from_cfg(p_provider, p_model);
        IF v_json IS NOT NULL THEN RETURN v_json; END IF;

        ------------------------------------------------------------------
        -- 2) Check ai_model_pricing registry
        ------------------------------------------------------------------
        v_json := pricing_from_table(p_provider, p_model);
        IF v_json IS NOT NULL THEN RETURN v_json; END IF;

        ------------------------------------------------------------------
        -- 3) Fallback provider default
        ------------------------------------------------------------------
        RETURN provider_default(p_provider);

    EXCEPTION WHEN OTHERS THEN
        debug_util.error( SQLERRM ,vcaller);
        RETURN provider_default(p_provider);
    END get_pricing;

/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- MAIN COST CALCULATION
    --------------------------------------------------------------------------
    FUNCTION calculate(
        p_provider      IN VARCHAR2,
        p_model    IN VARCHAR2,
        p_tokens_input  IN NUMBER,
        p_tokens_output IN NUMBER
    ) RETURN t_cost_breakdown
    IS
            vcaller constant varchar2(70):= c_package_name ||'.calculate'; 

        v_cost_json     JSON;
        v_in_cost       NUMBER;
        v_out_cost      NUMBER;

        out_rec t_cost_breakdown;
    BEGIN
        v_cost_json := get_pricing(p_provider, p_model);

 
        v_in_cost  := JSON_VALUE(v_cost_json, '$.input_cost' RETURNING NUMBER);
        v_out_cost := JSON_VALUE(v_cost_json, '$.output_cost' RETURNING NUMBER);

        out_rec.tokens_input   := NVL(p_tokens_input,0);
        out_rec.tokens_output  := NVL(p_tokens_output,0);

        out_rec.input_cost  := out_rec.tokens_input  * v_in_cost;
        out_rec.output_cost := out_rec.tokens_output * v_out_cost;

        out_rec.total_cost := out_rec.input_cost + out_rec.output_cost;

        out_rec.provider    := p_provider;
        out_rec.model  := p_model;
        out_rec.currency    := c_default_currency;

        RETURN out_rec;

    EXCEPTION WHEN OTHERS THEN
        debug_util.error(  SQLERRM || p_provider|| p_model ,vcaller);
        RAISE;
    END calculate;
/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- JSON VERSION (for logging and analytics dashboards)
    --------------------------------------------------------------------------
    FUNCTION calculate_json(
        p_provider      IN VARCHAR2,
        p_model         IN VARCHAR2,
        p_tokens_input  IN NUMBER,
        p_tokens_output IN NUMBER
    ) RETURN JSON
    IS
      vcaller constant varchar2(70):= c_package_name ||'.calculate_json'; 
        r t_cost_breakdown;
    BEGIN
        r := calculate(p_provider, p_model, p_tokens_input, p_tokens_output);

        -- Best practice: Add RETURNING JSON to JSON_OBJECT output
        RETURN JSON_OBJECT(
            'provider' VALUE r.provider,
            'model' VALUE r.model,
            'tokens_input' VALUE r.tokens_input,
            'tokens_output' VALUE r.tokens_output,
            'input_cost' VALUE r.input_cost,
            'output_cost' VALUE r.output_cost,
            'total_cost' VALUE r.total_cost,
            'currency' VALUE r.currency
        RETURNING JSON);

    EXCEPTION WHEN OTHERS THEN
        debug_util.error('calculate_json'|| SQLERRM || p_provider|| p_model ,vcaller);
        RAISE;
    END calculate_json;
/*******************************************************************************
 *  
 *******************************************************************************/
END LLM_TOKEN_CALC_PKG;

/
