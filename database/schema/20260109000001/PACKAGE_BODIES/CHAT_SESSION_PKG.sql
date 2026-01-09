--------------------------------------------------------
--  DDL for Package Body CHAT_SESSION_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CHAT_SESSION_PKG" AS

         -- PRIVATE CONSTANTS & VARIABLES
     c_max_title_length  CONSTANT NUMBER := 200;
     c_default_title     CONSTANT VARCHAR2(50) := TO_CHAR(SYSDATE, 'YYYY-Mon-DD HH24:MI:SS');
    

    FUNCTION get_traceid_from_chatsession(p_session_id IN NUMBER ,  p_trace_id   IN VARCHAR2) RETURN varchar2
    IS 
     vcaller constant varchar2(70):= c_package_name ||'.get_traceid_from_chatsession'; 
    v_trace_id varchar2(200);
    BEGIN
     select trace_id into v_trace_id from chat_sessions where session_id = p_session_id;
    Exception
      when others then
           debug_util.error( sqlerrm,vcaller, v_trace_id);
       return null;
    END get_traceid_from_chatsession;

     /*******************************************************************************
     *  
     *******************************************************************************/
  FUNCTION new_session(
                        p_provider        IN VARCHAR2,
                        p_model           IN VARCHAR2,
                        p_session_title   IN VARCHAR2 DEFAULT NULL,
                        p_user_id         IN NUMBER DEFAULT v('G_USER_ID'),
                        p_app_id          IN NUMBER DEFAULT v('APP_ID'),
                        p_app_page_id     IN NUMBER DEFAULT v('APP_PAGE_ID'),
                        p_project_id      IN NUMBER DEFAULT v('G_CHAT_PROJECT_ID'),
                        p_app_session_id  IN NUMBER DEFAULT v('APP_SESSION'),
                        p_tenant_id       IN number default v('G_TENANT_ID'),
                        p_trace_id        Out Varchar2 
                        )
     RETURN NUMBER
 
    IS  vcaller constant varchar2(70):= c_package_name ||'.new_session'; 
        v_msg VARCHAR2(4000);
        v_chat_session_id NUMBER;
        v_provider_Missing_ex exception;
        v_model_Missing_ex exception;
        v_userid_Missing_ex exception;
        v_chat_project_Id number:=p_project_id;
        v_trace_id varchar2(200);
        
    BEGIN
        v_trace_id :=  'SESSION-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');
        debug_util.starting( vcaller,'', v_trace_id);
        IF p_user_id is null then
          RAISE v_userid_Missing_ex;
        END IF;
        IF p_provider IS   NULL THEN  RAISE v_provider_Missing_ex;
        END IF;
       
         IF p_model  IS NULL THEN   RAISE v_model_Missing_ex;
        END IF;
                   
        if v_chat_project_Id is null then
          v_chat_project_Id := CHAT_PROJECTS_PKG.default_handling(p_user_id=>p_user_id );
         end if;


        INSERT INTO chat_sessions (
            user_id,
            session_uuid,
            session_title,
            provider,
            model,
            created_date,
            last_activity_date,
            message_count,
            tokens_total,
            tokens_total_cost,
            is_active,
            app_session_id,
            tenant_id,
            app_id,
            app_page_id,
            chat_project_id,
            session_metadata,
            trace_id
        )
        VALUES (
            p_user_id,
            SYS_GUID(),
            NVL(p_session_title, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI')),
            p_provider,
            p_model,
            SYSTIMESTAMP,--created_date
            SYSTIMESTAMP,--last_activity_date
            0,
            0,
            0,
            'Y', --is_active
            p_app_session_id,
            p_tenant_id,
            v('APP_ID'),
            v('APP_PAGE_ID'),
            v_chat_project_Id,
            JSON_OBJECT('created_by' VALUE c_package_name) ,--session_metadata
            v_trace_id
        )
        RETURNING session_id INTO v_chat_session_id;
         p_trace_id:= v_trace_id;
        COMMIT;
        debug_util.ending(vcaller,'|New chatSessionId> '||v_chat_session_id, v_trace_id);
        RETURN v_chat_session_id;

    EXCEPTION
        WHEN v_userid_Missing_ex THEN
          v_msg:=  'UserId is missing'  ;
            debug_util.ERROR( v_msg ,vcaller ,v_trace_id);
          RETURN v_chat_session_id;

        WHEN v_provider_Missing_ex THEN
          v_msg:=   ' Missing provider > ' || p_provider ;
            debug_util.ERROR(v_msg , vcaller ,v_trace_id);
          RETURN v_chat_session_id;
  
       WHEN v_model_Missing_ex THEN
          v_msg:= ' Missing Model for > ' || p_provider ;
              debug_util.ERROR(v_msg ,vcaller ,v_trace_id);
            RETURN v_chat_session_id;
        
        WHEN OTHERS THEN
           v_msg:=  'Creating New session>'||SQLERRM;
             debug_util.ERROR(  v_msg||' RAISE(-20001)'   ,vcaller ,v_trace_id);
             RAISE_APPLICATION_ERROR(-20001,   v_msg);
            ROLLBACK;
            RAISE;
    END new_session;
     /*******************************************************************************
     *  
     *******************************************************************************/
   FUNCTION get_session_title(p_session_id IN NUMBER,p_trace_id in varchar2 default null)
    RETURN varchar2
    IS   vcaller constant varchar2(70):= c_package_name ||'.get_session_title'; 
        v_title varchar2(300);
        v_trace_id varchar2(200);
    BEGIN
 
    SELECT   SESSION_TITLE ,trace_id
    INTO   v_title,v_trace_id
    FROM  chat_sessions 
    WHERE   session_id = p_session_id;

    RETURN v_title;
  
    EXCEPTION 
    WHEN OTHERS  THEN
       debug_util.error( 'p_session_id>'||p_session_id|| ','|| sqlerrm, vcaller, nvl(v_trace_id , p_trace_id  ));
       RETURN v_title;
    END get_session_title;
     /*******************************************************************************
     *  
     *******************************************************************************/

    FUNCTION get_session(p_session_id IN NUMBER,    p_trace_id   IN VARCHAR2 default null)
    RETURN t_chat_session_rec
    IS vcaller constant varchar2(70):= c_package_name ||'.get_session'; 
        v_rec t_chat_session_rec;
    BEGIN
-- EXPANDED COLUMNS: Explicitly listing all columns to avoid dependency on order.
    SELECT 
        SESSION_ID,
        SESSION_UUID,
        USER_ID,
        SESSION_TITLE,
        PROVIDER,
        MODEL,
        CREATED_DATE,
        LAST_ACTIVITY_DATE,
        MESSAGE_COUNT,
        tokens_TOTAL,
        tokens_TOTAL_COST,
        IS_ACTIVE,
        APP_SESSION_ID,
        SESSION_METADATA,
        CONTEXT_DOMAIN_ID,
        TENANT_ID,
        APP_PAGE_ID,
        CHAT_PROJECT_ID,
        APP_ID,
        TRACE_ID
    INTO 
        v_rec.SESSION_ID,
        v_rec.SESSION_UUID,
        v_rec.USER_ID,
        v_rec.SESSION_TITLE,
        v_rec.PROVIDER,
        v_rec.MODEL,
        v_rec.CREATED_DATE,
        v_rec.LAST_ACTIVITY_DATE,
        v_rec.MESSAGE_COUNT,
        v_rec.TOTAL_TOKENS,
        v_rec.TOTAL_COST,
        v_rec.IS_ACTIVE,
        v_rec.APP_SESSION_ID,
        v_rec.SESSION_METADATA,
        v_rec.CONTEXT_DOMAIN_ID,
        v_rec.TENANT_ID,
        v_rec.APP_PAGE_ID,
        v_rec.PROJECT_ID,
        v_rec.APP_ID,
        v_rec.TRACE_ID
    FROM 
        chat_sessions 
    WHERE 
        session_id = p_session_id;

    RETURN v_rec;
  
    EXCEPTION 
    WHEN NO_DATA_FOUND  THEN 
       debug_util.error('No Data Found', vcaller,v_rec.TRACE_ID);
       RETURN NULL;
    END get_session;
      /*******************************************************************************
     *  
     *******************************************************************************/
   FUNCTION generate_session_title( p_first_message IN CLOB ,   p_trace_id   IN VARCHAR2 ) RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_session_title'; 
        v_title             VARCHAR2(200);
        v_message_text      VARCHAR2(32767);
    BEGIN
        -- Convert CLOB to VARCHAR2 for processing
        v_message_text := DBMS_LOB.SUBSTR(p_first_message, 32767, 1);

        -- Take first 200 characters, strip newlines, add ellipsis if needed
        v_title := REGEXP_REPLACE(v_message_text, '\s+', ' ');
        
        IF LENGTH(v_title) > c_max_title_length THEN
            v_title := SUBSTR(v_title, 1, c_max_title_length - 3) || '...';
        END IF;

        -- Fallback to default if empty
        IF v_title IS NULL OR TRIM(v_title) IS NULL THEN
            v_title := c_default_title;
        END IF;

        RETURN v_title;

    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error(sqlerrm, vcaller);
            RETURN c_default_title;
    END generate_session_title;
     /*******************************************************************************
     *  
     *******************************************************************************/
    FUNCTION get_by_uuid(p_uuid IN VARCHAR2,  p_trace_id   IN VARCHAR2)
    RETURN t_chat_session_rec
    IS  vcaller constant varchar2(70):= c_package_name ||'.get_by_uuid'; 
        v_rec t_chat_session_rec;
    BEGIN
-- EXPANDED COLUMNS: Explicitly listing all columns to avoid dependency on order.
    SELECT 
        SESSION_ID,
        SESSION_UUID,
        USER_ID,
        SESSION_TITLE,
        PROVIDER,
        MODEL,
        CREATED_DATE,
        LAST_ACTIVITY_DATE,
        MESSAGE_COUNT,
        tokens_TOTAL,
        tokens_TOTAL_COST,
        IS_ACTIVE,
        APP_SESSION_ID,
        SESSION_METADATA,
        CONTEXT_DOMAIN_ID,
        TENANT_ID,
        APP_PAGE_ID,
        CHAT_PROJECT_ID,
        APP_ID,
        TRACE_ID
    INTO 
        v_rec.SESSION_ID,
        v_rec.SESSION_UUID,
        v_rec.USER_ID,
        v_rec.SESSION_TITLE,
        v_rec.PROVIDER,
        v_rec.MODEL,
        v_rec.CREATED_DATE,
        v_rec.LAST_ACTIVITY_DATE,
        v_rec.MESSAGE_COUNT,
        v_rec.TOTAL_TOKENS,
        v_rec.TOTAL_COST,
        v_rec.IS_ACTIVE,
        v_rec.APP_SESSION_ID,
        v_rec.SESSION_METADATA,
        v_rec.CONTEXT_DOMAIN_ID,
        v_rec.TENANT_ID,
        v_rec.APP_PAGE_ID,
        v_rec.PROJECT_ID,
        v_rec.APP_ID,
        v_rec.trace_id
    FROM  chat_sessions 
     WHERE session_uuid = p_uuid;

        RETURN v_rec;
    EXCEPTION 
    WHEN NO_DATA_FOUND
          THEN 
            debug_util.error('No Data Found', vcaller , v_rec.trace_id);
          RETURN NULL;
    END get_by_uuid;
     /*******************************************************************************
     *  
     *******************************************************************************/
 PROCEDURE update_session_title(
        p_session_id      IN NUMBER,  
        p_session_title   IN VARCHAR2 ,
         p_trace_id   IN VARCHAR2 
        
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.update_session_title'; 
    BEGIN
        UPDATE chat_sessions
        SET session_title = NVL(p_session_title, session_title) 
        WHERE session_id = p_session_id;

        COMMIT;
    END update_session_title;
     /*******************************************************************************
     *  
     *******************************************************************************/
 PROCEDURE update_session(
        p_session_id      IN NUMBER,
        p_app_session_id  IN NUMBER default v('APP_SESSION'),
        p_user_id         IN NUMBER DEFAULT v('G_USER_ID'),
        p_is_active       IN VARCHAR2 DEFAULT NULL,
        p_provider        IN VARCHAR2 DEFAULT NULL,
        p_model           IN VARCHAR2 DEFAULT NULL,
        p_session_title   IN VARCHAR2 DEFAULT NULL,
        p_project_id      IN NUMBER DEFAULT v('G_CHAT_PROJECT_ID'),
        p_trace_id   IN VARCHAR2
        
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.update_session'; 
    BEGIN
        UPDATE chat_sessions
        SET session_title = NVL(p_session_title, session_title),
            is_active        = NVL(p_is_active, is_active),
            CHAT_project_id      = NVL(p_project_id, p_project_id),
            provider        = NVL(p_provider, Provider),
            model           = NVL(p_model, model),
            last_activity_date = SYSTIMESTAMP
        WHERE session_id = p_session_id;

        COMMIT;
    END update_session;
     /*******************************************************************************
     *  
     *******************************************************************************/
    PROCEDURE delete_session(
        p_session_id IN NUMBER,
        p_hard       IN VARCHAR2 DEFAULT 'N',
        p_trace_id   IN VARCHAR2
    ) IS
      vcaller constant varchar2(70):= c_package_name ||'.delete_session'; 
    BEGIN
        IF p_hard = 'Y' THEN
            DELETE FROM chat_calls    WHERE chat_session_id = p_session_id;
            DELETE FROM chat_sessions WHERE session_id = p_session_id;
        ELSE
            UPDATE chat_sessions
            SET is_active = 'N',
                last_activity_date = SYSTIMESTAMP
            WHERE session_id = p_session_id;
        END IF;

        COMMIT;
    END delete_session ;
      /*******************************************************************************
     *  
     *******************************************************************************/
    FUNCTION archive_old(p_days_old NUMBER DEFAULT 90 , p_trace_id   IN VARCHAR2)
    RETURN NUMBER
    IS
      vcaller constant varchar2(70):= c_package_name ||'.archive_old'; 
    BEGIN
        UPDATE chat_sessions
        SET is_active = 'N'
        WHERE is_active='Y'
        AND last_activity_date < SYSTIMESTAMP - p_days_old;

        COMMIT;
        RETURN SQL%ROWCOUNT;
    END archive_old;
     /*******************************************************************************
     *  
     *******************************************************************************/
    FUNCTION purge_old(p_days_old NUMBER DEFAULT 180 ,   p_trace_id   IN VARCHAR2)
    RETURN NUMBER
    IS
      vcaller constant varchar2(70):= c_package_name ||'.purge_old'; 
    BEGIN
        DELETE FROM chat_calls
        WHERE chat_session_id IN (
            SELECT session_id
            FROM chat_sessions
            WHERE is_active='N'
            AND created_date < SYSTIMESTAMP - p_days_old
        );

        DELETE FROM chat_sessions
        WHERE is_active='N'
        AND created_date < SYSTIMESTAMP - p_days_old;

        COMMIT;
        RETURN SQL%ROWCOUNT;
    END purge_old;
     /*******************************************************************************
     *  
     *******************************************************************************/

 FUNCTION session_exists(  p_session_id   IN NUMBER ,  p_trace_id   IN VARCHAR2) 
    RETURN BOOLEAN IS
      vcaller constant varchar2(70):= c_package_name ||'.session_exists'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM chat_sessions
        WHERE session_id = p_session_id;
        
        RETURN v_count > 0;
    END session_exists;
 
     /*******************************************************************************
     *  
     *******************************************************************************/

     PROCEDURE update_session_totals(  p_session_id        IN NUMBER,  p_trace_id   IN VARCHAR2 ) IS
      vcaller constant varchar2(70):= c_package_name ||'.update_session_totals'; 
        v_message_count     NUMBER;
        v_total_tokens      NUMBER;
        v_total_cost        NUMBER;
    BEGIN
        SELECT 
            COUNT(*),
            NVL(SUM(tokens_total), 0),
            NVL(SUM(tokens_input * 0.00015 + tokens_output * 0.0006), 0)
        INTO 
            v_message_count,
            v_total_tokens,
            v_total_cost
        FROM chat_calls
        WHERE chat_session_id = p_session_id;

        UPDATE chat_sessions
        SET message_count = v_message_count,
            tokens_total = v_total_tokens,
            tokens_total_cost = v_total_cost,
            last_activity_date = SYSTIMESTAMP
        WHERE session_id = p_session_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
          debug_util.error(sqlerrm, vcaller,p_trace_id);
            ROLLBACK;
            RAISE;
    END update_session_totals;
     /*******************************************************************************
     *  
     *******************************************************************************/


END chat_session_pkg;

/
