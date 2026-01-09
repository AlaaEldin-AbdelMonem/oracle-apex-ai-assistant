--------------------------------------------------------
--  DDL for Package Body CX_BUILDER_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CX_BUILDER_PKG" AS

    
    -- GLOBAL CONSTANTS (GOVERNANCE & SAFETY)
    -----------------------------------------------------------------------------
   
   --[ENTERPRISE-GOVERNANCE]
 
c_governance CONSTANT CLOB := '
- Enforce strict role-based access control at all times.
- Never return HR, Payroll, or sensitive employee data unless the user is explicitly authorized.
- Only respond with data that the current session/user is allowed to access.
- Never reveal information about other employees, departments, or entities unless authorization is confirmed.
- If the request cannot be fulfilled due to insufficient access, respond with: "No authorized data available."
- All responses must comply with enterprise data-governance, privacy, and compliance requirements.
';

--[SAFETY-RULES]

c_safety CONSTANT CLOB := '
- Do NOT hallucinate under any circumstances.
- Do NOT invent data, policies, rules, or facts that are not explicitly present in retrieved, validated sources.
- If information is missing, incomplete, or ambiguous, ask a clarifying question.
- Keep responses factual, grounded, and supported by retrieved RAG context or user-provided data.
- If no grounded data exists, clearly state: "No grounded data available."
- Maintain auditability: every response must be explainable and reproducible from the provided context.
';
/*******************************************************************************
 *  
 *******************************************************************************/
    -- Helper: Append with newline for readability
    -------------------------------------------------------------------------
FUNCTION append(p_clob IN OUT CLOB,p_header in varchar2, p_text IN CLOB)
  RETURN CLOB
IS
  vcaller constant varchar2(70):= c_package_name ||'.append';
BEGIN
    -- This is the correct spelling!
    IF p_text IS NOT NULL AND DBMS_LOB.GETLENGTH(p_text) > 0 THEN
        p_clob := p_clob ||p_header|| CHR(10) || p_text || CHR(10)||CHR(10) ;
    END IF;

    RETURN p_clob;
END append;
 /*******************************************************************************
 *  
 *******************************************************************************/
    
    -- Getter functions (allows overriding in the future)
    -----------------------------------------------------------------------------
    FUNCTION get_governance_block(
        p_session_id                 IN NUMBER,
        p_context_Domain_id         IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_trace_Id                  IN VARCHAR2

    ) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.get_governance_block';
    BEGIN
        RETURN c_governance;
    END get_governance_block;
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_safety_block (
        p_session_id                 IN NUMBER,
        p_context_Domain_id         IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_trace_Id                  IN VARCHAR2) RETURN CLOB IS
    BEGIN
        RETURN c_safety;
    END get_safety_block;
/*******************************************************************************
 *  
 *******************************************************************************/
    -- MAIN BUILDER FUNCTION
     
      FUNCTION system_prompt_Injector (
        p_context_Domain_id        IN NUMBER,
         p_call_Id                  IN NUMBER,
        p_enforce_context_domain   IN VARCHAR2 default 'Y',--enforce intent determination
        p_user_prompt              IN clob ,
        p_top_k                    IN NUMBER  DEFAULT 5,
        p_behavior_code            IN VARCHAR2 DEFAULT 'STANDARD',
        p_output_format_code       IN VARCHAR2 DEFAULT 'DEFAULT',
        p_user_id                  IN NUMBER   DEFAULT v('G_USER_ID'),
        p_trace_Id                 IN VARCHAR2
    ) RETURN CLOB IS
        vcaller constant varchar2(70):= c_package_name ||'.system_prompt_Injector';
        v_domain_clob     CLOB;
        v_behavior_clob   CLOB;
        v_format_clob     CLOB;
        v_result          CLOB;
        v_doc_chunks_clob CLOB;
        v_data_clob       CLOB;
        v_data_records    CLOB;

    BEGIN
         
        -- 1. Load domain (instruction mode) instructions
        ------------------------------- 
        v_domain_clob :=
            cxd_pkg.get_domain_instructions(p_context_Domain_id);

         
        -- 2. Load behavior style (e.g. ANALYTICAL, TECHNICAL…)
        -------------------------------- 
        v_behavior_clob :=
            cx_behavior_pkg.get_behavior_instructions(p_behavior_code);

         
        -- 3. Load output format template (TABLE, JSON, SUMMARY…)
        ---------------------------- 
        v_format_clob :=
            cx_behavior_pkg.get_format_instructions(p_output_format_code);

    

        
        -- (4) DOC CONTEXT  (MOST IMPORTANT)
  
            v_doc_chunks_clob := cx_chunks_builder_pkg.get_context_docs(p_user_id => p_user_id,
                                                                             p_context_Domain_id=>p_context_Domain_id,
                                                                             p_query   => p_user_prompt,
                                                                             p_top_k   => p_top_k  );
 

      
        -- 5. DATA RECORDS 
        ---------------------- 

        --still need to be generated
        if p_context_Domain_id is not null then
        v_data_records :=cx_data_builder_pkg.get_context_data(p_context_Domain_id =>p_context_Domain_id ,
                                                               p_user_id  => v('G_USER_ID'),
                                                                p_filter_ctx  => null  ,
                                                                 p_call_Id   =>p_call_Id,
                                                               p_trace_Id    =>p_trace_Id
                                                                 );    --   IN CLOB  DEFAULT NULL  
       end if;                                                                 
       ------------------ 
       -- 6 GOVERNANCE & SAFETY
        ----------------- 
       --c_governance  and  c_safety above
  
       

          
        -- 7. MERGE ALL INTO ONE FINAL SYSTEM PROMPT
        ------------------------- 

        v_result :=append(v_result, '[DOMAIN INSTRUCTIONS]'               , v_domain_clob );
        v_result :=append(v_result, '[BEHAVIOR PROFILE]'                  , v_behavior_clob );
        v_result :=append(v_result, '[OUTPUT FORMAT]'                     , v_format_clob );
        v_result :=append(v_result, '[DOCUMENTS (Top '|| p_top_k || ')]'  , v_data_clob );
        v_result :=append(v_result, '[DATA]'                              , v_data_records);
        v_result :=append(v_result, '[ENTERPRISE GOVERNANCE]'             , c_governance );
        v_result :=append(v_result, '[SAFETY-RULES]'                      , c_safety );


 

        RETURN v_result;
    END system_prompt_Injector;
/*******************************************************************************
 *  
 *******************************************************************************/


 
END cx_builder_pkg;

/
