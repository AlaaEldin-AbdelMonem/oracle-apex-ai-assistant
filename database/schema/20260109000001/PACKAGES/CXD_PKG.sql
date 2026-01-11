--------------------------------------------------------
--  DDL for Package CXD_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "CXD_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CXD_PKG (Specification)
 * PURPOSE:     Context Domain Management & Metadata Lookup.
 *
 * DESCRIPTION: Manages the lifecycle of knowledge domains. Handles instruction 
 * retrieval for prompt engineering, domain validation, and 
 * session-level domain management.
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
    c_package_name  CONSTANT VARCHAR2(30) := 'CXD_PKG';

 /*******************************************************************************
 **
 * Record: t_context_domain_info
 * Lightweight container for domain-level metadata.
 *
 *******************************************************************************/

    TYPE t_context_domain_info IS RECORD (
        context_domain_id           NUMBER,
        context_domain_code         VARCHAR2(100),
        context_domain_name         VARCHAR2(200),
        context_domain_description  VARCHAR2(4000),
        category_name               VARCHAR2(200)
    );


FUNCTION to_json (p_rec IN t_context_domain_info) RETURN CLOB;
/*******************************************************************************
**
     * Function: get_domain_instructions
     * Fetches the system instructions/prompts associated with a specific domain.
     * @param  p_context_Instruction_id The ID of the instruction set.
     * @return CLOB containing the text-based prompt instructions.
  *******************************************************************************/

    
    FUNCTION get_domain_instructions (
        p_context_Instruction_id IN NUMBER
    ) RETURN CLOB;

/*******************************************************************************
**
     * Function: get_domain_info
     * Retrieves descriptive metadata for a specific context domain.
     * 
     *******************************************************************************/
  
    FUNCTION get_domain_info (
        p_context_domain_id IN NUMBER
    ) RETURN t_context_domain_info;

    /*******************************************************************************
    **
     * Function: is_valid_domain
     * Checks if a domain ID exists in the system and is currently marked as active.
     * 
     *******************************************************************************/

  
    FUNCTION is_valid_domain (
        p_context_domain_id IN NUMBER
    ) RETURN BOOLEAN;

END cxd_pkg;

/
