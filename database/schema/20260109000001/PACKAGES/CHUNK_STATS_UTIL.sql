--------------------------------------------------------
--  DDL for Package CHUNK_STATS_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHUNK_STATS_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_STATS_UTIL (Specification)
 * PURPOSE:     Management of denormalized chunk metrics and performance caching.
 *
 * DESCRIPTION: Maintains pre-calculated statistics for RAG chunks to ensure 
 * high-performance UI rendering and analytics without re-scanning 
 * large vector or text tables.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_STATS_UTIL';

    /*******************************************************************************
     * REFRESH OPERATIONS (Cache Management)
     *******************************************************************************/

    /**
     * Procedure: refresh_stats_for_doc
     * Recalculates and persists metrics (counts, sizes) for a specific document.
     * @param p_doc_id  The document identifier to refresh.
     */
    PROCEDURE refresh_stats_for_doc(
        p_doc_id IN NUMBER
    );
    
    /**
     * Procedure: refresh_all_stats
     * Global refresh of the statistics cache for all active documents.
     */
    PROCEDURE refresh_all_stats;
    
    /*******************************************************************************
     * ANALYTICS & RETRIEVAL
     *******************************************************************************/

    /**
     * Function: get_chunk_count
     * Returns the cached number of chunks for a document.
     */
    FUNCTION get_chunk_count(
        p_doc_id IN NUMBER
    ) RETURN NUMBER;
    
    /**
     * Function: get_avg_chunk_size
     * Returns the average character length of chunks for the document.
     */
    FUNCTION get_avg_chunk_size(
        p_doc_id IN NUMBER
    ) RETURN NUMBER;
    
    /**
     * Function: get_chunk_size_range
     * Returns a formatted string representing the Min/Max size (e.g., "120 - 512").
     */
    FUNCTION get_chunk_size_range(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2;
    
END chunk_stats_util;

/
