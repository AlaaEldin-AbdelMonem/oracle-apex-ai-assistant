--------------------------------------------------------
--  DDL for Package APP_SESSION_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "APP_SESSION_UTIL" AS
/**
 * PROJECT:     Oracle AI ChatPot - Enterprise RAG System
 * MODULE:      APP_SESSION_UTIL (Specification)
 * PURPOSE:     Security framework for user authentication, session state 
 * initialization, and cryptographic operations.
 * * DESCRIPTION: Provides standardized methods for password hashing, 
 * multi-factor authentication logic, and APEX session 
 * item management.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim
 *
 * DEPENDENCY:  DBMS_CRYPTO (Standard Oracle Package)
 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'APP_SESSION_UTIL';

    /*******************************************************************************
     * CRYPTOGRAPHIC FUNCTIONS
     *******************************************************************************/

    /**
     * Function: generate_salt
     * Generates a random cryptographic salt for password security.
     * @return: VARCHAR2 (Hex)
     */
    FUNCTION generate_salt RETURN VARCHAR2;
    
    /**
     * Function: hash_password
     * Generates a SHA-256 (or better) salted hash for the provided credentials.
     * @param:  p_user_name - Unique username context
     * @param:  p_password  - Raw password string
     * @return: VARCHAR2 (Hash)
     */
    FUNCTION hash_password(p_user_name IN VARCHAR2, p_password IN VARCHAR2) 
    RETURN VARCHAR2;

    /*******************************************************************************
     * AUTHENTICATION & ERROR HANDLING
     *******************************************************************************/

    /**
     * Function: authenticate_user
     * Core logic for verifying user identity during the login process.
     * @return: BOOLEAN (True if credentials match)
     */
    FUNCTION authenticate_user(
        p_username IN VARCHAR2,
        p_password IN VARCHAR2
    ) RETURN BOOLEAN;

    /**
     * Function: get_auth_error_message
     * Maps internal numeric error codes to user-friendly feedback strings.
     */
    FUNCTION get_auth_error_message(p_auth_code IN NUMBER) RETURN VARCHAR2;

    /*******************************************************************************
     * SESSION & USER MANAGEMENT
     *******************************************************************************/

    /**
     * Procedure: set_application_items
     * Initializes APEX Global Items after successful authentication.
     * @context: Called from Login Page (e.g., Page 9999).
     */
    PROCEDURE set_application_items(p_user_name IN VARCHAR2);
    
    /**
     * Procedure: create_user
     * Registers a new user with salted/hashed credentials.
     */
    PROCEDURE create_user(
        p_username  IN VARCHAR2,
        p_password  IN VARCHAR2,
        p_is_active IN CHAR DEFAULT 'Y'
    );
    
    /**
     * Procedure: reset_password
     * Overwrites existing password with a new salted hash.
     */
    PROCEDURE reset_password(
        p_user_id  IN NUMBER,
        p_new_pass IN VARCHAR2
    );
    
END app_session_util;

/
