--------------------------------------------------------
--  DDL for Package RAG_CHUNK_STATS_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "RAG_CHUNK_STATS_UTIL" AS
    -- Package to manage chunk statistics caching
    -- Maintains denormalized chunk metrics for performance
    c_version           CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name      CONSTANT VARCHAR2(30) := 'RAG_CHUNK_STATS_UTIL'; 
    PROCEDURE refresh_stats_for_doc(
        p_doc_id IN NUMBER
    );
    
    PROCEDURE refresh_all_stats;
    
    FUNCTION get_chunk_count(
        p_doc_id IN NUMBER
    ) RETURN NUMBER;
    
    FUNCTION get_avg_chunk_size(
        p_doc_id IN NUMBER
    ) RETURN NUMBER;
    
    FUNCTION get_chunk_size_range(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2;
    
END rag_chunk_stats_util;

/
