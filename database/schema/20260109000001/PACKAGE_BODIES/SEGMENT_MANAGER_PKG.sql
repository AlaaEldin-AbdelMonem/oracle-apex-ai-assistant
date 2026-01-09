--------------------------------------------------------
--  DDL for Package Body SEGMENT_MANAGER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."SEGMENT_MANAGER_PKG" AS

    /***************************************************************************
     * Refresh user count for a specific segment
     ***************************************************************************/
    PROCEDURE refresh_segment_count(
        p_segment_id IN NUMBER
    ) IS
       vcaller constant varchar2(70):= c_package_name ||'.refresh_segment_count';  
         v_segment_type VARCHAR2(50);
        v_filter_criteria CLOB;
        v_user_count NUMBER := 0;
        v_sql CLOB;
    BEGIN
        -- Get segment details
        SELECT segment_type, filter_criteria
        INTO v_segment_type, v_filter_criteria
        FROM USER_SEGMENTS
        WHERE segment_id = p_segment_id;
        
        -- Calculate count based on segment type
        IF v_segment_type = 'STATIC' THEN
            -- Count from SEGMENT_USERS association table
            SELECT COUNT(DISTINCT user_id)
            INTO v_user_count
            FROM SEGMENT_USERS
            WHERE segment_id = p_segment_id;
            
        ELSIF v_segment_type IN ('DYNAMIC', 'PERCENTAGE') THEN
            -- Build dynamic query
            v_sql := 'SELECT COUNT(*) FROM HCM_EMPLOYEES WHERE ' || v_filter_criteria;
            
            EXECUTE IMMEDIATE v_sql INTO v_user_count;
            
        ELSE
            -- For CUSTOM, count from SEGMENT_USERS
            SELECT COUNT(DISTINCT user_id)
            INTO v_user_count
            FROM SEGMENT_USERS
            WHERE segment_id = p_segment_id;
        END IF;
        
        -- Update count
        UPDATE USER_SEGMENTS
        SET current_user_count = v_user_count,
            last_refreshed_at = SYSTIMESTAMP,
            last_refreshed_by = USER
        WHERE segment_id = p_segment_id;
        
        COMMIT;
        
    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error( sqlerrm,vcaller);
            ROLLBACK;
            RAISE;
    END refresh_segment_count;
    
    /***************************************************************************
     * Refresh counts for all active segments
     ***************************************************************************/
    PROCEDURE refresh_all_segment_counts IS
       vcaller constant varchar2(70):= c_package_name ||'.refresh_all_segment_counts';
    BEGIN
        FOR rec IN (SELECT segment_id FROM USER_SEGMENTS WHERE is_active = 'Y') LOOP
            BEGIN
                refresh_segment_count(rec.segment_id);
            EXCEPTION
                WHEN OTHERS THEN
                    debug_util.error( sqlerrm,vcaller);
                    -- Log error but continue with other segments
                   -- DBMS_OUTPUT.PUT_LINE('Error refreshing segment ' || rec.segment_id || ': ' || SQLERRM);
            END;
        END LOOP;
    END refresh_all_segment_counts;
    
    /***************************************************************************
     * Assign users to a segment based on filter criteria
     ***************************************************************************/
    PROCEDURE assign_users_to_segment(
        p_segment_id IN NUMBER
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.assign_users_to_segment';
        v_segment_type VARCHAR2(50);
        v_filter_criteria CLOB;
        v_sql CLOB;
        v_assigned_count NUMBER := 0;
    BEGIN
        -- Get segment details
        SELECT segment_type, filter_criteria
        INTO v_segment_type, v_filter_criteria
        FROM USER_SEGMENTS
        WHERE segment_id = p_segment_id;
        
        -- Only process DYNAMIC and PERCENTAGE segments
        IF v_segment_type IN ('DYNAMIC', 'PERCENTAGE') THEN
            -- Delete existing assignments
            DELETE FROM SEGMENT_USERS WHERE segment_id = p_segment_id;
            
            -- Build and execute insert
            v_sql := 'INSERT INTO SEGMENT_USERS (segment_id, user_id, assignment_method) ' ||
                     'SELECT :segment_id, employee_id, :method FROM HCM_EMPLOYEES ' ||
                     'WHERE ' || v_filter_criteria;
            
            EXECUTE IMMEDIATE v_sql 
                USING p_segment_id, v_segment_type;
            
            v_assigned_count := SQL%ROWCOUNT;
            
            COMMIT;
            
            -- Refresh count
            refresh_segment_count(p_segment_id);
             debug_util.info( 'Assigned ' || v_assigned_count || ' users to segment ' || p_segment_id,vcaller);
           
        END IF;
        
    EXCEPTION
        WHEN OTHERS THEN
        debug_util.error( sqlerrm,vcaller);
            ROLLBACK;
            RAISE;
    END assign_users_to_segment;
    
END SEGMENT_MANAGER_PKG;

/
