--------------------------------------------------------
--  DDL for Function FIND_CONSTRAINT_SOURCE
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FIND_CONSTRAINT_SOURCE" (
    p_constraint_id IN VARCHAR2 -- E.g., 'SYS_C0094633'
)
/*******************************************************************************
 *  
 *******************************************************************************/
RETURN VARCHAR2
IS
    -- Variables to hold the constraint details
    v_child_owner         ALL_CONSTRAINTS.owner%TYPE;
    v_child_table         ALL_CONSTRAINTS.table_name%TYPE;
    v_parent_owner        ALL_CONSTRAINTS.r_owner%TYPE;
    v_parent_pk_name      ALL_CONSTRAINTS.r_constraint_name%TYPE;

    -- Variables to hold the column names
    v_child_columns       VARCHAR2(4000);
    v_parent_table        VARCHAR2(128);
    v_parent_columns      VARCHAR2(4000);

    v_result_message      VARCHAR2(4000);

BEGIN
    -- 1. Get the primary relationship details (Child table and Parent PK name)
    BEGIN
        SELECT
            owner,
            table_name,
            r_owner,
            r_constraint_name
        INTO
            v_child_owner,
            v_child_table,
            v_parent_owner,
            v_parent_pk_name
        FROM
            all_constraints
        WHERE
            constraint_name = p_constraint_id
            AND constraint_type = 'R'; -- R for Referential Integrity (Foreign Key)

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Error: Constraint "' || p_constraint_id || '" not found or is not a Foreign Key (R type).';
    END;

    -- 2. Get the Child Columns involved in the Foreign Key
    SELECT
        LISTAGG(column_name, ', ') WITHIN GROUP (ORDER BY position)
    INTO
        v_child_columns
    FROM
        all_cons_columns
    WHERE
        owner = v_child_owner
        AND constraint_name = p_constraint_id;

    -- 3. Get the Parent Table and Columns (using the Parent PK name)
    BEGIN
        SELECT
            c.table_name,
            LISTAGG(cc.column_name, ', ') WITHIN GROUP (ORDER BY cc.position)
        INTO
            v_parent_table,
            v_parent_columns
        FROM
            all_constraints c
        JOIN
            all_cons_columns cc ON c.owner = cc.owner AND c.constraint_name = cc.constraint_name
        WHERE
            c.owner = v_parent_owner
            AND c.constraint_name = v_parent_pk_name
            AND c.constraint_type = 'P' -- P for Primary Key
        GROUP BY c.table_name;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_parent_table := 'UNKNOWN';
            v_parent_columns := 'UNKNOWN';
    END;

    -- 4. Construct the descriptive message
    v_result_message :=
        'CONSTRAINT VIOLATION SOURCE (ORA-02292): ' || p_constraint_id || '
        Parent Table: ' || v_parent_owner || '.' || v_parent_table || ' (Columns: ' || v_parent_columns || ')
        Child Table:  ' || v_child_owner || '.' || v_child_table || ' (FK Columns: ' || v_child_columns || ')
        Action Needed: Delete or update records in the CHILD TABLE before deleting the PARENT record.';

    RETURN v_result_message;

END find_constraint_source;

/
