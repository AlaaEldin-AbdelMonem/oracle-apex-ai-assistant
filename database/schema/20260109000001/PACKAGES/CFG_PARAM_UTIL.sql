--------------------------------------------------------
--  DDL for Package CFG_PARAM_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CFG_PARAM_UTIL" AS
/**
 * PROJECT:     Oracle Flexible Configuration Framework
 * MODULE:      CFG_PARAM_UTIL (Specification)
 * PURPOSE:     Centralized API for reading, writing, and managing configuration 
 * parameters across hierarchical scopes.
 *
 * DESCRIPTION: Implements a scoped parameter resolution engine:
 * Tenant -> App -> Role -> User -> Session.
 * Supports typed retrieval (String, Number, Boolean, Date, JSON).
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CFG_PARAM_UTIL';

    /*******************************************************************************
     * BASIC RETRIEVAL FUNCTIONS
     *
     * Example: 
     * v_val := CFG_PARAM_UTIL.get_value(
     * p_param_key => 'CHUNKING_STRATEGY', 
     * p_tenant_id => '1', 
     * p_app_id    => 119
     * );
     *******************************************************************************/

    /**
     * Function: get_value
     * Retrieves string value based on the highest-priority active scope.
     */
    FUNCTION get_value(
        p_param_key  IN VARCHAR2,
        p_tenant_id  IN VARCHAR2,
        p_app_id     IN NUMBER,
        p_user_name  IN VARCHAR2 DEFAULT USER,
        p_roles      IN SYS.ODCIVARCHAR2LIST DEFAULT NULL,
        p_session_id IN VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','SESSIONID')
    ) RETURN VARCHAR2;

    FUNCTION get_number(
        p_param_key IN VARCHAR2,
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN NUMBER;

    FUNCTION get_boolean(
        p_param_key IN VARCHAR2,
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN BOOLEAN;

    FUNCTION get_date(
        p_param_key IN VARCHAR2,
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN DATE;

    FUNCTION get_json(
        p_param_key IN VARCHAR2,
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN JSON_OBJECT_T;

    /*******************************************************************************
     * BULK RETRIEVAL
     *******************************************************************************/

    /**
     * Function: get_all
     * Returns a Ref Cursor for bulk retrieval of configuration parameters.
     */
    FUNCTION get_all(
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN SYS_REFCURSOR;

    /*******************************************************************************
     * WRITE / ADMIN OPERATIONS
     *******************************************************************************/

    /**
     * Procedure: set_value
     * Manages parameter persistence within a specific scope.
     * @param p_scope_type  'APP', 'ROLE', 'USER', 'SESSION'
     * @param p_is_secret   If 'Y', value is flagged for sensitive handling
     */
    PROCEDURE set_value(
        p_param_key   IN VARCHAR2,
        p_tenant_id   IN VARCHAR2,
        p_app_id      IN NUMBER,
        p_value       IN VARCHAR2,
        p_scope_type  IN VARCHAR2 DEFAULT 'APP',
        p_scope_value IN VARCHAR2 DEFAULT NULL,
        p_user        IN VARCHAR2 DEFAULT USER,
        p_is_secret   IN CHAR DEFAULT 'N'
    );

    /*******************************************************************************
     * VALIDATION & UTILITIES
     *******************************************************************************/

    FUNCTION param_exists(
        p_param_key IN VARCHAR2,
        p_tenant_id IN VARCHAR2,
        p_app_id    IN NUMBER
    ) RETURN BOOLEAN;

    /**
     * Procedure: clear_cache
     * Invalidates cached configuration to force a fresh retrieval.
     */
    PROCEDURE clear_cache;

END cfg_param_util;

/
