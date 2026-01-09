prompt --application/shared_components/navigation/lists/navigation_bar
begin
--   Manifest
--     LIST: Navigation Bar
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(123956269288486112)
,p_name=>'Navigation Bar'
,p_list_status=>'PUBLIC'
,p_version_scn=>38948142046865
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(124990179986922039)
,p_list_item_display_sequence=>2
,p_list_item_link_text=>'&G_USER_ROLE_NAME.'
,p_list_item_link_target=>'f?p=&APP_ID.:10:&SESSION.::&DEBUG.:10:::'
,p_list_item_icon=>'fa-user-secret'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(123968222107486210)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'&APP_USER.'
,p_list_item_link_target=>'#'
,p_list_item_icon=>'fa-user'
,p_list_text_02=>'has-username'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(123968790119486213)
,p_list_item_display_sequence=>20
,p_list_item_link_text=>'---'
,p_list_item_link_target=>'separator'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(123968222107486210)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(123969117756486214)
,p_list_item_display_sequence=>30
,p_list_item_link_text=>'Sign Out'
,p_list_item_link_target=>'&LOGOUT_URL.'
,p_list_item_icon=>'fa-sign-out'
,p_list_item_disp_cond_type=>'USER_IS_NOT_PUBLIC_USER'
,p_parent_list_item_id=>wwv_flow_imp.id(123968222107486210)
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(157654974097443855)
,p_list_item_display_sequence=>40
,p_list_item_link_text=>'Switch Theme'
,p_list_item_link_target=>'f?p=&APP_ID.:3:&SESSION.::&DEBUG.::P3_RETURN_PAGE:&APP_PAGE_ID.:'
,p_list_item_icon=>'fa-paint-brush'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
