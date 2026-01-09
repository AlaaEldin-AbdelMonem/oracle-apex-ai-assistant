--------------------------------------------------------
--  DDL for Function EMBD_LLM_TEST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."EMBD_LLM_TEST" (p_txt varchar2 default 'Hello!') return varchar2
IS
/*******************************************************************************
 *  
 *******************************************************************************/
    v_vector  vector ;
 
BEGIN
 
    DBMS_OUTPUT.PUT_LINE('-----------------------------------');
   v_vector:=  chunk_EMBEDDING_pkg.generate_embedding(p_txt);
   if v_vector is not null then
      DBMS_OUTPUT.PUT_LINE('vector generated');
      return to_char(v_vector);
      else 
    DBMS_OUTPUT.PUT_LINE('the embedding model may be not loaded');
         return 'N';
    end if;
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
             return 'N';
END;

/
