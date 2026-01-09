--------------------------------------------------------
--  DDL for Package CHUNK_STRATEGY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."CHUNK_STRATEGY_PKG" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      CHUNK_STRATEGY_PKG (Specification)
 * PURPOSE:     Intelligent strategy recommendation engine for RAG pipelines.
 *
 * DESCRIPTION: Analyzes document characteristics (category, security, size, patterns)
 * to recommend the optimal chunking approach. Automates the selection of 
 * chunk size and overlap to maximize retrieval accuracy.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2026 Alaa Abdelmoneim
 * DATABASE:    Oracle 23ai or higher
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'CHUNK_STRATEGY_PKG';

    /*******************************************************************************
     * TYPE DEFINITIONS
     *******************************************************************************/
    
    -- Document metadata container for rule evaluation
    TYPE t_doc_metadata IS RECORD (
        doc_id                NUMBER,
        doc_category          VARCHAR2(200),
        doc_topic             VARCHAR2(500),
        doc_tags              VARCHAR2(1000),
        classification_level  NUMBER,
        sensitivity_label     VARCHAR2(100),
        mime_type             VARCHAR2(200),
        language_code         VARCHAR2(10),
        file_size             NUMBER,
        source_system         VARCHAR2(100),
        text_content          CLOB,
        text_length           NUMBER
    );
    
    -- Content analysis metrics derived from regex patterns
    TYPE t_content_metrics IS RECORD (
        sentence_count         NUMBER,
        paragraph_count        NUMBER,
        code_indicators        NUMBER,
        structured_indicators  NUMBER,
        avg_sentence_length    NUMBER,
        newline_ratio          NUMBER,
        has_tables             BOOLEAN,
        has_code               BOOLEAN,
        has_lists              BOOLEAN,
        has_xml_html           BOOLEAN
    );
    
    -- Structured recommendation output
    TYPE t_strategy_recommendation IS RECORD (
        strategy_code     VARCHAR2(50),
        chunk_size        NUMBER,
        overlap_pct       NUMBER,
        confidence_score  NUMBER,
        reasoning         VARCHAR2(4000),
        rule_applied      VARCHAR2(100)
    );
    
    /*******************************************************************************
     * CONSTANTS - STRATEGY CODES & DEFAULTS
     *******************************************************************************/
    
    c_fixed_size          CONSTANT VARCHAR2(30) := 'FIXED_SIZE';
    c_sentence_boundary   CONSTANT VARCHAR2(30) := 'SENTENCE_BOUNDARY';
    c_paragraph_boundary  CONSTANT VARCHAR2(30) := 'PARAGRAPH_BOUNDARY';
    c_token_based         CONSTANT VARCHAR2(30) := 'TOKEN_BASED';
    c_semantic_sliding    CONSTANT VARCHAR2(30) := 'SEMANTIC_SLIDING';
    c_hierarchical        CONSTANT VARCHAR2(30) := 'HIERARCHICAL';
    
    c_default_chunk_size  CONSTANT NUMBER := 512;
    c_default_overlap_pct CONSTANT NUMBER := 20;
    c_min_confidence      CONSTANT NUMBER := 60;
    c_high_confidence     CONSTANT NUMBER := 90;
    
    /*******************************************************************************
     * CORE API - RECOMMENDATION ENGINE
     *******************************************************************************/
    
    /**
     * Function: recommend_strategy
     * Simple entry point that returns the recommended strategy code.
     */
    FUNCTION recommend_strategy(p_doc_id IN NUMBER) RETURN VARCHAR2;
    
    /**
     * Function: get_full_recommendation
     * Returns a full record including optimized size, overlap, and reasoning.
     */
    FUNCTION get_full_recommendation(p_doc_id IN NUMBER) RETURN t_strategy_recommendation;
    
    /*******************************************************************************
     * RULE EVALUATION (STRATEGY PATTERN)
     *******************************************************************************/
    
    /**
     * Rule Functions: Apply specific business and technical logic.
     * Weights: Category (40%), Classification (25%), Content Type (20%), Size (15%).
     */
    FUNCTION apply_category_rules(p_metadata IN t_doc_metadata, p_metrics IN t_content_metrics) 
    RETURN t_strategy_recommendation;
    
    FUNCTION apply_classification_rules(p_metadata IN t_doc_metadata) 
    RETURN t_strategy_recommendation;
    
    FUNCTION apply_content_type_rules(p_metadata IN t_doc_metadata, p_metrics IN t_content_metrics) 
    RETURN t_strategy_recommendation;
    
    FUNCTION apply_size_rules(p_metadata IN t_doc_metadata, p_metrics IN t_content_metrics) 
    RETURN t_strategy_recommendation;
    
    FUNCTION get_default_strategy(p_metrics IN t_content_metrics) RETURN t_strategy_recommendation;
    
    /*******************************************************************************
     * BATCH OPERATIONS & ANALYTICS
     *******************************************************************************/
    
    PROCEDURE recommend_all_documents(p_force_regenerate IN BOOLEAN DEFAULT FALSE);
    
    PROCEDURE store_recommendation(p_doc_id IN NUMBER, p_recommendation IN t_strategy_recommendation);
    
    PROCEDURE chunk_documents_smart(
        p_doc_ids       IN SYS.ODCINUMBERLIST DEFAULT NULL,
        p_force_rechunk IN BOOLEAN DEFAULT FALSE,
        p_commit_batch  IN NUMBER DEFAULT 10
    );

    /*******************************************************************************
     * UTILITY & TELEMETRY
     *******************************************************************************/

    FUNCTION analyze_content_patterns(p_text IN CLOB) RETURN t_content_metrics;
    
    FUNCTION get_document_metadata(p_doc_id IN NUMBER) RETURN t_doc_metadata;

    FUNCTION optimize_chunk_size(p_base_size IN NUMBER, p_doc_size IN NUMBER) RETURN NUMBER;
    
    FUNCTION calculate_optimal_overlap(p_strategy IN VARCHAR2, p_doc_size IN NUMBER) RETURN NUMBER;
    
    FUNCTION get_recommendation_stats RETURN CLOB; -- JSON output
    
    FUNCTION get_confidence_distribution RETURN CLOB; -- JSON output
    
    /*******************************************************************************
     * EXCEPTIONS
     *******************************************************************************/
    
    e_doc_not_found     EXCEPTION;
    e_invalid_strategy  EXCEPTION;
    e_no_content        EXCEPTION;
    
    PRAGMA EXCEPTION_INIT(e_doc_not_found, -20001);
    PRAGMA EXCEPTION_INIT(e_invalid_strategy, -20002);
    PRAGMA EXCEPTION_INIT(e_no_content, -20003);

END chunk_strategy_pkg;

/
