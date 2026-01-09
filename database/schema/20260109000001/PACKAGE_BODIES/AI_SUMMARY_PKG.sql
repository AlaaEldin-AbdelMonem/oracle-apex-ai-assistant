--------------------------------------------------------
--  DDL for Package Body AI_SUMMARY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."AI_SUMMARY_PKG" AS


  FUNCTION generate_summary(p_text CLOB) RETURN CLOB IS
   vcaller constant varchar2(70):= c_package_name ||'.get_mime_type'; 
    v_prompt  CLOB;
    v_summary CLOB;
  BEGIN
    v_prompt := 'Summarize this document: ' || SUBSTR(p_text, 1, 4000);
   -- v_summary := openai_pkg.call_openai(v_prompt);
    RETURN v_summary;
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.put_line('Summary generation failed: ' || SQLERRM);
      RETURN NULL;
  END generate_summary;

  
END ai_summary_pkg;

/
