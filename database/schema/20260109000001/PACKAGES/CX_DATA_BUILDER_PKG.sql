--------------------------------------------------------
--  DDL for Package CX_DATA_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CX_DATA_BUILDER_PKG" 
AUTHID CURRENT_USER AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_DATA_BUILDER_PKG (Specification)
 * PURPOSE:     Structured Data Context Assembler for LLM Prompts.
 *
 * DESCRIPTION: Handles the conversion of structured database data into 
 * natural language blocks. Unlike document chunks, this package 
 * fetches live data (ERP records, CRM status, etc.) based on 
 * the identified context domain to provide real-time grounding.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * DEPENDENCY:  Oracle APEX (v function)
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_DATA_BUILDER_PKG';

    /*******************************************************************************
     * PRIMARY CONTEXT BUILDER API
     *******************************************************************************/

    /**
     * Function: get_context_data
     * High-level entry point that returns a combined text block of all 
     * relevant structured data for a specific domain.
     *
     * @param p_context_domain_id  The knowledge domain ID (e.g., Finance, Sales).
     * @param p_user_id            Current user for row-level security.
     * @param p_filter_ctx         Optional JSON or string containing dynamic filters.
     * @return CLOB                Formatted text block (e.g., "Customer X has 3 open orders...").
     */
    FUNCTION get_context_data(
        p_context_domain_id IN NUMBER,
        p_user_id            IN NUMBER DEFAULT v('G_USER_ID'),
        p_filter_ctx         IN CLOB   DEFAULT NULL,
        p_call_Id            IN NUMBER,
        p_trace_Id           IN VARCHAR2
    ) RETURN CLOB;

    /*******************************************************************************
     * REGISTRY-BASED DATA RETRIEVAL
     *******************************************************************************/

    /**
     * Function: get_data_block
     * Retrieves data for a specific registry entry (a defined query or view).
     *
     * @param p_user_id      Current user context.
     * @param p_registry_id  Specific ID for the data source configuration.
     * @param p_filter_ctx   Dynamic parameters to be applied to the data query.
     * @return CLOB          The resulting dataset formatted as text/markdown.
     */
    FUNCTION get_data_block(
        p_user_id      IN NUMBER,
        p_registry_id  IN NUMBER,
        p_filter_ctx   IN CLOB DEFAULT NULL,
        p_call_Id            IN NUMBER,
        p_trace_Id           IN VARCHAR2
    ) RETURN CLOB;

END cx_data_builder_pkg;

/
