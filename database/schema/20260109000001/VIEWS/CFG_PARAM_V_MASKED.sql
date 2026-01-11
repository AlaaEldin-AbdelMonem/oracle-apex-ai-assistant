--------------------------------------------------------
--  DDL for View CFG_PARAM_V_MASKED
--------------------------------------------------------

  CREATE OR REPLACE FORCE EDITIONABLE VIEW "CFG_PARAM_V_MASKED" ("PARAM_KEY", "CATEGORY_CODE", "PARAM_NAME", "VALUE_TYPE", "DESCRIPTION", "IS_SECRET", "IS_ACTIVE") DEFAULT COLLATION "USING_NLS_COMP"  AS 
  SELECT 
    param_key,
     category_code,
    param_name,
    
    VALUE_TYPE,
    description,
   IS_SECRET,
    is_active 
    
   
FROM cfg_parameters
WHERE is_active = 'Y'
;
