--------------------------------------------------------
--  DDL for Package Body APEX_CONTEXT_HELPER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APEX_CONTEXT_HELPER_PKG" AS

  FUNCTION get_domain_name(p_domain_id IN NUMBER) RETURN VARCHAR2 IS
    v_name VARCHAR2(500);
  BEGIN
    SELECT domain_name
    INTO v_name
    FROM context_domains
    WHERE context_domain_id = p_domain_id;

    RETURN v_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END get_domain_name;

  FUNCTION get_behavior_name(p_behavior_code IN VARCHAR2) RETURN VARCHAR2 IS
    v_name VARCHAR2(500);
  BEGIN
    SELECT behavior_name
    INTO v_name
    FROM context_domain_behaviors
    WHERE domain_behavior_code = p_behavior_code;

    RETURN v_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Standard';
  END get_behavior_name;

  FUNCTION get_format_name(p_format_code IN VARCHAR2) RETURN VARCHAR2 IS
    v_name VARCHAR2(500);
  BEGIN
    SELECT format_name
    INTO v_name
    FROM lkp_output_format
    WHERE format_code = p_format_code;

    RETURN v_name;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN 'Default';
  END get_format_name;

  FUNCTION sanitize_user_input(p_input IN CLOB) RETURN CLOB IS
    v_clean CLOB;
  BEGIN
    -- Remove potentially dangerous characters
    -- Add your sanitization logic here
    v_clean := REPLACE(p_input, '<script>', '');
    v_clean := REPLACE(v_clean, '</script>', '');

    RETURN v_clean;
  END sanitize_user_input;

  FUNCTION get_prompt_quality(p_prompt IN CLOB) RETURN VARCHAR2 IS
    v_length NUMBER;
  BEGIN
    v_length := DBMS_LOB.GETLENGTH(p_prompt);

    RETURN CASE
      WHEN v_length > 2500 THEN 'Excellent'
      WHEN v_length > 2000 THEN 'Good'
      WHEN v_length > 1500 THEN 'Fair'
      ELSE 'Limited'
    END;
  END get_prompt_quality;

END apex_context_helper_pkg;

/
