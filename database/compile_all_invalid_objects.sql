SET SERVEROUTPUT ON;

DECLARE
    v_sql VARCHAR2(1000);
BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Starting Compilation ---');

    FOR cur IN (
        SELECT object_name, object_type 
        FROM user_objects 
        WHERE status = 'INVALID'
        ORDER BY 
            -- Try to compile specs before bodies
            CASE WHEN object_type LIKE '%BODY' THEN 2 ELSE 1 END,
            object_name
    ) LOOP
        BEGIN
            IF cur.object_type LIKE '%BODY' THEN
                v_sql := 'ALTER ' || REPLACE(cur.object_type, ' BODY', '') || ' "' || cur.object_name || '" COMPILE BODY';
            ELSE
                v_sql := 'ALTER ' || cur.object_type || ' "' || cur.object_name || '" COMPILE';
            END IF;

            DBMS_OUTPUT.PUT('.'); -- Progress indicator
            EXECUTE IMMEDIATE v_sql;
            
        EXCEPTION WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(CHR(10) || '❌ FAILED: ' || cur.object_type || ' ' || cur.object_name);
            DBMS_OUTPUT.PUT_LINE('   Error: ' || SQLERRM);
        END;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE(CHR(10) || '--- Finished ---');
END;
/