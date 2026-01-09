--------------------------------------------------------
--  DDL for Package STREAM_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."STREAM_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      STREAM_UTIL (Specification)
 * PURPOSE:     Low-level Token Emission and Protocol Management.
 *
 * DESCRIPTION: Handles the physical delivery of text tokens to various 
 * output channels. It manages the specific formatting requirements for 
 * different consumers (e.g., prefixing "data:" for SSE or handling 
 * buffer flushing for APEX).
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 *
 */

    -- Package Metadata
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'STREAM_UTIL'; 

    /*******************************************************************************
     * TOKEN EMISSION API
     *******************************************************************************/

    /**
     * Procedure: emit_token
     * Sends a single text fragment to the specified channel.
     * * @param p_channel The destination protocol/channel:
     * - 'APEX': Standard APEX HTTP buffer with immediate flush.
     * - 'ORDS': SSE formatted (data: {token}) for REST consumers.
     * - 'DBMS_OUTPUT': Standard database console output.
     * @param p_token   The text content to be delivered.
     */
    PROCEDURE emit_token(
        p_channel IN VARCHAR2,
        p_token   IN VARCHAR2
    );

END stream_util;

/
