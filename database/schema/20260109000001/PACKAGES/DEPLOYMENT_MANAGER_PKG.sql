--------------------------------------------------------
--  DDL for Package DEPLOYMENT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."DEPLOYMENT_MANAGER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      DEPLOYMENT_MANAGER_PKG (Specification)
 * PURPOSE:     AI Model Deployment, Rollout, and Experimentation Management.
 *
 * DESCRIPTION: Orchestrates the lifecycle of LLM deployments. Supports 
 * Canary rollouts, A/B testing variants, and Shadow mode (parallel 
 * execution for validation). Includes statistical significance 
 * calculations and safety-based automated blocking.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'DEPLOYMENT_MANAGER_PKG'; 

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/

    /**
     * Record: t_deployment_info
     * Complete metadata for an active deployment or experiment variant.
     */
    TYPE t_deployment_info IS RECORD (
        deployment_id       NUMBER,
        deployment_name     VARCHAR2(100),
        deployment_type     VARCHAR2(20),  -- CANARY, SHADOW, PROD, AB_TEST
        provider            VARCHAR2(50),  -- OCI, OpenAI, Gemini
        model_name          VARCHAR2(100),
        config_json         JSON,
        rollout_percentage  NUMBER,
        segment_id          NUMBER,
        variant_label       VARCHAR2(10)
    );

    TYPE t_deployment_list IS TABLE OF t_deployment_info;

    /*******************************************************************************
     * CORE ROUTING & DISPATCH
     *******************************************************************************/

    /**
     * Function: get_user_deployment
     * Determines which deployment ID should serve a specific user session.
     * Considers: Sticky sessions, segments, and rollout percentages.
     */
    FUNCTION get_user_deployment(
        p_user_id            IN NUMBER,
        p_session_id         IN NUMBER DEFAULT NULL,
        p_context_domain_id  IN NUMBER DEFAULT NULL
    ) RETURN NUMBER;

    /**
     * Function: get_user_deployments
     * Retrieves all active deployments for a user, including shadow deployments
     * that should run in the background for validation.
     */
    FUNCTION get_user_deployments(
        p_user_id            IN NUMBER
    ) RETURN t_deployment_list;

    /*******************************************************************************
     * SEGMENTATION & A/B TESTING
     *******************************************************************************/

    FUNCTION assign_user_to_segment(
        p_user_id            IN NUMBER,
        p_deployment_id      IN NUMBER,
        p_force_reassign     IN BOOLEAN DEFAULT FALSE
    ) RETURN NUMBER;

    FUNCTION is_user_in_segment(
        p_user_id            IN NUMBER,
        p_segment_id         IN NUMBER
    ) RETURN BOOLEAN;

    FUNCTION get_ab_variant(
        p_user_id            IN NUMBER,
        p_experiment_id      IN NUMBER
    ) RETURN NUMBER;

    /*******************************************************************************
     * SHADOW DEPLOYMENT (DARK LAUNCH)
     *******************************************************************************/

    /**
     * Procedure: execute_shadow_deployment
     * Runs a secondary model in parallel to production to evaluate performance 
     * without affecting the user experience.
     */
    PROCEDURE execute_shadow_deployment(
        p_production_call_id    IN NUMBER,
        p_shadow_deployment_id  IN NUMBER,
        p_execution_mode        IN VARCHAR2 DEFAULT 'ASYNC' -- SYNC | ASYNC
    );

    FUNCTION compare_shadow_results(
        p_production_call_id    IN NUMBER,
        p_shadow_call_id        IN NUMBER
    ) RETURN JSON;

    /*******************************************************************************
     * CANARY ROLLOUT MANAGEMENT
     *******************************************************************************/

    FUNCTION is_user_in_canary(
        p_user_id               IN NUMBER,
        p_canary_deployment_id  IN NUMBER
    ) RETURN BOOLEAN;

    PROCEDURE increase_canary_rollout(
        p_canary_deployment_id  IN NUMBER,
        p_new_percentage        IN NUMBER
    );

    PROCEDURE promote_canary_to_production(
        p_canary_deployment_id  IN NUMBER
    );

    /*******************************************************************************
     * METRICS, ANALYSIS & SAFETY
     *******************************************************************************/

    PROCEDURE calculate_deployment_metrics(
        p_deployment_id     IN NUMBER,
        p_metric_date       IN DATE DEFAULT TRUNC(SYSDATE)
    );

    PROCEDURE calculate_all_metrics(
        p_metric_date       IN DATE DEFAULT TRUNC(SYSDATE)
    );

    /**
     * Function: compare_deployments
     * Returns a CLOB (JSON) report comparing latency, cost, and quality 
     * between two deployment IDs.
     */
    FUNCTION compare_deployments(
        p_deployment_id_a   IN NUMBER,
        p_deployment_id_b   IN NUMBER,
        p_start_date        IN DATE DEFAULT TRUNC(SYSDATE) - 7,
        p_end_date          IN DATE DEFAULT TRUNC(SYSDATE)
    ) RETURN CLOB;

    /**
     * Function: should_block_deployment
     * Safety circuit breaker. Returns TRUE if error rates or latency exceed thresholds.
     */
    FUNCTION should_block_deployment(p_deployment_id IN NUMBER) RETURN BOOLEAN;

    FUNCTION calculate_statistical_significance(
        p_deployment_a_id   IN NUMBER,
        p_deployment_b_id   IN NUMBER,
        p_metric_type       IN VARCHAR2 DEFAULT 'latency'
    ) RETURN NUMBER;

    /*******************************************************************************
     * LIFECYCLE CONTROLS
     *******************************************************************************/

    PROCEDURE activate_deployment(p_deployment_id IN NUMBER);

    PROCEDURE pause_deployment(p_deployment_id IN NUMBER);

    PROCEDURE deactivate_deployment(p_deployment_id IN NUMBER);

    PROCEDURE log_deployment_event(
        p_deployment_id     IN NUMBER,
        p_event_type        IN VARCHAR2,
        p_old_value         IN VARCHAR2 DEFAULT NULL,
        p_new_value         IN VARCHAR2 DEFAULT NULL
    );

END deployment_manager_pkg;

/
