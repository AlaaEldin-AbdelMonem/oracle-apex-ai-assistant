--------------------------------------------------------
--  DDL for Package Body POLICY_REDACTION_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "POLICY_REDACTION_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
 FUNCTION apply_redaction(
        p_content CLOB,
        p_classification VARCHAR2
    ) RETURN CLOB
    IS
        vcaller constant varchar2(70):= c_package_name ||'.apply_redaction'; 
        v_output CLOB := p_content;
    BEGIN
        FOR r IN (
            SELECT pattern, replacement_txt
            FROM cfg_redaction_rules
            WHERE is_active ='Y'
            ORDER BY rule_order
        ) LOOP
            v_output := REGEXP_REPLACE(
                v_output,
                r.pattern,
                r.replacement_txt
            );
        END LOOP;

        RETURN v_output;
    END apply_redaction;
/*******************************************************************************
 *  
 *******************************************************************************/
/* -------------------------------------------------------------------------
 
*----
* PURPOSE:
*   Applies dynamic masking rules defined in CFG_REDACTION_RULES.
*   Rules can be applied before embedding 2 or before display 1.
*
* PUBLIC FUNCTION:
*   - APPLY_MASKS(p_text, p_stage): Returns redacted text based on stage.
 -------------------------------------------------------------------------*/

   FUNCTION apply_masks(
        p_text                      IN CLOB,
        p_redaction_apply_phase_id  IN VARCHAR2
    ) RETURN CLOB  IS
    vcaller constant varchar2(70):= c_package_name ||'.apply_masks'; 
    v_masked CLOB := p_text;
  BEGIN
    FOR rec IN (
      SELECT pattern, REPLACEMENT_TXT, REDACTION_APPLY_PHASE_ID 
        FROM cfg_redaction_rules
    ) LOOP
      IF (p_redaction_apply_phase_id = 1 
         OR  p_redaction_apply_phase_id =2) THEN
        -- Apply pattern replacement
        v_masked := REGEXP_REPLACE(v_masked, rec.pattern, rec.REPLACEMENT_TXT);
      END IF;
    END LOOP;
    RETURN v_masked;
  END apply_masks;
/*******************************************************************************
 *  
 *******************************************************************************/
END policy_redaction_pkg;

/
