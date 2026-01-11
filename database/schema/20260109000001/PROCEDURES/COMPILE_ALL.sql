--------------------------------------------------------
--  DDL for Procedure COMPILE_ALL
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "COMPILE_ALL" 
as
/*******************************************************************************
 *  
 *******************************************************************************/
begin
 
    FOR r IN (
        SELECT object_name FROM user_objects 
        WHERE object_type = 'PACKAGE'
    )
    LOOP 
    begin
        EXECUTE IMMEDIATE 'ALTER PACKAGE "'||r.object_name||'" COMPILE';
        EXECUTE IMMEDIATE 'ALTER PACKAGE "'||r.object_name||'" COMPILE BODY';
        exception
         when others then   DBMS_OUTPUT.put_line (  RPAD(r.object_name, 50, ' ')||'>>'||sqlerrm);
        end;
    END LOOP;
 DBMS_OUTPUT.put_line (    ' ------------------------------------------------------------------------------ ' );
 BEGIN

    FOR r IN (SELECT object_name, object_type FROM user_objects 
              WHERE status = 'INVALID'  and object_type <> 'PACKAGE'  and object_type <> 'PACKAGE BODY' ) 
    LOOP
         begin
        EXECUTE IMMEDIATE 'ALTER ' || r.object_type ||   ' "' || r.object_name || '" COMPILE';
       exception
         when others then   DBMS_OUTPUT.put_line (  RPAD( r.object_type ||' ==> '||r.object_name, 60, ' ')||'>>'||sqlerrm);
        end;
    END LOOP;
   END;

end COMPILE_ALL;

/
