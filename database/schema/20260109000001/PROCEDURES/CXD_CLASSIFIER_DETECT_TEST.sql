--------------------------------------------------------
--  DDL for Procedure CXD_CLASSIFIER_DETECT_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "CXD_CLASSIFIER_DETECT_TEST" as
/*******************************************************************************
 *  
 *******************************************************************************/
vcaller varchar2(100):= 'cxd_classifier_detect_test';
    v_domain_detect_req   CXD_TYPES.t_cxd_classifier_req;
    v_detect_resp_Domain  CXD_TYPES.t_cxd_classifier_resp;
    v_detect_resp_Intent  CXD_TYPES.t_intent_classifier_resp;
BEGIN
     debug_util.info('========================================' ,vcaller);
     debug_util.info('TEST: CXD_CLASSIFIER_LLM_PKG.detect' ,vcaller);
     debug_util.info('========================================' ,vcaller);

    -- Initialize APEX session
    APEX_SESSION.CREATE_SESSION(
        p_app_id   => 119,
        p_page_id  => 100,
        p_username => 'AI',
        p_call_post_authentication => FALSE
    );
    COMMIT;

    -- Build request
    v_domain_detect_req.trace_id := 'TEST-001';
    v_domain_detect_req.cxd_required := 'Y';
    v_domain_detect_req.detection_Method_code := 'AUTO';
    v_domain_detect_req.context_domain_id := NULL;
    v_domain_detect_req.provider := 'OPENAI';
    v_domain_detect_req.model := 'gpt-4o-mini';
    v_domain_detect_req.user_prompt := 'What is my current salary?';
    v_domain_detect_req.chat_session_id := NULL;
    v_domain_detect_req.user_id := 4;
    v_domain_detect_req.user_name := 'AI';
    v_domain_detect_req.app_session_id := v('APP_SESSION');
    v_domain_detect_req.tenant_id := 0;
    v_domain_detect_req.chat_project_id := -2;
    v_domain_detect_req.app_id := 119;
    v_domain_detect_req.app_page_id := 100;

     debug_util.info('Calling cxd_classifier_pkg.detect...' ,vcaller);
     debug_util.info('' ,vcaller);

    BEGIN
        cxd_classifier_pkg.detect(
            p_req         => v_domain_detect_req,
            P_resp_Domain => v_detect_resp_Domain,
            P_resp_Intent => v_detect_resp_Intent
        );

         debug_util.info('✅ detect() completed successfully' ,vcaller ,vcaller);
         debug_util.info('' ,vcaller);
         debug_util.info('Domain Response:' ,vcaller);
         debug_util.info('  context_domain_id: ' || NVL(TO_CHAR(v_detect_resp_Domain.context_domain_id), 'NULL') ,vcaller);
         debug_util.info('  context_domain_code: ' || NVL(v_detect_resp_Domain.context_domain_code , 'NULL')  ,vcaller);
         debug_util.info('  detection_method: ' || NVL(v_detect_resp_Domain.detection_method_code, 'NULL') ,vcaller);
       -- debug_util.info('  confidence: ' || NVL(TO_CHAR(v_detect_resp_Domain.confidence)), 'NULL'  ,vcaller);

    EXCEPTION
        WHEN OTHERS THEN
             debug_util.info('❌ ERROR in detect(): ' || SQLERRM ,vcaller);
             debug_util.info('Error Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK ,vcaller);
             debug_util.info('Error Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ,vcaller);
    END;

     debug_util.info('',vcaller);
     debug_util.info('========================================' ,vcaller);

END;

/
