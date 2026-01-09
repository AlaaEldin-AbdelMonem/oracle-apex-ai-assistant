--------------------------------------------------------
--  DDL for Package Body LLM_STREAM_ADAPTER_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."LLM_STREAM_ADAPTER_UTIL" AS
 /*******************************************************************************
 *  
 *******************************************************************************/
-------------------------------------------------------------------------------
-- INIT: called before streaming begins
-------------------------------------------------------------------------------
PROCEDURE init(
    p_stream_channel IN VARCHAR2,
    p_trace_id       IN VARCHAR2
) IS
   vcaller constant varchar2(70):= c_package_name ||'.init'; 
BEGIN
    g_stream_channel := NVL(UPPER(p_stream_channel), 'NONE');
    g_trace_id       := p_trace_id;
    g_final_response := EMPTY_CLOB();

    debug_util.info(  'STREAM INIT: channel=' || g_stream_channel || ', trace_id=' || p_trace_id, vcaller, p_trace_id );
END init;
/*******************************************************************************
 *  
 *******************************************************************************/
-------------------------------------------------------------------------------
-- EMIT: internal router (APEX / ORDS / DBMS_OUTPUT / BACKEND / NONE)
-------------------------------------------------------------------------------
PROCEDURE emit( p_text IN VARCHAR2 ) IS
   vcaller constant varchar2(70):= c_package_name ||'.emit'; 
BEGIN
    CASE g_stream_channel
        WHEN 'APEX' THEN
            HTP.p(p_text);
            HTP.flush;

        WHEN 'ORDS' THEN
            HTP.p('data: ' || REPLACE(p_text, CHR(10), ' '));
            HTP.p;
            HTP.flush;

        WHEN 'DBMS_OUTPUT' THEN
            DBMS_OUTPUT.put_line(p_text);

        WHEN 'BACKEND' THEN
            NULL; -- Backend-only: do NOT emit to UI

        ELSE
            NULL; -- NONE or invalid
    END CASE;

EXCEPTION
    WHEN OTHERS THEN
        debug_util.warn('STREAM EMIT error: ' || SQLERRM, vcaller, g_trace_id);
END emit;
/*******************************************************************************
 *  
 *******************************************************************************/
-------------------------------------------------------------------------------
-- ON_TOKEN: called for each partial chunk from provider
-------------------------------------------------------------------------------
PROCEDURE on_token(  p_token IN VARCHAR2 ) IS
   vcaller constant varchar2(70):= c_package_name ||'.on_token'; 
BEGIN
    IF p_token IS NULL THEN
        RETURN;
    END IF;

    -- Accumulate for final response
    g_final_response := g_final_response || p_token;

    -- UI streaming ONLY if channel supports UI output
    IF g_stream_channel IN ('APEX','ORDS','DBMS_OUTPUT') THEN
        emit(p_token);
    END IF;

    debug_util.info(  'STREAM TOKEN: ' || SUBSTR(p_token,1,200),vcaller, g_trace_id );
END on_token;
/*******************************************************************************
 *  
 *******************************************************************************/
-------------------------------------------------------------------------------
-- ON_END: called after streaming ends
-------------------------------------------------------------------------------
PROCEDURE on_end(  p_full_response IN CLOB ) IS
   vcaller constant varchar2(70):= c_package_name ||'.on_end'; 
BEGIN
    debug_util.info(
        'STREAM END. Final length=' || NVL(DBMS_LOB.getlength(p_full_response),0),vcaller,
        g_trace_id
    );

    -- Always store final
    g_final_response := p_full_response;

    -- Final push to client (if full-streaming mode)
    IF g_stream_channel IN ('APEX','ORDS','DBMS_OUTPUT') THEN
        emit(p_full_response);
    END IF;

END on_end;
/*******************************************************************************
 *  
 *******************************************************************************/
END llm_stream_adapter_util;

/
