--------------------------------------------------------
--  DDL for Package Body STREAM_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "STREAM_UTIL" AS

    PROCEDURE emit_token(
        p_channel IN VARCHAR2,
        p_token   IN VARCHAR2
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.emit_token';
    BEGIN
        IF p_channel = 'ORDS' THEN
            -- Send SSE format
            HTP.p('data: ' || REPLACE(p_token, CHR(10), ' '));
            HTP.p;
            HTP.flush;
        ELSIF p_channel = 'APEX' THEN
            -- APEX streaming (future)
            NULL;
        ELSIF p_channel = 'DBMS_OUTPUT' THEN
             debug_util.info( p_token,vcaller);
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            -- Never break the stream
            NULL;
    END emit_token;

END stream_util;

/
