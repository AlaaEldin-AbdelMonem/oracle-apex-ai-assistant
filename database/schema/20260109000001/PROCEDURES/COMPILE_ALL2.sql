--------------------------------------------------------
--  DDL for Procedure COMPILE_ALL2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "COMPILE_ALL2" as 
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Cursor to select the name and type of all compilable objects owned by the current user.
    -- USER_OBJECTS view implicitly filters by the current user (OWNER = USER).
    CURSOR c_objects IS
        SELECT object_name, object_type
        FROM USER_OBJECTS -- CORRECTED: Using USER_OBJECTS instead of ALL_OBJECTS
        WHERE object_type IN (
            'PACKAGE',
            'PACKAGE BODY',
            'FUNCTION',
            'PROCEDURE',
            'TRIGGER',
            'TYPE',
            'TYPE BODY',
            'VIEW'
        )
        -- Removing: AND owner = USER -- Not needed in USER_OBJECTS
        AND status = 'INVALID' -- Optional: only compile objects that are already invalid
        ORDER BY object_type, object_name;

    v_ddl_statement VARCHAR2(500);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Compilation for Schema: ' || USER || ' ---');

    FOR obj IN c_objects LOOP
        -- obj.object_name and obj.object_type are now valid fields from the cursor

        -- Determine the correct DDL statement based on the object type
        CASE obj.object_type
            WHEN 'PACKAGE' THEN
                v_ddl_statement := 'ALTER PACKAGE ' || obj.object_name || ' COMPILE';
            WHEN 'PACKAGE BODY' THEN
                -- We generally compile the SPEC (PACKAGE) which handles the body,
                -- but we can explicitly compile the body if needed.
                v_ddl_statement := 'ALTER PACKAGE ' || obj.object_name || ' COMPILE BODY'; 
            WHEN 'FUNCTION' THEN
                v_ddl_statement := 'ALTER FUNCTION ' || obj.object_name || ' COMPILE';
            WHEN 'PROCEDURE' THEN
                v_ddl_statement := 'ALTER PROCEDURE ' || obj.object_name || ' COMPILE';
            WHEN 'TRIGGER' THEN
                v_ddl_statement := 'ALTER TRIGGER ' || obj.object_name || ' COMPILE';
            WHEN 'TYPE' THEN
                v_ddl_statement := 'ALTER TYPE ' || obj.object_name || ' COMPILE';
            WHEN 'TYPE BODY' THEN
                v_ddl_statement := 'ALTER TYPE ' || obj.object_name || ' COMPILE BODY';
            WHEN 'VIEW' THEN
                v_ddl_statement := 'ALTER VIEW ' || obj.object_name || ' COMPILE';
            ELSE
                CONTINUE;
        END CASE;

        -- Execute the dynamic DDL statement
        BEGIN
            EXECUTE IMMEDIATE v_ddl_statement;
            DBMS_OUTPUT.PUT_LINE('Compiled ' || obj.object_type || ': ' || obj.object_name || ' - SUCCESS');
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.PUT_LINE('Compiled ' || obj.object_type || ': ' || obj.object_name || ' - FAILED (' || SQLERRM || ')');
        END;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('--- Compilation Finished ---');
END;

/
