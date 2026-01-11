--------------------------------------------------------
--  DDL for Package CHAT_PROJECTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CHAT_PROJECTS_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHAT_PROJECTS_PKG (Specification)
 * PURPOSE:     Manage chat projects lifecycle including CRUD, default handling, 
 * and AI summarization tracking.
 *
 * DESCRIPTION: Provides a comprehensive API for managing workspace-like projects 
 * where chat sessions are organized. Includes logic for default 
 * project enforcement and soft-deletion.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 * DEPENDENCY:  CHAT_PROJECTS table
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHAT_PROJECTS_PKG';
    
    -- Custom Exceptions
    e_project_not_found       EXCEPTION;
    e_project_already_exists  EXCEPTION;
    e_default_project_exists  EXCEPTION;
    e_invalid_user            EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(e_project_not_found, -20001);
    PRAGMA EXCEPTION_INIT(e_project_already_exists, -20002);
    PRAGMA EXCEPTION_INIT(e_default_project_exists, -20003);
    PRAGMA EXCEPTION_INIT(e_invalid_user, -20004);

    /*******************************************************************************
     * PROJECT LIFECYCLE (CRUD)
     *******************************************************************************/

    /**
     * Function: add_project
     * Creates a new chat project container.
     * @return chat_project_id of the newly created record.
     */
    FUNCTION add_project(
        p_project_code          IN chat_projects.project_code%TYPE,
        p_project_name          IN chat_projects.project_name%TYPE,
        p_project_description   IN chat_projects.project_description%TYPE DEFAULT NULL,
        p_project_instructions  IN chat_projects.project_instructions%TYPE DEFAULT NULL,
        p_owner_user_id         IN chat_projects.owner_user_id%TYPE,
        p_is_default            IN chat_projects.is_default%TYPE DEFAULT 'N',
        p_tenant_id             IN chat_projects.tenant_id%TYPE DEFAULT NULL
    ) RETURN NUMBER;

    /**
     * Procedure: update_project_metadata
     * Updates basic textual attributes of a project.
     */
    PROCEDURE update_project_metadata(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE,
        p_project_code          IN chat_projects.project_code%TYPE DEFAULT NULL,
        p_project_name          IN chat_projects.project_name%TYPE DEFAULT NULL,
        p_project_description   IN chat_projects.project_description%TYPE DEFAULT NULL,
        p_project_instructions  IN chat_projects.project_instructions%TYPE DEFAULT NULL
    );

    /**
     * Procedure: delete_project
     * Performs a "Soft Delete" by flagging is_deleted and setting a timestamp.
     */
    PROCEDURE delete_project(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE
    );

    /*******************************************************************************
     * AI SUMMARIZATION TRACKING
     *******************************************************************************/

    /**
     * Procedure: update_project_summary
     * Stores AI-generated summaries for the project content.
     */
    PROCEDURE update_project_summary(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE,
        p_project_summary       IN chat_projects.project_summary%TYPE DEFAULT NULL,
        p_project_short_summary IN chat_projects.project_short_summary%TYPE DEFAULT NULL,
        p_update_timestamp      IN BOOLEAN DEFAULT TRUE
    );

    /*******************************************************************************
     * VALIDATION & STATUS MANAGEMENT
     *******************************************************************************/

    FUNCTION is_project_exists(p_project_code IN chat_projects.project_code%TYPE) RETURN BOOLEAN;

    PROCEDURE activate_project(p_chat_project_id IN chat_projects.chat_project_id%TYPE);

    PROCEDURE deactivate_project(p_chat_project_id IN chat_projects.chat_project_id%TYPE);

    FUNCTION get_project_id(p_project_code IN chat_projects.project_code%TYPE) RETURN NUMBER;

    /*******************************************************************************
     * DEFAULT PROJECT HANDLING
     *******************************************************************************/

    /**
     * Function: is_default_exists
     * Checks if the user currently has an assigned default project.
     */
    FUNCTION is_default_exists(p_user_id IN chat_projects.owner_user_id%TYPE) RETURN BOOLEAN;

    /**
     * Function: default_handling
     * Ensures user has a default project; automatically creates one if missing.
     * @return chat_project_id of the active default project.
     */
    FUNCTION default_handling(p_user_id IN chat_projects.owner_user_id%TYPE) RETURN NUMBER;

    /**
     * Procedure: set_default_project
     * Swaps the default flag to the specified project for a user.
     */
    PROCEDURE set_default_project(
        p_chat_project_id IN chat_projects.chat_project_id%TYPE,
        p_user_id         IN chat_projects.owner_user_id%TYPE
    );

END chat_projects_pkg;

/
