--------------------------------------------------------
--  DDL for Package Body CX_DATA_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CX_DATA_PKG" AS

/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    -- INTERNAL: Convert JSON CLOB to same CLOB (helper for JSON_EXISTS)
    ----------------------------------------------------------------------------
    FUNCTION json_clob(p_json CLOB) RETURN CLOB IS
       vcaller constant varchar2(70):= c_package_name ||'.json_clob';
    BEGIN
        RETURN p_json;
    END json_clob;
/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    --  : Load metadata for registry entry
    ----------------------------------------------------------------------------
    PROCEDURE load_registry(
        p_registry_id        IN NUMBER,
        p_source_name        OUT VARCHAR2,
        p_source_type        OUT VARCHAR2,
        p_mandatory_filters  OUT CLOB,
        p_security_level     OUT NUMBER
    ) IS
           vcaller constant varchar2(70):= c_package_name ||'.load_registry';
    BEGIN
        SELECT source_name,
               registry_source_type_code,
               mandatory_filters--,
              -- security_level
        INTO p_source_name,
             p_source_type,
             p_mandatory_filters--,
             --p_security_level
        FROM context_registry
        WHERE context_registry_id = p_registry_id
          AND is_active = 'Y';

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           debug_util.error(sqlerrm,vcaller);  
            p_source_name := NULL;
    END load_registry;

/*******************************************************************************
 *  
 *******************************************************************************/

 --   Load role-based filter template
    ----------------------------------------------------------------------------
    FUNCTION load_role_filter(
        p_user_id     IN NUMBER,
        p_registry_id IN NUMBER
    ) RETURN CLOB
    IS
        vcaller constant varchar2(70):= c_package_name ||'.load_role_filter';
        v_filter CLOB;
    BEGIN
        SELECT rr.filter_template
        INTO v_filter
        FROM context_registry_roles rr
        JOIN user_roles ur
          ON ur.role_id = rr.role_id
        WHERE rr.context_registry_id = p_registry_id
          AND rr.is_active = 'Y'
          AND ur.user_id = p_user_id
        FETCH FIRST 1 ROW ONLY;

        RETURN v_filter;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           debug_util.error(sqlerrm,vcaller);  
            RETURN NULL;
    END load_role_filter;


/*******************************************************************************
 *  
 *******************************************************************************/
    ----------------------------------------------------------------------------
    --   Build dynamic SQL with safety features
    ----------------------------------------------------------------------------
    FUNCTION build_sql(
        p_user_id        IN NUMBER,
        p_source_name    IN VARCHAR2,
        p_mand_filters   IN CLOB,
        p_role_filter    IN CLOB,
        p_filter_ctx     IN CLOB
    ) RETURN CLOB
    IS
      vcaller constant varchar2(70):= c_package_name ||'.build_sql';
        v_sql CLOB :=
            'SELECT * FROM ' || DBMS_ASSERT.sql_object_name(p_source_name) || ' WHERE 1=1 ';
    BEGIN

        ------------------------------------------------------------------------
        -- Apply mandatory filters (JSON array: ["person_id","org_id"])
        ------------------------------------------------------------------------
        IF p_mand_filters IS NOT NULL THEN
            FOR f IN (
                SELECT value AS col_name
                FROM JSON_TABLE(
                    p_mand_filters,
                    '$[*]' COLUMNS (value VARCHAR2(200) PATH '$')
                )
            ) LOOP

                IF JSON_EXISTS(json_clob(p_filter_ctx),
                               '$."'||f.col_name||'"')
                THEN
                    v_sql := v_sql ||
                        ' AND ' || DBMS_ASSERT.simple_sql_name(f.col_name) ||
                        ' = ' ||
                        '''' || 
                        REPLACE(
                            JSON_VALUE(p_filter_ctx,
                                       '$."'||f.col_name||'"'),
                            '''',''''''
                        ) ||
                        '''';
                END IF;

            END LOOP;
        END IF;


        ------------------------------------------------------------------------
        -- Apply role-based SQL template
        ------------------------------------------------------------------------
        IF p_role_filter IS NOT NULL THEN
            v_sql := v_sql || ' ' || p_role_filter;
        END IF;

        RETURN v_sql;

    END build_sql;

/*******************************************************************************
 *  
 *******************************************************************************/

    ----------------------------------------------------------------------------
    -- INTERNAL: Run dynamic SQL using DBMS_SQL
    -- Returns SQL type t_data_row_tab
    ----------------------------------------------------------------------------
    FUNCTION run_query(
        p_sql CLOB
    ) RETURN t_data_row_tab
    IS
         vcaller constant varchar2(70):= c_package_name ||'.run_query';
        v_cur    INTEGER;
        v_rc     INTEGER;
        v_cols   INTEGER;
        v_desc   DBMS_SQL.desc_tab;
        v_tab    t_data_row_tab := t_data_row_tab();

        -- buffers
        v_num   NUMBER;
        v_vc    VARCHAR2(4000);
        v_date  DATE;

        v_val   CLOB;
    BEGIN
        v_cur := DBMS_SQL.open_cursor;
        DBMS_SQL.parse(v_cur, p_sql, DBMS_SQL.native);

        DBMS_SQL.describe_columns(v_cur, v_cols, v_desc);

        -- Define columns by type
        FOR i IN 1..v_cols LOOP
            CASE v_desc(i).col_type
                WHEN 1 THEN DBMS_SQL.define_column(v_cur, i, v_vc, 4000);
                WHEN 2 THEN DBMS_SQL.define_column(v_cur, i, v_num);
                WHEN 12 THEN DBMS_SQL.define_column(v_cur, i, v_date);
                ELSE DBMS_SQL.define_column(v_cur, i, v_vc, 4000);
            END CASE;
        END LOOP;

        v_rc := DBMS_SQL.execute(v_cur);

        WHILE DBMS_SQL.fetch_rows(v_cur) > 0 LOOP

            FOR i IN 1..v_cols LOOP
                CASE v_desc(i).col_type
                    WHEN 1 THEN
                        DBMS_SQL.column_value(v_cur, i, v_vc);
                        v_val := v_vc;
                    WHEN 2 THEN
                        DBMS_SQL.column_value(v_cur, i, v_num);
                        v_val := TO_CHAR(v_num);
                    WHEN 12 THEN
                        DBMS_SQL.column_value(v_cur, i, v_date);
                        v_val := TO_CHAR(v_date,'YYYY-MM-DD');
                    ELSE
                        DBMS_SQL.column_value(v_cur, i, v_vc);
                        v_val := v_vc;
                END CASE;

                v_tab.EXTEND;
                v_tab(v_tab.COUNT) :=
                    t_data_row_obj(
                        v_desc(i).col_name,
                        v_val
                    );
            END LOOP;

        END LOOP;

        DBMS_SQL.close_cursor(v_cur);

        RETURN v_tab;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error(sqlerrm,vcaller);  
            IF DBMS_SQL.is_open(v_cur) THEN
                DBMS_SQL.close_cursor(v_cur);
            END IF;
            RAISE;
    END run_query;
/*******************************************************************************
 *  
 *******************************************************************************/


    ----------------------------------------------------------------------------
    -- PUBLIC: Return JSON array
    ----------------------------------------------------------------------------
    FUNCTION get_data_json(
        p_user_id      IN NUMBER,
        p_registry_id  IN NUMBER,
        p_filter_ctx   IN CLOB
    ) RETURN CLOB
    IS
      vcaller constant varchar2(70):= c_package_name ||'.get_data_json';
        v_source_name VARCHAR2(200);
        v_source_type VARCHAR2(30);
        v_mand_filters CLOB;
        v_sec_level NUMBER;
        v_role_filter CLOB;
        v_sql CLOB;
        v_data t_data_row_tab;
        v_json CLOB;
    BEGIN
        load_registry(p_registry_id, v_source_name, v_source_type, v_mand_filters, v_sec_level);

        IF v_source_name IS NULL THEN RETURN '[]'; END IF;

       -- IF NOT context_policy_pkg.can_access_classification(p_user_id, v_sec_level) THEN
        --    RETURN '[]';
       -- END IF;

        v_role_filter := load_role_filter(p_user_id, p_registry_id);

        v_sql := build_sql(p_user_id, v_source_name, v_mand_filters, v_role_filter, p_filter_ctx);

        v_data := run_query(v_sql);

        SELECT JSON_ARRAYAGG(
                   JSON_OBJECT(
                       'column' VALUE d.column_name,
                       'value'  VALUE d.value_text
                   )
               )
        INTO v_json
        FROM TABLE(CAST(v_data AS t_data_row_tab)) d;

        RETURN v_json;

    END get_data_json;
/*******************************************************************************
 *  
 *******************************************************************************/----------------------------------------------------------------------------
    -- PUBLIC: Return formatted block for LLM
    ----------------------------------------------------------------------------
    FUNCTION get_data_block(
        p_user_id      IN NUMBER,
        p_registry_id  IN NUMBER,
        p_filter_ctx   IN CLOB
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
        load_registry(p_registry_id, v_source_name, v_source_type, v_mand_filters, v_sec_level);

        IF v_source_name IS NULL THEN
            RETURN '[INVALID SOURCE]';
        END IF;

        --IF NOT context_policy_pkg.can_access_classification(p_user_id, v_sec_level) THEN
        --    RETURN '[ACCESS DENIED]';
        --END IF;

        v_role_filter := load_role_filter(p_user_id, p_registry_id);

        v_sql := build_sql(p_user_id, v_source_name, v_mand_filters, v_role_filter, p_filter_ctx);

        v_data := run_query(v_sql);

        v_block := '---'||CHR(10)||'DATA SOURCE: '||v_source_name||CHR(10);

        FOR i IN 1 .. v_data.COUNT LOOP
            v_block := v_block ||
                       v_data(i).column_name || ': ' || v_data(i).value_text || CHR(10);
        END LOOP;

        RETURN v_block;

    END get_data_block;
/*******************************************************************************
 *  
 *******************************************************************************/

END cx_data_pkg;

/
