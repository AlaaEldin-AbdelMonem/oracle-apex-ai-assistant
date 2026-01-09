--------------------------------------------------------
--  DDL for Package CXD_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CXD_TYPES" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_TYPES (Specification)
 * PURPOSE:     Common Data Types for Context Domain and Intent Classification.
 *
 * DESCRIPTION: Central repository for classification-related record types. 
 * Defines the schema for requests and responses used by the 
 * LLM and Semantic classification engines.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_TYPES';

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/

    /**
     * Record: t_cxd_classifier_req
     * Input structure for initiating a classification request.
     */
    TYPE t_cxd_classifier_req IS RECORD (
        trace_id                VARCHAR2(200),
        chat_session_id         NUMBER,
        chat_call_id            NUMBER,
        chat_project_id         NUMBER,
        detection_method_code   VARCHAR2(35),
        context_domain_id       NUMBER,         -- Populated for 'MANUAL' method
        provider                VARCHAR2(70),   -- LLM Provider
        model                   VARCHAR2(200),  -- Specific LLM model
        cxd_required            CHAR(1),        -- Domain detection flag (Y/N)
        user_prompt             CLOB,           -- Raw user input
        intent_required         CHAR(1),        -- Intent detection flag (Y/N)
        intent_cxd_id           NUMBER,         -- Mandatory if intent_required='Y'
        user_id                 NUMBER,
        user_name               VARCHAR2(200),
        app_session_id          NUMBER,
        tenant_id               NUMBER,
        app_id                  NUMBER,
        app_page_id             NUMBER
    );

    /**
     * Record: t_cxd_classifier_resp
     * Result structure for Domain Context detection.
     */
    TYPE t_cxd_classifier_resp IS RECORD (
        trace_id                      VARCHAR2(200),
        chat_session_id               NUMBER,
        chat_call_id                  NUMBER,
        detection_method_code         VARCHAR2(35), -- Requested method
        final_detection_method_code   VARCHAR2(35), -- Actual method used (fallback logic)
        context_domain_id             NUMBER,
        context_domain_code           VARCHAR2(70),
        context_domain_name           VARCHAR2(200),
        context_domain_confidence     NUMBER,
        detect_status                 VARCHAR2(20), -- SUCCESS / FAIL
        message                       VARCHAR2(4000),
        search_time_ms                NUMBER,
        used_provider                 VARCHAR2(70),
        used_model                    VARCHAR2(100)
    );

    /**
     * Record: t_intent_classifier_resp
     * Result structure for User Intent detection.
     */
    TYPE t_intent_classifier_resp IS RECORD ( 
        trace_id                      VARCHAR2(200),
        chat_session_id               NUMBER,
        chat_call_id                  NUMBER,
        detection_method_code         VARCHAR2(35),
        final_detection_method_code   VARCHAR2(35),
        intent_id                     NUMBER,
        intent_code                   VARCHAR2(70),
        intent_name                   VARCHAR2(200),
        intent_confidence             NUMBER,
        detect_status                 VARCHAR2(20), -- SUCCESS / FAIL
        message                       VARCHAR2(4000),
        search_time_ms                NUMBER,
        used_provider                 VARCHAR2(70),
        used_model                    VARCHAR2(100)
    );


    ----------------------------------------------------------------------------
    -- SERIALIZATION UTILITIES
    ----------------------------------------------------------------------------
    -- Overloaded functions to convert any record type to JSON CLOB
    FUNCTION to_json(p_rec t_cxd_classifier_req)   RETURN CLOB;
    FUNCTION to_json(p_rec t_cxd_classifier_resp)  RETURN CLOB;
    FUNCTION to_json(p_rec t_intent_classifier_resp) RETURN CLOB;
    
END cxd_types;

/
