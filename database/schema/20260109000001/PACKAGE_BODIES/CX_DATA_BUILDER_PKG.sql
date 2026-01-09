--------------------------------------------------------
--  DDL for Package Body CX_DATA_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CX_DATA_BUILDER_PKG" AS

    ----------------------------------------------------------------------------
    -- PUBLIC: Return formatted block for LLM
    ----------------------------------------------------------------------------
 /*******************************************************************************
 * 
  *******************************************************************************/
   FUNCTION concat_text(
    p_main_text  IN VARCHAR2,
    p_new_text   IN VARCHAR2,
    p_separator  IN VARCHAR2 DEFAULT ', ',
    p_max_limit  IN NUMBER DEFAULT 4000
) RETURN VARCHAR2 
IS
    v_indicator  CONSTANT VARCHAR2(5) := '.....';
    v_limit      CONSTANT NUMBER := p_max_limit;
    v_result     VARCHAR2(4000);
BEGIN
    -- 1. Handle NULL/Empty additions
    IF p_new_text IS NULL OR TRIM(p_new_text) = '' THEN
        RETURN p_main_text;
    END IF;

    -- 2. Handle First entry
    IF p_main_text IS NULL OR TRIM(p_main_text) = '' THEN
        -- Ensure the first entry itself isn't over the limit
        IF LENGTH(p_new_text) > v_limit THEN
            RETURN SUBSTR(p_new_text, 1, v_limit - LENGTH(v_indicator)) || v_indicator;
        ELSE
            RETURN p_new_text;
        END IF;
    END IF;

    -- 3. Check if already truncated (contains the dots at the end)
    IF p_main_text LIKE '%' || v_indicator THEN
        RETURN p_main_text;
    END IF;

    -- 4. Calculate potential new length
    -- Formula: current + separator + new
    IF (LENGTH(p_main_text) + LENGTH(p_separator) + LENGTH(p_new_text)) > v_limit THEN
        -- Not enough room for everything. Truncate current and add dots.
        -- We take the existing text and ensure we have room for the dots.
        RETURN SUBSTR(p_main_text || p_separator || p_new_text, 1, v_limit - LENGTH(v_indicator)) || v_indicator;
    ELSE
        -- Plenty of room
        RETURN p_main_text || p_separator || p_new_text;
    END IF;
    
END concat_text;

 /*******************************************************************************
 * 
  *******************************************************************************/
    FUNCTION get_context_data(
        p_context_Domain_id IN NUMBER,
        p_user_id           IN NUMBER DEFAULT v('G_USER_ID'),
        p_filter_ctx        IN CLOB   DEFAULT NULL,
        p_call_Id            IN NUMBER,
        p_trace_Id           IN VARCHAR2
    ) RETURN CLOB
    IS
        vcaller      CONSTANT VARCHAR2(70) := c_package_name || '.get_context_data';
        v_output     CLOB := '';
        v_data_block CLOB;
        v_count      NUMBER := 0;
        v_start_time TIMESTAMP := SYSTIMESTAMP;
        v_total_ms   NUMBER;
        v_msg VARCHAR2(400);
    BEGIN
        debug_util.starting(vcaller, 'Domain ID: ' || p_context_Domain_id, p_trace_id);

        -- Header
        v_output := '[CONTEXT DATA BLOCK - Domain ID: ' || p_context_Domain_id || ']' || CHR(10) || CHR(10);
        
        -- Loop through authorized registry entries
        FOR rec IN (
            SELECT DISTINCT 
                 dr.context_registry_id,
                 cr.source_name
            FROM context_domain_registry dr
            JOIN context_registry cr ON dr.context_registry_id = cr.context_registry_id
            JOIN context_registry_roles rr ON cr.context_registry_id = rr.context_registry_id
            JOIN user_roles ur ON rr.role_id = ur.role_id
            WHERE dr.context_domain_id = p_context_Domain_id
              AND ur.user_id = p_user_id
              AND cr.REGISTRY_SOURCE_TYPE_CODE IN ('VIEW','TABLE','SQL','PLSQL_FN')
              AND dr.is_active = 'Y'
              AND cr.is_active = 'Y'
              AND ur.is_active = 'Y'
        ) LOOP
            
            v_count := v_count + 1;
     
              v_msg :=  concat_text( p_main_text  =>v_msg, p_new_text => rec.source_name);--get list of sourceNames

            -- Call get_data_block
            -- PRO TIP: p_filter_ctx can be passed as a JSON string from the calling RAG pipeline
            v_data_block := cx_data_builder_pkg.get_data_block(
                p_user_id     => p_user_id,
                p_registry_id => rec.context_registry_id,
                p_filter_ctx  => p_filter_ctx,
                p_call_Id   =>   p_call_Id  ,
               p_trace_Id   =>     p_trace_Id       
            );
            
            v_output := v_output || v_data_block || CHR(10);
            
        END LOOP;
       
         debug_util.info(v_msg, vcaller, p_trace_id); 

        -- Calculate Latency for Dashboard Page 721
        v_total_ms := (EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000);

        -- Footer & Auditing
        IF v_count = 0 THEN
            v_output := v_output || '[NO DATA SOURCES AVAILABLE FOR THIS DOMAIN]' || CHR(10);
            
            -- Log a Warning (Nature: FAIL, Group: AI KPI, Code: AI_ERR)
             debug_util.error( 'No data sources found for Domain ' || p_context_Domain_id, vcaller,p_trace_id);  
            audit_util.log_failure(
                p_event_code => 'AI_ERR',
                p_reason     => 'No data sources found for Domain ' || p_context_Domain_id,
                p_caller     => vcaller
            );
        ELSE
            v_output := v_output || CHR(10) || '[Total Data Sources: ' || v_count || ' | Build Time: ' || v_total_ms || 'ms]' || CHR(10);
            
            -- Log Success (Nature: EVNT, Group: AI KPI, Code: PROC_OK)
            audit_util.log_event(
                p_event_code => 'PROC_OK',
                p_message    => 'Context Built: ' || v_count || ' sources in ' || v_total_ms || 'ms',
                p_caller     => vcaller,
                p_trace_id => p_trace_id
            );
        END IF;
        
        debug_util.ending(vcaller,'', p_trace_id);
        RETURN v_output;
        
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error( SQLERRM||' , Domain ' || p_context_Domain_id, vcaller , p_trace_id);  
            -- Log Infrastructure Failure (Nature: FAIL, Group: System Health, Code: SYS_DEP)

            audit_util.log_failure('SYS_DEP', 'Context Builder Crash: ' || SQLERRM, p_caller => vcaller ,p_trace_id=> p_trace_id);
            RETURN '[ERROR IN get_context_data: ' || SQLERRM || ']';
    END get_context_data;
 /*******************************************************************************
 * Fetch individual source block
  *******************************************************************************/
 
    FUNCTION get_data_block(
        p_user_id     IN NUMBER,
        p_registry_id IN NUMBER,
        p_filter_ctx  IN CLOB  DEFAULT NULL,
         p_call_Id            IN NUMBER,
        p_trace_Id           IN VARCHAR2
    ) RETURN CLOB
    IS
        vcaller        CONSTANT VARCHAR2(70) := c_package_name || '.get_data_block';
        v_source_name  VARCHAR2(200);
        v_source_type  VARCHAR2(30);
        v_mand_filters CLOB;
        v_sec_level    NUMBER;
        v_role_filter  CLOB;
        v_sql          CLOB;
        v_data         t_data_row_tab;
        v_block        CLOB := '';
    BEGIN
        -- 1. Load Metadata
        Cx_DATA_PKG.load_registry(p_registry_id, v_source_name, v_source_type, v_mand_filters, v_sec_level);
        
        IF v_source_name IS NULL THEN
            RETURN '[INVALID SOURCE: Registry ID ' || p_registry_id || ']';
        END IF;

        -- 2. Build and Execute SQL
        -- p_filter_ctx allows the LLM or UI to pass e.g. '{"project_id": 5}' to filter the result
        v_sql  := Cx_DATA_PKG.build_sql(p_user_id, v_source_name, v_mand_filters, v_role_filter, p_filter_ctx);
        v_data := Cx_DATA_PKG.run_query(v_sql);

        -- 3. Format result block
        v_block := '---' || CHR(10) || 'DATA SOURCE: ' || v_source_name || CHR(10);

        FOR i IN 1 .. v_data.COUNT LOOP
            v_block := v_block || v_data(i).column_name || ': ' || v_data(i).value_text || CHR(10);
        END LOOP;

        RETURN v_block;

    EXCEPTION
        WHEN OTHERS THEN 
            debug_util.error(SQLERRM, vcaller, p_trace_id);  
            RETURN '[ERROR IN get_data_block: Source ' || v_source_name || ' | ' || SQLERRM || ']';
    END get_data_block;
 /*******************************************************************************
 * 
  *******************************************************************************/
END cx_data_builder_pkg;

/
