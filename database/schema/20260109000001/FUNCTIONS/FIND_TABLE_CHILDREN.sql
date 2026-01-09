--------------------------------------------------------
--  DDL for Function FIND_TABLE_CHILDREN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."FIND_TABLE_CHILDREN" (
    p_parent_table_name IN VARCHAR2, -- The table whose PK is being referenced (e.g., 'USERS')
    p_owner             IN VARCHAR2 DEFAULT USER -- Defaults to the current schema
)
RETURN VARCHAR2
/*******************************************************************************
 *  
 *******************************************************************************/
IS
    -- Stores the list of child tables found
    v_child_list        VARCHAR2(4000);
    v_parent_pk_name    user_CONSTRAINTS.constraint_name%TYPE;

BEGIN
    -- 1. Find the Primary Key (PK) constraint name of the parent table.
    -- We need this to link it to the foreign keys (R_CONSTRAINT_NAME) in the child tables.
    BEGIN
        SELECT
            constraint_name
        INTO
            v_parent_pk_name
        FROM
            user_constraints
        WHERE
            owner = UPPER(p_owner)
            AND table_name = UPPER(p_parent_table_name)
            AND constraint_type = 'P'; -- 'P' denotes Primary Key

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 'Error: Parent table ' || UPPER(p_parent_table_name) || ' not found or has no Primary Key.';
    END;

    -- 2. Query the data dictionary to find constraints where this PK is referenced.
    SELECT
        LISTAGG(
            c_child.table_name || ' (FK: ' || c_child.constraint_name || ')', 
            CHR(10) || '---------------------------------' || CHR(10) -- Use a newline separator
        ) WITHIN GROUP (ORDER BY c_child.table_name)
    INTO
        v_child_list
    FROM
        user_constraints c_child
    WHERE
        c_child.r_owner = UPPER(p_owner) -- Parent owner must match the input owner
        AND c_child.r_constraint_name = v_parent_pk_name -- The Foreign Key references the Parent PK
        AND c_child.constraint_type = 'R'; -- 'R' denotes a Referential Integrity (Foreign Key) constraint

    -- 3. Format the final output message.
    IF v_child_list IS NULL THEN
        RETURN 'No child tables found referencing ' || UPPER(p_parent_table_name) || ' in schema ' || UPPER(p_owner) || '.';
    ELSE
        RETURN 'CHILD TABLES REFERENCING ' || UPPER(p_parent_table_name) || ' (PK: ' || v_parent_pk_name || '):' || CHR(10) ||
               '-------------------------------------------------------' || CHR(10) ||
               v_child_list;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;

END find_table_children;

/
