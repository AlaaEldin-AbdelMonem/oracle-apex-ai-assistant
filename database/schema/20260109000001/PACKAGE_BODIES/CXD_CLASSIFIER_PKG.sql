--------------------------------------------------------
--  DDL for Package Body CXD_CLASSIFIER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CXD_CLASSIFIER_PKG" AS

 
 /*******************************************************************************
 *  
 *******************************************************************************/
    -- Reset Manual Override
     
    PROCEDURE reset_user_domain(
        p_user_id IN NUMBER
    )
    IS
      vcaller constant varchar2(70):= c_package_name ||'.reset_user_domain';
    BEGIN
        UPDATE CHAT_SESSIONS
        SET context_domain_id = NULL
        WHERE user_id = p_user_id;

        COMMIT;
    END reset_user_domain;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- INTERNAL: Get default domain
    ----------------------
    FUNCTION get_default_domain RETURN NUMBER
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_default_domain';
        v_domain_id NUMBER;
    BEGIN
        SELECT context_domain_id
        INTO v_domain_id
        FROM context_domains
        WHERE is_default = 'Y'
        FETCH FIRST 1 ROW ONLY;

        RETURN v_domain_id;
    EXCEPTION WHEN NO_DATA_FOUND THEN
          DEBUG_UTIL.warn('No Active Context Found',vcaller);
          RETURN NULL;
        WHEN OTHERS  THEN
            DEBUG_UTIL.error(SQLERRM,vcaller);
        RETURN NULL;
    END get_default_domain;
/*******************************************************************************
 *  
 *******************************************************************************/
    function get_domain_context_id (p_context_domain_code in varchar2) return number
    is
    vcaller constant varchar2(70):= c_package_name ||'.get_domain_context_id';
    v_context_domain_id number;
    v_context_domain_name varchar2(130);
     begin

           SELECT    context_domain_id,  DOMAIN_NAME
              INTO v_context_domain_id,  v_context_domain_name
              FROM context_domains
            WHERE context_domain_code = p_context_domain_code;

           return v_context_domain_id;
       
              
     exception
        when others then  
           DEBUG_UTIL.error(SQLERRM,vcaller);
        return null;
      end get_domain_context_id;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- MAIN  : detect_domain()
    -- Using detection type:
    --   1 AUTO    → LLM then VECTOR fallback
    --   2 MANUAL  → user selection only
    --   3 VECTOR  → semantic similarity only
    --   4 LLM     → LLM only, no fallback
    -------------------------
    
PROCEDURE detect(
    p_req          IN  CXD_TYPES.t_cxd_classifier_req,
    p_resp_domain  OUT CXD_TYPES.t_cxd_classifier_resp,
    p_resp_intent  OUT CXD_TYPES.t_intent_classifier_resp
)
IS
    vcaller  CONSTANT VARCHAR2(70) := c_package_name || '.detect';
    v_trace_id        VARCHAR2(200) := p_req.trace_id;

    v_req             CXD_TYPES.t_cxd_classifier_req := p_req;
    v_domain_resp     CXD_TYPES.t_cxd_classifier_resp;
    v_intent_resp     CXD_TYPES.t_intent_classifier_resp;

    v_domain_id       NUMBER;
    v_success         BOOLEAN := FALSE;

    v_msg             VARCHAR2(4000);
BEGIN
    DEBUG_UTIL.starting(vcaller,
        'Detection method=' || p_req.detection_method_code,
        v_trace_id
    );

    DEBUG_UTIL.info(
        'Provider=' || p_req.provider || ', Model=' || p_req.model,
        vcaller, v_trace_id
    );

    /* =========================================================
       MANUAL OVERRIDE
       ========================================================= */
    IF p_req.detection_method_code = 'MANUAL' THEN
        IF p_req.context_domain_id IS NULL THEN
            v_msg := 'Manual detection failed: CONTEXT_DOMAIN_ID is NULL';
            GOTO fail;
        END IF;

        v_domain_id := p_req.context_domain_id;
        v_domain_resp.final_detection_method_code := 'MANUAL';
        v_success := TRUE;

    /* =========================================================
       LLM / AUTO
       ========================================================= */
    ELSIF p_req.detection_method_code IN ('AUTO', 'LLM') THEN
        DEBUG_UTIL.info('Attempting LLM detection', vcaller, v_trace_id);

        v_req.detection_method_code := NULL;

        CXD_CLASSIFIER_LLM_PKG.detect(
            p_req             => v_req,
            p_response_domain => v_domain_resp,
            p_response_intent => v_intent_resp
        );

        v_domain_id := v_domain_resp.context_domain_id;

        IF v_domain_id IS NOT NULL THEN
            v_domain_resp.final_detection_method_code := 'LLM';
            v_success := TRUE;

        ELSIF p_req.detection_method_code = 'AUTO' THEN
            /* ---------- AUTO fallback ---------- */
            DEBUG_UTIL.info('LLM failed → VECTOR fallback', vcaller, v_trace_id);

            audit_util.log_failure(
                p_event_code => 'AI_ERR',
                p_reason     => 'LLM returned NULL, fallback to VECTOR',
                p_caller     => vcaller,
                p_trace_id   => v_trace_id
            );

            CXD_CLASSIFIER_SEMANTIC_PKG.detect(
                p_req             => v_req,
                p_response_domain => v_domain_resp,
                p_response_intent => v_intent_resp
            );

            v_domain_id := v_domain_resp.context_domain_id;

            IF v_domain_id IS NOT NULL THEN
                v_domain_resp.final_detection_method_code := 'VECTOR';
                v_success := TRUE;
            END IF;
        END IF;

    /* =========================================================
       VECTOR ONLY
       ========================================================= */
    ELSIF p_req.detection_method_code = 'VECTOR' THEN
        DEBUG_UTIL.info('Attempting VECTOR detection', vcaller, v_trace_id);

        CXD_CLASSIFIER_SEMANTIC_PKG.detect(
            p_req             => v_req,
            p_response_domain => v_domain_resp,
            p_response_intent => v_intent_resp
        );

        v_domain_id := v_domain_resp.context_domain_id;

        IF v_domain_id IS NOT NULL THEN
            v_domain_resp.final_detection_method_code := 'VECTOR';
            v_success := TRUE;
        END IF;
    END IF;

    /* =========================================================
       FINALIZATION
       ========================================================= */
    IF v_success THEN
        v_domain_resp.context_domain_id := v_domain_id;
        v_domain_resp.detect_status := 'SUCCESS';

        p_resp_domain := v_domain_resp;
        p_resp_intent := v_intent_resp;

        audit_util.log_event(
            p_event_code => 'PROC_OK',
            p_message    => 'Domain detected via ' ||
                            v_domain_resp.final_detection_method_code,
            p_caller     => vcaller,
            p_trace_id   => v_trace_id
        );

        DEBUG_UTIL.ending(vcaller, 'SUCCESS', v_trace_id);
        RETURN;
    END IF;

<<fail>>
    v_msg := 'Domain detection failed using ' ||
             NVL(p_req.detection_method_code, 'AUTO');

    DEBUG_UTIL.error(v_msg, vcaller, v_trace_id);

    audit_util.log_failure(
        p_event_code => 'AI_ERR',
        p_reason     => v_msg,
        p_caller     => vcaller,
        p_trace_id   => v_trace_id
    );

    p_resp_domain.detect_status := 'FAIL';
    p_resp_domain.message := v_msg;
    p_resp_domain.context_domain_id := NULL;
    p_resp_intent := v_intent_resp;

EXCEPTION
    WHEN OTHERS THEN
        v_msg := 'Classifier orchestration error: ' || SQLERRM;

        DEBUG_UTIL.error(v_msg, vcaller, v_trace_id);

        audit_util.log_failure(
            p_event_code => 'SYS_DEP',
            p_reason     => v_msg,
            p_caller     => vcaller,
            p_trace_id   => v_trace_id
        );

        p_resp_domain.detect_status := 'FAIL';
        p_resp_domain.message := 'System error during domain detection';
        p_resp_domain.context_domain_id := NULL;
END detect;
    
/*******************************************************************************
 *  
 *******************************************************************************/
END cxd_classifier_pkg;

/
