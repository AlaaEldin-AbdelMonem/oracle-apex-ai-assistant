prompt --application/shared_components/plugins/item_type/ranrange_slider
begin
--   Manifest
--     PLUGIN: RANRANGE_SLIDER
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
 p_id=>wwv_flow_imp.id(131987724503454371)
,p_plugin_type=>'ITEM TYPE'
,p_name=>'RANRANGE_SLIDER'
,p_display_name=>'Range Slider (v1.0)'
,p_supported_component_types=>'APEX_APPLICATION_PAGE_ITEMS:APEX_APPL_PAGE_IG_COLUMNS'
,p_image_prefix => nvl(wwv_flow_application_install.get_static_plugin_file_prefix('ITEM TYPE','RANRANGE_SLIDER'),'')
,p_javascript_file_urls=>'#APP_FILES#RANGESLIDER_PLUGIN/range-slider#MIN#.css'
,p_css_file_urls=>'#APP_FILES#RANGESLIDER_PLUGIN/range-slider#MIN#.js'
,p_plsql_code=>wwv_flow_string.join(wwv_flow_t_varchar2(
'PROCEDURE render_slider (',
'    p_item   IN apex_plugin.t_item,',
'    p_plugin IN apex_plugin.t_plugin,',
'    p_param  IN apex_plugin.t_item_render_param,',
'    p_result IN OUT NOCOPY apex_plugin.t_item_render_result',
') IS',
'    l_id     VARCHAR2(4000) := p_item.name;',
'    l_min    VARCHAR2(50)   := NVL(p_item.attribute_01, ''0'');',
'    l_max    VARCHAR2(50)   := NVL(p_item.attribute_02, ''1'');',
'    l_step   VARCHAR2(50)   := NVL(p_item.attribute_03, ''0.1'');',
'    l_default VARCHAR2(50)  := NVL(p_item.attribute_04, ''0.5'');',
'    l_help   VARCHAR2(4000) := p_item.attribute_05;',
'BEGIN',
'    -- Include static JS/CSS',
'    apex_css.add_file(p_name=>''range-slider'', p_directory=>''#PLUGIN_FILES#'');',
'    apex_javascript.add_library(p_name=>''range-slider'', p_directory=>''#PLUGIN_FILES#'', p_key=>''range_slider_js'');',
'',
'    -- Render slider HTML dynamically',
'    htp.p(''<div class="range-slider-container">'');',
'    htp.p(''<label for="''||l_id||''">''||p_item.label||''</label><br>'');',
'    htp.p(''<input type="range" id="''||l_id||''" name="''||l_id||''" ''||',
'          ''min="''||l_min||''" max="''||l_max||''" step="''||l_step||''" ''||',
'          ''value="''||NVL(p_param.value,l_default)||''" ''||',
'          ''class="range-slider">'');',
'    htp.p(''<div id="''||l_id||''_val" class="slider-value">''||',
'          NVL(p_param.value,l_default)||''</div>'');',
'',
'    IF l_help IS NOT NULL THEN',
'        htp.p(''<div class="slider-help">''||apex_escape.html(l_help)||''</div>'');',
'    END IF;',
'    htp.p(''</div>'');',
'',
'    -- JS to update label live',
'    apex_javascript.add_onload_code(''RangeSlider.init("''||l_id||''");'');',
'END render_slider;',
''))
,p_partial_template=>wwv_flow_string.join(wwv_flow_t_varchar2(
'// range-slider.js',
'(function(){',
'  window.RangeSlider = {',
'    init: function(itemId){',
'      const el = document.getElementById(itemId);',
'      const val = document.getElementById(itemId + "_val");',
'      if(el && val){',
'        el.addEventListener("input", ()=> val.textContent = el.value);',
'      }',
'    }',
'  };',
'})();',
''))
,p_api_version=>3
,p_render_function=>'render_slider'
,p_standard_attributes=>'VISIBLE:READONLY:QUICKPICK:ELEMENT:WIDTH:HEIGHT:PLACEHOLDER:ICON'
,p_substitute_attributes=>true
,p_version_scn=>38947038540384
,p_subscribe_plugin_settings=>true
,p_version_identifier=>'1.0'
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131992546450541754)
,p_plugin_id=>wwv_flow_imp.id(131987724503454371)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>1
,p_display_sequence=>10
,p_static_id=>'min_value'
,p_prompt=>'Minimum Value'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'0'
,p_display_length=>3
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131993123060546973)
,p_plugin_id=>wwv_flow_imp.id(131987724503454371)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>2
,p_display_sequence=>20
,p_static_id=>'max_value'
,p_prompt=>'Maximum Value'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_max_length=>1
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131993782181552556)
,p_plugin_id=>wwv_flow_imp.id(131987724503454371)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>3
,p_display_sequence=>30
,p_static_id=>'step_size'
,p_prompt=>'Step Size'
,p_attribute_type=>'NUMBER'
,p_is_required=>false
,p_default_value=>'0.1'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131994382129554543)
,p_plugin_id=>wwv_flow_imp.id(131987724503454371)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>4
,p_display_sequence=>40
,p_static_id=>'default_value'
,p_prompt=>'Default Value'
,p_attribute_type=>'NUMBER'
,p_is_required=>true
,p_default_value=>'0'
,p_is_translatable=>false
);
wwv_flow_imp_shared.create_plugin_attribute(
 p_id=>wwv_flow_imp.id(131994968417560356)
,p_plugin_id=>wwv_flow_imp.id(131987724503454371)
,p_attribute_scope=>'COMPONENT'
,p_attribute_sequence=>5
,p_display_sequence=>50
,p_static_id=>'help_text'
,p_prompt=>'Help Text'
,p_attribute_type=>'TEXTAREA'
,p_is_required=>false
,p_is_translatable=>false
);
end;
/
begin
wwv_flow_imp.component_end;
end;
/
