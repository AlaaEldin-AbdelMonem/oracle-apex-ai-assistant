--------------------------------------------------------
--  DDL for Package Body DOC_EXTRACT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."DOC_EXTRACT_PKG" AS

    FUNCTION extract_text(p_blob BLOB) RETURN CLOB IS
    
       vcaller constant varchar2(70):= c_package_name ||'.extract_text'; 

    BEGIN
        RETURN DBMS_VECTOR_CHAIN.UTL_TO_TEXT(
                 p_blob,
                 JSON('{"plaintext":"true","charset":"UTF8"}')
               );
    EXCEPTION WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);  
        RETURN NULL;
    END;

    FUNCTION is_text_ready(p_doc_id NUMBER) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_text_ready'; 
        v1 NUMBER; v2 NUMBER;
    BEGIN
        SELECT DBMS_LOB.GETLENGTH(text_extracted),
               DBMS_LOB.GETLENGTH(file_blob)
        INTO v1, v2
        FROM docs WHERE doc_id = p_doc_id;

        RETURN (v1 IS NOT NULL AND v2 IS NOT NULL);
    EXCEPTION WHEN OTHERS THEN
        debug_util.error(sqlerrm,vcaller);  
        RETURN FALSE;
    END;

    PROCEDURE generate_text(
        p_doc_id      IN NUMBER,
        p_commit_flag IN CHAR DEFAULT 'Y'
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_text'; 
    BEGIN
        UPDATE docs
           SET text_extracted = extract_text(file_blob)
         WHERE doc_id = p_doc_id;

        IF p_commit_flag = 'Y' THEN COMMIT; END IF;
    END;

    FUNCTION generate_text(
        p_doc_id      IN NUMBER,
        p_commit_flag IN CHAR DEFAULT 'Y'
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_text'; 
        v CLOB;
    BEGIN
        SELECT extract_text(file_blob)
          INTO v
          FROM docs
         WHERE doc_id = p_doc_id;

        UPDATE docs
           SET text_extracted = v
         WHERE doc_id = p_doc_id;

        IF p_commit_flag = 'Y' THEN COMMIT; END IF;

        RETURN v;
    END;

END doc_extract_pkg;

/
