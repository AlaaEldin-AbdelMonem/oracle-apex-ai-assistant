--------------------------------------------------------
--  DDL for Function GET_CONTEXT_DEBUG_INFO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."GET_CONTEXT_DEBUG_INFO" (
  p_domain_id IN NUMBER,
  p_user_id IN NUMBER DEFAULT 1
) RETURN CLOB
/*******************************************************************************
 *  
 *******************************************************************************/
IS
  v_output CLOB;
BEGIN
  v_output := 'CONTEXT BUILDER DEBUG INFO' || CHR(10);
  v_output := v_output || '=========================' || CHR(10) || CHR(10);

  -- Domain info
  FOR rec IN (
    SELECT domain_name, context_domain_code, is_active
    FROM context_domains
    WHERE context_domain_id = p_domain_id
  ) LOOP
    v_output := v_output || 'Domain: ' || rec.domain_name || CHR(10);
    v_output := v_output || 'Code: ' || rec.context_domain_code || CHR(10);
    v_output := v_output || 'Active: ' || rec.is_active || CHR(10) || CHR(10);
  END LOOP;

  -- Source mappings
  v_output := v_output || 'Data Sources Mapped:' || CHR(10);
  FOR rec IN (
    SELECT r.source_title, r.registry_source_type_code
    FROM context_domain_registry cdr
    JOIN context_registry r ON cdr.context_registry_id = r.context_registry_id
    WHERE cdr.context_domain_id = p_domain_id
      AND cdr.is_active = 'Y'
      AND r.is_active = 'Y'
  ) LOOP
    v_output := v_output || '  - ' || rec.source_title || 
                ' (' || rec.registry_source_type_code || ')' || CHR(10);
  END LOOP;

  RETURN v_output;

EXCEPTION
  WHEN OTHERS THEN
    RETURN 'Error: ' || SQLERRM;
END get_context_debug_info;

/
