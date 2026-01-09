--------------------------------------------------------
--  DDL for Package APP_ADMIN_SECURITY
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "AI8P"."APP_ADMIN_SECURITY" AS
/**
 * PROJECT:     Enterprise AI Assistant
 * MODULE:      APP_ADMIN_SECURITY (Specification)
 * PURPOSE:     Public interface for authorization and administrative 
 * access control within the AI Assistant application.
 *
 * AUTHOR:      Alaa Abdelmoneim <alaa.guru@outlook.com>
 * GITHUB:      https://github.com/AlaaEldin-AbdelMonem/oracle-apex-ai-assistant
 * LINKEDIN:    https://www.linkedin.com/in/alaa-eldin/
 * LICENSE:     MIT
 * COPYRIGHT:   (c) 2025 Alaa Abdelmoneim

 */

    -- Global Constants
    c_version       CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name  CONSTANT VARCHAR2(30) := 'APP_ADMIN_SECURITY';

    /*******************************************************************************
     * FUNCTION:  is_admin
     * PURPOSE:   Returns TRUE if the current session user has admin privileges.
     * @return:   BOOLEAN
     *******************************************************************************/
    FUNCTION is_admin RETURN BOOLEAN;

END app_admin_security;

/
