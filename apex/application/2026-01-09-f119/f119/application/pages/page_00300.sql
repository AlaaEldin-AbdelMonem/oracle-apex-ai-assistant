prompt --application/pages/page_00300
begin
--   Manifest
--     PAGE: 00300
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_page.create_page(
 p_id=>300
,p_name=>'AI Governance - Policy Manager'
,p_alias=>'POLICY-MANAGER1'
,p_step_title=>'Policy Manager'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* Highlight inactive policies */',
'tr.inactive-row {',
'    background-color: #f3f3f3 !important;',
'    opacity: 0.7;',
'}',
'',
'tr.inactive-row:hover {',
'    background-color: #e8e8e8 !important;',
'}',
'',
'/* Policy grid styling */',
'.policy-grid .a-IG-header {',
'    background-color: #3a5795;',
'    color: white;',
'    font-weight: bold;',
'}',
'',
'/* Search filter region styling */',
'#search-filters {',
'    background-color: #f9f9f9;',
'    padding: 12px;',
'    margin-bottom: 12px;',
'    border: 1px solid #e0e0e0;',
'    border-radius: 4px;',
'}'))
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_help_text=>wwv_flow_string.join(wwv_flow_t_varchar2(
'## Policy Manager - User Guide',
'',
'### Purpose',
'The Policy Manager allows you to define and manage AI governance policies that control:',
'- Which roles can access specific data domains',
'- What classification levels are permitted',
'- Which actions are allowed (READ, SUMMARIZE, CLASSIFY, etc.)',
'',
'### Policy Components',
'',
'1. **Role**: The user role this policy applies to (e.g., Employee, Manager, HR Admin)',
'2. **Data Domain**: The data category (e.g., HCM_DATA, TEAM_DATA, SELF_DATA)',
'3. **Classification Level**: ',
'   - Level 1: Public',
'   - Level 2: Internal',
'   - Level 3: Confidential',
'   - Level 4: Restricted',
'4. **Allowed Actions**: Comma-separated action codes (READ, SUMMARIZE, CLASSIFY, etc.)',
'5. **Active Status**: Enable/disable policy without deletion',
'',
'### Best Practices',
'',
unistr('\2705 **DO:**'),
'- Always start with least-privilege (lowest classification)',
'- Test policies before activating',
'- Document policy rationale in comments',
'- Review policies quarterly',
'',
unistr('\274C **DON''T:**'),
'- Grant Restricted access to Employee roles',
'- Overlap policies for same role+domain',
'- Leave policies inactive indefinitely',
'- Bypass audit logging',
'',
'### Security Notes',
'',
'- All policy changes are logged in the audit trail',
'- Deleted policies are soft-deleted (marked inactive)',
'- Only AIADMIN and HR roles can modify policies',
'- Policy violations are tracked and reported',
'',
'### Support',
'',
'For questions or issues, contact: **IT Governance Team**'))
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124108847676184691)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_validation(
 p_id=>wwv_flow_imp.id(124067173274964427)
,p_validation_name=>'Validate Actions Format'
,p_validation_sequence=>30
,p_validation=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'       v_actions VARCHAR2(500) := :ALLOW_ACTIONS;',
'       v_action VARCHAR2(100);',
'       v_pos NUMBER;',
'       v_valid NUMBER;',
'   BEGIN',
'       -- Allow NULL',
'       IF v_actions IS NULL THEN',
'           RETURN TRUE;',
'       END IF;',
'       ',
'       -- Split by comma and validate each action',
'       LOOP',
'           v_pos := INSTR(v_actions, '','');',
'           ',
'           IF v_pos > 0 THEN',
'               v_action := TRIM(SUBSTR(v_actions, 1, v_pos - 1));',
'               v_actions := SUBSTR(v_actions, v_pos + 1);',
'           ELSE',
'               v_action := TRIM(v_actions);',
'           END IF;',
'           ',
'           -- Check if action exists',
'           SELECT COUNT(*) INTO v_valid',
'           FROM lkp_access_action',
'           WHERE action_code = v_action;',
'           ',
'           IF v_valid = 0 THEN',
'               RETURN FALSE;',
'           END IF;',
'           ',
'           EXIT WHEN v_pos = 0;',
'       END LOOP;',
'       ',
'       RETURN TRUE;',
'   END;'))
,p_validation2=>'PLSQL'
,p_validation_type=>'FUNC_BODY_RETURNING_BOOLEAN'
,p_error_message=>'Invalid action code detected. Please select from valid actions only.'
,p_error_display_location=>'INLINE_WITH_FIELD_AND_NOTIFICATION'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp.component_end;
end;
/
