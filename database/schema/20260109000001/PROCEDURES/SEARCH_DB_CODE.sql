--------------------------------------------------------
--  DDL for Procedure SEARCH_DB_CODE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "SEARCH_DB_CODE" (
    p_search_string IN VARCHAR2
)
IS
/*******************************************************************************
 *  
 *******************************************************************************/
    v_search_upper VARCHAR2(4000);
BEGIN
    -- Capitalize the input search string for case-insensitive comparison
    v_search_upper := UPPER(p_search_string);

    DBMS_OUTPUT.PUT_LINE('Searching for: ' || v_search_upper);
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');

    -- Query USER_SOURCE for the capitalized text
    FOR item IN (
        SELECT DISTINCT
            name,
            type
        FROM
            user_source
        WHERE
            UPPER(text) LIKE '%' || v_search_upper || '%'
            AND type IN ('PACKAGE', 'PACKAGE BODY', 'PROCEDURE', 'FUNCTION', 'TRIGGER')
        ORDER BY
            name,
            type
    ) LOOP
        -- Print the object name and type where the string was found
        DBMS_OUTPUT.PUT_LINE('Found in ' || RPAD(item.type, 15) || ': ' || item.name);
    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;

/
