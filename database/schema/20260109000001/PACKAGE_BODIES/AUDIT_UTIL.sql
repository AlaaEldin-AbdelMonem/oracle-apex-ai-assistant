--------------------------------------------------------
--  DDL for Package Body AUDIT_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AUDIT_UTIL" AS

    /***************************************************************************
     * PRIVATE INTERNAL LOGGING (AUTONOMOUS)
     ***************************************************************************/
    PROCEDURE write_to_log(
        p_event_type   IN VARCHAR2, 
        p_event_code   IN VARCHAR2, 
        p_message      IN VARCHAR2,
        p_extra_data   IN CLOB,
        p_caller       IN VARCHAR2,
        p_trace_id     IN VARCHAR2
    ) IS
        PRAGMA AUTONOMOUS_TRANSACTION;
         vcaller constant varchar2(70):= c_package_name ||'.write_to_log';
        v_app_id      NUMBER := NVL(V('APP_ID'), 0);
        v_page_id     NUMBER := NVL(V('APP_PAGE_ID'), 0);
        v_session_id  NUMBER := NVL(V('APP_SESSION'), 0);
        v_user_id     NUMBER :=  V('G_USER_ID') ;
        -- Define the specific error for Foreign Key Violation
            fk_violation EXCEPTION;
            PRAGMA EXCEPTION_INIT(fk_violation, -2291);
    BEGIN
        -- Resolve User ID for the Enterprise RAG System
        v_user_id := NV('G_USER_ID'); 
        
        IF v_user_id IS NULL AND V('APP_USER') IS NOT NULL THEN
            BEGIN
                SELECT user_id INTO v_user_id FROM users WHERE user_name = V('APP_USER');
            EXCEPTION WHEN OTHERS THEN v_user_id := NULL;
            END;
        END IF;

        -- MATCHING YOUR LATEST DDL EXACTLY
  INSERT INTO  DEBUG_AUDIT_LOG  (
            EVENT_TYPE,            -- Nature of event (SEC, FAIL, etc.)
            APP_ID,
            PAGE_ID,
            USER_ID,
            SESSION_ID,
            MODULE_NAME,
            MESSAGE,
            EXTRA_DATA,
            TRACE_ID,
            EVENT_CODE,            -- FIXED: Corrected from AUDIT_EVENT_CODE
            AUDIT_EVENT_TYPE_CODE, -- FK to LKP_DEBUG_AUDIT_EVENT_TYPES
            CREATED_AT
        ) VALUES (
            p_event_type,            
            v_app_id,
            v_page_id,
            v_user_id,
            v_session_id,
            p_caller,
            p_message,
            p_extra_data,
            p_trace_id,
            p_event_code,            -- Populating EVENT_CODE (Secondary Tier)
            p_event_type,            -- Populating AUDIT_EVENT_TYPE_CODE (Top Tier)
            SYSTIMESTAMP
        );

        COMMIT;
        EXCEPTION
            WHEN fk_violation THEN
             -- Log specific details about the missing parent keys
                debug_util.error(
                    'FK VIOLATION: Parent key not found. ' || 
                    'Attempted Event Type: [' || p_event_type || '], ' ||
                    'Attempted Event Code: [' || p_event_code || ']. ' ||
                    'Check LKP_DEBUG_AUDIT_EVENT_TYPES and associated lookup tables.',
                    vcaller
                );
                ROLLBACK;

            WHEN OTHERS THEN
                ROLLBACK;
                debug_util.error(SQLERRM, vcaller);
   END write_to_log;

    /***************************************************************************
     * PUBLIC INTERFACE
     ***************************************************************************/

    PROCEDURE log_audit(
        p_event_type   IN VARCHAR2,
        p_event_code   IN VARCHAR2,
        p_message      IN VARCHAR2,
        p_extra_data   IN CLOB     DEFAULT NULL,
        p_caller       IN VARCHAR2 DEFAULT NULL,
        p_trace_id     IN VARCHAR2 DEFAULT NULL
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_audit';
    BEGIN
        write_to_log(p_event_type, p_event_code, p_message, p_extra_data, p_caller, p_trace_id);
    END log_audit;
/*******************************************************************************
* -- Success Milestones (EVNT)
*******************************************************************************/
    
    PROCEDURE log_event(
        p_event_code IN VARCHAR2,
        p_message    IN VARCHAR2,
        p_trace_id   IN VARCHAR2 DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_event';
    BEGIN
        log_audit(c_type_event, p_event_code, p_message, NULL, p_caller, p_trace_id);
    END log_event;
/*******************************************************************************
* -- Security Actions (SEC)
*******************************************************************************/
    -- Security Actions (SEC)
    PROCEDURE log_security(
        p_event_code IN VARCHAR2,
        p_message    IN VARCHAR2,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT  NULL
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_security';
    BEGIN
        log_audit(c_type_security, p_event_code, p_message, NULL, p_caller, p_trace_id);
    END log_security;
/*******************************************************************************
*     -- Functional/KPI Failures (FAIL)
*******************************************************************************/

    PROCEDURE log_failure(
        p_event_code IN VARCHAR2,
        p_reason     IN VARCHAR2,
        p_context    IN CLOB     DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT NULL 
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_failure';
    BEGIN
        log_audit(c_type_fail, p_event_code, p_reason, p_context, p_caller, p_trace_id);
    END log_failure;
/*******************************************************************************
*  -- Data Sensitivity Audits (DATA)
*******************************************************************************/
    PROCEDURE log_data_change(
        p_event_code IN VARCHAR2,
        p_message    IN VARCHAR2,
        p_old_data   IN CLOB     DEFAULT NULL,
        p_new_data   IN CLOB     DEFAULT NULL,
        p_caller     IN VARCHAR2 DEFAULT NULL,
        p_trace_id   IN VARCHAR2 DEFAULT NULL 
    ) IS
     vcaller constant varchar2(70):= c_package_name ||'.log_data_change';
        l_combined CLOB;
    BEGIN
        l_combined := 'OLD: ' || p_old_data || CHR(10) || 'NEW: ' || p_new_data;
        log_audit(c_type_data, p_event_code, p_message, l_combined, p_caller, p_trace_id);
    END log_data_change;
/*******************************************************************************
* 
*******************************************************************************/
END audit_util;

/
