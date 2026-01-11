--------------------------------------------------------
--  DDL for Procedure COMPILE_INVALID_OBJECTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "COMPILE_INVALID_OBJECTS" AS
BEGIN
/*******************************************************************************
 *  
 *******************************************************************************/
    FOR r IN (
        SELECT object_name, object_type
        FROM user_objects
        WHERE status = 'INVALID'
        ORDER BY object_type, object_name
    ) LOOP
        BEGIN
            EXECUTE IMMEDIATE 
                'ALTER ' || r.object_type || ' "' || r.object_name || '" COMPILE';
            
            DBMS_OUTPUT.put_line('✔ Compiled: ' || r.object_type || ' - ' || r.object_name);

        EXCEPTION 
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line(
                    '❌ Failed: ' || r.object_type || ' - ' || r.object_name || 
                    ' | Error: ' || SQLERRM
                );
        END;
    END LOOP;

    DBMS_OUTPUT.put_line('✔ Invalid object compilation complete.');
END;

/
