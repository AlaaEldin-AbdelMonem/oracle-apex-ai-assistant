prompt --application/pages/page_00150
begin
--   Manifest
--     PAGE: 00150
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
 p_id=>150
,p_name=>'Chat History'
,p_alias=>'CHAT-HISTORY1'
,p_step_title=>'Chat History'
,p_autocomplete_on_off=>'OFF'
,p_inline_css=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/* ===============================',
'   ENTERPRISE CHAT HISTORY',
'   Page 150',
'   =============================== */',
'',
'#chatHistory {',
'  padding: 6px 8px;',
'}',
'',
'/* One turn */',
'.chat-turn {',
'  margin-bottom: 6px;',
'}',
'',
'/* One line */',
'.chat-line {',
'  display: flex;',
'  align-items: flex-start;',
'  gap: 6px;',
'  margin: 2px 0;',
'  width: 100%;',
'}',
'',
'/* Icon */',
'.chat-icon {',
'  font-size: 14px;',
'  opacity: 0.7;',
'  line-height: 1.4;',
'  flex-shrink: 0;',
'}',
'',
'/* Bubble */',
'.chat-bubble {',
'  padding: 6px 8px;',
'  border-radius: 6px;',
'  line-height: 1.4;',
'  font-size: 13px;',
'  white-space: pre-wrap;',
'  overflow-wrap: anywhere;',
'  max-width: 100%;',
'}',
'',
'/* User bubble */',
'.user-bubble {',
'  background: #ffffff;',
'  border: 1px solid #e5e7eb;',
'  color: #111827;',
'}',
'',
'/* Assistant bubble */',
'.ai-bubble {',
'  background: #fffbe6;       /* very light yellow */',
'  border: 1px solid #f5e6a8;',
'  color: #3a2f00;',
'}',
'',
'/* Right-side meta (USER only) */',
'.chat-meta-right {',
'  margin-left: auto;',
'  display: flex;',
'  align-items: center;',
'  gap: 6px;',
'  font-size: 11px;',
'  color: #6b7280;',
'  white-space: nowrap;',
'}',
'',
'/* Timestamp */',
'.chat-time {',
'  opacity: 0.8;',
'}',
'',
'/* Dotted menu */',
'.chat-menu {',
'  font-size: 16px;',
'  line-height: 1;',
'  padding: 0 2px;',
'}',
'',
'/* Disabled menu */',
'.chat-menu.disabled {',
'  opacity: 0.35;',
'  pointer-events: none;',
'}',
'',
'/* Remove Classic Report spacing */',
'#chatHistory table,',
'#chatHistory tr,',
'#chatHistory td {',
'  padding: 0 !important;',
'  border: none !important;',
'}',
''))
,p_step_template=>2526643373347724467
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'03'
);
wwv_flow_imp_page.create_report_region(
 p_id=>wwv_flow_imp.id(123998686940353957)
,p_name=>'Chat History'
,p_region_name=>'chatHistory'
,p_template=>2100526641005906379
,p_display_sequence=>60
,p_region_template_options=>'#DEFAULT#:t-IRR-region--hideHeader js-addHiddenHeadingRoleDesc'
,p_component_template_options=>'#DEFAULT#'
,p_source_type=>'NATIVE_SQL_REPORT'
,p_query_type=>'SQL'
,p_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT',
'    c.call_id,',
'    c.call_seq,',
'    c.message_role,',
'    c.user_prompt,',
'    c.response_text,',
'    c.db_created_at,',
'    c.processing_status,',
'    c.success,',
'    c.is_refusal',
'FROM chat_calls c',
'WHERE c.chat_session_id = :P150_CHAT_SESSION_ID',
'  AND c.is_deleted = ''N''',
'ORDER BY c.call_seq;'))
,p_ajax_enabled=>'Y'
,p_ajax_items_to_submit=>'P150_CHAT_SESSION_ID'
,p_lazy_loading=>false
,p_query_row_template=>wwv_flow_imp.id(155681777593051477)
,p_query_num_rows=>15
,p_query_options=>'DERIVED_REPORT_COLUMNS'
,p_query_num_rows_type=>'NEXT_PREVIOUS_LINKS'
,p_pagination_display_position=>'BOTTOM_RIGHT'
,p_csv_output=>'N'
,p_prn_output=>'N'
,p_sort_null=>'L'
,p_plug_query_strip_html=>'N'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154734920082983120)
,p_query_column_id=>1
,p_column_alias=>'CALL_ID'
,p_column_display_sequence=>10
,p_column_heading=>'Call Id'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735070580983121)
,p_query_column_id=>2
,p_column_alias=>'CALL_SEQ'
,p_column_display_sequence=>20
,p_column_heading=>'Call Seq'
,p_column_alignment=>'RIGHT'
,p_heading_alignment=>'RIGHT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735196665983122)
,p_query_column_id=>3
,p_column_alias=>'MESSAGE_ROLE'
,p_column_display_sequence=>30
,p_column_heading=>'Message Role'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735264042983123)
,p_query_column_id=>4
,p_column_alias=>'USER_PROMPT'
,p_column_display_sequence=>40
,p_column_heading=>'User Prompt'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735310143983124)
,p_query_column_id=>5
,p_column_alias=>'RESPONSE_TEXT'
,p_column_display_sequence=>50
,p_column_heading=>'Response Text'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735461103983125)
,p_query_column_id=>6
,p_column_alias=>'DB_CREATED_AT'
,p_column_display_sequence=>60
,p_column_heading=>'Db Created At'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735523096983126)
,p_query_column_id=>7
,p_column_alias=>'PROCESSING_STATUS'
,p_column_display_sequence=>70
,p_column_heading=>'Processing Status'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735694443983127)
,p_query_column_id=>8
,p_column_alias=>'SUCCESS'
,p_column_display_sequence=>80
,p_column_heading=>'Success'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_report_columns(
 p_id=>wwv_flow_imp.id(154735728257983128)
,p_query_column_id=>9
,p_column_alias=>'IS_REFUSAL'
,p_column_display_sequence=>90
,p_column_heading=>'Is Refusal'
,p_heading_alignment=>'LEFT'
,p_derived_column=>'N'
,p_include_in_export=>'Y'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(124005836832353984)
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
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(456125948450691610)
,p_plug_name=>'MyProjectsTree'
,p_title=>'Projects'
,p_region_name=>'myProjectsTreeStaticID'
,p_region_template_options=>'#DEFAULT#'
,p_plug_template=>4501440665235496320
,p_plug_display_sequence=>30
,p_plug_display_point=>'REGION_POSITION_02'
,p_query_type=>'SQL'
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'SELECT ',
'    LEVEL                                             AS tree_level,',
'    ',
'    -- Required by APEX Tree Region',
'     item_id                      AS node_id,',
'    parent_id                                         AS parent_node_id,',
unistr('    DECODE(item_type, ''PROJECT'',''\D83D\DCC1 '',''\D83D\DCAC '') '),
'        || item_title                                AS node_label,',
'    item_type||''|'' || item_id  || ''|''  || parent_id AS Node_Value_Column, --Workaround to get nodeIds',
'    -- Optional but useful for APEX config',
'    item_type                                         AS node_type,',
'    item_title                                        AS title,',
'    created_at                                        AS created_at,',
'    last_activity                                     AS last_activity,',
'    session_count                                     AS session_count,',
'    token_total                                       AS token_total,',
'    token_cost                                        AS token_cost,',
'',
'    -- For ordering inside tree',
'    created_at                                        AS order_value,',
'',
'    -- Optional icon class if needed',
'    CASE ',
'        WHEN item_type = ''PROJECT'' THEN ''icon-tree-folder''',
'        ELSE ''icon-tree-file''',
'    END                                               AS icon_css',
'',
'FROM (',
'    ----------------------------------------------------------------------',
'    -- Level 1: Projects',
'    ----------------------------------------------------------------------',
'    SELECT ',
'        ''PROJECT''                AS item_type,',
'        cp.CHAT_PROJECT_ID       AS item_id,',
'        NULL                     AS parent_id,',
'        cp.PROJECT_NAME          AS item_title,',
'        cp.IS_ACTIVE             AS is_active,',
'        cp.CREATED_AT            AS created_at,',
'        NULL                     AS last_activity,',
'        (SELECT COUNT(*) ',
'         FROM CHAT_SESSIONS cs2',
'         WHERE cs2.CHAT_PROJECT_ID = cp.CHAT_PROJECT_ID',
'           AND cs2.IS_ACTIVE = ''Y'') AS session_count,',
'        NULL                     AS token_total,',
'        NULL                     AS token_cost',
'    FROM CHAT_PROJECTS cp',
'    WHERE cp.owner_user_id = v(''G_USER_ID'') ',
'      AND cp.IS_ACTIVE = ''Y''',
'    ',
'    UNION ALL',
'',
'    ----------------------------------------------------------------------',
'    -- Level 2: Sessions',
'    ----------------------------------------------------------------------',
'    SELECT',
'        ''SESSION''                AS item_type,',
'        cs.SESSION_ID            AS item_id,',
'        cs.CHAT_PROJECT_ID       AS parent_id,',
'        NVL(cs.SESSION_TITLE, ''Untitled Session'') AS item_title,',
'        cs.IS_ACTIVE             AS is_active,',
'        cs.CREATED_DATE          AS created_at,',
'        cs.LAST_ACTIVITY_DATE    AS last_activity,',
'        NULL                     AS session_count,',
'        cs.TOKENS_TOTAL          AS token_total,',
'        cs.TOKENS_TOTAL_COST     AS token_cost',
'    FROM CHAT_SESSIONS cs',
'    WHERE cs.IS_ACTIVE = ''Y''',
'         and cs.user_id = v(''G_USER_ID'')',
'      AND cs.CHAT_PROJECT_ID IS NOT NULL',
')',
'START WITH parent_id IS NULL',
'CONNECT BY PRIOR item_id = parent_id',
'ORDER SIBLINGS BY created_at DESC;'))
,p_lazy_loading=>false
,p_plug_source_type=>'NATIVE_JSTREE'
,p_ajax_items_to_submit=>'P150_ISSUE_LEVEL'
,p_ai_enabled=>false
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'activate_node_link_with', 'S',
  'default_icon_css_class', 'icon-tree-folder',
  'icon_css_class_column', 'ICON_CSS',
  'node_id_column', 'NODE_ID',
  'node_label_column', 'NODE_LABEL',
  'node_value_column', 'NODE_VALUE_COLUMN',
  'order_siblings_by', 'ORDER_VALUE',
  'parent_key_column', 'PARENT_NODE_ID',
  'selected_node_page_item', 'P150_ISSUE_LEVEL',
  'start_tree_with', 'NULL',
  'tooltip_column', 'NODE_ID',
  'tree_hierarchy', 'SQL',
  'tree_link', 'javascript:void(0);',
  'tree_tooltip', 'DB')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(124005104362353981)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(123998686940353957)
,p_button_name=>'CREATE'
,p_button_action=>'REDIRECT_PAGE'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Create'
,p_button_position=>'RIGHT_OF_IR_SEARCH_BAR'
,p_button_redirect_url=>'f?p=&APP_ID.:151:&APP_SESSION.::&DEBUG.:151::'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(154733522205983106)
,p_name=>'P150_CHAT_PROJECT_ID'
,p_item_sequence=>50
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(154733613389983107)
,p_name=>'P150_SELECTED_PROJECT_ID'
,p_item_sequence=>10
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(154733752837983108)
,p_name=>'P150_CHAT_SESSION_ID'
,p_item_sequence=>30
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(154733860297983109)
,p_name=>'P150_CHAT_PROJECT_TITLE'
,p_item_sequence=>20
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(154733923732983110)
,p_name=>'P150_SESSION_TITLE'
,p_item_sequence=>40
,p_display_as=>'NATIVE_HIDDEN'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'value_protected', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(155667693877979050)
,p_name=>'ProjectTree Node Selected'
,p_event_sequence=>10
,p_triggering_element_type=>'REGION'
,p_triggering_region_id=>wwv_flow_imp.id(456125948450691610)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'NATIVE_JSTREE|REGION TYPE|treeviewselectionchange'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155668546515979056)
,p_event_id=>wwv_flow_imp.id(155667693877979050)
,p_event_result=>'TRUE'
,p_action_sequence=>40
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'var node = apex.region("myProjectsTreeStaticID").call("getSelectedNodes")[0];',
'if (!node) return;',
'',
'// Read node metadata',
'var raw = node.id;                // PROJECT|1|   or SESSION|302|2',
unistr('var label = node.label;           // "\D83D\DCC1 HR Portal"  or "\D83D\DCAC what is my salary"'),
'console.log("RAW NODE_ID:", raw);',
'console.log("label:", label);',
'',
'// Split metadata',
'var parts = raw.split("|");',
'var type   = parts[0];  // PROJECT / SESSION',
'var id     = parts[1];  // Project ID or Session ID',
'var parent = parts[2];  // Parent project ID (may be "" for root)',
'',
' ',
'// PROJECT NODE',
'if (type === "PROJECT") {',
'    apex.item("P150_CHAT_PROJECT_ID").setValue(id);',
'    apex.item("P150_SELECTED_PROJECT_ID").setValue(id);',
'    ',
'    // extract clean project title',
unistr('    var cleanTitle = label.replace("\D83D\DCC1 ", "");'),
'    apex.item("P150_CHAT_PROJECT_TITLE").setValue(cleanTitle);',
'}',
'',
'// SESSION NODE',
'if (type === "SESSION") {',
'    apex.item("P150_CHAT_SESSION_ID").setValue(id);',
'    apex.item("P150_CHAT_PROJECT_ID").setValue(parent);',
'    apex.item("P150_SELECTED_PROJECT_ID").setValue(parent);',
'',
'    // extract clean session title',
unistr('    var cleanTitle = label.replace("\D83D\DCAC ", "");'),
'    apex.item("P150_SESSION_TITLE").setValue(cleanTitle);',
'',
'',
'    // GET PROJECT TITLE FROM TREE NODE (not from items)',
'    var parentLabel = "";',
'    if (node._parent && node._parent.label) {',
unistr('        parentLabel = node._parent.label.replace("\D83D\DCC1 ", "");'),
'    }',
'',
'    console.log("PARENT PROJECT TITLE:", parentLabel);',
'',
'    // Set APEX item for UI/header',
'    apex.item("P150_CHAT_PROJECT_TITLE").setValue(parentLabel);',
'',
'',
'    // Push value to session state immediately',
'  // apex.server.process(  "", // Name of a defined AJAX Callback process',
'   // { x01: apex.item("P150_CHAT_SESSION_ID").getValue(),x02: apex.item("P150_SELECTED_PROJECT_ID").getValue() },',
'    ',
'  //  {  success: function(pData) {  console.log("Session state updated");',
'    //    } } );',
'',
'',
'',
'',
'           try {',
'            apex.server.process(',
'                "SET_SESSION_ITEM",',
'                {',
'                    pageItems: "#P150_CHAT_SESSION_ID,#P150_SELECTED_PROJECT_ID" ',
'                },',
'                {',
'                    url: window.location.href,',
'                    dataType: "text",',
unistr('                    success: () => {  console.log("\2705 Protected item synced.");  },'),
unistr('                    error: (err) => { console.error("\274C Protected Item Sync Failed:", err);'),
'                                        apex.message.alert("Failed to sync protected items.");',
'                    }',
'                }',
'            );',
unistr('        } catch (e) { console.error("\274C openReportIssueDialog Exception:", e); };'),
' ',
'}',
''))
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155669003467979057)
,p_event_id=>wwv_flow_imp.id(155667693877979050)
,p_event_result=>'TRUE'
,p_action_sequence=>60
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(155668037188979054)
,p_event_id=>wwv_flow_imp.id(155667693877979050)
,p_event_result=>'TRUE'
,p_action_sequence=>70
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_REFRESH'
,p_affected_elements_type=>'REGION'
,p_affected_region_id=>wwv_flow_imp.id(123998686940353957)
,p_attribute_01=>'N'
);
wwv_flow_imp_page.create_page_process(
 p_id=>wwv_flow_imp.id(155667107283972736)
,p_process_sequence=>10
,p_process_point=>'ON_DEMAND'
,p_process_type=>'NATIVE_PLSQL'
,p_process_name=>'SET_SESSION_ITEM'
,p_process_sql_clob=>wwv_flow_string.join(wwv_flow_t_varchar2(
'  null;',
'  declare  ',
'     v_CHAT_SESSION_ID           NUMBER := TO_NUMBER(apex_application.g_x01);',
'     v_SELECTED_PROJECT_ID       NUMBER := TO_NUMBER(apex_application.g_x02);',
' --  v     NUMBER := apex_application.g_x03;',
' BEGIN',
'    APEX_UTIL.SET_SESSION_STATE(''P150_CHAT_SESSION_ID'', v_CHAT_SESSION_ID);',
'    APEX_UTIL.SET_SESSION_STATE(''P150_SELECTED_PROJECT_ID'', v_SELECTED_PROJECT_ID);',
'   -- APEX_UTIL.SET_SESSION_STATE(''P1_ITEM'', :x03);',
'END;  ',
'',
'   '))
,p_process_clob_language=>'PLSQL'
,p_internal_uid=>155667107283972736
);
wwv_flow_imp.component_end;
end;
/
