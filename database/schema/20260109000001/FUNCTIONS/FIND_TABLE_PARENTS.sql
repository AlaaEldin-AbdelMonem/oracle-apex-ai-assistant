--------------------------------------------------------
--  DDL for Function FIND_TABLE_PARENTS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "FIND_TABLE_PARENTS" (
    p_child_table_name IN VARCHAR2, -- The table with the foreign keys
    p_owner            IN VARCHAR2 DEFAULT USER -- Optionally specify the table owner
)
RETURN VARCHAR2
/*******************************************************************************
 *  
 *******************************************************************************/
IS
    -- Stores the list of parent tables found
    v_parent_list VARCHAR2(4000);

BEGIN
    -- Query the data dictionary to find constraints where the input table is the CHILD (TABLE_NAME)
    -- and identify the parent table via R_CONSTRAINT_NAME.
    SELECT
        LISTAGG(
            c_parent.table_name || ' (' || c_parent.owner || ')', 
            CHR(10) || '-------------------' || CHR(10) -- Use a newline separator for better readability
        ) WITHIN GROUP (ORDER BY c_parent.table_name)
    INTO
        v_parent_list
    FROM
        user_constraints c_child -- Alias for the foreign key (child) constraint
    JOIN
        user_constraints c_parent -- Alias for the primary key (parent) constraint
        ON c_child.r_constraint_name = c_parent.constraint_name
        AND c_child.r_owner = c_parent.owner
    WHERE
        c_child.table_name = UPPER(p_child_table_name) -- The input table is the child
       -- AND c_child.owner = UPPER(p_owner)
        AND c_child.constraint_type = 'R'; -- 'R' denotes a Referential Integrity (Foreign Key) constraint

    -- Check if any parent tables were found
    IF v_parent_list IS NULL THEN
        RETURN 'No parent tables found (no foreign keys defined in ' || UPPER(p_child_table_name) || ').';
    ELSE
        RETURN 'PARENT TABLES REFERENCED BY ' || UPPER(p_child_table_name) || ':' || CHR(10) ||
               '-------------------------------------------------------' || CHR(10) ||
               v_parent_list;
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 'ERROR: ' || SQLERRM;

END find_table_parents;

/
