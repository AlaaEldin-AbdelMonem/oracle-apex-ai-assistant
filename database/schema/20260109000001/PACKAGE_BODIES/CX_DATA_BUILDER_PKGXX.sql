--------------------------------------------------------
--  DDL for Package Body CX_DATA_BUILDER_PKGXX
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CX_DATA_BUILDER_PKGXX" AS


/*******************************************************************************
 *  
 *******************************************************************************/
 
    ---------------------------------------------- 
    -- PUBLIC: Return formatted block for LLM
 
FUNCTION get_context_data(
    p_context_Domain_id IN NUMBER,
    p_user_id           IN NUMBER DEFAULT v('G_USER_ID'),
    p_filter_ctx        IN CLOB  DEFAULT NULL   ,
    p_call_Id                  IN NUMBER,
   p_trace_Id                  IN VARCHAR2

 
) RETURN CLOB
IS
    vcaller constant varchar2(70):= c_package_name ||'.get_context_data';
    v_output CLOB := '';
    v_data_block CLOB;
    v_count NUMBER := 0;
BEGIN

--⚠️p_filter_ctx  May need actual filter context  Should p_filter_ctx be dynamically built (e.g., from session state)?
     --Or should it remain NULL for now? Example: '{"person_id": 123, "org_id": 45}'

    -- Header
    v_output := '[CONTEXT DATA BLOCK - Domain ID: ' || p_context_Domain_id || ']' || CHR(10) || CHR(10);
    
    -- Loop through all context registry entries linked to this domain
    -- that are accessible to the user's role
    FOR rec IN (
        SELECT DISTINCT 
             dr.context_registry_id,
             cr.source_name,
             cr.registry_source_type_code
        FROM context_domain_registry dr,
             context_registry cr,
             context_registry_roles rr,
             user_roles ur
        WHERE dr.context_domain_id = p_context_Domain_id
             AND ur.user_id = p_user_id
              AND dr.context_registry_id = cr.context_registry_id
              AND cr.context_registry_id = rr.context_registry_id
              AND rr.role_id = ur.role_id
              AND  cr.REGISTRY_SOURCE_TYPE_CODE in ('VIEW','TABLE','SQL','PLSQL_FN')
              AND dr.is_active = 'Y'
              AND cr.is_active = 'Y'
              AND rr.is_active = 'Y'
              AND ur.is_active = 'Y'

    ) LOOP
        
        v_count := v_count + 1;
        
        -- Call existing get_data_block for each registry
        -- Note: p_filter_ctx is NULL - you may need to provide actual context
        v_data_block := cx_data_builder_pkg.get_data_block(
            p_user_id     => p_user_id,
            p_registry_id => rec.context_registry_id,
            p_filter_ctx  => p_filter_ctx,  -- ⚠️ May need actual filter context  Should p_filter_ctx be dynamically built (e.g., from session state)?
                                      --Or should it remain NULL for now? Example: '{"person_id": 123, "org_id": 45}'
          p_call_Id => p_call_Id,
           p_trace_id => p_trace_id
        );
        
        v_output := v_output || v_data_block || CHR(10);
        
    END LOOP;
    
    -- Footer
    IF v_count = 0 THEN
        v_output := v_output || '[NO DATA SOURCES AVAILABLE FOR THIS DOMAIN]' || CHR(10);
    ELSE
        v_output := v_output || CHR(10) || '[Total Data Sources: ' || v_count || ']' || CHR(10);
    END IF;
    
    RETURN v_output;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN '[ERROR IN get_context_data: ' || SQLERRM || ']';
END get_context_data;

/*******************************************************************************
 *  
 *******************************************************************************/

    FUNCTION get_data_block(
        p_user_id      IN NUMBER,
        p_registry_id  IN NUMBER,
        p_filter_ctx   IN CLOB  DEFAULT NULL
    ) RETURN CLOB
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_data_block';
        v_source_name  VARCHAR2(200);
        v_source_type  VARCHAR2(30);
        v_mand_filters CLOB;
        v_sec_level    NUMBER;
        v_role_filter  CLOB;
        v_sql          CLOB;
        v_data         t_data_row_tab;
        v_block        CLOB := '';
    BEGIN
        Cx_DATA_PKG.load_registry(p_registry_id, v_source_name, v_source_type, v_mand_filters, v_sec_level);
         debug_util.info('Step 0: ...',vcaller);  
        IF v_source_name IS NULL THEN
            RETURN '[INVALID SOURCE]';
        END IF;
   --debug_util.info( Step 1: ...',vcaller);  
     
     --DBMS_OUTPUT.PUT_LINE(' Step 2: ...',vcaller);  
      --  v_role_filter := CONTEXT_DATA_PKG.load_role_filter(p_user_id, p_registry_id);
--debug_util.info(' Step 3: ...',vcaller);  
        v_sql := Cx_DATA_PKG.build_sql(p_user_id, v_source_name, v_mand_filters, v_role_filter, p_filter_ctx);
 -- debug_util.info(' Step 4: ...',vcaller);  
        v_data := Cx_DATA_PKG.run_query(v_sql);
-- debug_util.info(' Step 5: ...',vcaller);  
        v_block := '---'||CHR(10)||'DATA SOURCE: '||v_source_name||CHR(10);

        FOR i IN 1 .. v_data.COUNT LOOP
            v_block := v_block ||
                       v_data(i).column_name || ': ' || v_data(i).value_text || CHR(10);
        END LOOP;

        RETURN v_block;
   Exception 
    when others then 
     debug_util.error(sqlerrm,vcaller);  
     RETURN '[ERROR IN >context_data_builder_pkg> get_data_block: ' || SQLERRM || ']';
    END get_data_block;
/*******************************************************************************
 *  
 *******************************************************************************/
END cx_data_builder_pkgxx;

/
