--------------------------------------------------------
--  DDL for Package Body APP_SESSION_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "APP_SESSION_UTIL" AS
 
  ---===============
  FUNCTION GET_AUTH_ERROR_MESSAGE(
    P_AUTH_CODE IN NUMBER
) RETURN VARCHAR2 IS
BEGIN
    RETURN CASE P_AUTH_CODE
        WHEN 0 THEN NULL -- Success
        WHEN 1 THEN 'AUTH01-Invalid username or password'
        WHEN 2 THEN 'AUTH02-Your account is locked. Please contact administrator'
        WHEN 3 THEN 'AUTH03-Your account has expired'
        WHEN 4 THEN 'AUTH04-Invalid username or password'
        WHEN 5 THEN 'AUTH05-Please change your password'
        WHEN 6 THEN 'AUTH06- Maximum login attempts exceeded'
        WHEN 7 THEN 'AUTH07- System error. Please try again later'
        WHEN 8 THEN 'AUTH08- User not r with this organization'
        WHEN 9 THEN 'AUTH09- User may be locked or In-Active'
        WHEN 10 THEN 'AUTH10-Your Organization Account is Disabled' 
        WHEN 11 THEN 'AUTH11- Wrong calling , You dont related to any Organization'
        ELSE 'Authentication error'
    END;
END GET_AUTH_ERROR_MESSAGE;  
  ----------------------------  
  -- FUNCTION: H A S H _ P A S S W O R D 
  -----------------------------  
 
 FUNCTION HASH_PASSWORD
  (p_user_name IN VARCHAR2, p_password  IN VARCHAR2  )
RETURN VARCHAR2
IS 
 vcaller constant varchar2(70):= c_package_name ||'.HASH_PASSWORD'; 
 l_salt VARCHAR2(255) := '21345UDFGOJN2T3HW89XEFGOBN23R5SDFGAKL'; 
  l_hash_input     VARCHAR2(255);
  l_hashed_password VARCHAR2(255);
BEGIN
  -- 1. Combine the password, salt, and user name.
  --    UTL_RAW.CAST_TO_RAW is needed to convert the VARCHAR2 to RAW for hashing.
  l_hash_input := UTL_RAW.CAST_TO_RAW(  substr(l_salt,4,14) ||    upper(p_user_name) ||    substr(l_salt,5,10)) ; 
 

  -- 2. Use DBMS_CRYPTO to hash the combined input with a secure algorithm (SHA-512).
  l_hashed_password := DBMS_CRYPTO.HASH(  src => l_hash_input,
                                          typ => DBMS_CRYPTO.HASH_SH512);

  -- 3. Convert the resulting RAW hash to a hexadecimal string for storage.
  RETURN RAWTOHEX(l_hashed_password);
END HASH_PASSWORD;
 
 
  --===========================  
 
  --===========================  
  PROCEDURE SET_APP_ITEMS(p_USER_NAME varchar2) 
  is 
   vcaller constant varchar2(70):= c_package_name ||'.SET_APP_ITEMS'; 
   l_user_Id number; 
  begin 
      debug_util.info(' p_USER_NAME >>'||p_USER_NAME ,vcaller);

  select user_id 
  into l_user_Id 
  from users 
   where upper(USER_NAME)=upper(p_USER_NAME); 
 
   APEX_UTIL.SET_SESSION_STATE ('G_USER_ID', l_user_Id); 
 
  --exception 
  --when others then 
  null; 
  end; 
/***************************************************************************
 *  GENERATE SECURE RANDOM SALT
 ***************************************************************************/
FUNCTION generate_salt RETURN VARCHAR2 IS
    vcaller constant varchar2(70):= c_package_name ||'.generate_salt'; 
    v_raw RAW(32);
BEGIN
    v_raw := DBMS_CRYPTO.RANDOMBYTES(32);
    RETURN RAWTOHEX(v_raw);
END generate_salt;

  
   -------------------- 


  --========================== 
/***************************************************************************
 *  AUTHENTICATE USER (Called by APEX - MUST BE SIMPLE!)
 ***************************************************************************/
FUNCTION AUTHENTICATE_USER(P_USERNAME IN VARCHAR2, 
                             P_PASSWORD IN VARCHAR2) RETURN BOOLEAN IS
    vcaller constant varchar2(70):= c_package_name ||'.AUTHENTICATE_USER';  
    L_USER_NAME       USERS.USER_NAME%TYPE := UPPER(P_USERNAME); 
    L_PASSWORD        USERS.PASSWORD%TYPE; 
    L_HASHED_PASSWORD VARCHAR2(1000); 
    L_USER_ID           NUMBER; 
    L_TENANT_ORG_ID     NUMBER;
    L_Org_Level_Enabled char(1); 
  
    L_USER_ACCOUNT_STATUS  USERS.ACCOUNT_STATUS%Type; --Current status: ACTIVE, INACTIVE, PENDING, LOCKED, SUSPENDED
  BEGIN 
    -- Returns from the AUTHENTICATE_USER function  
    --    0    Normal, successful authentication 
    --    1    Unknown User Name 
    --    2    Account Locked 
    --    3    Account Expired 
    --    4    Incorrect Password 
    --    5    Password First Use 
    --    6    Maximum Login Attempts Exceeded 
    --    7    Unknown Internal Error 
     --   8    Tenant User Organization not Defined or Disabled
    -- First, check to see if the user exists 
          debug_util.info('  p_USER_NAME >>'||p_USERNAME,vcaller );

   /*IF v('ORX') is not null and v('ORGID') is null THEN
    -- AUTH11- Wrong calling , You dont related to any Organization
    APEX_UTIL.SET_AUTHENTICATION_RESULT(11); 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(11));
      RETURN FALSE; 
   END IF;*/
    

   BEGIN
    SELECT USER_ID ,PASSWORD,ACCOUNT_STATUS
      INTO L_USER_ID ,L_PASSWORD,L_USER_ACCOUNT_STATUS
      FROM  USERS 
     WHERE upper(USER_NAME) = upper(L_USER_NAME); 
     
     --ORGID are set at loginPage decrypted from ORX
    /* SELECT  ORG_ID  ,ENABLED_FLAG
      INTO L_TENANT_ORG_ID ,L_ORG_LEVEL_ENABLED
      FROM USER_ORG_LINK uo
     WHERE    uo.user_id =L_user_id   AND ORG_ID=NVL(v('ORGID'),0) ; 
*/
     EXCEPTION
     WHEN OTHERS THEN NULL;
     END;

     IF L_USER_ID IS NULL THEN
    -- The username does not exist 
      APEX_UTIL.SET_AUTHENTICATION_RESULT(1); 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(1));
      RETURN FALSE; 
     END IF;

     IF L_USER_ACCOUNT_STATUS <> 'ACTIVE' THEN
       --  9   User may be locked or In-Active'
      APEX_UTIL.SET_AUTHENTICATION_RESULT(9); 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(9));
     END IF;
    
     /*IF L_TENANT_ORG_ID IS NULL THEN
      --  8    Tenant User Organization not Defined or Disabled
      APEX_UTIL.SET_AUTHENTICATION_RESULT(8); 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(8));
      RETURN FALSE; 
     END IF;*/

    
      /*IF L_ORG_LEVEL_ENABLED ='N' THEN
      --  10   Your Organization Account is Disabled
      APEX_UTIL.SET_AUTHENTICATION_RESULT(10); 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(10));
      RETURN FALSE; 
     END IF;*/

      -- Hash the password provided 
      l_hashed_password := hash_password(L_USER_NAME, p_password); 
     

      IF L_HASHED_PASSWORD <> L_PASSWORD THEN 
        -- The Passwords didn't match 
        APEX_UTIL.SET_AUTHENTICATION_RESULT(4); 
        APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(4));
        RETURN FALSE; 
      END IF; 

  
      debug_util.info(' AUTHENTICATE_USER >>> Passwork Match',vcaller  );
      APEX_UTIL.SET_AUTHENTICATION_RESULT(0); 
      debug_util.info(' AUTHENTICATE_USER >>> Auth set',vcaller );
        SET_APP_ITEMS(p_USER_NAME=> upper(L_USER_NAME) ); 
      IF upper(V('APP_USER')) = 'nobody' THEN
           APEX_CUSTOM_AUTH.SET_USER(upper(L_USER_NAME));
      END IF;
      --APEX_UTIL.SET_SESSION_STATE ('USERNAME',  upper(L_USER_NAME)); 
       set_application_items(upper(L_USER_NAME) ); 
       debug_util.info(' AUTHENTICATE_USER >>> All Ok',vcaller  );

     RETURN TRUE; 
  EXCEPTION 
    WHEN OTHERS THEN 
       debug_util.error('AUTHENTICATE_USER >>> ' ||Sqlerrm,vcaller );
      -- We don't know what happened so log an unknown internal error 
      APEX_UTIL.SET_AUTHENTICATION_RESULT(7); 
      --APEX_UTIL.SET_CUSTOM_AUTH_STATUS(GET_AUTH_ERROR_MESSAGE(7));
      -- And save the SQL Error Message to the Auth Status. 
      APEX_UTIL.SET_CUSTOM_AUTH_STATUS(SQLERRM);  


     APEX_ERROR.ADD_ERROR (
     p_message  => 'USER NOT FOUND',
     p_display_location => apex_error.c_inline_with_field,
     p_page_item_name => 'P9999_PASSWORD');

      RETURN FALSE; 
     
  END AUTHENTICATE_USER; 
 
--=============================  
 
/***************************************************************************
 *  SET APPLICATION ITEMS (Called AFTER successful authentication)
 ***************************************************************************/

 
PROCEDURE set_app_environment( p_app_id in number, p_tenant_id in number) IS
    vcaller constant varchar2(70):= c_package_name ||'.set_app_environment'; 
    v_env_code VARCHAR2(50);
BEGIN
   
    BEGIN
        SELECT PARAM_VALUE
        INTO   v_env_code 
        FROM   CFG_PARAMETERS
        WHERE   app_id = p_app_id
         AND  tenant_id = p_tenant_id
         AND PARAM_KEY='ENV';
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            v_env_code := 'DEV';  --default 
            debug_util.error('APP_SESSION_UTIL>>ENV not found in configuration',vcaller);  
    END;
    
    APEX_UTIL.SET_SESSION_STATE('G_APP_ENV', v_env_code);
 
EXCEPTION
    WHEN NO_DATA_FOUND THEN
       debug_util.error('APP_SESSION_UTIL>>ENV not found in configuration',vcaller);
        RAISE_APPLICATION_ERROR(-20001, 'User not found for app: ' || p_app_id ||' and tenant :'||p_tenant_id);
    WHEN OTHERS THEN
         debug_util.error('APP_SESSION_UTIL>>set_app_environment>>'||sqlerrm,vcaller);
        RAISE;
END set_app_environment;
--------------------------------
--------------------------------
PROCEDURE set_application_items(
    p_user_name IN VARCHAR2
) IS
    vcaller constant varchar2(70):= c_package_name ||'.set_application_items'; 
    v_user_id     NUMBER;
    v_roles       VARCHAR2(4000);
    v_level       NUMBER;
    v_tenant_id   NUMBER;
    v_tenant_code VARCHAR2(50);
    v_tenant_name VARCHAR2(200);
BEGIN
    -- 1) Get user ID
    SELECT user_id
    INTO   v_user_id
    FROM   users
    WHERE  UPPER(user_name) = UPPER(p_user_name);
    
    APEX_UTIL.SET_SESSION_STATE('G_USER_ID', v_user_id);
    
    
    -- 2) Get user roles (CSV format)
    SELECT LISTAGG(r.role_name, ',') WITHIN GROUP (ORDER BY r.role_name)
    INTO   v_roles
    FROM   user_roles ur
    JOIN   roles r ON ur.role_id = r.role_id
    WHERE  ur.user_id = v_user_id;
    
    --APEX_UTIL.SET_SESSION_STATE('G_ROLES', NVL(v_roles, 'NONE'));
    
    
    -- 3) Get classification level
    v_level := 1; -- Default
    
    FOR r IN (
        SELECT role_name
        FROM   user_roles ur
        JOIN   roles r ON ur.role_id = r.role_id
        WHERE  ur.user_id = v_user_id
    ) LOOP
        IF r.role_name IN ('HR ADMIN', 'AUDITOR') THEN
            v_level := 4;
        ELSIF r.role_name = 'MANAGER' THEN
            v_level := GREATEST(v_level, 3);
        ELSIF r.role_name = 'EMPLOYEE' THEN
            v_level := GREATEST(v_level, 2);
        END IF;
    END LOOP;
    
   -- APEX_UTIL.SET_SESSION_STATE('G_CLASSIFICATION_LEVEL', v_level);
    
    
    -- 4) Get tenant information
    BEGIN
        SELECT tenant_id, tenant_code, tenant_name
        INTO   v_tenant_id, v_tenant_code, v_tenant_name
        FROM   tenants
        WHERE  is_active = 'Y'
          AND  ROWNUM = 1;
    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            v_tenant_id   := 1;
            v_tenant_code := 'DEFAULT';
            v_tenant_name := 'Default Organization';
    END;
    
    APEX_UTIL.SET_SESSION_STATE('G_TENANT_ID', v_tenant_id);
    APEX_UTIL.SET_SESSION_STATE('G_TENANT_CODE', v_tenant_code);
    APEX_UTIL.SET_SESSION_STATE('G_TENANT_NAME', v_tenant_name);
    
      --set G_APP_ENV DEV/PROD
      set_app_environment( p_app_id=> v('APP_ID'), p_tenant_id =>v_tenant_id);

    COMMIT;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'User not found: ' || p_user_name);
    WHEN OTHERS THEN
      --  INSERT INTO error_log (log_date, error_msg, username)
      --  VALUES (SYSDATE, 'set_application_items: ' || SQLERRM, p_user_name);
        COMMIT;
        RAISE;
END set_application_items;


/***************************************************************************
 *  USER CREATION
 ***************************************************************************/
PROCEDURE create_user(
    p_username  IN VARCHAR2,
    p_password  IN VARCHAR2,
    p_is_active IN CHAR DEFAULT 'Y'
) IS
    vcaller constant varchar2(70):= c_package_name ||'.create_user'; 
    v_exists NUMBER;
    v_salt   VARCHAR2(200);
    v_hash   VARCHAR2(4000);
BEGIN
    SELECT COUNT(*) INTO v_exists
    FROM   users
    WHERE  UPPER(user_name) = UPPER(p_username);
    
    IF v_exists > 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'User already exists: ' || p_username);
    END IF;
    
    v_salt := generate_salt;
    v_hash := hash_password(p_password, v_salt);
    
    INSERT INTO users (user_name, password_hash, password_salt, is_active)
    VALUES (p_username, v_hash, v_salt, p_is_active);
    
    COMMIT;
END create_user;


/***************************************************************************
 *  RESET PASSWORD
 ***************************************************************************/
PROCEDURE reset_password(
    p_user_id  IN NUMBER,
    p_new_pass IN VARCHAR2
) IS
    vcaller constant varchar2(70):= c_package_name ||'.reset_password'; 
    v_salt VARCHAR2(200);
    v_hash VARCHAR2(4000);
BEGIN
    v_salt := generate_salt;
    v_hash := hash_password(p_new_pass, v_salt);
    
    UPDATE users
    SET    password_hash = v_hash,
           password_salt = v_salt
    WHERE  user_id = p_user_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'User not found: ' || p_user_id);
    END IF;
    
    COMMIT;
END reset_password;

END app_session_util;

/
