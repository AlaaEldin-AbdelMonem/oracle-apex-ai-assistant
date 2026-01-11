--------------------------------------------------------
--  DDL for Package AI_SUMMARY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI_SUMMARY_PKG" AS
/**
 * PROJECT:     Enterprise AI Assistant
 * MODULE:      AI_SUMMARY_PKG (Body)
 * PURPOSE:     Logic for generating document summaries using LLM integration.
 * * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 */

    c_version           CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name      CONSTANT VARCHAR2(30) := 'AI_SUMMARY_PKG';
/*******************************************************************************
     * FUNCTION:  generate_summary
     * PURPOSE:   Generates a concise summary of the provided CLOB text.
 *******************************************************************************/
  FUNCTION generate_summary(p_text CLOB) RETURN CLOB;

  
END ai_summary_pkg;

/
