--------------------------------------------------------
--  DDL for Function GET_IAM_TOKEN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE FUNCTION "AI8P"."GET_IAM_TOKEN" RETURN VARCHAR2 IS
/*******************************************************************************
 *  
 *******************************************************************************/
    l_response   CLOB;
    l_json       apex_json.t_values;
    l_token      VARCHAR2(4000);
BEGIN
    apex_web_service.g_request_headers.delete;

    apex_web_service.g_request_headers(1).name  := 'Content-Type';
    apex_web_service.g_request_headers(1).value := 'application/x-www-form-urlencoded';

    l_response :=
        apex_web_service.make_rest_request(
            p_url                  => 'https://idcs-3f641a8d3f8b438cad276c90021dc544.identity.oraclecloud.com/oauth2/v1/token',
            p_http_method          => 'POST',
            p_credential_static_id => 'OCI_IAM_CLIENT_CRED',
            p_body                 =>
                'grant_type=client_credentials&scope=urn:oracle:idcs:clientid:4e1a50c35c0c431c82a11924dc31dd4f:scope:ai_chatpot'
        );

    apex_json.parse(l_json, l_response);

    RETURN apex_json.get_varchar2('access_token', l_json);
END;

/
