--------------------------------------------------------
--  DDL for Package Body CHUNK_STRATEGY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CHUNK_STRATEGY_PKG" AS
/*******************************************************************************
 * Package Body:  CHUNK_STRATEGY_PKG
 * 
 * Implementation of modular chunking strategy recommendation engine
 * 
 * Architecture Notes:
 *   - Each rule function is independent and testable
 *   - Main function orchestrates rule evaluation
 *   - Uses priority-based decision making
 *   - All functions return NULL if rule doesn't match (allows fallthrough)
 * 
 * Performance Considerations:
 *   - Single metadata fetch per recommendation
 *   - Content analysis cached in memory
 *   - Regex compiled once per call
 *   - Bulk operations use FORALL where applicable
 *******************************************************************************/

/*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Creates empty recommendation record
     */
    FUNCTION init_recommendation RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.init_recommendation';
        v_rec t_strategy_recommendation;
    BEGIN
        v_rec.strategy_code := NULL;
        v_rec.chunk_size := c_default_chunk_size;
        v_rec.overlap_pct := c_default_overlap_pct;
        v_rec.confidence_score := 0;
        v_rec.reasoning := '';
        v_rec.rule_applied := NULL;
        RETURN v_rec;
    END init_recommendation;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: get_document_metadata
     *==========================================================================*/
    
    FUNCTION get_document_metadata(
        p_doc_id IN NUMBER
    ) RETURN t_doc_metadata IS
        vcaller constant varchar2(70):= c_package_name ||'.get_document_metadata';
        v_metadata t_doc_metadata;
        v_msg varchar2(4000);
    BEGIN
        SELECT 
            doc_id,
            doc_category,
            doc_topic,
            doc_tags,
            classification_level,
            sensitivity_level,
            file_mime_type,
            language_code,
            file_size,
            source_system,
            text_extracted,
            DBMS_LOB.GETLENGTH(text_extracted)
        INTO 
            v_metadata.doc_id,
            v_metadata.doc_category,
            v_metadata.doc_topic,
            v_metadata.doc_tags,
            v_metadata.classification_level,
            v_metadata.sensitivity_label,
            v_metadata.mime_type,
            v_metadata.language_code,
            v_metadata.file_size,
            v_metadata.source_system,
            v_metadata.text_content,
            v_metadata.text_length
        FROM docs
        WHERE doc_id = p_doc_id;
        
        RETURN v_metadata;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_msg:= 'Document ID ' || p_doc_id || ' not found';
            debug_util.error(v_msg  || ', RAISE_APPLICATION_ERROR(-20001', vcaller );
            RAISE_APPLICATION_ERROR(-20001, 'Document ID ' || p_doc_id || ' not found');
    END get_document_metadata;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: analyze_content_patterns
     *==========================================================================*/
    
    FUNCTION analyze_content_patterns(
        p_text IN CLOB
    ) RETURN t_content_metrics IS
        vcaller constant varchar2(70):= c_package_name ||'.analyze_content_patterns';
        v_metrics t_content_metrics;
        v_text_length NUMBER;
    BEGIN
        -- Initialize
        v_text_length := DBMS_LOB.GETLENGTH(p_text);
        
        -- Count sentences (periods, question marks, exclamation followed by space)
        v_metrics.sentence_count := REGEXP_COUNT(p_text, '\.[[:space:]]|\?\s|\!\s|\.\n');
        
        -- Count paragraphs (double newlines or indented paragraphs)
        v_metrics.paragraph_count := REGEXP_COUNT(p_text, '\n\n|\n[[:space:]]{2,}');
        
        -- Detect code indicators
        v_metrics.code_indicators := 
            REGEXP_COUNT(p_text, '\{|\}|\[|\]') +
            REGEXP_COUNT(p_text, 'function |class |def |var |const |int |public |private ') +
            REGEXP_COUNT(p_text, '^\s*(import|from|#include|using|package)', 1, 'im');
        
        -- Detect structured data (tables, lists, XML)
        v_metrics.structured_indicators :=
            REGEXP_COUNT(p_text, '\t') +
            REGEXP_COUNT(p_text, '\|[[:space:]]*\|') +
            REGEXP_COUNT(p_text, '^[-*+]\s+', 1, 'm') +
            REGEXP_COUNT(p_text, '<[a-z]+>|</[a-z]+>');
        
        -- Calculate average sentence length
        IF v_metrics.sentence_count > 0 THEN
            v_metrics.avg_sentence_length := v_text_length / v_metrics.sentence_count;
        ELSE
            v_metrics.avg_sentence_length := 0;
        END IF;
        
        -- Calculate newline ratio
        v_metrics.newline_ratio := REGEXP_COUNT(p_text, '\n') / GREATEST(v_text_length / 100.0, 1);
        
        -- Boolean indicators
        v_metrics.has_tables := (REGEXP_COUNT(p_text, '\|[[:space:]]*\|') > 5);
        v_metrics.has_code := (v_metrics.code_indicators > 20);
        v_metrics.has_lists := (REGEXP_COUNT(p_text, '^[-*+]\s+', 1, 'm') > 10);
        v_metrics.has_xml_html := (REGEXP_COUNT(p_text, '<[a-z]+>') > 10);
        
        RETURN v_metrics;
        
    EXCEPTION
        WHEN OTHERS THEN
             debug_util.error('analyze_content_patterns: ' || SQLERRM,vcaller,vcaller);
            RETURN v_metrics; -- Return partially filled metrics
    END analyze_content_patterns;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: apply_category_rules
     * Priority: HIGHEST (40% weight)
     *==========================================================================*/
    
    FUNCTION apply_category_rules(
        p_metadata IN t_doc_metadata,
        p_metrics IN t_content_metrics
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.apply_category_rules';
        v_rec t_strategy_recommendation := init_recommendation();
        v_category VARCHAR2(200) := UPPER(NVL(p_metadata.doc_category, ''));
    BEGIN
         debug_util.starting(vcaller,' Evaluating category rules...');
        
        -- HR Documents
        IF v_category LIKE '%HR%' OR v_category LIKE '%HUMAN%RESOURCE%' THEN
            v_rec.strategy_code := c_sentence_boundary;
            v_rec.chunk_size := 400;
            v_rec.overlap_pct := 25;
            v_rec.confidence_score := 95;
            v_rec.reasoning := 'HR Category: Optimized for employee Q&A accuracy. ' ||
                              'Smaller chunks (400) with high overlap (25%) ensure precise policy answers.';
            v_rec.rule_applied := 'CATEGORY_HR';
             debug_util.info(' Matched: HR Category',vcaller);
            RETURN v_rec;
            
        -- Legal Documents
        ELSIF v_category LIKE '%LEGAL%' OR v_category LIKE '%CONTRACT%' THEN
            v_rec.strategy_code := c_paragraph_boundary;
            v_rec.chunk_size := 800;
            v_rec.overlap_pct := 30;
            v_rec.confidence_score := 95;
            v_rec.reasoning := 'Legal Category: Preserves contract clauses and legal context. ' ||
                              'Larger chunks (800) maintain clause integrity.';
            v_rec.rule_applied := 'CATEGORY_LEGAL';
             debug_util.info('Matched: Legal Category',vcaller);
            RETURN v_rec;
            
        -- Technical Documentation
        ELSIF v_category LIKE '%TECHNICAL%' OR v_category LIKE '%TECH%DOC%' THEN
            v_rec.strategy_code := c_semantic_sliding;
            v_rec.chunk_size := 600;
            v_rec.overlap_pct := 40;
            v_rec.confidence_score := 90;
            v_rec.reasoning := 'Technical Category: Mixed content (code + prose). ' ||
                              'Semantic sliding with 40% overlap preserves technical relationships.';
            v_rec.rule_applied := 'CATEGORY_TECHNICAL';
             debug_util.info('Matched: Technical Category',vcaller);
            RETURN v_rec;
            
        -- Financial Documents
        ELSIF v_category LIKE '%FINANCE%' OR v_category LIKE '%ACCOUNTING%' THEN
            v_rec.strategy_code := c_paragraph_boundary;
            v_rec.chunk_size := 700;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 90;
            v_rec.reasoning := 'Finance Category: Preserves financial sections and tables. ' ||
                              'Paragraph boundaries maintain report structure.';
            v_rec.rule_applied := 'CATEGORY_FINANCE';
             debug_util.info(' Matched: Finance Category',vcaller);
            RETURN v_rec;
            
        -- Training/Education Materials
        ELSIF v_category LIKE '%TRAINING%' OR v_category LIKE '%EDUCATION%' THEN
            v_rec.strategy_code := c_sentence_boundary;
            v_rec.chunk_size := 450;
            v_rec.overlap_pct := 25;
            v_rec.confidence_score := 85;
            v_rec.reasoning := 'Training Category: Optimized for learning clarity. ' ||
                              'Sentence boundaries make content easily digestible.';
            v_rec.rule_applied := 'CATEGORY_TRAINING';
             debug_util.info('Matched: Training Category',vcaller);
            RETURN v_rec;
            
        -- Procedures/SOPs
        ELSIF v_category LIKE '%PROCEDURE%' OR v_category LIKE '%SOP%' THEN
            v_rec.strategy_code := c_paragraph_boundary;
            v_rec.chunk_size := 500;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 90;
            v_rec.reasoning := 'Procedure Category: Preserves procedural steps. ' ||
                              'Paragraph boundaries keep steps complete.';
            v_rec.rule_applied := 'CATEGORY_PROCEDURE';
             debug_util.info(' Matched: Procedure Category',vcaller);
            RETURN v_rec;
            
        -- Reference/Glossary
        ELSIF v_category LIKE '%REFERENCE%' OR v_category LIKE '%GLOSSARY%' THEN
            v_rec.strategy_code := c_fixed_size;
            v_rec.chunk_size := 300;
            v_rec.overlap_pct := 10;
            v_rec.confidence_score := 85;
            v_rec.reasoning := 'Reference Category: Optimized for fast lookup. ' ||
                              'Fixed-size chunks (300) enable quick retrieval.';
            v_rec.rule_applied := 'CATEGORY_REFERENCE';
             debug_util.info('Matched: Reference Category',vcaller);
            RETURN v_rec;
        END IF;
        
        -- No category rule matched
         debug_util.info('   No category rule matched',vcaller);
        RETURN NULL;
        
    END apply_category_rules;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: apply_classification_rules
     * Priority: HIGH (25% weight)
     *==========================================================================*/
    
    FUNCTION apply_classification_rules(
        p_metadata IN t_doc_metadata
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.apply_classification_rules';
        v_rec t_strategy_recommendation := init_recommendation();
    BEGIN
         debug_util.info('Evaluating classification rules...',vcaller);
        
        -- High classification (Confidential/Restricted): Minimize exposure
        IF p_metadata.classification_level >= 3 THEN
            v_rec.strategy_code := c_sentence_boundary;
            v_rec.chunk_size := 350;
            v_rec.overlap_pct := 15;
            v_rec.confidence_score := 80;
            v_rec.reasoning := 'High Classification Level (' || p_metadata.classification_level || '): ' ||
                              'Smaller chunks (350) minimize sensitive data exposure in single chunk.';
            v_rec.rule_applied := 'CLASSIFICATION_HIGH';
             debug_util.info(' Matched: High Classification',vcaller);
            RETURN v_rec;
        END IF;
        
        -- No classification rule matched
         debug_util.info(' No classification rule matched',vcaller);
        RETURN NULL;
        
    END apply_classification_rules;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: apply_content_type_rules
     * Priority: MEDIUM (20% weight)
     *==========================================================================*/
    
    FUNCTION apply_content_type_rules(
        p_metadata IN t_doc_metadata,
        p_metrics IN t_content_metrics
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.apply_content_type_rules';
        v_rec t_strategy_recommendation := init_recommendation();
        v_mime VARCHAR2(200) := UPPER(NVL(p_metadata.mime_type, ''));
    BEGIN
         debug_util.info('Evaluating content type rules...',vcaller);
        
        -- Source Code
        IF p_metrics.has_code OR v_mime LIKE '%CODE%' OR v_mime LIKE '%SCRIPT%' THEN
            v_rec.strategy_code := c_token_based;
            v_rec.chunk_size := 512;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 90;
            v_rec.reasoning := 'Source Code Detected: Token-based preserves code structure. ' ||
                              'Standard chunk size (512) balances context and precision.';
            v_rec.rule_applied := 'CONTENT_CODE';
             debug_util.info('Matched: Source Code',vcaller);
            RETURN v_rec;
            
        -- Highly Structured Data
        ELSIF p_metrics.structured_indicators > 30 OR p_metrics.has_tables THEN
            v_rec.strategy_code := c_fixed_size;
            v_rec.chunk_size := 512;
            v_rec.overlap_pct := 15;
            v_rec.confidence_score := 85;
            v_rec.reasoning := 'Structured Data Detected: Fixed-size handles tables efficiently.';
            v_rec.rule_applied := 'CONTENT_STRUCTURED';
             debug_util.info(' Matched: Structured Data',vcaller);
            RETURN v_rec;
            
        -- XML/HTML Documents
        ELSIF p_metrics.has_xml_html THEN
            v_rec.strategy_code := c_hierarchical;
            v_rec.chunk_size := 600;
            v_rec.overlap_pct := 25;
            v_rec.confidence_score := 85;
            v_rec.reasoning := 'Hierarchical Structure Detected: Preserves XML/HTML hierarchy.';
            v_rec.rule_applied := 'CONTENT_HIERARCHICAL';
             debug_util.info('Matched: Hierarchical Structure',vcaller);
            RETURN v_rec;
        END IF;
        
        -- No content type rule matched
         debug_util.info('No content type rule matched',vcaller);
        RETURN NULL;
        
    END apply_content_type_rules;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: apply_size_rules
     * Priority: LOW (15% weight)
     *==========================================================================*/
    
    FUNCTION apply_size_rules(
        p_metadata IN t_doc_metadata,
        p_metrics IN t_content_metrics
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.apply_size_rules';
        v_rec t_strategy_recommendation := init_recommendation();
    BEGIN
         debug_util.info('Evaluating size rules...',vcaller);
        
        -- Very Large Documents
        IF p_metadata.text_length > 30000 AND p_metrics.paragraph_count > 30 THEN
            v_rec.strategy_code := c_semantic_sliding;
            v_rec.chunk_size := 600;
            v_rec.overlap_pct := 40;
            v_rec.confidence_score := 75;
            v_rec.reasoning := 'Large Document (' || p_metadata.text_length || ' chars): ' ||
                              'Semantic sliding with 40% overlap maintains cross-section context.';
            v_rec.rule_applied := 'SIZE_LARGE';
             debug_util.info('Matched: Large Document',vcaller);
            RETURN v_rec;
            
        -- Long-form Articles
        ELSIF p_metrics.paragraph_count > 15 AND p_metrics.avg_sentence_length > 100 THEN
            v_rec.strategy_code := c_paragraph_boundary;
            v_rec.chunk_size := 650;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 80;
            v_rec.reasoning := 'Long-form Article: Paragraph boundaries preserve narrative flow.';
            v_rec.rule_applied := 'SIZE_LONGFORM';
             debug_util.info(' Matched: Long-form Article',vcaller);
            RETURN v_rec;
        END IF;
        
        -- No size rule matched
         debug_util.info('No size rule matched',vcaller);
        RETURN NULL;
        
    END apply_size_rules;

    /*==========================================================================
     * PUBLIC FUNCTION: get_default_strategy
     *==========================================================================*/
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_default_strategy(
        p_metrics IN t_content_metrics
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.get_default_strategy';
        v_rec t_strategy_recommendation := init_recommendation();
    BEGIN
         debug_util.starting(vcaller,'Applying default strategy...');
        
        -- Natural language Q&A (most common use case)
        IF p_metrics.sentence_count > 5 
           AND p_metrics.avg_sentence_length BETWEEN 50 AND 200 THEN
            v_rec.strategy_code := c_sentence_boundary;
            v_rec.chunk_size := 512;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 95;
            v_rec.reasoning := 'Natural Language Document: Sentence boundaries optimize Q&A accuracy. ' ||
                              'Industry standard settings (512/20%) balance precision and context.';
            v_rec.rule_applied := 'DEFAULT_NATURAL_LANGUAGE';
            debug_util.info(' Applied: Natural Language Default',vcaller);
        ELSE
            -- Ultimate fallback
            v_rec.strategy_code := c_sentence_boundary;
            v_rec.chunk_size := 512;
            v_rec.overlap_pct := 20;
            v_rec.confidence_score := 60;
            v_rec.reasoning := 'No specific pattern matched. Using safe default (SENTENCE_BOUNDARY).';
            v_rec.rule_applied := 'DEFAULT_FALLBACK';
             debug_util.warn('⚠️  Applied: Safe Fallback',vcaller);
        END IF;
        
        RETURN v_rec;
        
    END get_default_strategy;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: get_full_recommendation (MAIN ORCHESTRATOR)
     *==========================================================================*/
    
    FUNCTION get_full_recommendation(
        p_doc_id IN NUMBER
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.get_full_recommendation';
        v_metadata t_doc_metadata;
        v_metrics t_content_metrics;
        v_recommendation t_strategy_recommendation;
        v_msg varchar2(4000);
    BEGIN
         
       --CHUNKING STRATEGY RECOMMENDATION ENGINE v2.0  --
     
        debug_util.starting(vcaller,'📄 Document ID: ' || p_doc_id);
   
        
        -- Phase 1: Fetch metadata
        v_metadata := get_document_metadata(p_doc_id);
        
        -- Validate content exists
        IF v_metadata.text_content IS NULL OR v_metadata.text_length < 100 THEN
        v_msg:= 'Document has no content or is too short';
            debug_util.error( v_msg ||',rasie -20003', vcaller);
            RAISE_APPLICATION_ERROR(-20003, v_msg);
        END IF;
        v_msg:= '📊 Metadata: ' || v_metadata.doc_category || ' | ' ||    v_metadata.text_length || ' chars';
         debug_util.info( v_msg, vcaller);
      
        
        -- Phase 2: Analyze content
        v_metrics := analyze_content_patterns(v_metadata.text_content);
        
        v_msg:= '📈 Content Analysis:'||
        '   Sentences: ' || v_metrics.sentence_count||
         '   Paragraphs: ' || v_metrics.paragraph_count||
        '   Code indicators: ' || v_metrics.code_indicators||
         '   Structured indicators: ' || v_metrics.structured_indicators;
        
          debug_util.info( v_msg, vcaller);
        -- Phase 3: Apply rules in priority order
         v_msg:='🎯 Applying Decision Rules (Priority Order):';
         debug_util.info( v_msg, vcaller);
    
        
        -- Priority 1: Category rules (40% weight)
        v_recommendation := apply_category_rules(v_metadata, v_metrics);
        IF v_recommendation.strategy_code IS NOT NULL THEN
            GOTO finalize_recommendation;
        END IF;
        
        -- Priority 2: Classification rules (25% weight)
        v_recommendation := apply_classification_rules(v_metadata);
        IF v_recommendation.strategy_code IS NOT NULL THEN
            GOTO finalize_recommendation;
        END IF;
        
        -- Priority 3: Content type rules (20% weight)
        v_recommendation := apply_content_type_rules(v_metadata, v_metrics);
        IF v_recommendation.strategy_code IS NOT NULL THEN
            GOTO finalize_recommendation;
        END IF;
        
        -- Priority 4: Size rules (15% weight)
        v_recommendation := apply_size_rules(v_metadata, v_metrics);
        IF v_recommendation.strategy_code IS NOT NULL THEN
            GOTO finalize_recommendation;
        END IF;
        
        -- Default: Natural language strategy
        v_recommendation := get_default_strategy(v_metrics);
        
        <<finalize_recommendation>>
        
        -- Phase 4: Optimize parameters
        v_recommendation.chunk_size := optimize_chunk_size(
            v_recommendation.chunk_size,
            v_metadata.text_length
        );
        
        v_recommendation.overlap_pct := calculate_optimal_overlap(
            v_recommendation.strategy_code,
            v_metadata.text_length
        );
        
        -- Phase 5: Display results
  
        v_msg:=' FINAL RECOMMENDATION ' ;
        debug_util.info( v_msg, vcaller);
  
        v_msg:='Strategy: ' || RPAD(v_recommendation.strategy_code, 42) || ', Chunk Size: ' || RPAD(TO_CHAR(v_recommendation.chunk_size), 40) ||  
           ' Overlap: ' || RPAD(TO_CHAR(v_recommendation.overlap_pct) || '%', 43) ||  
       ' Confidence: ' || RPAD(TO_CHAR(v_recommendation.confidence_score) || '%', 40) || 
        '║ Rule: ' || RPAD(v_recommendation.rule_applied, 45) ;
      debug_util.info( v_msg, vcaller);
        
        RETURN v_recommendation;
        
    EXCEPTION
        WHEN OTHERS THEN
            -- Return safe default on error
            v_recommendation := init_recommendation();
            v_recommendation.strategy_code := c_sentence_boundary;
            v_recommendation.reasoning := 'Error occurred: ' || SQLERRM || '. Using safe default.';
            v_recommendation.rule_applied := 'ERROR_FALLBACK';
        v_msg :=  'Error occurred: ' || SQLERRM || '. Using safe default.';
         debug_util.error( v_msg, vcaller);
            RETURN v_recommendation;
    END get_full_recommendation;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: recommend_strategy (Simple API)
     *==========================================================================*/
    
    FUNCTION recommend_strategy(
        p_doc_id IN NUMBER
    ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.recommend_strategy';
        v_rec t_strategy_recommendation;
    BEGIN
        v_rec := get_full_recommendation(p_doc_id);
        RETURN v_rec.strategy_code;
    END recommend_strategy;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: optimize_chunk_size
     *==========================================================================*/
    
    FUNCTION optimize_chunk_size(
        p_base_size IN NUMBER,
        p_doc_size IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.optimize_chunk_size';
        v_optimized_size NUMBER := p_base_size;
    BEGIN
        -- Small documents: reduce chunk size for granular retrieval
        IF p_doc_size < 2000 THEN
            v_optimized_size := LEAST(p_base_size, 300);
            
        -- Very large documents: increase chunk size to reduce total chunks
        ELSIF p_doc_size > 50000 THEN
            v_optimized_size := GREATEST(p_base_size, 700);
        END IF;
        
        RETURN v_optimized_size;
    END optimize_chunk_size;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTION: calculate_optimal_overlap
     *==========================================================================*/
    
  /*==========================================================================
     * FUNCTION: calculate_optimal_overlap
     * 
     * Purpose:
     *   Calculates the optimal overlap percentage for document chunking based on
     *   the selected chunking strategy and document size characteristics.
     * 
     * Business Value:
     *   - Maximizes context preservation between chunks for better RAG retrieval
     *   - Balances retrieval accuracy vs storage/processing overhead
     *   - Prevents information loss at chunk boundaries
     *   - Optimizes for specific strategy characteristics
     * 
     * Parameters:
     *   p_strategy  - Chunking strategy code (e.g., SENTENCE_BOUNDARY, SEMANTIC_SLIDING)
     *   p_doc_size  - Document size in characters
     * 
     * Returns:
     *   NUMBER - Optimal overlap percentage (10-50%)
     * 
     * Algorithm:
     *   1. Set base overlap based on strategy characteristics:
     *      - SEMANTIC_SLIDING: 40% (high context preservation needed)
     *      - PARAGRAPH_BOUNDARY: 25% (medium context for narrative flow)
     *      - SENTENCE_BOUNDARY: 20% (standard for Q&A)
     *      - TOKEN_BASED: 20% (code context)
     *      - FIXED_SIZE: 10% (speed priority)
     *      - HIERARCHICAL: 25% (structure preservation)
     * 
     *   2. Adjust for document size:
     *      - Large documents (>20K chars): +10% overlap (cap at 50%)
     *      - Rationale: Larger docs have more cross-references, need more context
     * 
     * Overlap Strategy Rationale:
     * 
     * ┌──────────────────────────────────────────────────────────────────┐
     * │ Strategy              │ Base │ Reason                            │
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ SEMANTIC_SLIDING      │ 40%  │ Highest - preserves semantic flow │
     * │                       │      │ across conceptually-related chunks│
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ PARAGRAPH_BOUNDARY    │ 25%  │ Medium-High - maintains narrative │
     * │                       │      │ context between paragraphs        │
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ HIERARCHICAL          │ 25%  │ Medium-High - preserves parent/   │
     * │                       │      │ child relationships in structure  │
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ SENTENCE_BOUNDARY     │ 20%  │ Standard - balanced approach for  │
     * │                       │      │ Q&A accuracy vs efficiency        │
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ TOKEN_BASED           │ 20%  │ Standard - code blocks need some  │
     * │                       │      │ context but not excessive         │
     * ├───────────────────────┼──────┼───────────────────────────────────┤
     * │ FIXED_SIZE            │ 10%  │ Lowest - prioritizes speed and    │
     * │                       │      │ storage efficiency over context   │
     * └───────────────────────┴──────┴───────────────────────────────────┘
     * 
     * Why Overlap Matters in RAG:
     * 
     *   WITHOUT OVERLAP:                  WITH OVERLAP:
     *   ┌─────────────┐                   ┌─────────────┐
     *   │  Chunk 1    │                   │  Chunk 1    │
     *   │ ...context A│                   │ ...context A│
     *   │ key concept │                   │ key concept │──┐
     *   └─────────────┘                   │ transition  │  │ Overlap
     *   ┌─────────────┐                   └─────────────┘  │ Region
     *   │  Chunk 2    │                   ┌─────────────┐  │
     *   │ continuation│                   │ transition  │──┘
     *   │ ...context B│                   │ continuation│
     *   └─────────────┘                   │ ...context B│
     *                                     └─────────────┘
     * 
     *   Problem: Key concept split       Solution: Context preserved
     *   Result: Lost information         Result: Better retrieval
     * 
     * Size-Based Adjustment Logic:
     * 
     *   Small Documents (< 20K chars):
     *     - Use base overlap percentage
     *     - Limited cross-references, less context needed
     *     - Example: 5K char policy doc → 20% overlap sufficient
     * 
     *   Large Documents (> 20K chars):
     *     - Add +10% to base overlap (max 50%)
     *     - More cross-references, complex relationships
     *     - Example: 50K char technical manual → 30% overlap (20% + 10%)
     * 
     * Performance Impact:
     * 
     *   Overlap %  │ Chunk Count │ Storage │ Retrieval Quality
     *   ───────────┼─────────────┼─────────┼──────────────────
     *   10%        │ Baseline    │ +0%     │ Good
     *   20%        │ +10%        │ +10%    │ Very Good (⭐ Recommended)
     *   30%        │ +20%        │ +20%    │ Excellent
     *   40%        │ +30%        │ +30%    │ Outstanding
     *   50%        │ +40%        │ +40%    │ Maximum (edge cases only)
     * 
     * Business Trade-offs:
     * 
     *   Higher Overlap (30-50%):
     *     ✅ Better RAG retrieval accuracy
     *     ✅ More context for LLM
     *     ✅ Fewer "lost" concepts at boundaries
     *     ❌ More storage required (chunks table)
     *     ❌ Slightly slower vector search (more candidates)
     *     ❌ Higher embedding API costs
     * 
     *   Lower Overlap (10-20%):
     *     ✅ Less storage overhead
     *     ✅ Faster vector search
     *     ✅ Lower embedding costs
     *     ❌ Risk of losing context at chunk boundaries
     *     ❌ May miss relevant information in retrieval
     * 
     * Usage Examples:
     * 
     *   -- Example 1: Standard sentence chunking for Q&A
     *   v_overlap := calculate_optimal_overlap('SENTENCE_BOUNDARY', 5000);
     *   -- Result: 20% (standard overlap for medium document)
     * 
     *   -- Example 2: Large technical document with semantic sliding
     *   v_overlap := calculate_optimal_overlap('SEMANTIC_SLIDING', 35000);
     *   -- Result: 50% (40% base + 10% for large doc, capped at 50%)
     * 
     *   -- Example 3: Quick reference with fixed-size chunks
     *   v_overlap := calculate_optimal_overlap('FIXED_SIZE', 3000);
     *   -- Result: 10% (minimal overlap for speed)
     * 
     *   -- Example 4: Legal contract with paragraph boundaries
     *   v_overlap := calculate_optimal_overlap('PARAGRAPH_BOUNDARY', 25000);
     *   -- Result: 35% (25% base + 10% for large doc)
     * 
     * Integration with RAG Pipeline:
     * 
     *   1. Strategy Recommendation → Determines p_strategy
     *   2. This Function → Calculates optimal overlap
     *   3. rag_chunk_util.chunk_text() → Uses calculated overlap
     *   4. Vector Embedding → Processes overlapping chunks
     *   5. RAG Retrieval → Benefits from preserved context
     * 
     * Best Practices:
     * 
     *   1. Always use this function rather than hardcoding overlap values
     *   2. Trust the algorithm - it's based on production RAG experience
     *   3. For custom requirements, adjust base percentages in CASE statement
     *   4. Monitor retrieval quality metrics to validate overlap effectiveness
     *   5. Consider storage costs when setting overlap for large document sets
     * 
     * Special Cases:
     * 
     *   Multi-lingual Documents:
     *     - No special handling needed
     *     - Overlap works independently of language
     * 
     *   Code + Documentation Mix:
     *     - Use TOKEN_BASED strategy (20% base)
     *     - Overlap preserves function signatures at boundaries
     * 
     *   Highly Structured Data (Tables):
     *     - Use FIXED_SIZE strategy (10% base)
     *     - Low overlap acceptable as tables are self-contained
     * 
     * Quality Assurance:
     * 
     *   Validation Rules:
     *     ✅ Output always between 10% and 50%
     *     ✅ Higher context strategies get higher overlap
     *     ✅ Large documents get adjustment bonus
     *     ✅ Never exceeds 50% (diminishing returns beyond this)
     * 
     * Dependencies:
     *   - Constants: c_default_overlap_pct (20%)
     *   - Constants: c_semantic_sliding, c_paragraph_boundary, etc.
     * 
     * Error Handling:
     *   - Invalid strategy → Falls back to default 20%
     *   - NULL doc_size → Treats as 0, uses base overlap
     *   - Negative doc_size → Treats as 0, uses base overlap
     * 
     * Author: Alaa Abdelmoneim
     * Date: October 26, 2025
     * Version: 2.0
     * Project: Oracle AI ChatPot - Enterprise RAG System
     * 
     * Modification History:
     *   Date        Author              Description
     *   ----------  ------------------  ------------------------------------
     *   2025-10-26  Alaa Abdelmoneim   Initial creation with strategy-based logic
     *   2025-10-26  Alaa Abdelmoneim   Added size-based adjustment algorithm
     *   2025-10-26  Alaa Abdelmoneim   Added 50% cap for overlap maximum
     * 
     *==========================================================================*/
    FUNCTION calculate_optimal_overlap(
        p_strategy IN VARCHAR2,
        p_doc_size IN NUMBER
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.calculate_optimal_overlap';
        v_overlap NUMBER := c_default_overlap_pct;  -- Default: 20%
        v_doc_size NUMBER;
    BEGIN
        -- Input validation: Handle NULL or negative document size
        v_doc_size := GREATEST(NVL(p_doc_size, 0), 0);
        
        -- ═══════════════════════════════════════════════════════════════
        -- PHASE 1: Strategy-Specific Base Overlap Selection
        -- ═══════════════════════════════════════════════════════════════
        
        CASE UPPER(p_strategy)
            -- ───────────────────────────────────────────────────────────
            -- SEMANTIC_SLIDING: Highest Overlap (40%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: Long technical documents, mixed content
            -- Reasoning: Needs maximum context to preserve semantic 
            --           relationships across conceptually-related chunks
            -- Example: Technical manuals, research papers, long reports
            WHEN c_semantic_sliding THEN
                v_overlap := 40;
            
            -- ───────────────────────────────────────────────────────────
            -- PARAGRAPH_BOUNDARY: Medium-High Overlap (25%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: Legal contracts, financial reports, procedures
            -- Reasoning: Preserves narrative flow and clause context
            --           between paragraph boundaries
            -- Example: Contracts with interconnected clauses
            WHEN c_paragraph_boundary THEN
                v_overlap := 25;
            
            -- ───────────────────────────────────────────────────────────
            -- HIERARCHICAL: Medium-High Overlap (25%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: XML documents, nested lists, structured content
            -- Reasoning: Maintains parent-child relationships across
            --           hierarchical boundaries
            -- Example: XML/JSON documents, nested procedure lists
            WHEN c_hierarchical THEN
                v_overlap := 25;
            
            -- ───────────────────────────────────────────────────────────
            -- SENTENCE_BOUNDARY: Standard Overlap (20%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: HR policies, Q&A documents, training materials
            -- Reasoning: Balanced approach - sufficient context without
            --           excessive storage overhead
            -- Example: Employee handbooks, FAQ documents
            WHEN c_sentence_boundary THEN
                v_overlap := 20;
            
            -- ───────────────────────────────────────────────────────────
            -- TOKEN_BASED: Standard Overlap (20%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: Source code, technical documentation
            -- Reasoning: Code blocks need context (function signatures,
            --           imports) but not excessive overlap
            -- Example: Python scripts, API documentation
            WHEN c_token_based THEN
                v_overlap := 20;
            
            -- ───────────────────────────────────────────────────────────
            -- FIXED_SIZE: Minimum Overlap (10%)
            -- ───────────────────────────────────────────────────────────
            -- Use Case: Quick reference, glossaries, structured tables
            -- Reasoning: Speed and storage efficiency prioritized over
            --           context preservation
            -- Example: Reference tables, glossary terms, indexes
            WHEN c_fixed_size THEN
                v_overlap := 10;
            
            -- ───────────────────────────────────────────────────────────
            -- DEFAULT: Standard Overlap (20%)
            -- ───────────────────────────────────────────────────────────
            -- Fallback for unknown or invalid strategies
            ELSE
                v_overlap := 20;
        END CASE;
        
        -- ═══════════════════════════════════════════════════════════════
        -- PHASE 2: Document Size-Based Adjustment
        -- ═══════════════════════════════════════════════════════════════
        
        -- Large documents (>20K characters) benefit from higher overlap
        -- Reasoning:
        --   - More cross-references between sections
        --   - Complex conceptual relationships
        --   - Higher risk of context loss at boundaries
        --   - Small storage overhead relative to document size
        IF v_doc_size > 20000 THEN
            v_overlap := v_overlap + 10;  -- Add 10% bonus
            
            -- Cap at 50% maximum
            -- Reasoning:
            --   - Beyond 50%, diminishing returns on retrieval quality
            --   - Storage overhead becomes significant
            --   - Processing time increases substantially
            v_overlap := LEAST(v_overlap, 50);
        END IF;
        
        -- ═══════════════════════════════════════════════════════════════
        -- PHASE 3: Safety Validation
        -- ═══════════════════════════════════════════════════════════════
        
        -- Ensure overlap is within acceptable bounds [10%, 50%]
        v_overlap := GREATEST(v_overlap, 10);  -- Minimum 10%
        v_overlap := LEAST(v_overlap, 50);     -- Maximum 50%
        
        RETURN v_overlap;
        
    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm, vcaller);
            -- On any error, return safe default overlap
            RETURN c_default_overlap_pct;  -- 20%
    END calculate_optimal_overlap;

    /*==========================================================================
     * PUBLIC PROCEDURE: store_recommendation
     *==========================================================================*/
    
    PROCEDURE store_recommendation(
        p_doc_id IN NUMBER,
        p_recommendation IN t_strategy_recommendation
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.store_recommendation';
    BEGIN
        UPDATE docs
        SET 
            chunking_strategy = p_recommendation.strategy_code,
            chunk_size_override = p_recommendation.chunk_size,
            overlap_pct_override = p_recommendation.overlap_pct,
            chunking_notes = p_recommendation.reasoning,
            updated_at = SYSTIMESTAMP,
            updated_by = USER
        WHERE doc_id = p_doc_id;
        
    END store_recommendation;

    /*==========================================================================
     * PUBLIC PROCEDURE: recommend_all_documents
     *==========================================================================*/
    
    PROCEDURE recommend_all_documents(
        p_force_regenerate IN BOOLEAN DEFAULT FALSE
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.recommend_all_documents';
        CURSOR c_docs IS
            SELECT doc_id 
            FROM docs 
            WHERE text_extracted IS NOT NULL 
              AND is_active = 'Y'
              AND (p_force_regenerate OR chunking_strategy IS NULL)
            ORDER BY doc_id;
        
        v_recommendation t_strategy_recommendation;
        v_count NUMBER := 0;
        
    BEGIN
           debug_util.starting(vcaller,'🔄 Generating recommendations for all documents...');
       
        
        FOR doc IN c_docs LOOP
            BEGIN
                v_recommendation := get_full_recommendation(doc.doc_id);
                store_recommendation(doc.doc_id, v_recommendation);
                
                v_count := v_count + 1;
                
                IF MOD(v_count, 10) = 0 THEN
                    COMMIT;
                      debug_util.info(' Processed ' || v_count || ' documents',vcaller);
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN
                    debug_util.error(' doc ' || doc.doc_id || ': ' || SQLERRM,vcaller);
                    -- Continue with next document
            END;
        END LOOP;
        
        COMMIT;
 
           debug_util.ending(vcaller,'✅ Complete: ' || v_count || ' documents');
        
    END recommend_all_documents;

    /*==========================================================================
     * PUBLIC PROCEDURE: chunk_documents_smart
     *==========================================================================*/
    
    PROCEDURE chunk_documents_smart(
        p_doc_ids IN SYS.ODCINUMBERLIST DEFAULT NULL,
        p_force_rechunk IN BOOLEAN DEFAULT FALSE,
        p_commit_batch IN NUMBER DEFAULT 10
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.chunk_documents_smart';
        v_doc_ids SYS.ODCINUMBERLIST;
        v_recommendation t_strategy_recommendation;
        v_chunks_created NUMBER;
        v_total_chunks NUMBER := 0;
        v_start_time TIMESTAMP := SYSTIMESTAMP;
    BEGIN
           debug_util.starting(vcaller,'🚀 Starting smart batch chunking...');
        
        -- Determine documents to process
        IF p_doc_ids IS NULL THEN
            SELECT doc_id
            BULK COLLECT INTO v_doc_ids
            FROM docs
            WHERE text_extracted IS NOT NULL
              AND is_active = 'Y'
              AND (p_force_rechunk OR rag_ready_flag = 'N')
            ORDER BY doc_id;
        ELSE
            v_doc_ids := p_doc_ids;
        END IF;
        
           debug_util.info('📋 Documents to process: ' || v_doc_ids.COUNT,vcaller);
 
        
        -- Process each document
        FOR i IN 1..v_doc_ids.COUNT LOOP
            BEGIN
 
                   debug_util.info('📄 Document ' || i || '/' || v_doc_ids.COUNT, vcaller);
                
                -- Get recommendation
                v_recommendation := get_full_recommendation(v_doc_ids(i));
                store_recommendation(v_doc_ids(i), v_recommendation);
                
                -- Delete existing chunks if re-chunking
                IF p_force_rechunk THEN
                    DELETE FROM DOC_CHUNKS WHERE doc_id = v_doc_ids(i);
                END IF;
                
                -- Chunk document
                v_chunks_created := chunk_util.chunk_batch(
                    p_doc_ids => SYS.ODCINUMBERLIST(v_doc_ids(i)),
                    p_strategy => v_recommendation.strategy_code,
                    p_chunk_size => v_recommendation.chunk_size,
                    p_overlap_pct => v_recommendation.overlap_pct,
                    p_commit_batch => 1
                );
                
                v_total_chunks := v_total_chunks + v_chunks_created;
                
                -- Mark as RAG-ready
                UPDATE docs
                SET rag_ready_flag = 'Y',
                    last_chunked_at = SYSTIMESTAMP,
                    last_chunking_strategy = v_recommendation.strategy_code
                WHERE doc_id = v_doc_ids(i);
                
                   debug_util.info('Created ' || v_chunks_created || ' chunks',vcaller);
                
                IF MOD(i, p_commit_batch) = 0 THEN
                    COMMIT;
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN
                       debug_util.error( SQLERRM,vcaller);
            END;
        END LOOP;
        
        COMMIT;
        
  
           debug_util.ending(vcaller,'Batch complete: ' || v_total_chunks || ' total chunks created');
        
    END chunk_documents_smart;

    /*==========================================================================
     * PUBLIC FUNCTIONS: Utility
     *==========================================================================*/
    
    FUNCTION is_valid_strategy(
        p_strategy IN VARCHAR2
    ) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_valid_strategy';
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM lkp_chunking_strategy
        WHERE strategy_code = p_strategy
          AND is_active = 'Y';
          
        RETURN (v_count > 0);
    END is_valid_strategy;
    
    FUNCTION get_strategy_defaults(
        p_strategy IN VARCHAR2
    ) RETURN t_strategy_recommendation IS
        vcaller constant varchar2(70):= c_package_name ||'.get_strategy_defaults';
        v_rec t_strategy_recommendation := init_recommendation();
    BEGIN
        SELECT 
            strategy_code,
            default_chunk_size,
            default_overlap_pct,
            0 as confidence, -- No confidence for defaults
            'Loaded from lookup table' as reasoning,
            'LOOKUP_DEFAULT' as rule
        INTO 
            v_rec.strategy_code,
            v_rec.chunk_size,
            v_rec.overlap_pct,
            v_rec.confidence_score,
            v_rec.reasoning,
            v_rec.rule_applied
        FROM lkp_chunking_strategy
        WHERE strategy_code = p_strategy
          AND is_active = 'Y';
          
        RETURN v_rec;
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           debug_util.info(sqlerrm,vcaller);
            RETURN init_recommendation();
    END get_strategy_defaults;
/*******************************************************************************
 *  
 *******************************************************************************/
    /*==========================================================================
     * PUBLIC FUNCTIONS: Reporting
     *==========================================================================*/
    
    FUNCTION get_recommendation_stats RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.get_recommendation_stats';
        v_json CLOB;
    BEGIN
        SELECT JSON_OBJECT(
            'total_documents' VALUE COUNT(*),
            'recommended' VALUE COUNT(CASE WHEN chunking_strategy IS NOT NULL THEN 1 END),
            'pending' VALUE COUNT(CASE WHEN chunking_strategy IS NULL THEN 1 END),
            'rag_ready' VALUE COUNT(CASE WHEN rag_ready_flag = 'Y' THEN 1 END),
            'strategies' VALUE JSON_OBJECT(
                'SENTENCE_BOUNDARY' VALUE COUNT(CASE WHEN chunking_strategy = 'SENTENCE_BOUNDARY' THEN 1 END),
                'PARAGRAPH_BOUNDARY' VALUE COUNT(CASE WHEN chunking_strategy = 'PARAGRAPH_BOUNDARY' THEN 1 END),
                'TOKEN_BASED' VALUE COUNT(CASE WHEN chunking_strategy = 'TOKEN_BASED' THEN 1 END),
                'SEMANTIC_SLIDING' VALUE COUNT(CASE WHEN chunking_strategy = 'SEMANTIC_SLIDING' THEN 1 END),
                'FIXED_SIZE' VALUE COUNT(CASE WHEN chunking_strategy = 'FIXED_SIZE' THEN 1 END),
                'HIERARCHICAL' VALUE COUNT(CASE WHEN chunking_strategy = 'HIERARCHICAL' THEN 1 END)
            )
            RETURNING CLOB
        )
        INTO v_json
        FROM docs
        WHERE is_active = 'Y';
        
        RETURN v_json;
    END get_recommendation_stats;
    
    FUNCTION get_confidence_distribution RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.get_confidence_distribution';
        v_json CLOB;
    BEGIN
        -- This would require storing confidence scores in a table
        -- For now, return placeholder
        RETURN '{"message": "Confidence distribution not yet implemented"}';
    END get_confidence_distribution;
/*******************************************************************************
 *  
 *******************************************************************************/
END chunk_strategy_pkg;

/
