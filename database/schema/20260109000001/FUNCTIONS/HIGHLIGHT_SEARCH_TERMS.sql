--------------------------------------------------------
--  DDL for Function HIGHLIGHT_SEARCH_TERMS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."HIGHLIGHT_SEARCH_TERMS" (
    p_text              IN CLOB,
    p_search_terms      IN VARCHAR2,
    p_highlight_class   IN VARCHAR2 DEFAULT 'highlight-term',
    p_match_strategy    IN VARCHAR2 DEFAULT 'PARTIAL'  -- EXACT, PARTIAL, STEMMED
) RETURN CLOB
/*******************************************************************************
 *  
 *******************************************************************************/
IS
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
        -- Log error and return original text
       
        RETURN p_text;
END highlight_search_terms;

/
