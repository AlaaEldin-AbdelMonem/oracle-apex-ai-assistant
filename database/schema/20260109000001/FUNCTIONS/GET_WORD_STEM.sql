--------------------------------------------------------
--  DDL for Function GET_WORD_STEM
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."GET_WORD_STEM" (
    p_word IN VARCHAR2
) RETURN VARCHAR2
/*******************************************************************************
 *  
 *******************************************************************************/
IS
    v_stem VARCHAR2(1000) := LOWER(TRIM(p_word));
BEGIN
    -- Remove common suffixes (Porter Stemmer simplified)

    -- Step 1: Remove plural forms
    IF REGEXP_LIKE(v_stem, 'sses$') THEN
        v_stem := REGEXP_REPLACE(v_stem, 'sses$', 'ss');
    ELSIF REGEXP_LIKE(v_stem, 'ies$') THEN
        v_stem := REGEXP_REPLACE(v_stem, 'ies$', 'i');
    ELSIF REGEXP_LIKE(v_stem, 'ss$') THEN
        NULL; -- Keep as is
    ELSIF REGEXP_LIKE(v_stem, 's$') THEN
        v_stem := REGEXP_REPLACE(v_stem, 's$', '');
    END IF;

    -- Step 2: Remove -ed, -ing
    IF REGEXP_LIKE(v_stem, 'eed$') THEN
        NULL; -- Keep as is
    ELSIF REGEXP_LIKE(v_stem, 'ed$|ing$') THEN
        v_stem := REGEXP_REPLACE(v_stem, 'ed$|ing$', '');

        -- Handle double consonants (e.g., running -> run)
        IF REGEXP_LIKE(v_stem, '([^aeiou])\1$') THEN
            v_stem := SUBSTR(v_stem, 1, LENGTH(v_stem) - 1);
        END IF;
    END IF;

    -- Step 3: Remove -ly, -er, -est
    v_stem := REGEXP_REPLACE(v_stem, 'ly$|er$|est$', '');

    -- Step 4: Remove -tion, -sion, -ment, -ness
    v_stem := REGEXP_REPLACE(v_stem, 'tion$|sion$|ment$|ness$|ity$', '');

    RETURN v_stem;

EXCEPTION
    WHEN OTHERS THEN
        RETURN p_word;
END get_word_stem;

/
