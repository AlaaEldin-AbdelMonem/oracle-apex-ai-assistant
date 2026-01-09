--------------------------------------------------------
--  DDL for Package CX_CHUNKS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CX_CHUNKS_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_CHUNKS_PKG (Specification)
 * PURPOSE:     High-performance Vector Retrieval for RAG Chunks.
 *
 * DESCRIPTION: Handles the low-level semantic search logic against the 
 * document vector store. Utilizes pipelined functions to efficiently 
 * stream the most relevant text segments (chunks) back to the 
 * context builder based on vector similarity.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 
 * DATABASE:    Oracle Database 23ai
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_CHUNKS_PKG';

    /*******************************************************************************
     * DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_chunk_record
     * Represents a single retrieved text segment with its search metadata.
     */
    TYPE t_chunk_record IS RECORD (
        doc_id          NUMBER,         -- Source document ID
        chunk_id        NUMBER,         -- Specific chunk ID
        content         CLOB,           -- The actual text segment
        similarity      NUMBER,         -- Semantic similarity score (vector distance)
        classification  VARCHAR2(50),   -- Data sensitivity (Confidential, Public, etc.)
        source_system   VARCHAR2(100)   -- Originating system (ERP, CRM, SharePoint)
    );

    /**
     * Table: t_chunk_tab
     * Collection type for bulk chunk handling and pipelined output.
     */
    TYPE t_chunk_tab IS TABLE OF t_chunk_record;

    /*******************************************************************************
     * RETRIEVAL API
     *******************************************************************************/

    /**
     * Function: get_chunks
     * Performs semantic vector search and streams relevant chunks.
     * Uses PIPELINED execution to reduce memory overhead during retrieval.
     *
     * @param p_user_id           Current user for security filtering/ACLs.
     * @param p_context_domain_id The domain silo to search within (e.g., HR, IT).
     * @param p_query             The raw or rephrased query text.
     * @param p_top_k             Number of chunks to return (Default: 5).
     * @return t_chunk_tab        Pipelined result set of retrieved chunks.
     */
    FUNCTION get_chunks(
        p_user_id            IN NUMBER,
        p_context_domain_id  IN NUMBER,
        p_query              IN CLOB,
        p_top_k              IN NUMBER DEFAULT 5
    ) RETURN t_chunk_tab PIPELINED;

END cx_chunks_pkg;

/
