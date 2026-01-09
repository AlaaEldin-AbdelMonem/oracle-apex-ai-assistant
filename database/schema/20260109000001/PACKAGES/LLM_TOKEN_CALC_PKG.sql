--------------------------------------------------------
--  DDL for Package LLM_TOKEN_CALC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."LLM_TOKEN_CALC_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_TOKEN_CALC_PKG (Specification)
 * PURPOSE:     LLM Token Consumption and Cost Calculation Engine.
 *
 * DESCRIPTION: Provides a centralized logic for calculating the monetary cost 
 * of LLM interactions based on token usage. Supports multi-provider 
 * pricing models (Input vs. Output tokens) and provides detailed 
 * financial breakdowns for auditing and budget management.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_TOKEN_CALC_PKG'; 

    /*******************************************************************************
     * DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_cost_breakdown
     * Encapsulates all financial metadata for a single LLM transaction.
     */
    TYPE t_cost_breakdown IS RECORD (
        total_cost       NUMBER,        -- Sum of input and output costs
        input_cost       NUMBER,        -- Cost of prompt tokens
        output_cost      NUMBER,        -- Cost of completion tokens
        tokens_input     NUMBER,        -- Count of tokens sent
        tokens_output    NUMBER,        -- Count of tokens received
        provider         VARCHAR2(50),  -- e.g., OPENAI, ANTHROPIC
        model            VARCHAR2(100), -- e.g., gpt-4o, claude-3-5-sonnet
        currency         VARCHAR2(10)   -- e.g., USD
    );

    /*******************************************************************************
     * COST CALCULATION API
     *******************************************************************************/

    /**
     * Function: calculate
     * Computes the full financial breakdown for an LLM call.
     * * @param p_provider      The LLM provider code.
     * @param p_model         The specific model ID.
     * @param p_tokens_input  Number of prompt tokens.
     * @param p_tokens_output Number of generated tokens.
     * @return t_cost_breakdown Record containing the calculated costs.
     */
    FUNCTION calculate(
        p_provider      IN VARCHAR2,
        p_model         IN VARCHAR2,
        p_tokens_input  IN NUMBER,
        p_tokens_output IN NUMBER
    ) RETURN t_cost_breakdown;

    /**
     * Function: calculate_json
     * Returns the cost breakdown as a JSON object, ideal for APEX UI components
     * or logging to JSON-capable audit tables.
     */
    FUNCTION calculate_json(
        p_provider      IN VARCHAR2,
        p_model         IN VARCHAR2,
        p_tokens_input  IN NUMBER,
        p_tokens_output IN NUMBER
    ) RETURN JSON;

    /*******************************************************************************
     * PRICING CONFIGURATION LOOKUP
     *******************************************************************************/

    /**
     * Function: get_pricing
     * Retrieves the per-1M-token pricing metadata from the configuration registry.
     * Hierarchy: Model-specific -> Provider Default -> Global Fallback.
     * * @return JSON containing 'input_price_per_1m' and 'output_price_per_1m'.
     */
    FUNCTION get_pricing(
        p_provider   IN VARCHAR2,
        p_model      IN VARCHAR2
    ) RETURN JSON;

END llm_token_calc_pkg;

/
