prompt --application/pages/page_00500
begin
--   Manifest
--     PAGE: 00500
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
 p_id=>500
,p_name=>'Governance Dashboard'
,p_alias=>'GOVERNANCE-DASHBOARD'
,p_step_title=>'Governance Dashboard'
,p_autocomplete_on_off=>'OFF'
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'11'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124703221581091095)
,p_plug_name=>'Breadcrumb'
,p_region_template_options=>'#DEFAULT#:t-BreadcrumbRegion--compactTitle:t-BreadcrumbRegion--useBreadcrumbTitle'
,p_component_template_options=>'#DEFAULT#'
,p_plug_template=>2531463326621247859
,p_plug_display_sequence=>10
,p_plug_display_point=>'REGION_POSITION_01'
,p_location=>null
,p_menu_id=>wwv_flow_imp.id(123954626239486075)
,p_plug_source_type=>'NATIVE_BREADCRUMB'
,p_menu_template_id=>4072363345357175094
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(124707907035182440)
,p_name=>'Auto-Refresh Dynamic Action'
,p_event_sequence=>10
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
,p_required_patch=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(124708050350182441)
,p_event_id=>wwv_flow_imp.id(124707907035182440)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_name=>'Auto-Refresh Dynamic Action'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
' ',
'// Auto-refresh dashboard every 30 seconds',
'setInterval(function() {',
'    // Refresh KPI region',
'    apex.region("governance_overview").refresh();',
'',
'    // Refresh all chart regions',
'    apex.region("model_usage_chart").refresh();',
'    apex.region("model_latency_chart").refresh();',
'    apex.region("violations_pie_chart").refresh();',
'',
'    // Refresh interactive report',
'    apex.region("violation_details_report").refresh();',
'',
'    console.log("Dashboard auto-refreshed at: " + new Date().toISOString());',
'}, 30000); // 30 seconds',
'',
'// Show refresh indicator',
'apex.message.showPageSuccess("Dashboard is set to auto-refresh every 30 seconds");',
' '))
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(124708154751182442)
,p_process_sequence=>10
,p_process_point=>'AFTER_HEADER'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'Log Dashboard Access'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'  v_role_id NUMBER;',
'  v_context_json CLOB;',
'BEGIN',
'  -- Get role_id for current user',
'  BEGIN',
'    SELECT ur.role_id ',
'    INTO v_role_id',
'    FROM user_roles ur, users u',
'    WHERE u.user_id = ur.user_id',
'     AND UPPER(u.user_name) = UPPER(:APP_USER)',
'      AND ROWNUM = 1;',
'  EXCEPTION',
'    WHEN NO_DATA_FOUND THEN',
'      v_role_id := NULL;',
'  END;',
'  ',
'  -- Build context JSON',
'  v_context_json := JSON_OBJECT(',
'    ''page_id'' VALUE 500,',
'    ''page_name'' VALUE ''Governance Dashboard'',',
'    ''app_session'' VALUE :APP_SESSION,',
'    ''remote_addr'' VALUE :APP_REMOTE_ADDR,',
'    ''browser'' VALUE :APP_BROWSER_NAME,',
'    ''access_timestamp'' VALUE TO_CHAR(SYSDATE, ''YYYY-MM-DD"T"HH24:MI:SS'')',
'  );',
'  end;'))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>124708154751182442
);
wwv_flow_imp.component_end;
end;
/
