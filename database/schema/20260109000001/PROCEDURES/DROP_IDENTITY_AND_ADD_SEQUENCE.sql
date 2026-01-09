--------------------------------------------------------
--  DDL for Procedure DROP_IDENTITY_AND_ADD_SEQUENCE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."DROP_IDENTITY_AND_ADD_SEQUENCE" (
    p_table_name IN VARCHAR2
)
AS
/*******************************************************************************
 *  
 *******************************************************************************/
    l_pk_column_name    VARCHAR2(128);
    l_pk_constraint_name VARCHAR2(128);
    l_sequence_name     VARCHAR2(128) := UPPER(p_table_name) || '_SEQ';
    l_max_value         NUMBER;
    l_ddl_statement     VARCHAR2(4000);
BEGIN
    -- 1. Find the Primary Key Column and Constraint Name
    BEGIN
        SELECT cols.column_name, cons.constraint_name
        INTO l_pk_column_name, l_pk_constraint_name
        FROM all_constraints cons
        JOIN all_cons_columns cols ON cons.owner = cols.owner
                                   AND cons.constraint_name = cols.constraint_name
        WHERE cons.constraint_type = 'P' -- Primary Key
        AND cons.table_name = UPPER(p_table_name)
        AND ROWNUM = 1; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Primary Key not found for table ' || p_table_name);
        WHEN TOO_MANY_ROWS THEN
            RAISE_APPLICATION_ERROR(-20002, 'Composite Primary Key found for table ' || p_table_name || '. Procedure only supports single-column PK.');
    END;

    -- 2. Drop the IDENTITY property from the Primary Key Column (FIXED)
    DBMS_OUTPUT.PUT_LINE('Modifying column ' || l_pk_column_name || ' to drop IDENTITY property.');
    -- Use DROP IDENTITY to successfully remove the identity property regardless of GENERATED ALWAYS/BY DEFAULT
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' MODIFY (' || l_pk_column_name || ' DROP IDENTITY)';
    EXECUTE IMMEDIATE l_ddl_statement; -- This was line 31 where the error occurred

    -- 3. Get the current maximum value in the Primary Key column
    l_ddl_statement := 'SELECT NVL(MAX(' || l_pk_column_name || '), 0) FROM ' || p_table_name;
    EXECUTE IMMEDIATE l_ddl_statement INTO l_max_value;
    
    DBMS_OUTPUT.PUT_LINE('Current max value in ' || l_pk_column_name || ' is ' || l_max_value);

    -- 4. Create the Sequence if it does not exist
    BEGIN
        SELECT 1 INTO l_max_value FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = l_sequence_name AND ROWNUM = 1;
        DBMS_OUTPUT.PUT_LINE('Sequence ' || l_sequence_name || ' already exists. Skipping creation.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Creating sequence ' || l_sequence_name || ' starting with ' || (l_max_value + 1));
            l_ddl_statement := 'CREATE SEQUENCE ' || l_sequence_name || ' START WITH ' || (l_max_value + 1) || ' INCREMENT BY 1 NOCACHE NOORDER';
            EXECUTE IMMEDIATE l_ddl_statement;
    END;

    -- 5. Set the Sequence NEXTVAL to MAX(PK) + 1 (Adjustment Logic)
    DECLARE
        l_increment_by NUMBER;
        l_next_value_fix_statement VARCHAR2(4000);
        l_jump_size      NUMBER := (l_max_value + 1) - 1;
    BEGIN
        -- Find the current increment by value
        SELECT INCREMENT_BY INTO l_increment_by FROM ALL_SEQUENCES WHERE SEQUENCE_NAME = l_sequence_name;
        
        -- If current MAX is 0, we set the jump size to 0 to keep start at 1
        IF l_jump_size < 1 THEN
           l_jump_size := 1;
        END IF;

        -- Step 1: Alter sequence to make the jump
        l_next_value_fix_statement := 'ALTER SEQUENCE ' || l_sequence_name || ' INCREMENT BY ' || l_jump_size;
        EXECUTE IMMEDIATE l_next_value_fix_statement;
        
        -- Step 2: Select next value to force the jump (if l_jump_size > 1)
        IF l_jump_size > 1 THEN
            l_ddl_statement := 'SELECT ' || l_sequence_name || '.NEXTVAL FROM DUAL';
            EXECUTE IMMEDIATE l_ddl_statement INTO l_max_value; 
        END IF;
        
        -- Step 3: Reset the increment to 1
        l_next_value_fix_statement := 'ALTER SEQUENCE ' || l_sequence_name || ' INCREMENT BY 1';
        EXECUTE IMMEDIATE l_next_value_fix_statement;

        DBMS_OUTPUT.PUT_LINE('Sequence ' || l_sequence_name || ' adjusted. Next value is now correct.');
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error adjusting sequence. Error: ' || SQLERRM);
            RAISE; -- Re-raise the exception
    END;
    
    -- 6. Add the Sequence as the Default Value to the Primary Key Column
    DBMS_OUTPUT.PUT_LINE('Setting default value on ' || l_pk_column_name || ' to use ' || l_sequence_name);
    l_ddl_statement := 'ALTER TABLE ' || p_table_name || ' MODIFY (' || l_pk_column_name || ' DEFAULT ' || l_sequence_name || '.NEXTVAL)';
    EXECUTE IMMEDIATE l_ddl_statement;

    DBMS_OUTPUT.PUT_LINE('Procedure completed successfully for table ' || p_table_name);

END DROP_IDENTITY_AND_ADD_SEQUENCE;

/
