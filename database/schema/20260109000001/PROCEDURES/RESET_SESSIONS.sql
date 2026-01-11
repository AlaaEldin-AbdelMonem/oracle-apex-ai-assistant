--------------------------------------------------------
--  DDL for Procedure RESET_SESSIONS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "RESET_SESSIONS" 
as
/*******************************************************************************
 *  
 *******************************************************************************/
begin
 DBMS_SESSION.RESET_PACKAGE;
   /*DBMS_SESSION.RESET_PACKAGE is an Oracle PL/SQL procedure that clears the state of all packages within the current session,
    freeing up memory and resetting all package variables to their initial values. It effectively "de-instantiates" packages, 
    clearing any cached cursors and global variables to make them behave as if they were at the beginning of a session. 
   This is particularly useful in pooled environments where sessions are reused to prevent unexpected behavior caused by leftover package state from previous calls. */
end "RESET_SESSIONS";

/
