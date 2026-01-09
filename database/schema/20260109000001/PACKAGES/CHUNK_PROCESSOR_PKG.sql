--------------------------------------------------------
--  DDL for Package CHUNK_PROCESSOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CHUNK_PROCESSOR_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_PROCESSOR_PKG (Specification)
 * PURPOSE:     Orchestration of document chunking and persistence.
 *
 * DESCRIPTION: Handles the logic for converting documents into searchable 
 * text segments. Provides an interface to trigger generation, 
 * save results to disk, and manage chunk lifecycles.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_PROCESSOR_PKG';

    /*******************************************************************************
     * GENERATION & DISPATCH
     *******************************************************************************/

    /**
     * Function: generate_chunks
     * Dispatches the document text to the appropriate chunking strategy.
     * @param  p_doc_id      Source document identifier.
     * @param  p_strategy    Strategy code (e.g., FIXED_SIZE, SENTENCE).
     * @param  p_chunk_size  Maximum character/token count per chunk.
     * @param  p_overlap_pct Percentage of text to overlap between chunks.
     * @return chunk_types.t_chunk_tab Table of generated segments.
     */
    FUNCTION generate_chunks(
        p_doc_id      IN NUMBER,
        p_strategy    IN VARCHAR2,
        p_chunk_size  IN NUMBER,
        p_overlap_pct IN NUMBER
    ) RETURN chunk_types.t_chunk_tab;

    /*******************************************************************************
     * PERSISTENCE & LIFECYCLE
     *******************************************************************************/

    /**
     * Procedure: save_chunks
     * Persists a collection of chunks into the database for a specific document.
     */
    PROCEDURE save_chunks(
        p_doc_id IN NUMBER,
        p_chunks IN chunk_types.t_chunk_tab
    );

    /**
     * Procedure: delete_chunks
     * Removes all existing chunks associated with a specific document.
     */
    PROCEDURE delete_chunks(p_doc_id IN NUMBER);

    /*******************************************************************************
     * UTILITIES & TELEMETRY
     *******************************************************************************/

    /**
     * Function: count_chunks
     * Returns the total number of chunks currently stored for a document.
     */
    FUNCTION count_chunks(p_doc_id IN NUMBER) RETURN NUMBER;

END chunk_processor_pkg;

/
