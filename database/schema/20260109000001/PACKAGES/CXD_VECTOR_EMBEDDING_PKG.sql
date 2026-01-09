--------------------------------------------------------
--  DDL for Package CXD_VECTOR_EMBEDDING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CXD_VECTOR_EMBEDDING_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_VECTOR_EMBEDDING_PKG (Specification)
 * PURPOSE:     Generation and management of Context Domain vector embeddings.
 *
 * DESCRIPTION: Provides tools to synchronize domain text descriptions with 
 * Oracle 23ai VECTOR columns. This enables semantic domain 
 * detection without requiring expensive LLM calls.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 * DATABASE:    Oracle Database 23ai
 * DEPENDENCY:  AI_VECTOR_UTX
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_VECTOR_EMBEDDING_PKG';

    /*******************************************************************************
     * CONFIGURATION CONSTANTS
     *******************************************************************************/
    
    /** Dimension size for the domain vectors, inherited from vector utility */
    c_vector_dim    CONSTANT NUMBER       := ai_vector_utx.c_vector_dimensions;
    
    /** The specific embedding model name used for domain vectorization */
    c_model         CONSTANT VARCHAR2(100) := ai_vector_utx.c_model_name;

    /*******************************************************************************
     * PUBLIC API - EMBEDDING ORCHESTRATION
     *******************************************************************************/

    /**
     * Procedure: generate_all_embeddings
     * Iterates through all active context domains and refreshes their vector 
     * representations based on the current description/metadata.
     */
    PROCEDURE generate_all_embeddings;

    /**
     * Procedure: generate_embedding_for_domain
     * Generates or updates the vector embedding for a single specific domain.
     * @param p_context_domain_id  Unique identifier for the domain.
     */
    PROCEDURE generate_embedding_for_domain(
        p_context_domain_id IN NUMBER
    );

    /**
     * Procedure: rebuild_failed_embeddings
     * Identifies domains where embedding generation failed or is missing 
     * and attempts a retry. Useful for automated maintenance jobs.
     */
    PROCEDURE rebuild_failed_embeddings;

END cxd_vector_embedding_pkg;

/
