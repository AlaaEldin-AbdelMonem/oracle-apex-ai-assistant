--------------------------------------------------------
--  DDL for Package Body CXD_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CXD_PKG" AS

/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_domain_info (
        p_context_domain_id IN NUMBER
    ) RETURN t_context_domain_info IS
       vcaller constant varchar2(70):= c_package_name ||'.get_domain_info';
        rec t_context_domain_info;
    BEGIN
        SELECT m.context_domain_category_id,
               m.CONTEXT_DOMAIN_CODE,
               m.domain_name,
               m.description,
               c.category_name
          INTO rec.context_domain_id,
               rec.context_domain_code,
               rec.context_domain_name,
               rec.context_domain_description,
               rec.category_name
          FROM CONTEXT_DOMAINS m,  lkp_context_domain_categories c
         WHERE m.CONTEXT_DOMAIN_CATEGORY_ID = c.CONTEXT_DOMAIN_CATEGORY_ID(+)
           AND m.CONTEXT_DOMAIN_CATEGORY_ID = p_context_domain_id
           AND m.is_active = 'Y';

        RETURN rec;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
    END get_domain_info;
/*******************************************************************************
 *      -- VALIDATION
 *******************************************************************************/
 
    FUNCTION is_valid_domain (
        p_context_domain_id IN NUMBER
    ) RETURN BOOLEAN IS
          vcaller constant varchar2(70):= c_package_name ||'.is_valid_domain';
        v_domain_info t_context_domain_info;
    BEGIN
        v_domain_info := get_domain_info(p_context_domain_id);
        
        -- ✅ FIX: Check a specific field, not the entire record
        IF v_domain_info.context_domain_id IS NOT NULL THEN
            RETURN TRUE;
        ELSE 
            RETURN FALSE;
        END IF;
        
    END is_valid_domain;

/*******************************************************************************
 *   -- RETRIEVE DOMAIN INSTRUCTIONS
 *******************************************************************************/

   
    FUNCTION get_domain_instructions (
        p_context_Instruction_id IN NUMBER
    ) RETURN CLOB IS
          vcaller constant varchar2(70):= c_package_name ||'.get_domain_instructions';
        v_clob  CLOB;
    BEGIN
        -- concatenate all instruction lines sorted by order
        SELECT LISTAGG(instruction_text, CHR(10)||CHR(10))
               WITHIN GROUP (ORDER BY instruction_order)
          INTO v_clob
          FROM CONTEXT_DOMAIN_INSTRUCTIONS
         WHERE context_DOMAIN_INSTRUCTION_ID = p_context_Instruction_id
           AND is_active = 'Y';

        RETURN NVL(v_clob, '');  -- always return something

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RETURN '';  -- Return empty string instead of NULL for consistency
    END get_domain_instructions;

/*******************************************************************************
 *  DOMAIN INFO DUMP
 *******************************************************************************/
 
    FUNCTION to_json (p_rec IN t_context_domain_info) RETURN CLOB IS
        l_clob CLOB;
    BEGIN
        APEX_JSON.INITIALIZE_CLOB_OUTPUT;
        APEX_JSON.OPEN_OBJECT;
        
        APEX_JSON.WRITE('context_domain_id',          p_rec.context_domain_id);
        APEX_JSON.WRITE('context_domain_code',        p_rec.context_domain_code);
        APEX_JSON.WRITE('context_domain_name',        p_rec.context_domain_name);
        APEX_JSON.WRITE('context_domain_description', p_rec.context_domain_description);
        APEX_JSON.WRITE('category_name',              p_rec.category_name);
        
        APEX_JSON.CLOSE_OBJECT;
        
        l_clob := APEX_JSON.GET_CLOB_OUTPUT;
        APEX_JSON.FREE_OUTPUT;
        
        RETURN l_clob;
    END to_json;

/*******************************************************************************
 * 
 *******************************************************************************/

END cxd_pkg;

/
