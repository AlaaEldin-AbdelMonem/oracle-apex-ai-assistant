--------------------------------------------------------
--  DDL for Package RAG_GOVERNANCE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "RAG_GOVERNANCE_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      RAG_GOVERNANCE_PKG (Specification)
 * PURPOSE:     Internal Pipeline Compliance and Security Enforcement.
 *
 * DESCRIPTION: Provides the core logic to enforce data sovereignty and 
 * process integrity within the RAG pipeline. It ensures that users 
 * possess the correct roles and clearance levels before a document 
 * can be processed, chunked, or retrieved for LLM context.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 * VERSION:     1.0.0
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'RAG_GOVERNANCE_PKG'; 

    /*******************************************************************************
     * ACCESS & ROLE ENFORCEMENT
     *******************************************************************************/

    /**
     * Procedure: enforce_access
     * Validates that the requesting user has the appropriate RBAC (Role-Based 
     * Access Control) permissions to interact with a specific document.
     * * @param p_user_id       The internal user identifier.
     * @param p_doc_id        The primary key of the target document.
     * @param p_required_role The minimum role required (Default: RAG_PROCESSOR).
     */
    PROCEDURE enforce_access(
        p_user_id        IN NUMBER,
        p_doc_id         IN NUMBER,
        p_required_role  IN VARCHAR2 DEFAULT 'RAG_PROCESSOR'
    );

    /*******************************************************************************
     * DATA CLASSIFICATION & CLEARANCE
     *******************************************************************************/

    /**
     * Procedure: enforce_classification
     * Compares the document's sensitivity label (e.g., Public, Internal, Secret) 
     * against the user's assigned clearance level.
     * * @param p_user_id             The user attempting access.
     * @param p_doc_id              The document being accessed.
     * @param p_user_clearance_lvl  Numerical value representing user clearance (1-5).
     */
    PROCEDURE enforce_classification(
        p_user_id              IN NUMBER,
        p_doc_id               IN NUMBER,
        p_user_clearance_lvl   IN NUMBER
    );

    /*******************************************************************************
     * PIPELINE INTEGRITY
     *******************************************************************************/

    /**
     * Procedure: verify_pipeline_allowed
     * Controls the state machine of the document pipeline. 
     * Prevents operations (like Embedding) if previous mandatory steps 
     * (like Extraction or Governance Approval) have not been completed.
     * * @param p_doc_id     The document ID.
     * @param p_stage_name The stage being attempted (CHUNK, EMBED, RETRIEVE).
     */
    PROCEDURE verify_pipeline_allowed(
        p_doc_id     IN NUMBER,
        p_stage_name IN VARCHAR2
    );

END rag_governance_pkg;

/
