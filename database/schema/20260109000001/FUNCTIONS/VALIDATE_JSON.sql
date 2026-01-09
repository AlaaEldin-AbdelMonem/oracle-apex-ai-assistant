--------------------------------------------------------
--  DDL for Function VALIDATE_JSON
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."VALIDATE_JSON" (p_json_string IN CLOB)
RETURN BOOLEAN IS
/*******************************************************************************
 *  
 *******************************************************************************/
BEGIN
    RETURN JSON_EXISTS(p_json_string, '$');
EXCEPTION
    WHEN OTHERS THEN
        RETURN FALSE;
END;

/
