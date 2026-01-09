prompt --application/pages/page_00009
begin
--   Manifest
--     PAGE: 00009
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
 p_id=>9
,p_name=>'test_token'
,p_alias=>'TEST-TOKEN'
,p_step_title=>'test_token'
,p_autocomplete_on_off=>'OFF'
,p_javascript_code=>' '
,p_page_template_options=>'#DEFAULT#'
,p_protection_level=>'C'
,p_page_component_map=>'17'
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(145254952273705741)
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
 p_id=>wwv_flow_imp.id(145718711625757215)
,p_plug_name=>'tab'
,p_region_template_options=>'#DEFAULT#:t-TabsRegion-mod--simple'
,p_plug_template=>3223171818405608528
,p_plug_display_sequence=>10
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(144733177340653646)
,p_plug_name=>'STREAMING TEST'
,p_region_name=>'stream_out'
,p_parent_plug_id=>wwv_flow_imp.id(145718711625757215)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>20
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
' <div id="stream_out"',
'     style="height:260px;overflow:auto;font-family:monospace;white-space:pre-wrap;background:#f3f3f3;padding:10px;border:1px solid #ccc;">',
'</div>'))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(145718883507757216)
,p_plug_name=>'IDCS access token'
,p_parent_plug_id=>wwv_flow_imp.id(145718711625757215)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>10
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_plug(
 p_id=>wwv_flow_imp.id(145719012961757218)
,p_plug_name=>'New'
,p_parent_plug_id=>wwv_flow_imp.id(145718711625757215)
,p_region_template_options=>'#DEFAULT#:t-Region--scrollBody'
,p_plug_template=>4072358936313175081
,p_plug_display_sequence=>30
,p_plug_display_point=>'SUB_REGIONS'
,p_location=>null
,p_plug_source=>wwv_flow_string.join(wwv_flow_t_varchar2(
'/********************************************************************',
unistr(' *  APEX Streaming Test \2013 Oracle ORDS SSE Endpoint'),
unistr(' *  Works from APEX Dynamic Action \2192 Execute JavaScript Code'),
' ********************************************************************/',
'',
'// --- Page Items ---',
'const pToken   = $v("P9_IAM_TOKEN");  // or replace with your item',
'const pPayload = $v("P9_PAYLOAD");    // JSON text area',
'',
'// --- Output region (HTML region with STATIC ID = "stream_out") ---',
'const outDiv = document.getElementById("stream_out");',
'outDiv.innerHTML = "";  // clear',
'',
'// --- Prevent page reload and double submit ---',
'if (window.streamRunning) {',
'    outDiv.innerHTML += "\n\n[Stream already running...]";',
'    return;',
'}',
'window.streamRunning = true;',
'',
'// --- SSE Fetch ---',
'(async () => {',
'    try {',
'        const response = await fetch(',
'            "https://g4b5adf6812b04d-mydb.adb.me-jeddah-1.oraclecloudapps.com/ords/ai8p/ai/stream/chat",',
'            {',
'                method: "POST",',
'                headers: {',
'                    "Content-Type": "application/json",',
'                    "Accept": "text/event-stream",',
'                    "Authorization": "Bearer " + pToken',
'                },',
'                body: pPayload',
'            }',
'        );',
'',
'        if (!response.ok) {',
'            outDiv.innerHTML = "HTTP ERROR: " + response.status;',
'            window.streamRunning = false;',
'            return;',
'        }',
'',
'        const reader = response.body.getReader();',
'        const decoder = new TextDecoder();',
'',
'        outDiv.innerHTML += "[Streaming started...]\n";',
'',
'        while (true) {',
'            const { done, value } = await reader.read();',
'            if (done) break;',
'',
'            const text = decoder.decode(value, { stream: true });',
'            outDiv.innerHTML += text;',
'',
'            // Auto scroll',
'            outDiv.scrollTop = outDiv.scrollHeight;',
'        }',
'',
'        outDiv.innerHTML += "\n[Streaming finished]";',
'    }',
'    catch (e) {',
'        outDiv.innerHTML += "\n[Streaming error]\n" + e;',
'    }',
'    finally {',
'        window.streamRunning = false;',
'    }',
'})();',
''))
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'expand_shortcuts', 'N',
  'output_as', 'HTML')).to_clob
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(144733028550653645)
,p_button_sequence=>10
,p_button_plug_id=>wwv_flow_imp.id(145718883507757216)
,p_button_name=>'Refresh_token'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>2349107722467437027
,p_button_is_hot=>'Y'
,p_button_image_alt=>'Refresh Token'
,p_warn_on_unsaved_changes=>null
,p_icon_css_classes=>'fa-refresh'
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_button(
 p_id=>wwv_flow_imp.id(145719200120757220)
,p_button_sequence=>40
,p_button_plug_id=>wwv_flow_imp.id(144733177340653646)
,p_button_name=>'STREAM_TEST'
,p_button_action=>'DEFINED_BY_DA'
,p_button_template_options=>'#DEFAULT#'
,p_button_template_id=>4072362960822175091
,p_button_image_alt=>'Stream Test'
,p_warn_on_unsaved_changes=>null
,p_grid_new_row=>'Y'
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(144732995436653644)
,p_name=>'P9_IAM_TOKEN'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(145718883507757216)
,p_prompt=>'Iam Token'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>20
,p_read_only_when_type=>'ALWAYS'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#:t-Form-fieldContainer--stretchInputs'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145718987895757217)
,p_name=>'P9_PAYLOAD'
,p_item_sequence=>30
,p_item_plug_id=>wwv_flow_imp.id(144733177340653646)
,p_prompt=>'Payload'
,p_display_as=>'NATIVE_DISPLAY_ONLY'
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'based_on', 'VALUE',
  'format', 'PLAIN',
  'send_on_page_submit', 'Y',
  'show_line_breaks', 'Y')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145719105486757219)
,p_name=>'P9_NEW'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(145719012961757218)
,p_prompt=>'New'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145719710238757225)
,p_name=>'P9_USER_MESSAGE'
,p_item_sequence=>10
,p_item_plug_id=>wwv_flow_imp.id(144733177340653646)
,p_item_default=>'What is the largest country in the world that have trees.'
,p_prompt=>'User Message'
,p_display_as=>'NATIVE_TEXT_FIELD'
,p_cSize=>30
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'disabled', 'N',
  'submit_when_enter_pressed', 'N',
  'subtype', 'TEXT',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_item(
 p_id=>wwv_flow_imp.id(145719804450757226)
,p_name=>'P9_STREAM_OUTPUT'
,p_item_sequence=>20
,p_item_plug_id=>wwv_flow_imp.id(144733177340653646)
,p_prompt=>'Stream Out'
,p_display_as=>'NATIVE_TEXTAREA'
,p_cSize=>30
,p_cHeight=>5
,p_field_template=>1609121967514267634
,p_item_template_options=>'#DEFAULT#'
,p_attributes=>wwv_flow_t_plugin_attributes(wwv_flow_t_varchar2(
  'auto_height', 'N',
  'character_counter', 'N',
  'resizable', 'Y',
  'trim_spaces', 'BOTH')).to_clob
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(145718316394757211)
,p_name=>'Get_Token'
,p_event_sequence=>20
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(144733028550653645)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(145718451869757212)
,p_event_id=>wwv_flow_imp.id(145718316394757211)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_response CLOB;',
'    l_json     apex_json.t_values;',
'BEGIN',
'    -- Reset headers',
'    apex_web_service.g_request_headers.delete;',
'',
'    -- Required for form POST',
'    apex_web_service.g_request_headers(1).name  := ''Content-Type'';',
'    apex_web_service.g_request_headers(1).value := ''application/x-www-form-urlencoded'';',
'',
'    -- Call IDCS OAuth endpoint with DEFAULT SCOPE',
'    l_response :=',
'        apex_web_service.make_rest_request(',
'            p_url                  => ''https://idcs-3f641a8d3f8b438cad276c90021dc544.identity.oraclecloud.com/oauth2/v1/token'',',
'            p_http_method          => ''POST'',',
'            p_credential_static_id => ''OCI_IAM_CLIENT_CRED'',',
'            p_body                 =>',
'                  ''grant_type=client_credentials''',
'                || ''&scope='' || apex_util.url_encode(''urn:opc:idm:__myscopes__'')',
'        );',
'',
'    apex_debug.message(''RAW RESPONSE = '' || l_response);',
'',
'    -- Parse JSON',
'    apex_json.parse(p_values => l_json, p_source => l_response);',
'',
'    -- Extract token',
'    :P9_IAM_TOKEN :=',
'        apex_json.get_varchar2(',
'            p_path   => ''access_token'',',
'            p_values => l_json',
'        );',
'',
'    apex_debug.message(''TOKEN = '' || :P9_IAM_TOKEN);',
'END;',
''))
,p_attribute_03=>'P9_IAM_TOKEN'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(145718668757757214)
,p_event_id=>wwv_flow_imp.id(145718316394757211)
,p_event_result=>'TRUE'
,p_action_sequence=>20
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'DECLARE',
'    l_jwt         VARCHAR2(32767);',
'    l_token       CLOB;',
'    CLIENT_ID     VARCHAR2(200) := ''4e1a50c35c0c431c82a11924dc31dd4f'';',
'    CLIENT_SECRET VARCHAR2(4000) := ''idcscs-eb04041f-60c1-486f-b34e-aa1818d2c748'';',
'    l_json        apex_json.t_values;',
'    l_assertion   VARCHAR2(32767);',
'BEGIN',
'    -- 1. Create JWT (HS256)',
'    l_jwt := apex_jwt.encode(',
'        p_iss           => CLIENT_ID,',
'        p_sub           => CLIENT_ID,',
'        p_aud           => ''https://idcs-3f641a8d3f8b438cad276c90021dc544.identity.oraclecloud.com/oauth2/v1/token'',',
'        p_exp_sec       => 300,',
'        p_jti           => sys_guid(),',
'        p_signature_key => utl_i18n.string_to_raw(CLIENT_SECRET, ''AL32UTF8'')',
'    );',
'',
'    apex_debug.message(''JWT (raw)='' || l_jwt);',
'',
'    -- URL-encode it',
'    l_assertion := apex_util.url_encode(l_jwt);',
'',
'    apex_debug.message(''JWT (encoded)='' || l_assertion);',
'',
'    -- Reset headers',
'    apex_web_service.g_request_headers.delete;',
'    apex_web_service.g_request_headers(1).name  := ''Content-Type'';',
'    apex_web_service.g_request_headers(1).value := ''application/x-www-form-urlencoded'';',
'',
'    -- 2. Request access token',
'    l_token :=',
'        apex_web_service.make_rest_request(',
'            p_url         => ''https://idcs-3f641a8d3f8b438cad276c90021dc544.identity.oraclecloud.com/oauth2/v1/token'',',
'            p_http_method => ''POST'',',
'            p_body        =>',
'                   ''grant_type=urn:ietf:params:oauth:grant-type:jwt-bearer''',
'                || ''&assertion='' || l_assertion',
'                || ''&assertion_type=urn:ietf:params:oauth:client-assertion-type:jwt-bearer''',
'                || ''&scope=ai_chatpot''',
'        );',
'',
'    apex_debug.message(''TOKEN RAW RESPONSE='' || l_token);',
'',
'    apex_json.parse(l_json, l_token);',
'',
'    :P9_IAM_TOKEN :=',
'        apex_json.get_varchar2(',
'            p_path   => ''access_token'',',
'            p_values => l_json',
'        );',
'',
'    apex_debug.message(''ACCESS TOKEN = '' || :P9_IAM_TOKEN);',
'END;',
' '))
,p_attribute_03=>'P9_IAM_TOKEN'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
,p_build_option_id=>wwv_flow_imp.id(123954063565486069)
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(145719373692757221)
,p_name=>'ORDS SSE Stream'
,p_event_sequence=>30
,p_triggering_element_type=>'BUTTON'
,p_triggering_button_id=>wwv_flow_imp.id(145719200120757220)
,p_bind_type=>'bind'
,p_execution_type=>'IMMEDIATE'
,p_bind_event_type=>'click'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(145719482657757222)
,p_event_id=>wwv_flow_imp.id(145719373692757221)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_JAVASCRIPT_CODE'
,p_attribute_01=>wwv_flow_string.join(wwv_flow_t_varchar2(
'let userMessage = $v("P9_USER_MESSAGE");',
'let out = apex.item("P9_STREAM_OUTPUT");',
'',
'console.log("=== STREAM START ===");',
'',
'if (!userMessage) {',
unistr('    out.setValue("\274C Please enter a message");'),
'    return;',
'}',
'',
'if (window.apexStreamRunning) return;',
'',
'window.apexStreamRunning = true;',
unistr('out.setValue("\D83D\DD04 Connecting...\005Cn");'),
'',
'let payload = JSON.stringify({',
'    provider: "OPENAI",',
'    model: "gpt-4o", // gpt-4o',
'    prompt: userMessage,',
'    user_id: 4,',
'    user_name: $v("APP_USER"),',
'    temperature: 0.7,',
'    max_tokens: 2000,',
'    top_p: 1.0,',
'    top_k: 50,',
'    app_session_id: $v("APP_SESSION") || null',
'});',
'',
' ',
'(async () => {',
'    try {',
'        const res = await fetch(',
unistr('            "https://g4b5adf6812b04d-mydb.adb.me-jeddah-1.oraclecloudapps.com/ords/ai/ai/stream/chat",  // \2705 Fixed URL'),
'            {',
'                method: "POST",',
'                headers: {',
'                    "Content-Type": "application/json",',
'                    "Accept": "text/event-stream" ',
'                },',
'                body: payload',
'            }',
'        );',
'',
'        console.log("Response:", res.status);',
'',
'        if (!res.ok) {',
'            const err = await res.text();',
unistr('            out.setValue(`\274C HTTP ${res.status}: ${err}`);'),
'            return;',
'        }',
'',
'        const reader = res.body.getReader();',
'        const decoder = new TextDecoder();',
'        let buffer = "", content = "";',
'',
'        out.setValue("");',
'',
'        while (true) {',
'            const {done, value} = await reader.read();',
'            if (done) break;',
'',
'            buffer += decoder.decode(value, {stream: true});',
'            let idx;',
'            ',
'            while ((idx = buffer.indexOf("\n\n")) !== -1) {',
'                const msg = buffer.substring(0, idx);',
'                buffer = buffer.substring(idx + 2);',
'',
'                if (msg.startsWith("data: ")) {',
'                    const data = msg.substring(6).trim();',
'                    ',
'                    if (data === "[[END]]") {',
unistr('                        console.log("\2705 Stream complete");'),
'                        break;',
'                    }',
'                    ',
'                    content += data;',
'                    out.setValue(content);',
'                }',
'            }',
'        }',
'',
unistr('        out.setValue(content + "\005Cn\005Cn\2705 Done");'),
'        console.log("Final length:", content.length);',
'        ',
'    } catch (err) {',
'        console.error("Error:", err);',
unistr('        out.setValue(`\274C ${err.message}`);'),
'    } finally {',
'        window.apexStreamRunning = false;',
'    }',
'})();'))
);
wwv_flow_imp_page.create_page_da_event(
 p_id=>wwv_flow_imp.id(145719554700757223)
,p_name=>'New'
,p_event_sequence=>40
,p_bind_type=>'bind'
,p_bind_event_type=>'ready'
);
wwv_flow_imp_page.create_page_da_action(
 p_id=>wwv_flow_imp.id(145719615426757224)
,p_event_id=>wwv_flow_imp.id(145719554700757223)
,p_event_result=>'TRUE'
,p_action_sequence=>10
,p_execute_on_page_init=>'N'
,p_action=>'NATIVE_EXECUTE_PLSQL_CODE'
,p_attribute_01=>':P9_IAM_TOKEN:='''';'
,p_attribute_02=>'P9_IAM_TOKEN'
,p_attribute_03=>'P9_IAM_TOKEN'
,p_attribute_04=>'N'
,p_attribute_05=>'PLSQL'
,p_wait_for_result=>'Y'
);
wwv_flow_imp.component_end;
end;
/
