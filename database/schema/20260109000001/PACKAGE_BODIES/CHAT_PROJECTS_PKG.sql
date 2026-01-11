--------------------------------------------------------
--  DDL for Package Body CHAT_PROJECTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHAT_PROJECTS_PKG" AS

    /***************************************************************************
     * FUNCTION: add_project
     ***************************************************************************/
    FUNCTION add_project(
        p_project_code          IN chat_projects.project_code%TYPE,
        p_project_name          IN chat_projects.project_name%TYPE,
        p_project_description   IN chat_projects.project_description%TYPE DEFAULT NULL,
        p_project_instructions  IN chat_projects.project_instructions%TYPE DEFAULT NULL,
        p_owner_user_id         IN chat_projects.owner_user_id%TYPE,
        p_is_default            IN chat_projects.is_default%TYPE DEFAULT 'N',
        p_tenant_id             IN chat_projects.tenant_id%TYPE DEFAULT NULL
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.add_project'; 
        v_chat_project_id       chat_projects.chat_project_id%TYPE;
        v_user_exists           NUMBER;
        v_default_exists        NUMBER;
        v_msg varchar2(4000);
    BEGIN
        -- Validate user exists
        SELECT COUNT(*)
        INTO v_user_exists
        FROM users
        WHERE user_id = p_owner_user_id;

        IF v_user_exists = 0 THEN
        v_msg := 'Invalid user_id: ' || p_owner_user_id || '. User does not exist.';

         debug_util.error( v_msg|| ',RAISE_APPLICATION_ERROR(-20004) ', vcaller);
         RAISE_APPLICATION_ERROR(-20004, v_msg );
        END IF;

        -- Check if project code already exists
        IF is_project_exists(p_project_code) THEN
         v_msg := 'Project code "' || p_project_code || '" already exists.';
         debug_util.error( v_msg|| ',RAISE_APPLICATION_ERROR(-20002 ', vcaller);
            RAISE_APPLICATION_ERROR(-20002, v_msg  );
        END IF;

        -- If setting as default, check if default already exists
        IF p_is_default = 'Y' THEN
            SELECT COUNT(*)
            INTO v_default_exists
            FROM chat_projects
            WHERE owner_user_id = p_owner_user_id
              AND is_default = 'Y'
              AND is_deleted = 'N'
              AND is_active = 'Y';

            IF v_default_exists > 0 THEN
                -- Unset existing default
                UPDATE chat_projects
                SET is_default = 'N'
                WHERE owner_user_id = p_owner_user_id
                  AND is_default = 'Y'
                  AND is_deleted = 'N';
            END IF;
        END IF;

        -- Insert new project
        INSERT INTO chat_projects (
            project_code,
            project_name,
            project_description,
            project_instructions,
            owner_user_id,
            is_default,
            tenant_id,
            is_active,
            is_deleted,
            created_at,
            created_by
        ) VALUES (
            p_project_code,
            p_project_name,
            p_project_description,
            p_project_instructions,
            p_owner_user_id,
            p_is_default,
            p_tenant_id,
            'Y',
            'N',
            SYSTIMESTAMP,
            USER
        ) RETURNING chat_project_id INTO v_chat_project_id;

        COMMIT;

        RETURN v_chat_project_id;

    EXCEPTION
        WHEN DUP_VAL_ON_INDEX THEN
        v_msg:='Project code "' || p_project_code || '" already exists (duplicate key).';
          debug_util.error(v_msg ,vcaller);
            ROLLBACK;
            RAISE_APPLICATION_ERROR(-20002,  v_msg);
        WHEN OTHERS THEN
         debug_util.error(sqlerrm ,vcaller);
            ROLLBACK;
            RAISE;
    END add_project;
 /*******************************************************************************
 *  
 *******************************************************************************/
   --------------------
 ---- PROCEDURE: update_project_metadata
   --------------------
       PROCEDURE update_project_metadata(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE,
        p_project_code          IN chat_projects.project_code%TYPE DEFAULT NULL,
        p_project_name          IN chat_projects.project_name%TYPE DEFAULT NULL,
        p_project_description   IN chat_projects.project_description%TYPE DEFAULT NULL,
        p_project_instructions  IN chat_projects.project_instructions%TYPE DEFAULT NULL
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.update_project_metadata'; 
        v_exists NUMBER;
        v_msg  varchar2(4000);
    BEGIN
        -- Check if project exists
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND is_deleted = 'N';

        IF v_exists = 0 THEN
           v_msg:= 'Project ID ' || p_chat_project_id || ' not found or deleted.';
            debug_util.error( v_msg|| ',RAISE_APPLICATION_ERROR(-20001 ', vcaller);
            RAISE_APPLICATION_ERROR(-20001,  v_msg );
        END IF;

        -- Update only provided fields
        UPDATE chat_projects
        SET project_code = NVL(p_project_code, project_code),
            project_name = NVL(p_project_name, project_name),
            project_description = NVL(p_project_description, project_description),
            project_instructions = NVL(p_project_instructions, project_instructions)
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error( sqlerrm, vcaller);
            ROLLBACK;
            RAISE;
    END update_project_metadata;

    /***************************************************************************
     * PROCEDURE: update_project_summary
     ***************************************************************************/
    PROCEDURE update_project_summary(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE,
        p_project_summary       IN chat_projects.project_summary%TYPE DEFAULT NULL,
        p_project_short_summary IN chat_projects.project_short_summary%TYPE DEFAULT NULL,
        p_update_timestamp      IN BOOLEAN DEFAULT TRUE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.update_project_summary'; 
        v_exists NUMBER;
        v_msg varchar2(4000);
    BEGIN
        -- Check if project exists
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND is_deleted = 'N';

        IF v_exists = 0 THEN
             v_msg :=   'Project ID ' || p_chat_project_id || ' not found or deleted.';
             debug_util.error( v_msg ||' , RAISE_APPLICATION_ERROR(-20001)', vcaller);
            RAISE_APPLICATION_ERROR(-20001, v_msg );
        END IF;

        -- Update summary fields
        UPDATE chat_projects
        SET project_summary = NVL(p_project_summary, project_summary),
            project_short_summary = NVL(p_project_short_summary, project_short_summary),
            last_ai_summarized = CASE 
                                    WHEN p_update_timestamp THEN SYSTIMESTAMP 
                                    ELSE last_ai_summarized 
                                 END
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error(sqlerrm, vcaller);
            ROLLBACK;
            RAISE;
    END update_project_summary;

    /***************************************************************************
     * PROCEDURE: delete_project
     ***************************************************************************/
    PROCEDURE delete_project(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.delete_project'; 
        v_exists NUMBER;
        v_msg varchar2(4000);
    BEGIN
        -- Check if project exists
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND is_deleted = 'N';

        IF v_exists = 0 THEN
            v_msg:= 'Project ID ' || p_chat_project_id || ' not found or already deleted.';
            debug_util.error(v_msg ||' ,  RAISE_APPLICATION_ERROR(-20001)', vcaller);
            RAISE_APPLICATION_ERROR(-20001,  v_msg );
        END IF;

        -- Soft delete
        UPDATE chat_projects
        SET is_deleted = 'Y',
            deleted_ts = SYSTIMESTAMP,
            is_active = 'N'
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
           debug_util.error( sqlerrm, vcaller);
            ROLLBACK;
            RAISE;
    END delete_project;

    /***************************************************************************
     * FUNCTION: is_project_exists
     ***************************************************************************/
    FUNCTION is_project_exists(
        p_project_code          IN chat_projects.project_code%TYPE
    ) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_project_exists'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM chat_projects
        WHERE project_code = p_project_code
          AND is_deleted = 'N';

        RETURN (v_count > 0);
    END is_project_exists;

    /***************************************************************************
     * FUNCTION: is_default_exists
     ***************************************************************************/
    FUNCTION is_default_exists(
        p_user_id               IN chat_projects.owner_user_id%TYPE
    ) RETURN BOOLEAN IS
        vcaller constant varchar2(70):= c_package_name ||'.is_default_exists'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM chat_projects
        WHERE owner_user_id = p_user_id
          AND is_default = 'Y'
          AND is_deleted = 'N'
          AND is_active = 'Y'
          ;

        RETURN (v_count > 0);
    END is_default_exists;
 /*******************************************************************************
 *  
 *******************************************************************************/
 FUNCTION get_default_Project_Id(  p_user_id  IN chat_projects.owner_user_id%TYPE ) RETURN NUMBER IS
    vcaller constant varchar2(70):= c_package_name ||'.get_default_Project_Id'; 
    v_chat_project_id NUMBER;
    BEGIN
        SELECT  chat_project_id
        INTO v_chat_project_id
        FROM chat_projects
        WHERE owner_user_id = p_user_id
          AND is_default = 'Y'
          AND is_deleted = 'N'
          AND is_active = 'Y' ;

        RETURN v_chat_project_id;
       Exception 
       when others then
        debug_util.error( 'Default Project Not Exist for userid>'||p_user_id ||','||sqlerrm, vcaller);
       return null;
    END get_default_Project_Id;
    /***************************************************************************
     * FUNCTION: default_handling
     ***************************************************************************/
    FUNCTION default_handling(
        p_user_id               IN chat_projects.owner_user_id%TYPE
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.default_handling'; 
        v_chat_project_id       chat_projects.chat_project_id%TYPE;
        v_user_exists           NUMBER;
        v_msg   varchar2(4000);
    BEGIN
    
        IF p_user_id is null THEN
        v_msg:=  'CHAT_PROJECTS_PKG>> default_handling >> Userid missing.'; 
          debug_util.error( v_msg||',RAISE_APPLICATION_ERROR(-20004)',vcaller);
            RAISE_APPLICATION_ERROR(-20004,v_msg );
        END IF;
         
         v_chat_project_id:= get_default_Project_Id(p_user_id);
        -- Check if default project already exists
        IF v_chat_project_id is not null THEN
            -- Return existing default project
         return v_chat_project_id;
        ELSE
            -- Create new default project
            v_chat_project_id := add_project(
                p_project_code          => 'DEFAULT_' || p_user_id || '_' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS'),
                p_project_name          => 'Default Project',
                p_project_description   => 'Auto-created default project for user ' || p_user_id,
                p_project_instructions  => NULL,
                p_owner_user_id         => p_user_id,
                p_is_default            => 'Y',
                p_tenant_id             => NULL
            );

            RETURN v_chat_project_id;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm, vcaller);
            ROLLBACK;
            RAISE;
    END default_handling;

    /***************************************************************************
     * PROCEDURE: set_default_project
     ***************************************************************************/
    PROCEDURE set_default_project(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE,
        p_user_id               IN chat_projects.owner_user_id%TYPE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.set_default_project'; 
        v_exists NUMBER;
        v_msg varchar2(4000);
    BEGIN
        -- Validate project exists and belongs to user
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND owner_user_id = p_user_id
          AND is_deleted = 'N'
          AND is_active = 'Y';

        IF v_exists = 0 THEN
           v_msg :=  'Project ID ' || p_chat_project_id || ' not found or does not belong to user ' || p_user_id;
            debug_util.error( v_msg||', RAISE_APPLICATION_ERROR(-20001)', vcaller);
            RAISE_APPLICATION_ERROR(-20001, v_msg );
        END IF;

        -- Unset any existing default for this user
        UPDATE chat_projects
        SET is_default = 'N'
        WHERE owner_user_id = p_user_id
          AND is_default = 'Y'
          AND is_deleted = 'N';

        -- Set new default
        UPDATE chat_projects
        SET is_default = 'Y'
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error( sqlerrm,vcaller);
            ROLLBACK;
            RAISE;
    END set_default_project;

    /***************************************************************************
     * FUNCTION: get_project_id
     ***************************************************************************/
    FUNCTION get_project_id( p_project_code          IN chat_projects.project_code%TYPE
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.get_project_id'; 
        v_chat_project_id       chat_projects.chat_project_id%TYPE;
    BEGIN
        SELECT chat_project_id
        INTO v_chat_project_id
        FROM chat_projects
        WHERE project_code = p_project_code
          AND is_deleted = 'N';

        RETURN v_chat_project_id;

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN NULL;
        WHEN OTHERS THEN
        debug_util.error( sqlerrm,vcaller);
            RAISE;
    END get_project_id;

    /***************************************************************************
     * PROCEDURE: activate_project
     ***************************************************************************/
    PROCEDURE activate_project(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.activate_project'; 
        v_exists NUMBER;
        v_msg  varchar2(4000);
    BEGIN
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND is_deleted = 'N';

        IF v_exists = 0 THEN
        v_msg:=   'Project ID ' || p_chat_project_id || ' not found or deleted.';
            debug_util.error(v_msg ||'  RAISE_APPLICATION_ERROR(-20001)', vcaller);
            RAISE_APPLICATION_ERROR(-20001,v_msg);
        END IF;

        UPDATE chat_projects
        SET is_active = 'Y'
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
         debug_util.error( sqlerrm,vcaller);
            ROLLBACK;
            RAISE;
    END activate_project;

    /***************************************************************************
     * PROCEDURE: deactivate_project
     ***************************************************************************/
    PROCEDURE deactivate_project(
        p_chat_project_id       IN chat_projects.chat_project_id%TYPE
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.deactivate_project'; 
        v_exists NUMBER;
        v_msg varchar2(4000);
    BEGIN
        SELECT COUNT(*)
        INTO v_exists
        FROM chat_projects
        WHERE chat_project_id = p_chat_project_id
          AND is_deleted = 'N';

        IF v_exists = 0 THEN
            v_msg:= 'Project ID ' || p_chat_project_id || ' not found or deleted.';
            debug_util.error( v_msg ||',RAISE_APPLICATION_ERROR(-20001)',vcaller);
            RAISE_APPLICATION_ERROR(-20001,v_msg );
        END IF;

        UPDATE chat_projects
        SET is_active = 'N'
        WHERE chat_project_id = p_chat_project_id;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            debug_util.error( sqlerrm,vcaller);
            ROLLBACK;
            RAISE;
    END deactivate_project;
 /*******************************************************************************
 *  
 *******************************************************************************/
END chat_projects_pkg;

/
