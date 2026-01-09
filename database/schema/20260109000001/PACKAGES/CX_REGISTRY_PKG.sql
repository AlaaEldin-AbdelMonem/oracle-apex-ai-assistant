--------------------------------------------------------
--  DDL for Package CX_REGISTRY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CX_REGISTRY_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_REGISTRY_PKG (Specification)
 * PURPOSE:     Data Source Registry and Access Control Management.
 *
 * DESCRIPTION: Centralizes the registration of structured data sources 
 * (Views, Tables, APIs). It maps these sources to specific 
 * Context Domains and enforces role-based security to ensure 
 * the AI only consumes data relevant to the user's permissions.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_REGISTRY_PKG';

    /*******************************************************************************
     * DATA TYPES
     *******************************************************************************/

    /**
     * Record: t_registry_obj
     * Encapsulates the metadata for a single structured data source.
     */
    TYPE t_registry_obj IS RECORD (
        context_registry_id        NUMBER,        -- Unique identifier for the registry entry
        source_title               VARCHAR2(200), -- Human-readable name for the source
        source_type_code           VARCHAR2(30),  -- e.g., VIEW, TABLE, PROCEDURE, API
        registry_source_type_code  VARCHAR2(30),  -- Specific registry category
        source_name                VARCHAR2(200), -- Actual DB object name or endpoint
        security_level             NUMBER,        -- Sensitivity level (1-5)
        mandatory_filters          CLOB,          -- Hard-coded SQL predicates or JSON filters
        role_filter                CLOB           -- Role-specific security predicates
    );

    /**
     * Table: t_registry_tab
     * Collection type for bulk retrieval of registry sources.
     */
    TYPE t_registry_tab IS TABLE OF t_registry_obj;

    /*******************************************************************************
     * REGISTRY LOOKUP API
     *******************************************************************************/

    /**
     * Function: get_registry_sources
     * Retrieves all data sources associated with a specific domain that the 
     * user's role is permitted to access.
     *
     * @param p_context_domain_id  The ID of the active Knowledge Domain.
     * @param p_role_id            The active security role of the user.
     * @return t_registry_tab      A collection of validated registry metadata objects.
     */
    FUNCTION get_registry_sources(
        p_context_domain_id IN NUMBER,
        p_role_id           IN NUMBER
    ) RETURN t_registry_tab;

END cx_registry_pkg;

/
