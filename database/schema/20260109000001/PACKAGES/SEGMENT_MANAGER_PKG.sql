--------------------------------------------------------
--  DDL for Package SEGMENT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "SEGMENT_MANAGER_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      SEGMENT_MANAGER_PKG (Specification)
 * PURPOSE:     User Segmentation and Knowledge Boundary Management.
 *
 * DESCRIPTION: Handles the logical partitioning of users and data. 
 * This package is responsible for calculating segment population metrics 
 * and executing bulk user-assignment logic to ensure users are correctly 
 * aligned with specific knowledge domains or security groups.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'SEGMENT_MANAGER_PKG'; 

    /*******************************************************************************
     * METRIC REFRESH OPERATIONS
     *******************************************************************************/

    /**
     * Procedure: refresh_segment_count
     * Updates the denormalized user count for a specific segment.
     * Used for real-time dashboarding in the APEX administration console.
     * @param p_segment_id The unique identifier of the segment.
     */
    PROCEDURE refresh_segment_count(
        p_segment_id IN NUMBER
    );
    
    /**
     * Procedure: refresh_all_segment_counts
     * Iterates through all active segments to synchronize member counts.
     * Typically scheduled as a background maintenance job.
     */
    PROCEDURE refresh_all_segment_counts;
    
    /*******************************************************************************
     * USER ASSIGNMENT LOGIC
     *******************************************************************************/

    /**
     * Procedure: assign_users_to_segment
     * Executes the dynamic assignment rules to link users to a segment.
     * This may involve evaluating department IDs, project roles, or 
     * custom attribute filters.
     * @param p_segment_id The target segment for user association.
     */
    PROCEDURE assign_users_to_segment(
        p_segment_id IN NUMBER
    );
    
END segment_manager_pkg;

/
