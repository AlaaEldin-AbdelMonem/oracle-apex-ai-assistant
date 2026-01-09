--------------------------------------------------------
--  DDL for Package Body CHAT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CHAT_MANAGER_PKG" AS
-- ============================================================================
-- PACKAGE BODY: CHAT_MANAGER_PKG
-- Purpose: Implementation of chat session and message management
-- Author: Oracle AI ChatPot Team
-- Created: 2024-11-10
-- ============================================================================
  /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION regenerate_response(
        p_session_id        IN NUMBER,
        p_new_params        IN JSON DEFAULT NULL
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.regenerate_response'; 
        v_last_call_id      NUMBER;
        v_last_msg_role     VARCHAR2(20);
        v_user_msg_content  CLOB;
        v_new_msg_id        NUMBER;
    BEGIN
        -- Find last assistant message
        BEGIN
            SELECT call_id, message_role
            INTO v_last_call_id, v_last_msg_role
            FROM chat_calls
            WHERE chat_session_id = p_session_id
              AND call_seq = ( SELECT MAX(call_seq) FROM chat_calls
                  WHERE chat_session_id = p_session_id
              );
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RAISE_APPLICATION_ERROR(-20006, 'No messages found for session: ' || p_session_id);
        END;

        -- Verify it's an assistant message
        IF v_last_msg_role != c_role_assistant THEN
            RAISE_APPLICATION_ERROR(-20007, 'Last message is not from assistant');
        END IF;
 
        COMMIT;

        RETURN v_new_msg_id;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
         
           --  log_error(p_procedure_name =>  c_package_name||'>regenerate_response>',  p_error_message=> 'Error>'|| SQLERRM, p_chat_session_id => NULL);

            RAISE;
    END regenerate_response;
 /*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE add_call_rating(
        p_call_id        IN NUMBER,
        p_rating          IN VARCHAR2,
        p_comment           IN VARCHAR2 DEFAULT NULL
    ) IS
    vcaller constant varchar2(70):= c_package_name ||'.add_call_rating'; 
    v_msg varchar2(4000);
    BEGIN
        -- Validate rating type
        IF NOT is_valid_rating(p_rating) THEN
            v_msg:='Invalid rating type: ' || p_rating;
            debug_util.error(v_msg ||' , RAISE_APPLICATION_ERROR-20008', vcaller);
            RAISE_APPLICATION_ERROR(-20008,v_msg );
        END IF;

        UPDATE chat_calls
        SET user_rating = UPPER(p_rating),
            user_rating_comment = p_comment
        WHERE call_id = p_call_id;

        IF SQL%NOTFOUND THEN
            v_msg:= 'Message not found: ' || p_call_id;
             debug_util.error(v_msg ||' , RAISE_APPLICATION_ERROR-20009', vcaller);
            RAISE_APPLICATION_ERROR(-20009,v_msg);
        END IF;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
          debug_util.error(SQLERRM, vcaller);
          ROLLBACK;
          RAISE;
    END add_call_rating;
 
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_user_stats(
    p_user_id   IN VARCHAR2,
    p_days_back IN NUMBER DEFAULT 30
) RETURN JSON IS
    vcaller constant varchar2(70):= c_package_name ||'.get_user_stats'; 
    v_session_count NUMBER;
    v_message_count NUMBER;
    v_total_tokens  NUMBER;
    v_total_cost    NUMBER;
    v_json_text     CLOB;
BEGIN
    SELECT 
        COUNT(DISTINCT s.session_id),
        NVL(SUM(s.message_count), 0),
        NVL(SUM(s.tokens_total), 0),
        NVL(SUM(s.tokens_total_cost), 0)
    INTO 
        v_session_count,
        v_message_count,
        v_total_tokens,
        v_total_cost
    FROM chat_sessions s
    WHERE s.user_id = p_user_id
      AND s.last_activity_date >= SYSTIMESTAMP - INTERVAL '1' DAY * p_days_back;

    -- Create JSON text (CLOB)
    v_json_text := JSON_OBJECT(
        'user_id' VALUE p_user_id,
        'days_analyzed' VALUE p_days_back,
        'session_count' VALUE v_session_count,
        'message_count' VALUE v_message_count,
        'total_tokens' VALUE v_total_tokens,
        'total_cost' VALUE v_total_cost,
        'avg_messages_per_session' VALUE 
            CASE 
                WHEN v_session_count > 0 
                THEN ROUND(v_message_count / v_session_count, 2) 
                ELSE 0 
            END
    );

    -- Convert JSON text (CLOB) → JSON SQL type
    RETURN JSON(v_json_text);

EXCEPTION
    WHEN OTHERS THEN
         debug_util.error(SQLERRM, vcaller);
        RAISE;
END get_user_stats;

 /*******************************************************************************
 *  
 *******************************************************************************/
 
    FUNCTION export_session_json(
        p_session_id        IN NUMBER
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.export_session_json'; 
        v_json              CLOB;
        v_session           CHAT_SESSION_PKG.t_chat_session_rec;
        v_messages_json     CLOB;
        v_msg_json          CLOB;
        v_first_msg         BOOLEAN := TRUE;
    BEGIN
        -- Get session info
        v_session := CHAT_SESSION_PKG.get_session(p_session_id);
        v_messages_json := '[';
        IF v_messages_json IS NULL THEN v_messages_json := '['; END IF;
        IF v_session.session_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20010, 'Session not found: ' || p_session_id);
        END IF;

        -- Build messages array manually
        v_messages_json := '[';

        FOR r IN (
            SELECT 
                call_id,
                call_seq,
                message_role,
                user_prompt,
                TO_CHAR(DB_CREATED_AT, 'YYYY-MM-DD HH24:MI:SS') AS timestamp_str,
                tokens_total,
                PROVIDER_PROCESSING_MS,
                user_rating
            FROM chat_calls
            WHERE chat_session_id = p_session_id
            ORDER BY call_seq
        ) LOOP
            IF NOT v_first_msg THEN
                v_messages_json := v_messages_json || ',';
            END IF;
            v_first_msg := FALSE;
            
            v_msg_json := JSON_OBJECT(
                'call_id' VALUE r.call_id,
                'sequence' VALUE r.call_seq,
                'role' VALUE r.message_role,
                'content' VALUE r.user_prompt,
                'timestamp' VALUE r.timestamp_str,
                'tokens' VALUE r.tokens_total,
                'processing_time_ms' VALUE r.PROVIDER_PROCESSING_MS,
                'user_rating' VALUE r.user_rating
            );
            
            v_messages_json := v_messages_json || v_msg_json;
        END LOOP;
        
        v_messages_json := v_messages_json || ']';

        -- Build complete JSON
        v_json := JSON_OBJECT(
            'session_id' VALUE v_session.session_id,
            'session_uuid' VALUE v_session.session_uuid,
            'title' VALUE v_session.session_title,
            'user_id' VALUE v_session.user_id,
            'model' VALUE v_session.provider,
            'model' VALUE v_session.model,
            'created_date' VALUE TO_CHAR(v_session.created_date, 'YYYY-MM-DD HH24:MI:SS'),
            'message_count' VALUE v_session.message_count,
            'total_tokens' VALUE v_session.total_tokens,
            'total_cost' VALUE v_session.total_cost,
            'messages' VALUE v_messages_json FORMAT JSON,
            'exported_at' VALUE TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS')
        );

        RETURN v_json;

    EXCEPTION
        WHEN OTHERS THEN
          debug_util.error(SQLERRM, vcaller);
            RAISE;
    END export_session_json;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION export_session_text(
        p_session_id        IN NUMBER
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.export_session_text'; 
        v_text              CLOB;
        v_session           CHAT_SESSION_PKG.t_chat_session_rec;
        v_line              VARCHAR2(32767);
    BEGIN
        -- Get session info
        v_session := CHAT_SESSION_PKG.get_session(p_session_id);

        IF v_session.session_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20011, 'Session not found: ' || p_session_id);
        END IF;

        -- Build header
        DBMS_LOB.CREATETEMPORARY(v_text, TRUE);
        
        v_line := '========================================' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'CHAT CONVERSATION EXPORT' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '========================================' || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Title: ' || v_session.session_title || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Session ID: ' || v_session.session_uuid || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Model: ' || v_session.provider || ' - ' || v_session.model || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Created: ' || TO_CHAR(v_session.created_date, 'YYYY-MM-DD HH24:MI:SS') || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Messages: ' || v_session.message_count || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Total Tokens: ' || v_session.total_tokens || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '========================================' || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);

        -- Add messages
        FOR r IN (
            SELECT 
                message_role,
                user_prompt,
                TO_CHAR(DB_CREATED_AT, 'HH24:MI:SS') AS time_str,
                tokens_total
            FROM chat_calls
            WHERE chat_session_id = p_session_id
            ORDER BY call_seq
        ) LOOP
            v_line := '[' || r.time_str || '] ' || r.message_role || ':' || CHR(10);
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
            
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(r.user_prompt), r.user_prompt);
            
            v_line := CHR(10) || '(Tokens: ' || NVL(TO_CHAR(r.tokens_total), 'N/A') || ')' || CHR(10) || CHR(10);
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        END LOOP;

        -- Add footer
        v_line := '========================================' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := 'Exported: ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);

        RETURN v_text;

    EXCEPTION
        WHEN OTHERS THEN
          debug_util.error(SQLERRM, vcaller);
          RAISE;
    END export_session_text;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION export_session_markdown(
        p_session_id        IN NUMBER
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.export_session_markdown'; 
        v_text              CLOB;
        v_session           CHAT_SESSION_PKG.t_chat_session_rec;
        v_line              VARCHAR2(32767);
    BEGIN
        -- Get session info
        v_session := CHAT_SESSION_PKG.get_session(p_session_id);

        IF v_session.session_id IS NULL THEN
            RAISE_APPLICATION_ERROR(-20012, 'Session not found: ' || p_session_id);
        END IF;

        -- Build markdown
        DBMS_LOB.CREATETEMPORARY(v_text, TRUE);
        
        v_line := '# ' || v_session.session_title || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '**Session ID:** `' || v_session.session_uuid || '`  ' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '**Model:** ' || v_session.provider || ' - ' || v_session.model|| '  ' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '**Created:** ' || TO_CHAR(v_session.created_date, 'YYYY-MM-DD HH24:MI:SS') || '  ' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '**Messages:** ' || v_session.message_count || ' | **Tokens:** ' || v_session.total_tokens || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '---' || CHR(10) || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);

        -- Add messages
        FOR r IN (
            SELECT 
                message_role,
                user_prompt,
                TO_CHAR(DB_CREATED_AT, 'HH24:MI:SS') AS time_str,
                tokens_total
            FROM chat_calls
            WHERE chat_session_id = p_session_id
            ORDER BY call_seq
        ) LOOP
            IF r.message_role = c_role_user THEN
                v_line := '### 💬 User `' || r.time_str || '`' || CHR(10) || CHR(10);
            ELSIF r.message_role = c_role_assistant THEN
                v_line := '### 🤖 Assistant `' || r.time_str || '`' || CHR(10) || CHR(10);
            ELSE
                v_line := '### ℹ️ System `' || r.time_str || '`' || CHR(10) || CHR(10);
            END IF;
            
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
            
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(r.user_prompt), r.user_prompt);
            
            v_line := CHR(10) || CHR(10) || '> *Tokens: ' || NVL(TO_CHAR(r.tokens_total), 'N/A') || '*' || CHR(10) || CHR(10);
            DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        END LOOP;

        -- Add footer
        v_line := '---' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);
        
        v_line := '*Exported: ' || TO_CHAR(SYSTIMESTAMP, 'YYYY-MM-DD HH24:MI:SS') || '*' || CHR(10);
        DBMS_LOB.WRITEAPPEND(v_text, LENGTH(v_line), v_line);

        RETURN v_text;

    EXCEPTION
        WHEN OTHERS THEN
          debug_util.error(SQLERRM, vcaller);
          RAISE;
    END export_session_markdown;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION is_valid_role(
        p_role              IN VARCHAR2
    ) RETURN BOOLEAN IS
      vcaller constant varchar2(70):= c_package_name ||'.is_valid_role'; 
    BEGIN
        RETURN UPPER(p_role) IN (c_role_user, c_role_assistant, c_role_system);
    END is_valid_role;
 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION is_valid_rating(
        p_rating          IN VARCHAR2
    ) RETURN BOOLEAN IS
      vcaller constant varchar2(70):= c_package_name ||'.is_valid_rating'; 
    BEGIN
        RETURN UPPER(p_rating) IN (c_feedback_positive, c_feedback_negative, c_feedback_neutral, c_feedback_excellent);
    END is_valid_rating;

    FUNCTION get_version RETURN VARCHAR2 IS
    BEGIN
        RETURN c_version;
    END get_version;
 
 /*******************************************************************************
 *  
 *******************************************************************************/
END chat_manager_pkg;

/
