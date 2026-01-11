--------------------------------------------------------
--  DDL for Package Body DEPLOYMENT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DEPLOYMENT_MANAGER_PKG" AS

/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Generate consistent hash for user (for canary/segment assignment)
     */

     FUNCTION should_block_deployment(
    p_deployment_id IN NUMBER
) RETURN BOOLEAN IS
    vcaller constant varchar2(70):= c_package_name ||'.should_block_deployment'; 
    v_failed_rate NUMBER;
    v_p95_latency NUMBER;
    v_blocked_cnt NUMBER;
BEGIN
    SELECT
        (SUM(failed_calls) / NULLIF(SUM(total_calls), 0)) * 100,
        MAX(p95_total_pipeline_ms),
        SUM(blocked_calls)
    INTO
        v_failed_rate,
        v_p95_latency,
        v_blocked_cnt
    FROM DEPLOYMENT_METRICS
    WHERE deployment_id = p_deployment_id
      AND metric_date >= TRUNC(SYSDATE) - 1;

    IF NVL(v_failed_rate,0) > 5 THEN RETURN TRUE; END IF;
    IF NVL(v_p95_latency,0) > 5000 THEN RETURN TRUE; END IF;
    IF NVL(v_blocked_cnt,0) > 50 THEN RETURN TRUE; END IF;

    RETURN FALSE;
END should_block_deployment;
/*******************************************************************************
 *  
 *******************************************************************************/
PROCEDURE rollback_deployment(
    p_deployment_id IN NUMBER,
    p_reason        IN VARCHAR2
) IS
  vcaller constant varchar2(70):= c_package_name ||'.rollback_deployment'; 
BEGIN
    UPDATE DEPLOYMENT_VERSIONS
    SET deployment_status = 'PAUSED',
        is_active = 'N',
        deactivated_at = SYSTIMESTAMP
    WHERE deployment_id = p_deployment_id;

    log_deployment_event(
        p_deployment_id,
        'DEACTIVATED',
        'AUTO',
        p_reason
    );

    COMMIT;
END rollback_deployment;
/*******************************************************************************
 *  
 *******************************************************************************/
FUNCTION is_experiment_healthy(
    p_experiment_id IN NUMBER
) RETURN BOOLEAN IS
     vcaller constant varchar2(70):= c_package_name ||'.is_experiment_healthy'; 
    v_unhealthy_cnt NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_unhealthy_cnt
    FROM DEPLOYMENT_VERSIONS d
    WHERE d.experiment_id = p_experiment_id
      AND should_block_deployment(d.deployment_id) = TRUE;

    RETURN (v_unhealthy_cnt = 0);
END is_experiment_healthy;
/*******************************************************************************
 *  
 *******************************************************************************/
FUNCTION score_deployment(
    p_deployment_id IN NUMBER,
    p_start_date    IN DATE,
    p_end_date      IN DATE
) RETURN NUMBER IS
    vcaller constant varchar2(70):= c_package_name ||'.score_deployment'; 
    v_score NUMBER;
BEGIN
    SELECT
          (SUM(successful_calls) * 2)
        - (SUM(failed_calls) * 5)
        - (AVG(p95_total_pipeline_ms) / 100)
        - (SUM(total_cost_usd) * 10)
        + (SUM(excellent_ratings) * 3)
    INTO v_score
    FROM DEPLOYMENT_METRICS
    WHERE deployment_id = p_deployment_id
      AND metric_date BETWEEN p_start_date AND p_end_date;

    RETURN NVL(v_score, 0);
END score_deployment;
/*******************************************************************************
 *  
 *******************************************************************************/

    FUNCTION get_user_hash(p_user_id IN NUMBER, p_seed IN NUMBER DEFAULT 12345)
    RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_production_deployment'; 
        v_hash_raw RAW(16);
        v_hash_num NUMBER;
    BEGIN
        v_hash_raw := DBMS_CRYPTO.HASH(
            UTL_RAW.CAST_TO_RAW(TO_CHAR(p_user_id) || ':' || TO_CHAR(p_seed)),
            DBMS_CRYPTO.HASH_MD5
        );

        v_hash_num := UTL_RAW.CAST_TO_BINARY_INTEGER(
            UTL_RAW.SUBSTR(v_hash_raw, 1, 4)
        );

        RETURN ABS(MOD(v_hash_num, 10000)) / 100.0;
    END get_user_hash;

/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Get production deployment ID
     */
    FUNCTION get_production_deployment RETURN NUMBER IS
        v_deployment_id NUMBER;
          vcaller constant varchar2(70):= c_package_name ||'.extract_text'; 
    BEGIN
        SELECT deployment_id
        INTO v_deployment_id
        FROM DEPLOYMENT_VERSIONS
        WHERE deployment_type = 'PRODUCTION'
          AND is_active = 'Y'
          AND deployment_status = 'ACTIVE'
        ORDER BY priority ASC
        FETCH FIRST 1 ROWS ONLY;

        RETURN v_deployment_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'No active PRODUCTION deployment found');
    END get_production_deployment;

/*******************************************************************************
 *  
 *******************************************************************************/
    -- ========================================================================
    -- PUBLIC FUNCTION IMPLEMENTATIONS
    -- ========================================================================

    /**
     * Get appropriate deployment for user
     */
    FUNCTION get_user_deployment(
        p_user_id           IN NUMBER,
        p_session_id        IN NUMBER DEFAULT NULL,
        p_context_domain_id IN NUMBER DEFAULT NULL
    ) RETURN NUMBER IS
      vcaller constant varchar2(70):= c_package_name ||'.get_user_deployment'; 
        v_deployment_id     NUMBER;
        v_segment_id        NUMBER;
        v_user_hash         NUMBER;
        v_session_locked    CHAR(1);
    BEGIN
        -- Check if session has locked deployment (sticky sessions)
        IF p_session_id IS NOT NULL THEN
            BEGIN
                SELECT primary_deployment_id, 
                       CASE 
                           WHEN assignment_locked_until > SYSTIMESTAMP THEN 'Y'
                           ELSE 'N'
                       END
                INTO v_deployment_id, v_session_locked
                FROM CHAT_SESSIONS
                WHERE session_id = p_session_id;

                IF v_session_locked = 'Y' AND v_deployment_id IS NOT NULL THEN
                    RETURN v_deployment_id;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END IF;

        v_user_hash := get_user_hash(p_user_id);

        -- PRIORITY 1: Check for active A/B test assignment
        BEGIN
            SELECT d.deployment_id, a.segment_id
            INTO v_deployment_id, v_segment_id
            FROM USER_SEGMENT_ASSIGNMENTS a,
                 DEPLOYMENT_VERSIONS d
            WHERE a.user_id = p_user_id
              AND a.deployment_id = d.deployment_id
              AND a.is_active = 'Y'
              AND d.deployment_type = 'AB_TEST'
              AND d.is_active = 'Y'
              AND d.deployment_status = 'ACTIVE'
              AND (a.sticky_until IS NULL OR a.sticky_until > SYSTIMESTAMP)
            ORDER BY d.priority ASC
            FETCH FIRST 1 ROWS ONLY;

            RETURN v_deployment_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        -- PRIORITY 2: Check for canary deployment
        FOR canary_rec IN (
            SELECT deployment_id, rollout_percentage
            FROM DEPLOYMENT_VERSIONS
            WHERE deployment_type = 'CANARY'
              AND is_active = 'Y'
              AND deployment_status = 'ACTIVE'
            ORDER BY priority ASC
        ) LOOP
            IF v_user_hash <= canary_rec.rollout_percentage THEN
                RETURN canary_rec.deployment_id;
            END IF;
        END LOOP;

        -- PRIORITY 3: Return production deployment
        RETURN get_production_deployment();

    EXCEPTION
        WHEN OTHERS THEN
            BEGIN
               debug_util.error(sqlerrm,vcaller);  
                RETURN get_production_deployment();
            EXCEPTION
                WHEN OTHERS THEN
                   debug_util.error(sqlerrm,vcaller);  
                    RAISE_APPLICATION_ERROR(-20002, 
                        'Failed to determine deployment: ' || SQLERRM);
            END;
    END get_user_deployment;

/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Get all deployments for user (including shadows)
     */
   FUNCTION get_user_deployments(p_user_id IN NUMBER)
    RETURN t_deployment_list IS
      vcaller constant varchar2(70):= c_package_name ||'.get_user_deployments'; 
    
    v_deployments t_deployment_list := t_deployment_list();
    v_primary_deployment_id NUMBER;
    v_deployment_rec t_deployment_info;
    
BEGIN
    -- Get primary deployment for user
    v_primary_deployment_id := get_user_deployment(p_user_id);
    
    -- Return empty list if no deployment found
    IF v_primary_deployment_id IS NULL THEN
        RETURN v_deployments;
    END IF;
    
    -- Get primary deployment config
    FOR dep_rec IN (
        SELECT 
            deployment_id,
            deployment_name,
            deployment_type,
            provider,
            model_name,
            deployment_config AS config_json,
            rollout_percentage,
            variant_label
        FROM DEPLOYMENT_VERSIONS
        WHERE deployment_id = v_primary_deployment_id
    ) LOOP
        -- Explicitly assign fields to match RECORD type
        v_deployment_rec.deployment_id := dep_rec.deployment_id;
        v_deployment_rec.deployment_name := dep_rec.deployment_name;
        v_deployment_rec.deployment_type := dep_rec.deployment_type;
        v_deployment_rec.provider := dep_rec.provider;
        v_deployment_rec.model_name := dep_rec.model_name;
        v_deployment_rec.config_json := dep_rec.config_json;
        v_deployment_rec.rollout_percentage := dep_rec.rollout_percentage;
        v_deployment_rec.segment_id := NULL;  -- Not applicable for primary
        v_deployment_rec.variant_label := dep_rec.variant_label;
        
        -- Add to collection
        v_deployments.EXTEND;
        v_deployments(v_deployments.COUNT) := v_deployment_rec;
    END LOOP;
    
    -- Get shadow deployments (if any)
    FOR shadow_rec IN (
        SELECT 
            deployment_id,
            deployment_name,
            deployment_type,
            provider,
            model_name,
            deployment_config AS config_json,
            rollout_percentage,
            variant_label
        FROM DEPLOYMENT_VERSIONS
        WHERE deployment_type = 'SHADOW'
          AND is_active = 'Y'
          AND deployment_status = 'ACTIVE'
          AND (shadow_parent_deployment_id = v_primary_deployment_id 
               OR shadow_parent_deployment_id IS NULL)
    ) LOOP
        -- Explicitly assign fields
        v_deployment_rec.deployment_id := shadow_rec.deployment_id;
        v_deployment_rec.deployment_name := shadow_rec.deployment_name;
        v_deployment_rec.deployment_type := shadow_rec.deployment_type;
        v_deployment_rec.provider := shadow_rec.provider;
        v_deployment_rec.model_name := shadow_rec.model_name;
        v_deployment_rec.config_json := shadow_rec.config_json;
        v_deployment_rec.rollout_percentage := shadow_rec.rollout_percentage;
        v_deployment_rec.segment_id := NULL;  -- Not applicable for shadows
        v_deployment_rec.variant_label := shadow_rec.variant_label;
        
        -- Add to collection
        v_deployments.EXTEND;
        v_deployments(v_deployments.COUNT) := v_deployment_rec;
    END LOOP;
    
    RETURN v_deployments;
    
EXCEPTION
    WHEN OTHERS THEN
        -- Log error and return empty list
         debug_util.error(sqlerrm,vcaller);  
        RETURN t_deployment_list();
END get_user_deployments;
/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Assign user to segment
     */
    FUNCTION assign_user_to_segment(
        p_user_id           IN NUMBER,
        p_deployment_id     IN NUMBER,
        p_force_reassign    IN BOOLEAN DEFAULT FALSE
    ) RETURN NUMBER IS
      vcaller constant varchar2(70):= c_package_name ||'.assign_user_to_segment'; 
        v_segment_id        NUMBER;
        v_segment_type      VARCHAR2(20);
        v_assignment_method VARCHAR2(30);
        v_user_hash         NUMBER;
    BEGIN
        -- Check if already assigned
        IF NOT p_force_reassign THEN
            BEGIN
                SELECT segment_id
                INTO v_segment_id
                FROM USER_SEGMENT_ASSIGNMENTS
                WHERE user_id = p_user_id
                  AND deployment_id = p_deployment_id
                  AND is_active = 'Y';

                RETURN v_segment_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END IF;

        v_user_hash := get_user_hash(p_user_id);

        -- Find eligible segment based on assignment strategy
        FOR segment_rec IN (
            SELECT s.segment_id, s.segment_type, s.assignment_strategy,
                   s.target_percentage, s.current_user_count, s.max_users
            FROM USER_SEGMENTS s
            WHERE s.is_active = 'Y'
              AND s.is_locked = 'N'
              AND EXISTS (
                  SELECT 1 FROM DEPLOYMENT_VERSIONS d
                  WHERE d.deployment_id = p_deployment_id
                    AND (',' || d.target_segment_ids || ',') LIKE '%,' || s.segment_id || ',%'
              )
            ORDER BY s.segment_id
        ) LOOP
            v_segment_id := segment_rec.segment_id;
            v_assignment_method := segment_rec.assignment_strategy;

            -- Check capacity
            IF segment_rec.max_users IS NOT NULL 
               AND segment_rec.current_user_count >= segment_rec.max_users THEN
                CONTINUE;
            END IF;

            -- Assign based on strategy
            IF segment_rec.assignment_strategy = 'HASH_BASED' THEN
                IF v_user_hash <= NVL(segment_rec.target_percentage, 50) THEN
                    EXIT;
                END IF;
            ELSIF segment_rec.assignment_strategy = 'RANDOM' THEN
                IF DBMS_RANDOM.VALUE(0, 100) <= NVL(segment_rec.target_percentage, 50) THEN
                    EXIT;
                END IF;
            ELSE
                EXIT;
            END IF;
        END LOOP;

        -- Insert assignment
        IF v_segment_id IS NOT NULL THEN
            INSERT INTO USER_SEGMENT_ASSIGNMENTS (
                user_id, segment_id, deployment_id,
                assignment_method, assignment_hash, is_active
            ) VALUES (
                p_user_id, v_segment_id, p_deployment_id,
                v_assignment_method, v_user_hash, 'Y'
            );

            -- Update segment count
            UPDATE USER_SEGMENTS
            SET current_user_count = current_user_count + 1
            WHERE segment_id = v_segment_id;

            COMMIT;
        END IF;

        RETURN v_segment_id;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20003, 
                'Failed to assign segment: ' || SQLERRM);
    END assign_user_to_segment;
/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Check if user in segment
     */
    FUNCTION is_user_in_segment(
        p_user_id   IN NUMBER,
        p_segment_id IN NUMBER
    ) RETURN BOOLEAN IS
        v_count NUMBER;
          vcaller constant varchar2(70):= c_package_name ||'.is_user_in_segment'; 
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM USER_SEGMENT_ASSIGNMENTS
        WHERE user_id = p_user_id
          AND segment_id = p_segment_id
          AND is_active = 'Y';

        RETURN (v_count > 0);
    END is_user_in_segment;
/*******************************************************************************
 *  
 *******************************************************************************/

    /**
     * Execute shadow deployment
     */
    PROCEDURE execute_shadow_deployment(
        p_production_call_id    IN NUMBER,
        p_shadow_deployment_id  IN NUMBER,
        p_execution_mode        IN VARCHAR2 DEFAULT 'ASYNC'
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.execute_shadow_deployment'; 
        v_prod_rec      CHAT_CALLS%ROWTYPE;
        v_shadow_call_id NUMBER;
    BEGIN
        SELECT *
        INTO v_prod_rec
        FROM CHAT_CALLS
        WHERE call_id = p_production_call_id;

        -- Create shadow call record
        INSERT INTO CHAT_CALLS (
            chat_session_id, provider, model, user_prompt,
            system_instructions, deployment_id,
            is_shadow_call, shadow_parent_call_id,
            temperature, max_tokens, top_p
        ) VALUES (
            v_prod_rec.chat_session_id,
            v_prod_rec.provider,
            v_prod_rec.model,
            v_prod_rec.user_prompt,
            v_prod_rec.system_instructions,
            p_shadow_deployment_id,
            'Y',
            p_production_call_id,
            v_prod_rec.temperature,
            v_prod_rec.max_tokens,
            v_prod_rec.top_p
        ) RETURNING call_id INTO v_shadow_call_id;

        IF p_execution_mode = 'ASYNC' THEN
            COMMIT;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
               debug_util.error(sqlerrm,vcaller);  
            DBMS_OUTPUT.PUT_LINE('Shadow execution failed: ' || SQLERRM);
    END execute_shadow_deployment;
/*******************************************************************************
 *  
 *******************************************************************************/

    /**
     * Calculate deployment metrics
     */
    PROCEDURE calculate_deployment_metrics(
    p_deployment_id IN NUMBER,
    p_metric_date   IN DATE DEFAULT TRUNC(SYSDATE)
) IS
  vcaller constant varchar2(70):= c_package_name ||'.calculate_deployment_metrics'; 
BEGIN
    MERGE INTO DEPLOYMENT_METRICS m
    USING (
        SELECT 
            p_deployment_id AS deployment_id,
            segment_id,
            p_metric_date AS metric_date,
            NULL AS metric_hour,
            COUNT(*) AS total_calls,
            SUM(CASE WHEN success = 'Y' THEN 1 ELSE 0 END) AS successful_calls,
            SUM(CASE WHEN success = 'N' THEN 1 ELSE 0 END) AS failed_calls,
            SUM(CASE WHEN is_blocked = 'Y' THEN 1 ELSE 0 END) AS blocked_calls,
            SUM(CASE WHEN is_refusal = 'Y' THEN 1 ELSE 0 END) AS refusal_calls,
            
            ROUND(AVG(total_pipeline_ms), 2) AS avg_total_pipeline_ms,
            PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_pipeline_ms) AS p50_total_pipeline_ms,
            PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY total_pipeline_ms) AS p95_total_pipeline_ms,
            PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY total_pipeline_ms) AS p99_total_pipeline_ms,
            MAX(total_pipeline_ms) AS max_total_pipeline_ms,
            ROUND(AVG(client_llm_call_ms), 2) AS avg_llm_call_ms,
            ROUND(AVG(rag_ms), 2) AS avg_rag_ms,
            ROUND(AVG(governance_ms), 2) AS avg_governance_ms,
            
            SUM(tokens_input) AS total_tokens_input,
            SUM(tokens_output) AS total_tokens_output,
            SUM(tokens_total) AS total_tokens,
            ROUND(AVG(tokens_total), 2) AS avg_tokens_per_call,
            
            SUM(cost_usd) AS total_cost_usd,
            ROUND(AVG(cost_usd), 6) AS avg_cost_per_call,
            
            COUNT(user_rating) AS total_ratings,
            SUM(CASE WHEN user_rating = 'LIKE' THEN 1 ELSE 0 END) AS positive_ratings,
            SUM(CASE WHEN user_rating = 'DISLIKE' THEN 1 ELSE 0 END) AS negative_ratings,
            SUM(CASE WHEN user_rating = 'NEUTRAL' THEN 1 ELSE 0 END) AS neutral_ratings,
            SUM(CASE WHEN user_rating = 'EXCELLENT' THEN 1 ELSE 0 END) AS excellent_ratings,
            
            SUM(CASE WHEN safety_filter_applied = 'Y' THEN 1 ELSE 0 END) AS safety_blocks,
            SUM(CASE WHEN is_truncated = 'Y' THEN 1 ELSE 0 END) AS truncations,
            
            COUNT(DISTINCT chat_session_id) AS unique_users,
            ROUND(AVG(rag_context_doc_count), 2) AS avg_rag_doc_count,
            SUM(CASE WHEN rag_enabled = 'Y' THEN 1 ELSE 0 END) AS rag_enabled_calls
            
        FROM CHAT_CALLS
        WHERE deployment_id = p_deployment_id
          AND TRUNC(db_created_at) = p_metric_date
          AND is_shadow_call = 'N'
        GROUP BY segment_id
    ) src
    ON (
        m.deployment_id = src.deployment_id 
        AND m.metric_date = src.metric_date
        AND (
            (m.segment_id = src.segment_id) 
            OR (m.segment_id IS NULL AND src.segment_id IS NULL)
        )
    )
    WHEN MATCHED THEN UPDATE SET
        m.total_calls = src.total_calls,
        m.successful_calls = src.successful_calls,
        m.failed_calls = src.failed_calls,
        m.blocked_calls = src.blocked_calls,
        m.refusal_calls = src.refusal_calls,
        m.avg_total_pipeline_ms = src.avg_total_pipeline_ms,
        m.p50_total_pipeline_ms = src.p50_total_pipeline_ms,
        m.p95_total_pipeline_ms = src.p95_total_pipeline_ms,
        m.p99_total_pipeline_ms = src.p99_total_pipeline_ms,
        m.max_total_pipeline_ms = src.max_total_pipeline_ms,
        m.avg_llm_call_ms = src.avg_llm_call_ms,
        m.avg_rag_ms = src.avg_rag_ms,
        m.avg_governance_ms = src.avg_governance_ms,
        m.total_tokens_input = src.total_tokens_input,
        m.total_tokens_output = src.total_tokens_output,
        m.total_tokens = src.total_tokens,
        m.avg_tokens_per_call = src.avg_tokens_per_call,
        m.total_cost_usd = src.total_cost_usd,
        m.avg_cost_per_call = src.avg_cost_per_call,
        m.total_ratings = src.total_ratings,
        m.positive_ratings = src.positive_ratings,
        m.negative_ratings = src.negative_ratings,
        m.neutral_ratings = src.neutral_ratings,
        m.excellent_ratings = src.excellent_ratings,
        m.safety_blocks = src.safety_blocks,
        m.truncations = src.truncations,
        m.unique_users = src.unique_users,
        m.avg_rag_doc_count = src.avg_rag_doc_count,
        m.rag_enabled_calls = src.rag_enabled_calls,
        m.calculated_at = SYSTIMESTAMP
    WHEN NOT MATCHED THEN INSERT (
        deployment_id, segment_id, metric_date, metric_hour,
        total_calls, successful_calls, failed_calls, blocked_calls, refusal_calls,
        avg_total_pipeline_ms, p50_total_pipeline_ms, p95_total_pipeline_ms,
        p99_total_pipeline_ms, max_total_pipeline_ms, avg_llm_call_ms, avg_rag_ms, avg_governance_ms,
        total_tokens_input, total_tokens_output, total_tokens, avg_tokens_per_call,
        total_cost_usd, avg_cost_per_call,
        total_ratings, positive_ratings, negative_ratings, neutral_ratings, excellent_ratings,
        safety_blocks, truncations, unique_users, avg_rag_doc_count, rag_enabled_calls
    ) VALUES (
        src.deployment_id, src.segment_id, src.metric_date, src.metric_hour,
        src.total_calls, src.successful_calls, src.failed_calls, src.blocked_calls, src.refusal_calls,
        src.avg_total_pipeline_ms, src.p50_total_pipeline_ms, src.p95_total_pipeline_ms,
        src.p99_total_pipeline_ms, src.max_total_pipeline_ms, src.avg_llm_call_ms, src.avg_rag_ms, src.avg_governance_ms,
        src.total_tokens_input, src.total_tokens_output, src.total_tokens, src.avg_tokens_per_call,
        src.total_cost_usd, src.avg_cost_per_call,
        src.total_ratings, src.positive_ratings, src.negative_ratings, src.neutral_ratings, src.excellent_ratings,
        src.safety_blocks, src.truncations, src.unique_users, src.avg_rag_doc_count, src.rag_enabled_calls
    );
    
    COMMIT;
END calculate_deployment_metrics;

/*******************************************************************************
 *  
 *******************************************************************************/

    /**
   /*******************************************************************************
 *  
     */
    PROCEDURE calculate_all_metrics(
        p_metric_date IN DATE DEFAULT TRUNC(SYSDATE)
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.calculate_all_metrics'; 
    BEGIN
        FOR dep_rec IN (
            SELECT deployment_id
            FROM DEPLOYMENT_VERSIONS
            WHERE is_active = 'Y'
        ) LOOP
            calculate_deployment_metrics(dep_rec.deployment_id, p_metric_date);
        END LOOP;
    END calculate_all_metrics;


    /**
     * Compare deployments
     */
    FUNCTION compare_deployments(
        p_deployment_id_a IN NUMBER,
        p_deployment_id_b IN NUMBER,
        p_start_date      IN DATE DEFAULT TRUNC(SYSDATE) - 7,
        p_end_date        IN DATE DEFAULT TRUNC(SYSDATE)
    ) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.compare_deployments'; 
        v_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'comparison_period' VALUE JSON_OBJECT(
                'start_date' VALUE TO_CHAR(p_start_date, 'YYYY-MM-DD'),
                'end_date' VALUE TO_CHAR(p_end_date, 'YYYY-MM-DD')
            ),
            'deployment_a' VALUE JSON_OBJECT(
                'deployment_id' VALUE p_deployment_id_a,
                'total_calls' VALUE SUM(CASE WHEN deployment_id = p_deployment_id_a THEN total_calls ELSE 0 END),
                'avg_latency_ms' VALUE ROUND(AVG(CASE WHEN deployment_id = p_deployment_id_a THEN avg_total_pipeline_ms END), 2),
                'p95_latency_ms' VALUE MAX(CASE WHEN deployment_id = p_deployment_id_a THEN p95_total_pipeline_ms END),
                'success_rate_pct' VALUE ROUND(
                    SUM(CASE WHEN deployment_id = p_deployment_id_a THEN successful_calls END) * 100.0 /
                    NULLIF(SUM(CASE WHEN deployment_id = p_deployment_id_a THEN total_calls END), 0), 2
                ),
                'total_cost_usd' VALUE ROUND(SUM(CASE WHEN deployment_id = p_deployment_id_a THEN total_cost_usd ELSE 0 END), 4),
                'positive_rating_pct' VALUE ROUND(
                    SUM(CASE WHEN deployment_id = p_deployment_id_a THEN positive_ratings END) * 100.0 /
                    NULLIF(SUM(CASE WHEN deployment_id = p_deployment_id_a THEN total_ratings END), 0), 2
                )
            ),
            'deployment_b' VALUE JSON_OBJECT(
                'deployment_id' VALUE p_deployment_id_b,
                'total_calls' VALUE SUM(CASE WHEN deployment_id = p_deployment_id_b THEN total_calls ELSE 0 END),
                'avg_latency_ms' VALUE ROUND(AVG(CASE WHEN deployment_id = p_deployment_id_b THEN avg_total_pipeline_ms END), 2),
                'p95_latency_ms' VALUE MAX(CASE WHEN deployment_id = p_deployment_id_b THEN p95_total_pipeline_ms END),
                'success_rate_pct' VALUE ROUND(
                    SUM(CASE WHEN deployment_id = p_deployment_id_b THEN successful_calls END) * 100.0 /
                    NULLIF(SUM(CASE WHEN deployment_id = p_deployment_id_b THEN total_calls END), 0), 2
                ),
                'total_cost_usd' VALUE ROUND(SUM(CASE WHEN deployment_id = p_deployment_id_b THEN total_cost_usd ELSE 0 END), 4),
                'positive_rating_pct' VALUE ROUND(
                    SUM(CASE WHEN deployment_id = p_deployment_id_b THEN positive_ratings END) * 100.0 /
                    NULLIF(SUM(CASE WHEN deployment_id = p_deployment_id_b THEN total_ratings END), 0), 2
                )
            )
            RETURNING CLOB
        )
        INTO v_json
        FROM DEPLOYMENT_METRICS
        WHERE deployment_id IN (p_deployment_id_a, p_deployment_id_b)
          AND metric_date BETWEEN p_start_date AND p_end_date;

        RETURN v_json;
    END compare_deployments;


    /**
     * Promote canary to production
     */
    PROCEDURE promote_canary_to_production(
        p_canary_deployment_id IN NUMBER
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.promote_canary_to_production'; 
        v_old_prod_id NUMBER;
    BEGIN
        BEGIN
            SELECT deployment_id INTO v_old_prod_id
            FROM DEPLOYMENT_VERSIONS
            WHERE deployment_type = 'PRODUCTION'
              AND is_active = 'Y';
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_old_prod_id := NULL;
        END;

        IF v_old_prod_id IS NOT NULL THEN
            UPDATE DEPLOYMENT_VERSIONS
            SET deployment_type = 'DRAFT',
                is_active = 'N',
                deactivated_at = SYSTIMESTAMP
            WHERE deployment_id = v_old_prod_id;

            log_deployment_event(v_old_prod_id, 'DEACTIVATED', 'PRODUCTION', 'DRAFT');
        END IF;

        UPDATE DEPLOYMENT_VERSIONS
        SET deployment_type = 'PRODUCTION',
            rollout_percentage = 100,
            promoted_at = SYSTIMESTAMP
        WHERE deployment_id = p_canary_deployment_id;

        log_deployment_event(p_canary_deployment_id, 'PROMOTED', 'CANARY', 'PRODUCTION');

        COMMIT;
    END promote_canary_to_production;


    /**
     * Activate deployment
     */
    PROCEDURE activate_deployment(p_deployment_id IN NUMBER) IS
      vcaller constant varchar2(70):= c_package_name ||'.activate_deployment'; 
    BEGIN
        UPDATE DEPLOYMENT_VERSIONS
        SET is_active = 'Y',
            deployment_status = 'ACTIVE',
            activated_at = SYSTIMESTAMP
        WHERE deployment_id = p_deployment_id;

        log_deployment_event(p_deployment_id, 'ACTIVATED', 'N', 'Y');

        COMMIT;
    END activate_deployment;


    /**
     * Pause deployment
     */
    PROCEDURE pause_deployment(p_deployment_id IN NUMBER) IS
      vcaller constant varchar2(70):= c_package_name ||'.pause_deployment'; 
    BEGIN
        UPDATE DEPLOYMENT_VERSIONS
        SET deployment_status = 'PAUSED'
        WHERE deployment_id = p_deployment_id;

        log_deployment_event(p_deployment_id, 'PAUSED', 'ACTIVE', 'PAUSED');

        COMMIT;
    END pause_deployment;


    /**
     * Deactivate deployment
     */
    PROCEDURE deactivate_deployment(p_deployment_id IN NUMBER) IS
      vcaller constant varchar2(70):= c_package_name ||'.deactivate_deployment'; 
    BEGIN
        UPDATE DEPLOYMENT_VERSIONS
        SET is_active = 'N',
            deployment_status = 'COMPLETED',
            deactivated_at = SYSTIMESTAMP
        WHERE deployment_id = p_deployment_id;

        log_deployment_event(p_deployment_id, 'DEACTIVATED', 'Y', 'N');

        COMMIT;
    END deactivate_deployment;


    /**
     * Log deployment event
     */
    PROCEDURE log_deployment_event(
        p_deployment_id IN NUMBER,
        p_event_type    IN VARCHAR2,
        p_old_value     IN VARCHAR2 DEFAULT NULL,
        p_new_value     IN VARCHAR2 DEFAULT NULL
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.log_deployment_event'; 
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO DEPLOYMENT_AUDIT_LOG (
            deployment_id, event_type, old_value, new_value
        ) VALUES (
            p_deployment_id, p_event_type, p_old_value, p_new_value
        );

        COMMIT;
    END log_deployment_event;


    /**
     * Additional helper functions
     */
    FUNCTION get_ab_variant(
        p_user_id       IN NUMBER,
        p_experiment_id IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_ab_variant'; 
        v_deployment_id NUMBER;
    BEGIN
        BEGIN
            SELECT deployment_id
            INTO v_deployment_id
            FROM USER_SEGMENT_ASSIGNMENTS
            WHERE user_id = p_user_id
              AND experiment_id = p_experiment_id
              AND is_active = 'Y';

            RETURN v_deployment_id;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;
        END;

        SELECT deployment_id
        INTO v_deployment_id
        FROM DEPLOYMENT_VERSIONS
        WHERE experiment_id = p_experiment_id
          AND deployment_type = 'AB_TEST'
          AND is_active = 'Y'
        ORDER BY DBMS_RANDOM.VALUE
        FETCH FIRST 1 ROWS ONLY;

        RETURN v_deployment_id;
    END get_ab_variant;


    FUNCTION is_user_in_canary(
        p_user_id               IN NUMBER,
        p_canary_deployment_id  IN NUMBER
    ) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_user_in_canary'; 
        v_user_hash     NUMBER;
        v_rollout_pct   NUMBER;
    BEGIN
        SELECT rollout_percentage
        INTO v_rollout_pct
        FROM DEPLOYMENT_VERSIONS
        WHERE deployment_id = p_canary_deployment_id;

        v_user_hash := get_user_hash(p_user_id);

        RETURN (v_user_hash <= v_rollout_pct);
    END is_user_in_canary;


    PROCEDURE increase_canary_rollout(
        p_canary_deployment_id  IN NUMBER,
        p_new_percentage        IN NUMBER
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.increase_canary_rollout'; 
        v_old_percentage NUMBER;
    BEGIN
        SELECT rollout_percentage
        INTO v_old_percentage
        FROM DEPLOYMENT_VERSIONS
        WHERE deployment_id = p_canary_deployment_id;

        UPDATE DEPLOYMENT_VERSIONS
        SET rollout_percentage = p_new_percentage
        WHERE deployment_id = p_canary_deployment_id;

        log_deployment_event(
            p_canary_deployment_id, 
            'ROLLOUT_INCREASED',
            TO_CHAR(v_old_percentage),
            TO_CHAR(p_new_percentage)
        );

        COMMIT;
    END increase_canary_rollout;


FUNCTION compare_shadow_results(
    p_production_call_id    IN NUMBER,
    p_shadow_call_id        IN NUMBER
) RETURN JSON IS
    vcaller constant varchar2(70):= c_package_name ||'.compare_shadow_results'; 
    v_comparison JSON;
BEGIN
    SELECT JSON_OBJECT(
        'production_call_id' VALUE p.call_id,
        'shadow_call_id' VALUE s.call_id,
        'response_match' VALUE CASE 
            WHEN DBMS_LOB.COMPARE(p.response_text, s.response_text) = 0 THEN 'EXACT'
            WHEN DBMS_LOB.COMPARE(
                DBMS_LOB.SUBSTR(p.response_text, 4000, 1),
                DBMS_LOB.SUBSTR(s.response_text, 4000, 1)
            ) = 0 THEN 'SIMILAR_PREFIX'
            ELSE 'DIFFERENT'
        END,
        'production_response_length' VALUE DBMS_LOB.GETLENGTH(p.response_text),
        'shadow_response_length' VALUE DBMS_LOB.GETLENGTH(s.response_text),
        'latency_diff_ms' VALUE (s.total_pipeline_ms - p.total_pipeline_ms),
        'latency_diff_pct' VALUE ROUND(
            (s.total_pipeline_ms - p.total_pipeline_ms) * 100.0 / 
            NULLIF(p.total_pipeline_ms, 0), 2
        ),
        'token_diff' VALUE (s.tokens_total - p.tokens_total),
        'token_diff_pct' VALUE ROUND(
            (s.tokens_total - p.tokens_total) * 100.0 / 
            NULLIF(p.tokens_total, 0), 2
        ),
        'cost_diff_usd' VALUE ROUND(s.cost_usd - p.cost_usd, 6),
        'cost_diff_pct' VALUE ROUND(
            (s.cost_usd - p.cost_usd) * 100.0 / 
            NULLIF(p.cost_usd, 0), 2
        ),
        'production_success' VALUE p.success,
        'shadow_success' VALUE s.success,
        'both_succeeded' VALUE CASE 
            WHEN p.success = 'Y' AND s.success = 'Y' THEN 'Y'
            ELSE 'N'
        END,
        'production_model' VALUE p.model,
        'shadow_model' VALUE s.model,
        'production_provider' VALUE p.provider,
        'shadow_provider' VALUE s.provider
        RETURNING JSON
    )
    INTO v_comparison
    FROM CHAT_CALLS p, CHAT_CALLS s
    WHERE p.call_id = p_production_call_id
      AND s.call_id = p_shadow_call_id
      AND p.is_shadow_call = 'N'
      AND s.is_shadow_call = 'Y';

    RETURN v_comparison;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       debug_util.error(sqlerrm,vcaller);  
        -- Return error JSON if calls not found
        RETURN JSON_OBJECT(
            'error' VALUE 'Calls not found',
            'production_call_id' VALUE p_production_call_id,
            'shadow_call_id' VALUE p_shadow_call_id
            RETURNING JSON
        );
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        -- Return error JSON
        RETURN JSON_OBJECT(
            'error' VALUE SQLERRM,
            'production_call_id' VALUE p_production_call_id,
            'shadow_call_id' VALUE p_shadow_call_id
            RETURNING JSON
        );
END compare_shadow_results;


 /***************************************************************************
     * Calculate statistical significance (p-value) between two deployments
     * Uses Welch's t-test for comparing means
     ***************************************************************************/
    FUNCTION calculate_statistical_significance(
        p_deployment_a_id NUMBER,
        p_deployment_b_id NUMBER,
        p_metric_type VARCHAR2 DEFAULT 'latency'
    ) RETURN NUMBER
    IS  vcaller constant varchar2(70):= c_package_name ||'.calculate_statistical_significance'; 
        v_mean_a NUMBER;
        v_mean_b NUMBER;
        v_stddev_a NUMBER;
        v_stddev_b NUMBER;
        v_count_a NUMBER;
        v_count_b NUMBER;
        v_t_statistic NUMBER;
        v_degrees_freedom NUMBER;
        v_p_value NUMBER;
        v_metric_column VARCHAR2(100);
    BEGIN
        -- Determine metric column
        v_metric_column := CASE p_metric_type
            WHEN 'latency' THEN 'processing_time_ms'
            WHEN 'tokens' THEN 'tokens_used'
            WHEN 'cost' THEN 'tokens_used * 0.002 / 1000'
            ELSE 'processing_time_ms'
        END;
        
        -- Get statistics for deployment A
        EXECUTE IMMEDIATE 
            'SELECT COUNT(*), AVG(' || v_metric_column || '), STDDEV(' || v_metric_column || ')
             FROM AI_CHAT_MESSAGES
             WHERE deployment_id = :1
               AND ' || v_metric_column || ' IS NOT NULL'
        INTO v_count_a, v_mean_a, v_stddev_a
        USING p_deployment_a_id;
        
        -- Get statistics for deployment B
        EXECUTE IMMEDIATE 
            'SELECT COUNT(*), AVG(' || v_metric_column || '), STDDEV(' || v_metric_column || ')
             FROM AI_CHAT_MESSAGES
             WHERE deployment_id = :1
               AND ' || v_metric_column || ' IS NOT NULL'
        INTO v_count_b, v_mean_b, v_stddev_b
        USING p_deployment_b_id;
        
        -- Check for sufficient data
        IF v_count_a < 2 OR v_count_b < 2 THEN
            RETURN NULL; -- Not enough data
        END IF;
        
        -- Calculate Welch's t-statistic
        v_t_statistic := ABS(v_mean_a - v_mean_b) / 
                         SQRT((POWER(v_stddev_a, 2) / v_count_a) + 
                              (POWER(v_stddev_b, 2) / v_count_b));
        
        -- Calculate degrees of freedom (Welch-Satterthwaite equation)
        v_degrees_freedom := POWER(
            (POWER(v_stddev_a, 2) / v_count_a) + (POWER(v_stddev_b, 2) / v_count_b),
            2
        ) / (
            POWER(POWER(v_stddev_a, 2) / v_count_a, 2) / (v_count_a - 1) +
            POWER(POWER(v_stddev_b, 2) / v_count_b, 2) / (v_count_b - 1)
        );
        
        -- Approximate p-value using t-distribution
        -- For simplicity, use rough approximation based on t-statistic
        -- p < 0.05 when t > 1.96 (for large df)
        IF v_t_statistic > 2.576 THEN
            v_p_value := 0.01; -- Very significant
        ELSIF v_t_statistic > 1.96 THEN
            v_p_value := 0.05; -- Significant
        ELSIF v_t_statistic > 1.645 THEN
            v_p_value := 0.10; -- Marginally significant
        ELSE
            v_p_value := 0.20; -- Not significant
        END IF;
        
        RETURN v_p_value;
        
    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            RETURN NULL;
    END calculate_statistical_significance;
/*******************************************************************************
 *  
 *******************************************************************************/
END DEPLOYMENT_MANAGER_PKG;

/
