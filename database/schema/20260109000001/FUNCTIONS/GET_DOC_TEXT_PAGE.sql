--------------------------------------------------------
--  DDL for Function GET_DOC_TEXT_PAGE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "GET_DOC_TEXT_PAGE" (
    p_doc_id IN NUMBER,
    p_page_num IN NUMBER DEFAULT 1,
    p_page_size IN NUMBER DEFAULT 10000
) RETURN CLOB
/*******************************************************************************
 *  
 *******************************************************************************/
IS
    v_text CLOB;
    v_start_pos NUMBER;
    v_length NUMBER;
    v_total_length NUMBER;
BEGIN
    SELECT text_extracted, DBMS_LOB.GETLENGTH(text_extracted)
    INTO v_text, v_total_length
    FROM docs
    WHERE doc_id = p_doc_id;

    -- Calculate start position (1-based)
    v_start_pos := ((p_page_num - 1) * p_page_size) + 1;

    -- Don't go beyond document length
    IF v_start_pos > v_total_length THEN
        RETURN '*** End of Document ***';
    END IF;

    -- Calculate length to read
    v_length := LEAST(p_page_size, v_total_length - v_start_pos + 1);

    RETURN DBMS_LOB.SUBSTR(v_text, v_length, v_start_pos);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Document not found';
    WHEN OTHERS THEN
        RETURN 'Error: ' || SQLERRM;
END get_doc_text_page;

/
