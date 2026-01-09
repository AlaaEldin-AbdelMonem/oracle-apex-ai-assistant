--------------------------------------------------------
--  DDL for Package Body CX_BEHAVIOR_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CX_BEHAVIOR_PKG" AS
 
    -----------------------------------------------------------------------------
    -- BEHAVIOR VALIDATION
    -----------------------------------------------------------------------------
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION is_valid_behavior (
        p_behavior_code IN VARCHAR2
    ) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_valid_behavior';
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM LKP_CONTEXT_DOMAIN_BEHAVIORS
        WHERE UPPER(domain_behavior_code) = UPPER(p_behavior_code)
          AND is_active = 'Y';

        RETURN v_count > 0;
    END is_valid_behavior;


/*******************************************************************************
 *  
 *******************************************************************************/
    -----------------------------------------------------------------------------
    -- GET BEHAVIOR INSTRUCTIONS
    -----------------------------------------------------------------------------

    FUNCTION get_behavior_instructions (
        p_behavior_code IN VARCHAR2
    ) RETURN CLOB IS
          vcaller constant varchar2(70):= c_package_name ||'.get_behavior_instructions';
        v_clob CLOB;
    BEGIN
        SELECT instruction_text
        INTO v_clob
        FROM LKP_CONTEXT_DOMAIN_BEHAVIORS
        WHERE UPPER(domain_behavior_code) = UPPER(p_behavior_code)
          AND is_active = 'Y';

        RETURN v_clob;

    EXCEPTION WHEN NO_DATA_FOUND THEN
        debug_util.error(sqlerrm, vcaller);
        RETURN 'Respond in a clear and helpful manner.'; -- fallback
    END get_behavior_instructions;
/*******************************************************************************
 *  
 *******************************************************************************/

    -----------------------------------------------------------------------------
    -- List Behavior LOV (APEX Friendly)
    -----------------------------------------------------------------------------

    FUNCTION list_behaviors RETURN SYS_REFCURSOR IS
          vcaller constant varchar2(70):= c_package_name ||'.list_behaviors';
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT domain_behavior_code AS return_value,
                   behavior_name AS display_value,
                   behavior_description,
                   display_order,
                   is_active
            FROM LKP_CONTEXT_DOMAIN_BEHAVIORS
            ORDER BY display_order;

        RETURN rc;
    END list_behaviors;
/*******************************************************************************
 *  
 *******************************************************************************/
  -- OUTPUT FORMAT VALIDATION
    -----------------------------------------------------------------------------

    FUNCTION is_valid_format (
        p_format_code IN VARCHAR2
    ) RETURN BOOLEAN IS
          vcaller constant varchar2(70):= c_package_name ||'.is_valid_format';
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM lkp_output_format
        WHERE UPPER(format_code) = UPPER(p_format_code)
          AND is_active = 'Y';

        RETURN v_count > 0;
    END is_valid_format;
/*******************************************************************************
 *  
 *******************************************************************************/
 -- GET OUTPUT FORMAT INSTRUCTIONS
    -----------------------------------------------------------------------------

    FUNCTION get_format_instructions (
        p_format_code IN VARCHAR2
    ) RETURN CLOB IS
          vcaller constant varchar2(70):= c_package_name ||'.get_format_instructions';
        v_clob CLOB;
    BEGIN
        SELECT instruction_text
        INTO v_clob
        FROM lkp_output_format
        WHERE UPPER(format_code) = UPPER(p_format_code)
          AND is_active = 'Y';

        RETURN v_clob;

    EXCEPTION WHEN NO_DATA_FOUND THEN
         debug_util.error(sqlerrm, vcaller);
        RETURN 'Provide the response in natural language.'; -- fallback
    END get_format_instructions;
/*******************************************************************************
 *  
 *******************************************************************************/
 -- List Output Formats LOV (APEX Friendly)
    -----------------------------------------------------------------------------

    FUNCTION list_output_formats RETURN SYS_REFCURSOR IS
          vcaller constant varchar2(70):= c_package_name ||'.list_output_formats';
        rc SYS_REFCURSOR;
    BEGIN
        OPEN rc FOR
            SELECT format_code AS return_value,
                   format_name AS display_value,
                   format_description,
                   display_order,
                   is_active
            FROM lkp_output_format
            ORDER BY display_order;

        RETURN rc;
    END list_output_formats;
/*******************************************************************************
 *  
 *******************************************************************************/
END cx_behavior_pkg;

/
