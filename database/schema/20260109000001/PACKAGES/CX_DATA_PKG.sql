--------------------------------------------------------
--  DDL for Package CX_DATA_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CX_DATA_PKG" 
AUTHID CURRENT_USER AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_DATA_PKG (Specification)
 * PURPOSE:     Low-level Data Access and Dynamic SQL Orchestration.
 *
 * DESCRIPTION: This package manages the technical execution of data queries. 
 * It handles registry metadata loading, role-based security filtering, 
 * dynamic SQL generation, and result set transformation into JSON.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_DATA_PKG';

    /*******************************************************************************
     * PRIMARY DATA API
     *******************************************************************************/

    /**
     * Function: get_data_json
     * Main entry point: Retrieves data and returns it as a JSON array of rows.
     * @param p_user_id      Current session user ID.
     * @param p_registry_id  The data source definition ID.
     * @param p_filter_ctx   JSON object containing runtime filters.
     * @return CLOB          JSON representation of the retrieved data.
     */
    FUNCTION get_data_json(
        p_user_id      IN NUMBER,
        p_registry_id  IN NUMBER,
        p_filter_ctx   IN CLOB DEFAULT NULL
    ) RETURN CLOB;

    /*******************************************************************************
     * REGISTRY & SECURITY MANAGEMENT
     *******************************************************************************/

    /**
     * Procedure: load_registry
     * Fetches metadata for a specific registry entry to guide SQL construction.
     */
    PROCEDURE load_registry(
        p_registry_id        IN NUMBER,
        p_source_name        OUT VARCHAR2,
        p_source_type        OUT VARCHAR2,
        p_mandatory_filters  OUT CLOB,
        p_security_level     OUT NUMBER
    );
     
    /**
     * Function: load_role_filter
     * Retrieves specific SQL predicates based on the user's roles and permissions.
     */
    FUNCTION load_role_filter(
        p_user_id     IN NUMBER,
        p_registry_id IN NUMBER
    ) RETURN CLOB;

    /*******************************************************************************
     * DYNAMIC SQL ORCHESTRATION
     *******************************************************************************/

    /**
     * Function: build_sql
     * Safely constructs a dynamic SQL string by merging filters and security predicates.
     * Prevents SQL injection by utilizing validated registry metadata.
     */
    FUNCTION build_sql(
        p_user_id        IN NUMBER,
        p_source_name    IN VARCHAR2,
        p_mand_filters   IN CLOB,
        p_role_filter    IN CLOB,
        p_filter_ctx     IN CLOB
    ) RETURN CLOB;

    /**
     * Function: run_query
     * Executes the constructed SQL and returns a local collection of rows.
     */
    FUNCTION run_query(
        p_sql CLOB
    ) RETURN t_data_row_tab;

END cx_data_pkg;

/
