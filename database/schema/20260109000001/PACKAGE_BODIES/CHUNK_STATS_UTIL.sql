--------------------------------------------------------
--  DDL for Package Body CHUNK_STATS_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHUNK_STATS_UTIL" AS
 /*******************************************************************************
 *  
 *******************************************************************************/
    -- ========================================================================
    -- Refresh statistics for a single document
    -- ========================================================================
    PROCEDURE refresh_stats_for_doc(
        p_doc_id IN NUMBER
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_stats_for_doc';
        v_stats_json VARCHAR2(1000);
    BEGIN
        SELECT JSON_OBJECT(
            'avg_size' VALUE ROUND(AVG(LENGTH(chunk_text)), 0),
            'min_size' VALUE MIN(LENGTH(chunk_text)),
            'max_size' VALUE MAX(LENGTH(chunk_text)),
            'count' VALUE COUNT(*)
        )
        INTO v_stats_json
        FROM DOC_CHUNKS
        WHERE doc_id = p_doc_id
        HAVING COUNT(*) > 0;
        
        UPDATE docs
        SET chunk_stats_json = v_stats_json,
            chunk_stats_updated_at = SYSTIMESTAMP
        WHERE doc_id = p_doc_id;
        
        COMMIT;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- No chunks found, set stats to NULL
            UPDATE docs
            SET chunk_stats_json = NULL,
                chunk_stats_updated_at = SYSTIMESTAMP
            WHERE doc_id = p_doc_id;
            COMMIT;
    END refresh_stats_for_doc;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- ========================================================================
    -- Refresh statistics for all documents
    -- ========================================================================
    PROCEDURE refresh_all_stats IS
          vcaller constant varchar2(70):= c_package_name ||'.refresh_all_stats';
    BEGIN
        MERGE INTO docs d
        USING (
            SELECT 
                doc_id,
                JSON_OBJECT(
                    'avg_size' VALUE ROUND(AVG(LENGTH(chunk_text)), 0),
                    'min_size' VALUE MIN(LENGTH(chunk_text)),
                    'max_size' VALUE MAX(LENGTH(chunk_text)),
                    'count' VALUE COUNT(*)
                ) as stats_json
            FROM DOC_CHUNKS
            GROUP BY doc_id
        ) c
        ON (d.doc_id = c.doc_id)
        WHEN MATCHED THEN
            UPDATE SET 
                d.chunk_stats_json = c.stats_json,
                d.chunk_stats_updated_at = SYSTIMESTAMP;
        
        COMMIT;
    END refresh_all_stats;
/*******************************************************************************
 *  
 *******************************************************************************/ 
    -- ========================================================================
    -- Get chunk count from cached stats
    -- ========================================================================
    FUNCTION get_chunk_count(
        p_doc_id IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_chunk_count';
        v_count NUMBER;
    BEGIN
        SELECT JSON_VALUE(chunk_stats_json, '$.count')
        INTO v_count
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN NVL(v_count, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END get_chunk_count;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- ========================================================================
    -- Get average chunk size from cached stats
    -- ========================================================================
    FUNCTION get_avg_chunk_size(
        p_doc_id IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_avg_chunk_size';
        v_avg NUMBER;
    BEGIN
        SELECT JSON_VALUE(chunk_stats_json, '$.avg_size')
        INTO v_avg
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN NVL(v_avg, 0);
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 0;
    END get_avg_chunk_size;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- ========================================================================
    -- Get chunk size range from cached stats
    -- ========================================================================
    FUNCTION get_chunk_size_range(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_chunk_size_range';
        v_range VARCHAR2(100);
    BEGIN
        SELECT 
            JSON_VALUE(chunk_stats_json, '$.min_size') || ' - ' || 
            JSON_VALUE(chunk_stats_json, '$.max_size') || ' chars'
        INTO v_range
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN NVL(v_range, 'N/A');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'N/A';
    END get_chunk_size_range;
/*******************************************************************************
 *  
 *******************************************************************************/
END chunk_stats_util;

/
