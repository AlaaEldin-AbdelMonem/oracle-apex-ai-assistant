--------------------------------------------------------
--  DDL for Procedure SAFELY_TRUNCATE_TABLE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."SAFELY_TRUNCATE_TABLE" (
    p_table_name IN VARCHAR2,
    p_owner      IN VARCHAR2 DEFAULT USER
)
/*******************************************************************************
 *  
 *******************************************************************************/
IS
    v_sql_stmt       VARCHAR2(4000);
    v_pk_name        ALL_CONSTRAINTS.constraint_name%TYPE;
    v_fk_count       NUMBER := 0;

    CURSOR c_child_fks IS
        -- 1. Find all Foreign Keys (R type) in all_constraints
        -- 2. Which reference the Primary Key (or Unique Key) of the parent table (p_table_name)
        SELECT
            c_child.owner       AS child_owner,
            c_child.table_name  AS child_table,
            c_child.constraint_name AS child_fk_name
        FROM
            user_constraints c_child
        WHERE
            c_child.r_owner = UPPER(p_owner)
            AND c_child.r_constraint_name = v_pk_name
            AND c_child.constraint_type = 'R';

BEGIN
    -- Set session parameters for output
    DBMS_OUTPUT.ENABLE(NULL);

    DBMS_OUTPUT.PUT_LINE('--- Starting Safe Truncate Procedure for ' || UPPER(p_owner) || '.' || UPPER(p_table_name) || ' ---');

    -- 1. Find the Primary Key (PK) constraint name of the target table.
    BEGIN
        SELECT
            constraint_name
        INTO
            v_pk_name
        FROM
            user_constraints
        WHERE
            owner = UPPER(p_owner)
            AND table_name = UPPER(p_table_name)
            AND constraint_type IN ('P', 'U') -- Use Primary Key or Unique Key
            AND ROWNUM = 1; -- Get the first one found

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- If no PK/UK, the ORA-02266 error is impossible, so we can proceed directly.
            v_pk_name := NULL;
    END;

    -- 2. If a PK/UK was found, check for dependent child tables.
    IF v_pk_name IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('Parent PK/UK detected: ' || v_pk_name);

        -- Generate the DISABLE statements
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 1. DISABLE STATEMENTS:');
        FOR rec IN c_child_fks LOOP
            v_fk_count := v_fk_count + 1;
            v_sql_stmt := 'ALTER TABLE ' || rec.child_owner || '.' || rec.child_table ||
                          ' DISABLE CONSTRAINT ' || rec.child_fk_name || ';';
            DBMS_OUTPUT.PUT_LINE(v_sql_stmt);
        END LOOP;
    END IF;

    -- 3. Truncate statement
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 2. TRUNCATE STATEMENT:');
    v_sql_stmt := 'TRUNCATE TABLE ' || UPPER(p_owner) || '.' || UPPER(p_table_name) || ';';
    DBMS_OUTPUT.PUT_LINE(v_sql_stmt);

    -- 4. Generate the ENABLE statements
    IF v_fk_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- 3. RE-ENABLE STATEMENTS:');
        FOR rec IN c_child_fks LOOP
            v_sql_stmt := 'ALTER TABLE ' || rec.child_owner || '.' || rec.child_table ||
                          ' ENABLE CONSTRAINT ' || rec.child_fk_name || ';';
            DBMS_OUTPUT.PUT_LINE(v_sql_stmt);
        END LOOP;
    END IF;

    -- Final Summary
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Total foreign keys disabled/enabled: ' || v_fk_count);
    DBMS_OUTPUT.PUT_LINE('Procedure complete. Run the generated SQL manually.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);

END safely_truncate_table;

/
