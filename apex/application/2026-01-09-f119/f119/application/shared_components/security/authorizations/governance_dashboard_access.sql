prompt --application/shared_components/security/authorizations/governance_dashboard_access
begin
--   Manifest
--     SECURITY SCHEME: Governance Dashboard Access
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_security_scheme(
 p_id=>wwv_flow_imp.id(124730165255399199)
,p_name=>'Governance Dashboard Access'
,p_scheme_type=>'NATIVE_FUNCTION_BODY'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_has_access NUMBER;',
'BEGIN',
'  SELECT COUNT(*)',
'  INTO v_has_access',
'  FROM user_roles ur , roles lr  ,Users u',
'  WHERE  u.user_id = ur.user_id',
'     and  ur.role_id = lr.role_id',
'     AND UPPER(u.user_name) = UPPER(:APP_USER)',
'    AND lr.role_code IN (''AIADMIN'', ''AUD'', ''MGR'', ''ADMIN'');',
'',
'  RETURN (v_has_access > 0);',
'EXCEPTION',
'  WHEN OTHERS THEN',
'    RETURN FALSE;',
'END;'))
,p_error_message=>wwv_flow_string.join(wwv_flow_t_varchar2(
'```',
'You do not have permission to access the Governance Dashboard. This page requires Administrator, Auditor, or Manager privileges.',
'```'))
,p_version_scn=>38947175552911
,p_caching=>'BY_USER_BY_SESSION'
,p_comments=>'page 500'
);
wwv_flow_imp.component_end;
end;
/
