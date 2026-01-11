--------------------------------------------------------
--  DDL for Package LLM_MODEL_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_MODEL_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      LLM_MODEL_UTIL (Specification)
 * PURPOSE:     LLM Configuration and API Key Management.
 *
 * DESCRIPTION: Centralizes the retrieval of model-specific configurations and 
 * manages the secure access to API keys. This ensures that provider 
 * endpoints and credentials are not hardcoded in the business logic.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'LLM_MODEL_UTIL'; 

    /*******************************************************************************
     * DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_llm_model_info_req
     * Input structure used to lookup specific model configurations 
     * based on multi-tenant and application-level context.
     */
    TYPE t_llm_model_info_req IS RECORD (
        provider   VARCHAR2(100), -- e.g., OPENAI, ANTHROPIC, GEMINI
        model      VARCHAR2(200), -- e.g., gpt-4o, claude-3-sonnet
        tenant_id  NUMBER,        -- Multi-tenant isolation
        app_id     NUMBER         -- Application-specific config
    );

    /*******************************************************************************
     * CONFIGURATION & SECURITY API
     *******************************************************************************/

    /**
     * Function: load_model_config
     * Retrieves the complete row from the model registry table.
     * Contains base URLs, default parameters (temperature, top_p), and active status.
     *
     * @param p_req The lookup record containing provider and model identifiers.
     * @return llm_provider_models%ROWTYPE
     */
    FUNCTION load_model_config(
        p_req IN llm_model_util.t_llm_model_info_req 
    ) RETURN llm_provider_models%ROWTYPE;

    /**
     * Function: load_api_key
     * Retrieves the API key for the given model configuration. 
     * Should interface with a secure credential store (Oracle Wallet or Vault).
     *
     * @param p_cfg The configuration row retrieved from load_model_config.
     * @return VARCHAR2 The plain-text API key for HTTP header injection.
     */
    FUNCTION load_api_key(
        p_cfg IN llm_provider_models%ROWTYPE
    ) RETURN VARCHAR2;

END llm_model_util;

/
