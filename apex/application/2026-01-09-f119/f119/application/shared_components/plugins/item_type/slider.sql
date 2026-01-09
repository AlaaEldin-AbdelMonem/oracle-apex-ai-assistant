prompt --application/shared_components/plugins/item_type/slider
begin
--   Manifest
--     PLUGIN: SLIDER
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_plugin(
 p_id=>wwv_flow_imp.id(158749235997690264)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'SLIDER'
,p_display_name=>'SLIDER'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('ITEM TYPE','SLIDER'),'')
,p_javascript_file_urls=>'#WORKSPACE_FILES#Alaa-sliderPlugin/slider_plugin#MIN#.js'
,p_css_file_urls=>' #WORKSPACE_FILES#Alaa-sliderPlugin/sliderPlugin#MIN#.css'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'procedure render_slider (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_render_param,',
'    p_result in out nocopy apex_plugin.t_item_render_result',
') as',
'    l_name           varchar2(30)   := apex_plugin.get_input_name_for_item;',
'    l_min            number         := nvl(p_item.attribute_01, 0);',
'    l_max            number         := nvl(p_item.attribute_02, 100);',
'    l_step           number         := nvl(p_item.attribute_03, 1);',
'    -- Get the target item name from attribute 4',
'    l_target_item    varchar2(100)  := p_item.attribute_04; ',
'    l_value          varchar2(4000) := nvl(p_param.value, l_min);',
'begin',
'    sys.htp.p(''<div class="t-Form-inputContainer">'');',
'    sys.htp.p(''  <div class="t-Form-itemWrapper slider-container">'');',
'    sys.htp.p(''    <input type="range" '' ||',
'              ''id="''    || p_item.name || ''" '' ||',
'              ''name="''  || l_name       || ''" '' ||',
'              ''min="''   || l_min        || ''" '' ||',
'              ''max="''   || l_max        || ''" '' ||',
'              ''step="''  || l_step       || ''" '' ||',
'              ''value="'' || sys.htf.escape_sc(l_value) || ''" '' ||',
'              ''class="slider-item-plugin">'');',
'    sys.htp.p(''    <span id="'' || p_item.name || ''_val" class="slider-display">'' || l_value || ''</span>'');',
'    sys.htp.p(''  </div>'');',
'    sys.htp.p(''</div>'');',
'',
'    -- Pass the target item to the JS init function',
'    apex_javascript.add_onload_code (',
'        p_code => ''if (window.sliderPlugin) { '' ||',
'                  ''  sliderPlugin.init("'' || p_item.name || ''", "'' || l_target_item || ''"); '' ||',
'                  ''}''',
'    );',
'',
'    p_result.is_navigable := true;',
'end render_slider;',
'',
'procedure validate_slider (',
'    p_item   in            apex_plugin.t_item,',
'    p_plugin in            apex_plugin.t_plugin,',
'    p_param  in            apex_plugin.t_item_validation_param,',
'    p_result in out nocopy apex_plugin.t_item_validation_result',
') as',
'    l_value number := p_param.value;',
'    l_min   number := nvl(p_item.attribute_01, 0);',
'    l_max   number := nvl(p_item.attribute_02, 100);',
'begin',
'    if l_value < l_min or l_value > l_max then',
'        p_result.message := p_item.plain_label || '' must be between '' || l_min || '' and '' || l_max || ''.'';',
'    end if;',
'end validate_slider;'))
,p_api_version=>3
,p_render_function=>'render_slider'
,p_validation_function=>'validate_slider'
,p_standard_attributes=>'VISIBLE'
,p_substitute_attributes=>true
,p_version_scn=>38948184840855
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(158751819274765585)
,p_plugin_id=>wwv_flow_imp.id(158749235997690264)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'min_value'
,p_prompt=>'Min Value'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'0'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(158752442077771069)
,p_plugin_id=>wwv_flow_imp.id(158749235997690264)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'max_value'
,p_prompt=>'Max Value'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'100'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(158753098884776729)
,p_plugin_id=>wwv_flow_imp.id(158749235997690264)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'step'
,p_prompt=>'Step'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'1'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(158761115655197700)
,p_plugin_id=>wwv_flow_imp.id(158749235997690264)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'return_item'
,p_prompt=>'Return Item'
,p_attribute_type=>'PAGE ITEM'
,p_is_required=>false
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
