--------------------------------------------------------
--  DDL for Package Body RAG_STRATEGY_CACHE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "RAG_STRATEGY_CACHE_UTIL" AS
/*******************************************************************************
 *  -Refresh cached recommendation for a single document
 *******************************************************************************/
 
    PROCEDURE refresh_recommendation(
        p_doc_id IN NUMBER
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_recommendation';  
        v_rec chunk_strategy_pkg.t_strategy_recommendation;
    BEGIN
        -- Get fresh recommendation
        v_rec := chunk_strategy_pkg.get_full_recommendation(p_doc_id);
        
        -- Cache it
        UPDATE docs
        SET recommended_strategy = v_rec.strategy_code,
            recommendation_reason = v_rec.reasoning,
            recommendation_confidence = v_rec.confidence_score,
            recommendation_updated_at = SYSTIMESTAMP
        WHERE doc_id = p_doc_id;
        
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
             debug_util.error( sqlerrm,vcaller);
         
    END refresh_recommendation;
/*******************************************************************************
 *  - Refresh all cached recommendations
 *******************************************************************************/
 
    PROCEDURE refresh_all_recommendations IS
        vcaller constant varchar2(70):= c_package_name ||'.refresh_all_recommendations';  
        v_rec chunk_strategy_pkg.t_strategy_recommendation;
    BEGIN
        FOR doc IN (
            SELECT doc_id
            FROM docs
            WHERE text_extracted IS NOT NULL
              AND is_active = 'Y'
        ) LOOP
            BEGIN
                v_rec := chunk_strategy_pkg.get_full_recommendation(doc.doc_id);
                
                UPDATE docs
                SET recommended_strategy = v_rec.strategy_code,
                    recommendation_reason = v_rec.reasoning,
                    recommendation_confidence = v_rec.confidence_score,
                    recommendation_updated_at = SYSTIMESTAMP
                WHERE doc_id = doc.doc_id;
                
            EXCEPTION
                WHEN OTHERS THEN
                    NULL; -- Continue with next document
            END;
        END LOOP;
        
        COMMIT;
    END refresh_all_recommendations;
/*******************************************************************************
 *  Get cached strategy (with optional auto-refresh)
 *******************************************************************************/
      FUNCTION get_cached_strategy(
        p_doc_id IN NUMBER,
        p_auto_refresh IN BOOLEAN DEFAULT FALSE
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_cached_strategy';  
        v_strategy VARCHAR2(50);
        v_updated_at TIMESTAMP;
    BEGIN
        SELECT recommended_strategy, recommendation_updated_at
        INTO v_strategy, v_updated_at
        FROM docs
        WHERE doc_id = p_doc_id;
        
        -- Auto-refresh if stale (older than 7 days) and requested
        IF p_auto_refresh AND 
           (v_updated_at IS NULL OR v_updated_at < SYSTIMESTAMP - 7) THEN
            refresh_recommendation(p_doc_id);
            
            SELECT recommended_strategy
            INTO v_strategy
            FROM docs
            WHERE doc_id = p_doc_id;
        END IF;
        
        RETURN v_strategy;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            debug_util.error( sqlerrm,vcaller);
            RETURN NULL;
        WHEN OTHERS THEN
             debug_util.error( sqlerrm,vcaller);
            RETURN NULL;
    END get_cached_strategy;
/*******************************************************************************
 *      -- Get cached reason
 *******************************************************************************/
 
    FUNCTION get_cached_reason(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_cached_reason';  
        v_reason VARCHAR2(4000);
    BEGIN
        SELECT recommendation_reason
        INTO v_reason
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN v_reason;
        
    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);
            RETURN NULL;
    END get_cached_reason;
/*******************************************************************************
 *   Get cached confidence
 *******************************************************************************/

    FUNCTION get_cached_confidence(
        p_doc_id IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_cached_confidence';  
        v_confidence NUMBER;
    BEGIN
        SELECT recommendation_confidence
        INTO v_confidence
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN v_confidence;
        
    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);
            RETURN NULL;
    END get_cached_confidence;
/*******************************************************************************
 *   Get strategy display name
 *******************************************************************************/

    FUNCTION get_strategy_display_name(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.get_strategy_display_name';  
        v_display_name VARCHAR2(200);
    BEGIN
        SELECT s.strategy_name
        INTO v_display_name
        FROM docs d
        JOIN lkp_chunking_strategy s ON s.strategy_code = d.recommended_strategy
        WHERE d.doc_id = p_doc_id;
        
        RETURN v_display_name;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            debug_util.error( sqlerrm,vcaller);
            RETURN 'Not Recommended';
        WHEN OTHERS THEN
            debug_util.error( sqlerrm,vcaller);
            RETURN NULL;
    END get_strategy_display_name;
/*******************************************************************************
 *  
 *******************************************************************************/
END rag_strategy_cache_util;

/
