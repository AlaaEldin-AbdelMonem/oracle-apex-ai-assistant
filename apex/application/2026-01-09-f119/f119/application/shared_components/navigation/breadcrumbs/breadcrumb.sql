prompt --application/shared_components/navigation/breadcrumbs/breadcrumb
begin
--   Manifest
--     MENU: Breadcrumb
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2024.11.30'
,p_release=>'24.2.11'
,p_default_workspace_id=>110979332345909267
,p_default_application_id=>119
,p_default_id_offset=>0
,p_default_owner=>'AI8P'
);
wwv_flow_imp_shared.create_menu(
 p_id=>wwv_flow_imp.id(123954626239486075)
,p_name=>'Breadcrumb'
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(123954823335486076)
,p_short_name=>'Home'
,p_link=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124005710616353983)
,p_parent_id=>wwv_flow_imp.id(123954823335486076)
,p_short_name=>'Chat History'
,p_link=>'f?p=&APP_ID.:150:&SESSION.::&DEBUG.:::'
,p_page_id=>150
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124006962070353987)
,p_parent_id=>wwv_flow_imp.id(124005710616353983)
,p_short_name=>'Chat History'
,p_link=>'f?p=&APP_ID.:151:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>151
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124108716346184691)
,p_short_name=>'Policy Manager'
,p_link=>'f?p=&APP_ID.:300:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>300
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124679942217841597)
,p_short_name=>'Redaction Rules'
,p_link=>'f?p=&APP_ID.:400:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>400
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124703649940091097)
,p_short_name=>'Governance Dashboard'
,p_link=>'f?p=&APP_ID.:500:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>500
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124744357712468374)
,p_short_name=>'AI Parameters'
,p_link=>'f?p=&APP_ID.:1000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1000
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124766290807481582)
,p_short_name=>'Alert Threshold'
,p_link=>'f?p=&APP_ID.:1010:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1010
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124788127303490324)
,p_short_name=>'Models'
,p_link=>'f?p=&APP_ID.:1020:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1020
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124790761477508008)
,p_short_name=>'HCM_ASSIGNMENT'
,p_link=>'f?p=&APP_ID.:1030:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1030
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124803014214513050)
,p_short_name=>'HCM_EMPLOYEE'
,p_link=>'f?p=&APP_ID.:1031:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1031
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124817672326517414)
,p_short_name=>'HCM_LEAVE_BALANCE'
,p_link=>'f?p=&APP_ID.:1033:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1033
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124827666732521758)
,p_short_name=>'HCM_SALARY'
,p_link=>'f?p=&APP_ID.:1034:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1034
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124854476486531073)
,p_short_name=>'User Roles'
,p_link=>'f?p=&APP_ID.:1040:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1040
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124897868029551287)
,p_short_name=>'RAG Embeddigns'
,p_link=>'f?p=&APP_ID.:1060:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1060
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(124938982211612988)
,p_short_name=>'Model Usage'
,p_link=>'f?p=&APP_ID.:1080:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>1080
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(125559365663396760)
,p_parent_id=>wwv_flow_imp.id(123954823335486076)
,p_short_name=>'Document Library'
,p_link=>'f?p=&APP_ID.:610:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>610
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(125611231705811292)
,p_parent_id=>wwv_flow_imp.id(125559365663396760)
,p_short_name=>'Document Details'
,p_link=>'f?p=&APP_ID.:630:&SESSION.::&DEBUG.:::'
,p_page_id=>630
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(125700651112439495)
,p_short_name=>'Document Repository'
,p_link=>'f?p=&APP_ID.:600:&SESSION.::&DEBUG.:RP::'
,p_page_id=>600
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(125724405743710326)
,p_short_name=>'Chunking Analytics'
,p_link=>'f?p=&APP_ID.:655:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>655
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(125816078836830253)
,p_short_name=>'Strategy Manager'
,p_link=>'f?p=&APP_ID.:665:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>665
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(131979642632579939)
,p_short_name=>'Smart Document Search'
,p_link=>'f?p=&APP_ID.:650:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>650
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(140874810958818214)
,p_parent_id=>wwv_flow_imp.id(141125043951667343)
,p_short_name=>'Registry Assigned Roles'
,p_link=>'f?p=&APP_ID.:420:&SESSION.::&DEBUG.:::'
,p_page_id=>410
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(140876054448818222)
,p_parent_id=>wwv_flow_imp.id(140874810958818214)
,p_short_name=>'Registry &amp; Roles'
,p_link=>'f?p=&APP_ID.:411:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>411
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141018170447402967)
,p_short_name=>'Domains'
,p_link=>'f?p=&APP_ID.:422:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>422
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141066555461429679)
,p_short_name=>'Data Source Registration'
,p_link=>'f?p=&APP_ID.:420:&SESSION.::&DEBUG.:::'
,p_page_id=>424
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141084849269441682)
,p_parent_id=>wwv_flow_imp.id(141125043951667343)
,p_short_name=>'Intention & Data Source Assignment'
,p_link=>'f?p=&APP_ID.:420:&SESSION.::&DEBUG.:::'
,p_page_id=>426
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141116157014451104)
,p_short_name=>'Data Sources Assignments to Roles'
,p_link=>'f?p=&APP_ID.:420:&SESSION.::&DEBUG.:::'
,p_page_id=>428
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141125043951667343)
,p_short_name=>'Context'
,p_page_id=>420
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(141743687488812886)
,p_short_name=>'Roles'
,p_link=>'f?p=&APP_ID.:350:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>350
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(144722174128178664)
,p_short_name=>'Enterprise AI Assistant'
,p_link=>'f?p=&APP_ID.:110:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>110
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(145255490974705748)
,p_short_name=>'test_token'
,p_link=>'f?p=&APP_ID.:9:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>9
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(155700983535219563)
,p_short_name=>'Feedback Dashboard'
,p_link=>'f?p=&APP_ID.:115:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>115
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(155718270355975542)
,p_short_name=>'Domain Retriever'
,p_link=>'f?p=&APP_ID.:440:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>440
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(157647004209345872)
,p_short_name=>'Administration'
,p_link=>'f?p=&APP_ID.:10000:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>10000
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(158153245796485181)
,p_short_name=>'Deployment Dashboard'
,p_link=>'f?p=&APP_ID.:702:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>702
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(158170489639665417)
,p_short_name=>'Deployment Versions'
,p_link=>'f?p=&APP_ID.:703:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>703
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(158709211294133374)
,p_short_name=>'deployments Edit'
,p_link=>'f?p=&APP_ID.:704:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>704
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(158788330860773410)
,p_short_name=>'User Segments Management'
,p_link=>'f?p=&APP_ID.:705:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>705
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(159358665513979813)
,p_short_name=>'Deployment Comparison'
,p_link=>'f?p=&APP_ID.:708:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>708
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(160977003555775443)
,p_parent_id=>wwv_flow_imp.id(123954823335486076)
,p_short_name=>'My Issues'
,p_link=>'f?p=&APP_ID.:117:&SESSION.::&DEBUG.:::'
,p_page_id=>117
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(161028402840079772)
,p_short_name=>unistr('Debug Configuration \D83D\DEE0\FE0F')
,p_link=>'f?p=&APP_ID.:716:&SESSION.::&DEBUG.:::'
,p_page_id=>716
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(161671350054190539)
,p_parent_id=>wwv_flow_imp.id(155700983535219563)
,p_short_name=>'User Issues'
,p_link=>'f?p=&APP_ID.:120:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>120
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(161707928190451873)
,p_parent_id=>wwv_flow_imp.id(161671350054190539)
,p_short_name=>'User Issues(edit)'
,p_link=>'f?p=&APP_ID.:121:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>121
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(162216687386776701)
,p_short_name=>'test'
,p_link=>'f?p=&APP_ID.:14:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>14
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(164001379580856595)
,p_parent_id=>wwv_flow_imp.id(124703649940091097)
,p_short_name=>'Audit Log Viewer'
,p_link=>'f?p=&APP_ID.:720:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>720
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(164483974034510867)
,p_short_name=>'Audit Intelligence Dashboard'
,p_link=>'f?p=&APP_ID.:721:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>721
);
wwv_flow_imp_shared.create_menu_option(
 p_id=>wwv_flow_imp.id(164973985216005858)
,p_short_name=>'Chat Calls Viewer'
,p_link=>'f?p=&APP_ID.:722:&APP_SESSION.::&DEBUG.:::'
,p_page_id=>722
);
wwv_flow_imp.component_end;
end;
/
