--------------------------------------------------------
--  DDL for Package CX_CHUNKS_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CX_CHUNKS_BUILDER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_CHUNKS_BUILDER_PKG (Specification)
 * PURPOSE:     RAG Context Assembler and Document Injector.
 *
 * DESCRIPTION: Handles the retrieval and formatting of relevant document 
 * chunks for LLM prompts. Orchestrates semantic search via 
 * vector distance and packages the results into a unified 
 * context block for the RAG engine.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  Oracle 23ai VECTOR functions
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_CHUNKS_BUILDER_PKG';

    /*******************************************************************************
     * CONTEXT ASSEMBLY API
     *******************************************************************************/

    /**
     * Function: get_context_docs
     * Performs a semantic search for the user query within a specific domain 
     * and formats the top results into a single CLOB block.
     *
     * @param p_user_id           Current user ID for access control filtering.
     * @param p_context_domain_id The knowledge domain to search within (HR, IT, etc.).
     * @param p_query             The raw user prompt or rephrased search query.
     * @param p_top_k             Number of relevant chunks to retrieve (Default: 5).
     * @return CLOB               A formatted string of chunks, ready for prompt injection.
     */
    FUNCTION get_context_docs(
        p_user_id            IN NUMBER,
        p_context_domain_id  IN NUMBER,
        p_query              IN CLOB,
        p_top_k              IN NUMBER DEFAULT 5
    ) RETURN CLOB;

END cx_chunks_builder_pkg;

/
