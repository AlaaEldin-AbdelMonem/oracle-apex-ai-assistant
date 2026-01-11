--------------------------------------------------------
--  DDL for Package AI_REFRESH_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI_REFRESH_PKG" AS

/******************************************************************************
* PACKAGE: AI_REFRESH_PKG
* -----------------------------------------------------------------------------
* PURPOSE:
*   Refresh or regenerate vector embeddings for documents in RAG_CORPUS.
*
* BUSINESS FLOW:
*   1. Retrieve each document (or specified doc_id).
*   2. Apply redaction rules (if required).
*   3. Generate embeddings using DBMS_VECTOR.
*   4. Store in RAG_EMBEDDINGS table.
******************************************************************************/

    c_version           CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name      CONSTANT VARCHAR2(30) := 'AI_REFRESH_PKG';

  PROCEDURE refresh_embeddings(p_doc_id NUMBER DEFAULT NULL);
END ai_refresh_pkg;

/
