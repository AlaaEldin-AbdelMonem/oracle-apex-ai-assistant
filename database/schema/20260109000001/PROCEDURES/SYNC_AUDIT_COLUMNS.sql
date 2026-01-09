--------------------------------------------------------
--  DDL for Procedure SYNC_AUDIT_COLUMNS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."SYNC_AUDIT_COLUMNS" (
    p_table_name IN VARCHAR2
)
AS
    -- List of column name patterns to be dropped
    TYPE t_column_list IS TABLE OF VARCHAR2(100);
    l_columns_to_check t_column_list := t_column_list(
        'CREATED_BY', 'CREATE_BY', 'CREATED_USER', 'CREATION_USER',
        'CREATED_ON', 'CREATE_DATE', 'CREATION_DATE', 'CREATED_AT',
        'UPDATED_BY', 'UPDATE_BY', 'MODIFIED_BY', 'LAST_MODIFIED_BY',
        'UPDATED_ON', 'UPDATE_DATE', 'MODIFIED_DATE', 'LAST_UPDATE_DATE',
        'VERSION', 'VERSION_ID'
    );
    
    l_owner            VARCHAR2(128) := USER; -- Assuming current user owns the table
    l_ddl_statement    VARCHAR2(4000);
    l_column_exists    NUMBER;
    l_current_column   VARCHAR2(100);
BEGIN
    -- Enable output for feedback
    DBMS_OUTPUT.PUT_LINE('Starting audit column synchronization for table: ' || UPPER(p_table_name));
    
    -- 1. DROP EXISTING AUDIT COLUMNS
    ----------------------------------------------------------------------
    FOR i IN 1..l_columns_to_check.COUNT LOOP
        l_current_column := UPPER(l_columns_to_check(i));
        
        -- Check if the column exists in the table
        BEGIN
            SELECT 1 INTO l_column_exists
            FROM ALL_TAB_COLUMNS
            WHERE OWNER = l_owner
            AND TABLE_NAME = UPPER(p_table_name)
            AND COLUMN_NAME = l_current_column;
            
            -- If it exists, drop it
            l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' DROP COLUMN ' || l_current_column;
            EXECUTE IMMEDIATE l_ddl_statement;
            
            DBMS_OUTPUT.PUT_LINE('  --> DROPPED column: ' || l_current_column);
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- Column does not exist, proceed to the next column
                NULL;
            WHEN OTHERS THEN
                -- Handle other errors (e.g., column is part of a constraint)
                DBMS_OUTPUT.PUT_LINE('  !!! WARNING: Failed to drop column ' || l_current_column || '. Error: ' || SQLERRM);
        END;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('Existing audit columns check complete.');

    -- 2. ADD STANDARD AUDIT COLUMNS and VERSION_NO
    ----------------------------------------------------------------------
    
    -- Add CREATED_BY
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' ADD (CREATED_BY VARCHAR2(100) DEFAULT USER)';
    EXECUTE IMMEDIATE l_ddl_statement;
    
    -- Add CREATION_DATE
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' ADD (CREATION_DATE DATE DEFAULT SYSDATE)';
    EXECUTE IMMEDIATE l_ddl_statement;
    
    -- Add LAST_UPDATED_BY
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' ADD (LAST_UPDATED_BY VARCHAR2(100))';
    EXECUTE IMMEDIATE l_ddl_statement;
    
    -- Add LAST_UPDATE_DATE
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' ADD (LAST_UPDATE_DATE DATE)';
    EXECUTE IMMEDIATE l_ddl_statement;
    
    -- Add VERSION_NO
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' ADD (VERSION_NO NUMBER(10) DEFAULT 1 NOT NULL)';
    EXECUTE IMMEDIATE l_ddl_statement;

    DBMS_OUTPUT.PUT_LINE('New standard audit columns added successfully.');
    DBMS_OUTPUT.PUT_LINE('Procedure completed for table ' || UPPER(p_table_name));

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('!!! FATAL ERROR: An unexpected error occurred while processing table ' || UPPER(p_table_name) || '. Error: ' || SQLERRM);
        -- Re-raise the exception to stop execution and log the error
        RAISE;
END SYNC_AUDIT_COLUMNS;

/
