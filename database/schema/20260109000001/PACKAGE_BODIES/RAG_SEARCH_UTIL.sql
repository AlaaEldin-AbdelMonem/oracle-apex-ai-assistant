--------------------------------------------------------
--  DDL for Package Body RAG_SEARCH_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "RAG_SEARCH_UTIL" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION smart_search(
        p_query         IN CLOB,
        p_doc_id        IN NUMBER DEFAULT NULL,
        p_max_results   IN NUMBER DEFAULT 10,
        p_threshold     IN NUMBER DEFAULT 0.5
    ) RETURN t_search_results_tab PIPELINED IS
        vcaller constant varchar2(70):= c_package_name ||'.smart_search';  
        v_query_embedding VECTOR;
        v_result t_search_result;
        v_distance NUMBER;

    BEGIN
        -- Generate embedding for search query
        v_query_embedding := ai_vector_utx.generate_embedding(p_query);

        -- Search for similar chunks
        FOR rec IN (
            SELECT 
                c.doc_chunk_id,
                c.doc_id,
                d.doc_title,
                c.chunk_sequence,
                c.chunk_text,
                c.embedding_model,
                VECTOR_DISTANCE(c.embedding_vector, v_query_embedding) as distance
            FROM doc_chunks c  ,docs d  
            WHERE      c.doc_id = d.doc_id
              AND c.is_active = 'Y'
               AND d.is_active = 'Y'
              AND (p_doc_id IS NULL OR c.doc_id = p_doc_id)
            ORDER BY distance ASC
            FETCH FIRST p_max_results ROWS ONLY
        ) LOOP
            -- Calculate relevance (lower distance = higher relevance)
            v_distance := rec.distance;

            -- Only return if meets threshold
            -- Note: distance ranges from 0 (identical) to 2 (opposite)
            -- Convert to percentage: 0 = 100%, 2 = 0%
            v_result.relevance_score := v_distance;
            v_result.relevance_pct := ROUND((1 - (v_distance / 2)) * 100, 2);

            -- Apply threshold filter
            IF v_result.relevance_pct >= (p_threshold * 100) THEN
                v_result.chunk_id := rec.doc_chunk_id;
                v_result.doc_id := rec.doc_id;
                v_result.doc_title := rec.doc_title;
                v_result.chunk_sequence := rec.chunk_sequence;
                v_result.chunk_text := rec.chunk_text;
                v_result.embedding_model := rec.embedding_model;

                PIPE ROW(v_result);
            END IF;
        END LOOP;

        RETURN;

    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);
            -- Log error but don't break search
            NULL;
            RETURN;
    END smart_search;
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_searchable_documents
    RETURN SYS_REFCURSOR IS
        vcaller constant varchar2(70):= c_package_name ||'.get_searchable_documents';  
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT DISTINCT
                d.doc_id,
                d.doc_title,
                COUNT(1) as embedding_count,
                d.created_at
            FROM docs d ,doc_chunks c 
 
            WHERE  d.doc_id = c.doc_id
              AND d.is_active = 'Y'
              AND c.is_active = 'Y'
            GROUP BY d.doc_id, d.doc_title, d.created_at
            ORDER BY d.doc_title;

        RETURN v_cursor;
    END get_searchable_documents;
/*******************************************************************************
 *  
 *******************************************************************************/
FUNCTION highlight_search_terms(
    p_text              IN CLOB,
    p_search_terms      IN VARCHAR2,
    p_highlight_class   IN VARCHAR2 DEFAULT 'highlight-term',
    p_match_strategy    IN VARCHAR2 DEFAULT 'PARTIAL'  -- EXACT, PARTIAL, STEMMED
) RETURN CLOB
IS 
    vcaller constant varchar2(70):= c_package_name ||'.highlight_search_terms';  
    v_result        CLOB := p_text;
    v_term          VARCHAR2(1000);
    v_terms         apex_t_varchar2;
    v_pattern       VARCHAR2(2000);
    v_replacement   VARCHAR2(2000);
    v_stem          VARCHAR2(1000);
BEGIN
    -- Handle null inputs
    IF p_text IS NULL OR p_search_terms IS NULL THEN
        RETURN p_text;
    END IF;
    
    -- Split search terms (comma or space separated)
    v_terms := apex_string.split(
        p_str => TRIM(p_search_terms),
        p_sep => ','
    );
    
    -- If no comma, try space separation
    IF v_terms.COUNT = 0 THEN
        v_terms := apex_string.split(
            p_str => TRIM(p_search_terms),
            p_sep => ' '
        );
    END IF;
    
    -- Highlight each term based on strategy
    FOR i IN 1..v_terms.COUNT LOOP
        v_term := TRIM(v_terms(i));
        
        IF LENGTH(v_term) > 0 THEN
            -- Escape special regex characters
            v_term := REGEXP_REPLACE(v_term, '([.*+?^${}()|[\]\\])', '\\\1');
            
            -- Build pattern based on matching strategy
            CASE UPPER(p_match_strategy)
                
                -- EXACT: Whole word only
                WHEN 'EXACT' THEN
                    v_pattern := '(\W|^)(' || v_term || ')(\W|$)';
                    v_replacement := '\1<span class="' || p_highlight_class || '">\2</span>\3';
                
                -- PARTIAL: Match word stems and variations (most flexible)
                WHEN 'PARTIAL' THEN
                    -- Match the term anywhere, including as part of other words
                    -- Also handles hyphenated terms
                    v_pattern := '(^|[^>])(' || v_term || '[a-zA-Z0-9_-]*)';
                    v_replacement := '\1<span class="' || p_highlight_class || '">\2</span>';
                
                -- STEMMED: Match word stem + common suffixes
                WHEN 'STEMMED' THEN
                    -- Get word stem (remove common suffixes)
                    v_stem := get_word_stem(v_term);
                    
                    -- Match stem with optional suffixes
                    v_pattern := '(\W|^)(' || v_stem || 
                                 '(ing|ed|s|es|er|est|ly|ion|tion|ment|ness|ity|ive|ous|al|able|ible)?)(\W|$)';
                    v_replacement := '\1<span class="' || p_highlight_class || '">\2</span>\4';
                
                -- Default to PARTIAL
                ELSE
                    v_pattern := '(^|[^>])(' || v_term || '[a-zA-Z0-9_-]*)';
                    v_replacement := '\1<span class="' || p_highlight_class || '">\2</span>';
            END CASE;
            
            -- Apply regex replacement (case-insensitive)
            v_result := REGEXP_REPLACE(
                v_result,
                v_pattern,
                v_replacement,
                1, 0, 'i'  -- Case-insensitive
            );
        END IF;
    END LOOP;
    
    RETURN v_result;
    
EXCEPTION
    WHEN OTHERS THEN
     debug_util.error( sqlerrm,vcaller);
         
        RETURN p_text;
END highlight_search_terms;
/*******************************************************************************
 *  
 *******************************************************************************/
END rag_search_util;

/
