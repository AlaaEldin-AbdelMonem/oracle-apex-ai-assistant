--------------------------------------------------------
--  DDL for Package CX_BEHAVIOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CX_BEHAVIOR_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CX_BEHAVIOR_PKG (Specification)
 * PURPOSE:     Management of AI Behavior Profiles and Output Format Templates.
 *
 * DESCRIPTION: Provides a centralized API to manage how the AI behaves (tone/style) 
 * and how it structures its response (JSON, Table, Markdown). 
 * These components are consumed by the prompt builder to create 
 * consistent, high-quality system instructions.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CX_BEHAVIOR_PKG';

    /*******************************************************************************
     * BEHAVIOR PROFILES (TONE & STYLE)
     *******************************************************************************/

    /**
     * Function: get_behavior_instructions
     * Retrieves specific prompt fragments defining the AI's persona.
     * @param  p_behavior_code  Unique code (e.g., 'PROFESSIONAL', 'CREATIVE').
     * @return CLOB containing instructions for the LLM's behavioral tone.
     */
    FUNCTION get_behavior_instructions (
        p_behavior_code IN VARCHAR2
    ) RETURN CLOB;

    /**
     * Function: is_valid_behavior
     * Validates that the requested behavior code exists and is active.
     */
    FUNCTION is_valid_behavior (
        p_behavior_code IN VARCHAR2
    ) RETURN BOOLEAN;

    /**
     * Function: list_behaviors
     * Returns a Ref Cursor of all available personas for UI selection.
     */
    FUNCTION list_behaviors RETURN SYS_REFCURSOR;

    /*******************************************************************************
     * OUTPUT FORMAT TEMPLATES
     *******************************************************************************/

    /**
     * Function: get_format_instructions
     * Retrieves prompt fragments that force specific response structures.
     * @param  p_format_code  Unique code (e.g., 'JSON_OBJ', 'MARKDOWN_TABLE').
     * @return CLOB containing formatting constraints for the LLM response.
     */
    FUNCTION get_format_instructions (
        p_format_code IN VARCHAR2
    ) RETURN CLOB;

    /**
     * Function: is_valid_format
     * Validates that the requested format code exists and is active.
     */
    FUNCTION is_valid_format (
        p_format_code IN VARCHAR2
    ) RETURN BOOLEAN;

    /**
     * Function: list_output_formats
     * Returns a Ref Cursor of all available output structures.
     */
    FUNCTION list_output_formats RETURN SYS_REFCURSOR;

END cx_behavior_pkg;

/
