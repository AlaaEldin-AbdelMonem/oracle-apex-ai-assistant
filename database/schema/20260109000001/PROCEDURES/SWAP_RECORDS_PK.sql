--------------------------------------------------------
--  DDL for Procedure SWAP_RECORDS_PK
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "AI8P"."SWAP_RECORDS_PK" (
    p_table_name  IN VARCHAR2,
    p_pk_column   IN VARCHAR2,
    p_id_one      IN NUMBER,
    p_id_two      IN NUMBER
)
AS
/*******************************************************************************
 *  
 *******************************************************************************/
    l_fk_owner_name  VARCHAR2(128);
    l_fk_table_name  VARCHAR2(128);
    l_fk_constraint  VARCHAR2(128);
    l_ddl_statement  VARCHAR2(4000);

    -- Cursor to find all referencing foreign key constraints
    CURSOR c_fk IS
        SELECT
            c.owner,
            c.table_name,
            c.constraint_name
        FROM
            all_constraints c
        WHERE
            c.r_owner = USER -- Assuming referenced table is in current user's schema
        AND c.r_constraint_name = (
            SELECT constraint_name
            FROM all_constraints
            WHERE table_name = UPPER(p_table_name)
            AND constraint_type = 'P'
            AND owner = USER -- Assuming the PK constraint is in current user's schema
        )
        AND c.constraint_type = 'R'; -- Foreign Key

BEGIN
    -- Enable deferrable constraints for the current transaction
    EXECUTE IMMEDIATE 'SET CONSTRAINTS ALL DEFERRED';
    DBMS_OUTPUT.PUT_LINE('Constraints set to DEFERRED.');

    -- 1. Temporarily Defer or Disable Foreign Keys
    -- This handles the case where FKs might not be deferrable or might need explicit attention.
    FOR r_fk IN c_fk LOOP
        BEGIN
            -- Attempt to make the constraint deferrable for this transaction
            l_ddl_statement := 'ALTER TABLE ' || r_fk.owner || '.' || r_fk.table_name 
                               || ' MODIFY CONSTRAINT ' || r_fk.constraint_name 
                               || ' DEFERRABLE INITIALLY DEFERRED';
            EXECUTE IMMEDIATE l_ddl_statement;
            DBMS_OUTPUT.PUT_LINE('  --> Deferred FK: ' || r_fk.table_name || '.' || r_fk.constraint_name);
        EXCEPTION
            WHEN OTHERS THEN
                -- If modifying fails (e.g., constraint is not alterable), try disabling it
                l_ddl_statement := 'ALTER TABLE ' || r_fk.owner || '.' || r_fk.table_name 
                                   || ' DISABLE CONSTRAINT ' || r_fk.constraint_name;
                EXECUTE IMMEDIATE l_ddl_statement;
                DBMS_OUTPUT.PUT_LINE('  --> Disabled FK: ' || r_fk.table_name || '.' || r_fk.constraint_name);
        END;
    END LOOP;

    -- 2. Perform the Swap using a temporary unique value
    DBMS_OUTPUT.PUT_LINE('Starting PK swap: ' || p_id_one || ' <-> ' || p_id_two);

    -- Oracle requires two updates and a temporary value, as you cannot swap in a single statement 
    -- and must avoid intermediate uniqueness violations.

    -- Generate a unique temporary ID (e.g., using a large negative number)
    DECLARE
        l_temp_id NUMBER := -999999999;
    BEGIN
        -- Step A: Move ID_ONE to TEMP_ID
        l_ddl_statement := 'UPDATE ' || p_table_name || ' SET ' || p_pk_column || ' = ' || l_temp_id || 
                           ' WHERE ' || p_pk_column || ' = ' || p_id_one;
        EXECUTE IMMEDIATE l_ddl_statement;

        -- Step B: Move ID_TWO to ID_ONE
        l_ddl_statement := 'UPDATE ' || p_table_name || ' SET ' || p_pk_column || ' = ' || p_id_one || 
                           ' WHERE ' || p_pk_column || ' = ' || p_id_two;
        EXECUTE IMMEDIATE l_ddl_statement;

        -- Step C: Move TEMP_ID to ID_TWO
        l_ddl_statement := 'UPDATE ' || p_table_name || ' SET ' || p_pk_column || ' = ' || p_id_two || 
                           ' WHERE ' || p_pk_column || ' = ' || l_temp_id;
        EXECUTE IMMEDIATE l_ddl_statement;
    END;

    DBMS_OUTPUT.PUT_LINE('PK swap complete.');

    -- 3. Re-enable Constraints (If they were disabled) and Commit
    FOR r_fk IN c_fk LOOP
        -- Attempt to re-enable (this will succeed only if it was disabled)
        l_ddl_statement := 'ALTER TABLE ' || r_fk.owner || '.' || r_fk.table_name 
                           || ' ENABLE CONSTRAINT ' || r_fk.constraint_name;

        BEGIN
            EXECUTE IMMEDIATE l_ddl_statement;
            DBMS_OUTPUT.PUT_LINE('  --> Enabled FK: ' || r_fk.table_name || '.' || r_fk.constraint_name);
        EXCEPTION
            WHEN OTHERS THEN
                -- Ignore errors if the constraint was only deferred, not disabled
                NULL;
        END;
    END LOOP;

    -- If any constraints were only deferred, committing will automatically check and enforce them now.
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Transaction committed successfully. All constraints checked/re-enabled.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        -- Attempt to re-enable disabled constraints before exiting on error
        FOR r_fk IN c_fk LOOP
             BEGIN
                l_ddl_statement := 'ALTER TABLE ' || r_fk.owner || '.' || r_fk.table_name 
                                   || ' ENABLE CONSTRAINT ' || r_fk.constraint_name;
                EXECUTE IMMEDIATE l_ddl_statement;
             EXCEPTION
                WHEN OTHERS THEN
                   NULL; -- Ignore error if constraint was only deferred
             END;
        END LOOP;
        DBMS_OUTPUT.PUT_LINE('!!! ERROR: An error occurred. Changes rolled back. Error: ' || SQLERRM);
        RAISE; -- Re-raise the exception
END SWAP_RECORDS_PK;

/
