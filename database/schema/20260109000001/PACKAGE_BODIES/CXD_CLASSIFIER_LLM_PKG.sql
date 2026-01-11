--------------------------------------------------------
--  DDL for Package Body CXD_CLASSIFIER_LLM_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CXD_CLASSIFIER_LLM_PKG" AS

    -- Package constants
    C_CLASSIFICATION_PURPOSE CONSTANT VARCHAR2(50) := 'DOMAIN_CLASSIFICATION';
    C_MAX_TOKENS             CONSTANT NUMBER := 150;  -- Short response expected
    C_TEMPERATURE            CONSTANT NUMBER := 0.0;  -- Deterministic classification

  
     /*******************************************************************************
     * PRIVATE:  Get All Active Domains for Prompt
     *******************************************************************************/
   
    FUNCTION get_active_domains_json RETURN CLOB
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_active_domains_json';
        v_domains_json CLOB;
    BEGIN
        -- Build JSON array of active domains
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'code' VALUE context_domain_code,
                'name' VALUE domain_name,
                'description' VALUE description,
                'keywords' VALUE context_domain_keywords
            ) RETURNING CLOB
        )
        INTO v_domains_json
        FROM context_domains
        WHERE is_active = 'Y';

        RETURN v_domains_json;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            RETURN '[]';  -- Empty array if no active domains
        WHEN OTHERS THEN
         debug_util.error(sqlerrm,vcaller);
            RETURN '[]';
    END get_active_domains_json;

     /*******************************************************************************
     * PRIVATE:  Build Classification Prompt
     *******************************************************************************/

    FUNCTION build_classification_prompt(
        p_user_query IN CLOB
    ) RETURN CLOB
    IS
        vcaller constant varchar2(70):= c_package_name ||'.build_classification_prompt';
        v_prompt         CLOB;
        v_domains_json   CLOB;
    BEGIN
        -- Get active domains as JSON
        v_domains_json := get_active_domains_json();

        -- Build structured prompt
        v_prompt := 
'You are a context domain classifier for an enterprise RAG system.

TASK: Analyze the user query and determine which context domain it belongs to.

USER QUERY:
"""
' || p_user_query || '
"""

AVAILABLE DOMAINS:
' || v_domains_json || '

INSTRUCTIONS:
1. Read the user query carefully
2. Match it against the domain descriptions and keywords
3. Select the SINGLE most appropriate domain code
4. If no domain matches well, select the default domain
5. Respond ONLY with valid JSON in this exact format:

{
  "domain_code": "SELECTED_DOMAIN_CODE",
  "confidence": 0.95,
  "reasoning": "Brief explanation of why this domain was selected"
}

RULES:
- Output ONLY the JSON object, nothing else
- Use exact domain_code values from the list above
- Confidence must be between 0.0 and 1.0
- Keep reasoning under 100 characters
- Do NOT include markdown code blocks or formatting';

        RETURN v_prompt;

    EXCEPTION WHEN OTHERS THEN
        debug_util.error(sqlerrm,vcaller);
        RETURN NULL;
    END build_classification_prompt;

     /*******************************************************************************
     * PRIVATE: Parse LLM Response
     *******************************************************************************/

  
    FUNCTION parse_llm_response(
        p_llm_response IN CLOB
    ) RETURN VARCHAR2
    IS
        vcaller constant varchar2(70):= c_package_name ||'.parse_llm_response';
        v_json_obj       JSON_OBJECT_T;
        v_domain_code    VARCHAR2(200);
        v_cleaned_response CLOB;
    BEGIN
        -- Clean response (remove markdown code blocks if present)
        v_cleaned_response := REGEXP_REPLACE(p_llm_response, '```json|```', '', 1, 0, 'i');
        v_cleaned_response := TRIM(v_cleaned_response);

        -- Parse JSON response
        v_json_obj := JSON_OBJECT_T.PARSE(v_cleaned_response);

        -- Extract domain_code
        IF v_json_obj.has('domain_code') THEN
            v_domain_code := v_json_obj.get_String('domain_code');
            RETURN v_domain_code;
        ELSE
            RETURN NULL;
        END IF;

    EXCEPTION 
        WHEN OTHERS THEN
            debug_util.error(sqlerrm,vcaller);
            -- JSON parsing failed - try regex fallback
            BEGIN
                v_domain_code := REGEXP_SUBSTR(
                    p_llm_response, 
                    '"domain_code"\s*:\s*"([^"]+)"', 
                    1, 1, 'i', 1
                );
                RETURN v_domain_code;
            EXCEPTION WHEN OTHERS THEN
                RETURN NULL;
            END;
    END parse_llm_response;
    /*******************************************************************************
     * PRIVATE:  get_domain_id
     *******************************************************************************/
  
 function get_domain_id(p_domain_code in varchar2) return number
is      
   vcaller constant varchar2(70):= c_package_name ||'.get_domain_id';
   v_context_domain_id number;
BEGIN
    SELECT context_domain_id
    INTO v_context_domain_id
    FROM context_domains
    WHERE context_domain_code = p_domain_code
      AND is_active = 'Y';
    
    RETURN v_context_domain_id;  

EXCEPTION
    WHEN OTHERS THEN
       debug_util.error(sqlerrm,vcaller);
        RETURN NULL;
END get_domain_id;

 /*******************************************************************************
 * PUBLIC: Get Domain via LLM Classification
 *******************************************************************************/
 
Procedure detect(
    p_req             IN  CXD_TYPES.t_cxd_classifier_req,
    P_response_Domain OUT CXD_TYPES.t_cxd_classifier_resp,
    P_response_Intent OUT CXD_TYPES.t_intent_classifier_resp 
)
IS  vcaller constant varchar2(70):= c_package_name ||'.detect';
    l_req  llm_types.t_llm_request  ;
    l_resp llm_types.t_llm_response;
    v_user_prompt         CLOB;  
    l_base_extra    JSON_OBJECT_T := JSON_OBJECT_T();
    l_payload_extra JSON_OBJECT_T := JSON_OBJECT_T(); 
    v_domain_code         VARCHAR2(200);
    v_context_domain_id   NUMBER;
    v_start_time          TIMESTAMP;
    v_processing_time_ms  NUMBER;
    v_msg       VARCHAR2(4000);
    v_system_instructions CLOB;
    e_cannot_get_code_ex  EXCEPTION;
    e_user_prompt_empty_ex  EXCEPTION;
    e_classfier_ex  EXCEPTION;
    e_Model_ex  EXCEPTION;
    e_Provider_ex  EXCEPTION;
    e_program_unit_missing EXCEPTION;--for Oracle error could not find program unit being called
    PRAGMA EXCEPTION_INIT(e_program_unit_missing, -06508);
    v_trace_id varchar2(200);
BEGIN
   v_trace_id := p_req.trace_id;
   v_msg := 'C_CLASSIFICATION_PURPOSE ( '|| C_CLASSIFICATION_PURPOSE|| ' ), C_MAX_TOKENS ( ' || C_MAX_TOKENS || ' ) ,C_TEMPERATURE ( '||C_TEMPERATURE||' )';
   debug_util.starting ( p_caller=> vcaller,p_message => v_msg , p_trace_id=>v_trace_id);

    -- CRITICAL: Initialize ALL OUT parameters at start
    P_response_Domain.trace_id := p_req.trace_id;
    P_response_Domain.detection_Method_code := p_req.detection_Method_code;
    P_response_Domain.final_detection_Method_code := p_req.detection_Method_code;
    P_response_Domain.used_provider := p_req.provider;
    P_response_Domain.used_model := p_req.model;
    P_response_Domain.Detect_status := 'PENDING';
    

    -- nitialize Intent response (even though not used yet)
    P_response_Intent.trace_id := p_req.trace_id;
    P_response_Intent.detection_Method_code := p_req.detection_Method_code;
    P_response_Intent.Detect_status := 'NOT_IMPLEMENTED';
    P_response_Intent.message := 'Intent detection not yet implemented';

    v_start_time := SYSTIMESTAMP;

    -- Step 1: Build classification prompt
    v_user_prompt := build_classification_prompt(p_req.user_prompt);

    IF v_user_prompt IS NULL THEN
        v_msg := 'No "USERPROMPT" provided';
        RAISE e_user_prompt_empty_ex;
    END IF;
    
    
     IF p_req.Provider IS NULL THEN
         v_msg := 'No "PROVIDER" provided';
        RAISE e_provider_ex;
      END IF;

      IF p_req.model IS NULL  THEN
         v_msg := 'No "MODEL" provided';
           RAISE e_Model_ex;
      END IF;
       
       

    -- Step 2: Call LLM via router package
    BEGIN

        -- Add initialize even not fully implmentend
        P_response_Intent.trace_id := p_req.trace_id;
        P_response_Intent.detection_Method_code := p_req.detection_Method_code;
        P_response_Intent.Detect_status := 'NOT_IMPLEMENTED';
        P_response_Intent.message := 'Intent detection reserved for future';

        v_system_instructions := '';
 
        l_req.provider              := p_req.Provider;
        l_req.model                 := p_req.MODEL;
        l_req.context_domain_id     := NULL;
        l_req.user_prompt           := v_user_prompt;
        l_req.system_instructions   := v_system_instructions;
        l_req.conversation_history  := NULL;
        l_req.response_schema       := NULL;
        l_req.is_doc_inject_required  := 'N';
        l_req.is_data_inject_required := 'N';
        l_req.temperature           := C_TEMPERATURE;
        l_req.max_tokens            := C_MAX_TOKENS;
        l_req.top_p                 := 1;
        l_req.top_k                 := NULL;
        l_req.seed                  := NULL;
        l_req.stop                  := NULL;
        l_req.response_format       := NULL;
        l_req.frequency_penalty     := NULL;
        l_req.presence_penalty      := NULL;
        l_req.stream_enabled        := FALSE;
        l_req.user_id         := p_req.user_id;  
        l_req.user_name       := p_req.user_name;
        l_req.chat_session_id := p_req.chat_session_id;
        l_req.app_session_id  := p_req.app_session_id;
        l_req.app_page_id     := p_req.app_page_id;
        l_req.project_id      := p_req.chat_project_id;
        l_req.app_id          := p_req.app_id;
        l_req.tenant_id       := p_req.tenant_id;
        l_req.trace_id        := p_req.trace_id;
        l_req.payload := NULL;
         
        v_msg:= 'Call Router >> provider ( '|| p_req.Provider || ' ) , Model ( ' ||p_req.MODEL||' )'   ;
         debug_util.info (p_message => v_msg , p_caller=> vcaller, p_trace_id=>v_trace_id);
   
      


       -- Step 2: Call LLM via router package
        l_resp := LLM_ROUTER_PKG.invoke_llm(p_req => l_req);  
                                    
    EXCEPTION 
        -- Catch the ORA-06508 specifically
        WHEN e_program_unit_missing THEN
            v_msg := 'Routing Error: The handler package for (' || p_req.provider || 
                     ') is missing or invalid (ORA-06508).';
            --- debug_util.error(v_msg, vcaller,v_trace_id);--will fired when handling e_classfier_ex
            RAISE e_classfier_ex;

        WHEN OTHERS THEN
            v_msg := 'Unexpected LLM Router Error >> ' || SQLERRM;
          --  debug_util.error(v_msg, vcaller,v_trace_id);--will fired when handling e_classfier_ex
            RAISE e_classfier_ex;
    END;

    -- Step 3: Parse LLM response to extract domain_code
    v_domain_code := parse_llm_response(l_resp.response_text);
    l_payload_extra.put('context_domain', v_domain_code);

    IF v_domain_code IS NULL THEN
        v_msg := 'Cannot Get domain after parsing response';
        RAISE e_cannot_get_code_ex;
    END IF;
    
    P_response_Domain.context_domain_code := v_domain_code;
    
    -- Step 4: Lookup context_domain_id from domain_code
    v_context_domain_id := get_domain_id(p_domain_code => v_domain_code);
    P_response_Domain.context_domain_id := v_context_domain_id;
    l_payload_extra.put('context_domain_id', v_context_domain_id);

    -- Calculate processing time
    v_processing_time_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

    P_response_Domain.search_time_ms := v_processing_time_ms;
    P_response_Domain.message := '';
    P_response_Domain.Detect_status := 'SUCCESS';        
     
      debug_util.ending( vcaller,'',v_trace_id);
  EXCEPTION 
    WHEN e_classfier_ex THEN
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
        P_response_Domain.context_domain_id := NULL;        
        P_response_Domain.context_domain_code := NULL;     
        P_response_Domain.search_time_ms := NULL; 
        debug_util.error( v_msg,vcaller,v_trace_id);           
        RETURN;  --  EXIT THE PROCEDURE
        
    WHEN e_user_prompt_empty_ex THEN
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
        P_response_Domain.context_domain_id := NULL;       
        P_response_Domain.context_domain_code := NULL;      
        P_response_Domain.search_time_ms := NULL; 

        debug_util.error( v_msg,vcaller,v_trace_id);       
         
        RETURN; --  EXIT THE PROCEDURE

             
    WHEN e_Provider_ex THEN
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
        P_response_Domain.context_domain_id := NULL;       
        P_response_Domain.context_domain_code := NULL;      
        P_response_Domain.search_time_ms := NULL; 
        debug_util.error( v_msg,vcaller,v_trace_id);       
        RETURN; --  EXIT THE PROCEDURE
   
    WHEN e_Model_ex THEN
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
        P_response_Domain.context_domain_id := NULL;       
        P_response_Domain.context_domain_code := NULL;      
        P_response_Domain.search_time_ms := NULL; 
        debug_util.error( v_msg,vcaller,v_trace_id);       
        RETURN; --  EXIT THE PROCEDURE


    WHEN e_cannot_get_code_ex THEN
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
        P_response_Domain.context_domain_id := NULL;     
        P_response_Domain.context_domain_code := NULL;    
        P_response_Domain.search_time_ms := NULL; 

        debug_util.error( v_msg,vcaller,v_trace_id);       
        RETURN;  ----  EXIT THE PROCEDURE
      

    WHEN OTHERS THEN
        v_msg :=  SQLERRM;
        P_response_Domain.message := v_msg;
        P_response_Domain.Detect_status := 'FAIL';
         debug_util.error(v_msg, vcaller,v_trace_id);

        -- Base extra values
        l_base_extra.put('pipeline_stage', 'CLASSIFY');
        l_base_extra.put('is_error', 'Y');

        -- Payload extra values
        l_payload_extra.put('error_message', SQLERRM);
        l_payload_extra.put('error_stack', DBMS_UTILITY.format_error_backtrace());
         
 
END detect;
 /*******************************************************************************
 *  
 *******************************************************************************/
END cxd_classifier_llm_pkg;

/
