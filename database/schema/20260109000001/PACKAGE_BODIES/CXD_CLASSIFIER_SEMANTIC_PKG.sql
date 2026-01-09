--------------------------------------------------------
--  DDL for Package Body CXD_CLASSIFIER_SEMANTIC_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CXD_CLASSIFIER_SEMANTIC_PKG" AS
 
  
/*******************************************************************************
 *  Always remember that in Vector Databases, Distance implies "how far apart are they?".
    Small Number = Close/Similar
    Large Number = Far/Different
 *******************************************************************************/
    FUNCTION calculate_similarity(
        p_query_embedding  IN VECTOR,
        p_domain_embedding IN VECTOR,
        p_trace_id IN Varchar2 default NULL
    ) RETURN NUMBER
    IS
        vcaller constant varchar2(70):= c_package_name ||'.calculate_similarity';
        v_distance      NUMBER;
        v_similarity    NUMBER;
    BEGIN
        -- 1. Calculate Distance
        -- Oracle returns: 0 (Identical) to 2 (Opposite)
        v_distance := VECTOR_DISTANCE(
            p_query_embedding, 
            p_domain_embedding, 
            COSINE
        );

        -- 2. Convert Distance (0..2) to Similarity (0..1)
        -- Formula: Similarity = 1 - (Distance / 2)
        v_similarity := 1 - (v_distance / 2);

        RETURN v_similarity;

    EXCEPTION WHEN OTHERS THEN
        -- It is often better to log the error but NULL might be safer 
        -- than 0 depending on your app logic, but 0 is fine for "no match".
        debug_util.error(sqlerrm, vcaller,p_trace_id);
        RETURN 0; 
    END calculate_similarity;

/*******************************************************************************
 *      -- PUBLIC: Get All Domain Similarities
 *******************************************************************************/
 
FUNCTION get_all_similarities(
    p_user_query IN CLOB,
    p_trace_id  IN VARCHAR2 default NULL
) RETURN SYS_REFCURSOR
IS
    vcaller constant varchar2(70):= c_package_name ||'.get_all_similarities';
    v_query_embedding  VECTOR(C_VECTOR_DIMENSION, FLOAT32);
    v_cursor           SYS_REFCURSOR;
BEGIN
    -- 1. Generate embedding for user query
    v_query_embedding := chunk_embedding_pkg.generate_embedding( p_text => p_user_query , p_trace_id=>p_trace_id);

    -- 2. Return cursor with top similarities
    OPEN v_cursor FOR
        SELECT 
            cd.context_domain_id,
            cd.context_domain_code,
            cd.domain_name,
            cd.description,
            -- CORRECTED FORMULA: 
            -- Oracle Distance 0 (match) -> becomes 1.0
            -- Oracle Distance 2 (opposite) -> becomes 0.0
            (1 - (VECTOR_DISTANCE(v_query_embedding, cd.DOMAIN_EMBEDDING_VECTOR, COSINE) / 2)) 
                AS similarity_score
        FROM context_domains cd
        WHERE cd.is_active = 'Y'
          AND cd.DOMAIN_EMBEDDING_VECTOR IS NOT NULL
        ORDER BY similarity_score DESC
        -- OPTIONAL BUT RECOMMENDED: Limit to top 10 or 20 results for speed
        FETCH FIRST 20 ROWS ONLY; 

    RETURN v_cursor;

EXCEPTION WHEN OTHERS THEN
   debug_util.error(sqlerrm, vcaller,p_trace_id);

   -- Return empty cursor on error so application doesn't crash
   OPEN v_cursor FOR SELECT NULL FROM dual WHERE 1=0;
   RETURN v_cursor;
END get_all_similarities;

/*******************************************************************************
 *  
 *******************************************************************************/
    -------------------------------------------------------------------------
    -- PUBLIC: Find Best Matching Domain
    -------------------------------------------------------------------------
  procedure detect0 (p_req             IN  CXD_TYPES.t_cxd_classifier_req,
                    P_response_Domain OUT CXD_TYPES.t_cxd_classifier_resp,
                    P_response_Intent OUT CXD_TYPES.t_intent_classifier_resp )
    IS
        vcaller constant varchar2(70):= c_package_name ||'.detect';
        v_query_embedding     VECTOR(C_VECTOR_DIMENSION, FLOAT32);
        v_context_domain_id   NUMBER;
        v_best_similarity     NUMBER;
        v_domain_code         VARCHAR2(200);
        v_domain_Name         VARCHAR2(200);
        v_start_time          TIMESTAMP;
        v_embedding_time_ms   NUMBER;
        v_search_time_ms      NUMBER;
        v_total_time_ms       NUMBER;
        v_error_message       VARCHAR2(4000);
        v_best_similarity_char VARCHAR2(15);
        v_proc VARCHAR2(30):='Best_Match';
        v_msg VARCHAR2(4000);
        v_minimum_threshold_ex exception;
        v_fetch_Many_ex exception;
        v_No_domain_with_Embeddings_ex exception;
        v_embed_ex exception;
        v_traceId varchar2(200);
    BEGIN
         v_traceId:=p_req.trace_id;
         DEBUG_UTIL.starting( vcaller,'',v_traceId);
         p_response_Domain.trace_id                     :=p_req.trace_id ;  
         p_response_Domain.chat_session_id              :=p_req.chat_session_id ; 
         p_response_Domain.chat_call_id                 :=p_req.chat_call_id ;       
         p_response_Domain.detection_Method_code        :=p_req.detection_Method_code ;   
         p_response_Domain.final_detection_Method_code  :='VECTOR' ;
         p_response_Domain.used_provider                :=NULL ; --llm only                   
         p_response_Domain.used_model                   :=NULL ; --llm only               
 
 /*
        p_response_Intent.trace_id                        :=p_req.trace_id ;    
        p_response_Intent.detection_Method_code           :=p_req.detection_Method_code ;                 
        p_response_Intent.final_detection_Method_code     :=p_req. ;       
        p_response_Intent.intent_id                       :=p_req. ;     
        p_response_Intent.intent_code                     :=NULL   ;        
        p_response_Intent.intent_Name                     :=NULL   ;       
        p_response_Intent.intent_confidence               :=p_req. ;          
        p_response_Intent.intent_message                  :=p_req. ;             
        p_response_Intent.used_provider                   :=p_req. ;            
        p_response_Intent.used_model                      :=p_req. ;            
  */
        v_start_time := SYSTIMESTAMP;

        v_msg :=  'v_embedding_time_ms> '||v_embedding_time_ms;
         debug_util.info( v_msg, vcaller,v_traceId);

         -- Step 1: Generate embedding for user query
         
        BEGIN
            v_query_embedding := chunk_embedding_pkg.generate_embedding(  p_text => p_req.user_prompt  ,p_trace_id=>v_traceid);

            v_embedding_time_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

        EXCEPTION WHEN OTHERS THEN
             v_msg := 'Embedding generation failed: ' || SQLERRM;
              p_response_Domain.message := v_msg;
     
             debug_util.error( v_msg, vcaller,v_traceId);
            raise v_embed_ex;  -- Cannot proceed without embedding
        END;
          
      
         -- Step 2: Find domain with highest similarity
         

        BEGIN
            SELECT 
                cd.context_domain_id,
                cd.context_domain_code,
                cd.domain_name,
                to_char( (1 - ((VECTOR_DISTANCE( chunk_embedding_pkg.generate_embedding(  p_text => 'xxx xxx' ), cd.DOMAIN_EMBEDDING_VECTOR, COSINE) + 1) / 2) )  ,'FM9999999990.00')
                    AS similarity_score_n,
                -- Calculate similarity score
                (1 - ((VECTOR_DISTANCE(v_query_embedding, cd.DOMAIN_EMBEDDING_VECTOR, COSINE) + 1) / 2)) 
                    AS similarity_score
            INTO 
                v_context_domain_id,
                v_domain_code,
                 v_domain_Name,
                v_best_similarity_char,
                v_best_similarity
            FROM context_domains cd
            WHERE cd.is_active = 'Y'
             -- AND cd.embedding_status = 'COMPLETED'
              AND cd.DOMAIN_EMBEDDING_VECTOR IS NOT NULL
            ORDER BY similarity_score DESC
            FETCH FIRST 1 ROW ONLY;
         EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                -- No domains with embeddings found
                 v_msg := 'No active domains with embeddings found';
                 p_response_Domain.message := v_msg;
                   debug_util.error( v_msg, vcaller,v_traceId);
                raise v_No_domain_with_Embeddings_ex;

             WHEN TOO_MANY_ROWS THEN
                -- Should never happen with FETCH FIRST 1 ROW
                 v_msg :=' Multiple domains with identical similarity';
                  p_response_Domain.message := v_msg;
                    debug_util.error( v_msg, vcaller,v_traceId);
                 raise v_fetch_Many_ex;
           END;


             p_response_Domain.context_domain_confidence :=v_best_similarity ;
 
             v_search_time_ms := (EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000)  - v_embedding_time_ms;
             p_response_Domain.search_time_ms:=v_search_time_ms;


                 v_msg := 'v_context_domain_id> '||v_context_domain_id ;
                 debug_util.info( v_msg, vcaller,v_traceId);
             -- Step 3: Apply similarity threshold
            -----------------------------------------------------------------------
 
             debug_util.info('best_match>best Similarity Score> '||v_best_similarity||'>C_MIN_SIMILARITY_THRESHOLD>'|| C_MIN_SIMILARITY_THRESHOLD,vcaller,v_traceId );  
            
            IF v_best_similarity < C_MIN_SIMILARITY_THRESHOLD THEN
                v_msg := 'Error: :'||' No domain meets minimum threshold';
                 p_response_Domain.message := v_msg;
                debug_util.error( v_msg, vcaller,v_traceId);
                raise v_minimum_threshold_ex;
            ELSE
               p_response_Domain.context_domain_Id            := v_context_domain_id ;               
               p_response_Domain.context_domain_code          :=v_domain_code ;               
               p_response_Domain.context_domain_Name          :=v_domain_Name ;
               p_response_Domain.Detect_status                := 'SUCCESS';  
            END IF;
            
       

        -----------------------------------------------------------------------
        -- Step 4: Calculate total processing time
         v_total_time_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;

     p_response_Domain.message := ''; 
    p_response_Domain.Detect_status := 'SUCCESS';

     debug_util.ending( vcaller,'',v_traceId);   
    EXCEPTION 
        WHEN v_minimum_threshold_ex THEN
           p_response_Domain.Detect_status  := 'FAIL';
           v_msg := 'minimum_threshold';
           debug_util.error( v_msg, vcaller,v_traceId);           

        WHEN v_fetch_Many_ex THEN
         p_response_Domain.Detect_status  := 'FAIL';
           v_msg := 'fetch_Many';
           debug_util.error( v_msg,vcaller,v_traceId);           

        WHEN v_No_domain_with_Embeddings_ex THEN
         p_response_Domain.Detect_status  := 'FAIL';
              v_msg := 'No_domain_with_Embeddings';
           debug_util.error( v_msg ,vcaller,v_traceId);  
        WHEN v_embed_ex THEN
          p_response_Domain.Detect_status  := 'FAIL';
           v_msg := 'embedding Issue';
           debug_util.error(v_msg,vcaller,v_traceId);           

        WHEN OTHERS THEN
           p_response_Domain.Detect_status  := 'FAIL';
            -- Catch-all error handler
             v_msg := 'Vector classification failed: ' || SQLERRM;
               debug_util.error( v_msg,vcaller,v_traceId );
            
    END detect0;
/*******************************************************************************
 *  
 *******************************************************************************/

PROCEDURE detect (
    p_req              IN  CXD_TYPES.t_cxd_classifier_req,
    P_response_Domain  OUT CXD_TYPES.t_cxd_classifier_resp,
    P_response_Intent  OUT CXD_TYPES.t_intent_classifier_resp 
) IS
    vcaller             CONSTANT VARCHAR2(70) := c_package_name ||'.detect';
    v_query_embedding   VECTOR(C_VECTOR_DIMENSION, FLOAT32);
    
    -- Variables for results
    v_context_domain_id NUMBER;
    v_domain_code       VARCHAR2(200);
    v_domain_Name       VARCHAR2(200);
    v_best_similarity   NUMBER;
    
    -- Timing variables
    v_start_ts          TIMESTAMP := SYSTIMESTAMP;
    v_step_ts           TIMESTAMP;
    v_embedding_time_ms NUMBER := 0;
    v_search_time_ms    NUMBER := 0;
    v_total_time_ms     NUMBER := 0;
    
    v_msg               VARCHAR2(4000);
    
    -- Exceptions
    v_minimum_threshold_ex         EXCEPTION;
    v_No_domain_with_Embeddings_ex EXCEPTION;
    v_embed_ex                     EXCEPTION;
    v_traceId varchar2(200);
    BEGIN
        
     v_traceId:=p_req.trace_id;
     DEBUG_UTIL.starting( vcaller,'',v_traceId);
        -- Initialize Response Object
    p_response_Domain.trace_id               :=p_req.trace_id ;  
    p_response_Domain.chat_session_id        :=p_req.chat_session_id ; 
    p_response_Domain.chat_call_id           :=p_req.chat_call_id ;      
    p_response_Domain.detection_Method_code   := p_req.detection_Method_code;
    p_response_Domain.final_detection_Method_code := 'VECTOR';
    p_response_Domain.Detect_status           := 'FAIL'; 

    -- ---------------------------------------------------------
    -- Step 1: Generate Embedding (Optimized: Done once outside SELECT)
    -- ---------------------------------------------------------
    BEGIN
        v_step_ts := SYSTIMESTAMP;
        
        v_msg := 'Generate vector';
        debug_util.info( v_msg ,vcaller,v_traceId);  
        v_query_embedding := chunk_embedding_pkg.generate_embedding(p_text => p_req.user_prompt, p_trace_id=>p_req.trace_id);
        
        v_embedding_time_ms := (EXTRACT(SECOND FROM (SYSTIMESTAMP - v_step_ts)) * 1000) 
                             + (EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_step_ts)) * 60000);
                             
    EXCEPTION WHEN 
        OTHERS THEN
        v_msg := 'Embedding failed: ' || SQLERRM;
        debug_util.error(v_msg, vcaller,v_traceId);
        
        -- Audit: AI KPI Failure (External Service Issue)
        audit_util.log_failure(
            p_event_code => 'AI_ERR', 
            p_reason     => 'Embedding Service Error: ' || SUBSTR(SQLERRM, 1, 200),
            p_context    => 'Prompt: ' || p_req.user_prompt,
            p_caller     => vcaller,
            p_trace_id  => v_traceId
        );
        RAISE v_embed_ex;
    END;

    -- ---------------------------------------------------------
    -- Step 2: Vector Search (Optimized: Uses pre-calculated v_query_embedding)
    -- ---------------------------------------------------------
    v_step_ts := SYSTIMESTAMP;
    BEGIN
        SELECT 
            cd.context_domain_id,
            cd.context_domain_code,
            cd.domain_name,
            -- Similarity: 1 - (Distance / 2) -> Exact match = 1.0
            (1 - (VECTOR_DISTANCE(v_query_embedding, cd.DOMAIN_EMBEDDING_VECTOR, COSINE) / 2)) 
                AS similarity_score
        INTO 
            v_context_domain_id,
            v_domain_code,
            v_domain_Name,
            v_best_similarity
        FROM context_domains cd
        WHERE cd.is_active = 'Y'
          AND cd.DOMAIN_EMBEDDING_VECTOR IS NOT NULL
        ORDER BY similarity_score DESC
        FETCH FIRST 1 ROW ONLY;

    EXCEPTION 
        WHEN NO_DATA_FOUND THEN
            v_msg := 'No active domains with embeddings found';
            debug_util.error(v_msg, vcaller,v_traceId);
            
            -- Audit: System Health Failure (Data Issue)
            audit_util.log_failure('SYS_DEP', v_msg, p_caller => vcaller, p_trace_id=> v_traceId);
            RAISE v_No_domain_with_Embeddings_ex;
    END;

    -- Update Timing
    v_search_time_ms := (EXTRACT(SECOND FROM (SYSTIMESTAMP - v_step_ts)) * 1000) 
                      + (EXTRACT(MINUTE FROM (SYSTIMESTAMP - v_step_ts)) * 60000);
    p_response_Domain.search_time_ms := v_search_time_ms;
    p_response_Domain.context_domain_confidence := v_best_similarity;

    -- ---------------------------------------------------------
    -- Step 3: Threshold Check & Final Audit
    -- ---------------------------------------------------------
     debug_util.info( 'Best_similarity > '||v_best_similarity ||',MIN_SIMILARITY_THRESHOLD > '||C_MIN_SIMILARITY_THRESHOLD, vcaller ,v_traceId);
    IF v_best_similarity < C_MIN_SIMILARITY_THRESHOLD THEN
        v_msg := 'Low confidence match (' || ROUND(v_best_similarity, 2) || ')' ||', minimum ( '||C_MIN_SIMILARITY_THRESHOLD ||')';
        debug_util.warn( v_msg, vcaller ,v_traceId);
        -- Audit: AI KPI Failure (Prompt out of domain)
        audit_util.log_failure(
            p_event_code => 'AI_ERR', 
            p_reason     => v_msg,
            p_context    => 'Prompt: ' || p_req.user_prompt,
            p_caller     => vcaller,
            p_trace_id  => v_traceId
        );
        RAISE v_minimum_threshold_ex;
    ELSE
        -- SUCCESS
        p_response_Domain.context_domain_Id   := v_context_domain_id;
        p_response_Domain.context_domain_code := v_domain_code;
        p_response_Domain.context_domain_Name := v_domain_Name;
        p_response_Domain.Detect_status       := 'SUCCESS';
        
        -- Audit: Business Success Milestone
        audit_util.log_event('PROC_OK', 'Semantic Match: ' || v_domain_Name, p_trace_id =>v_traceId);
    END IF;

    -- ---------------------------------------------------------
    -- Step 4: Finalize
    -- ---------------------------------------------------------
    v_total_time_ms := date_util.diff_seconds ( v_start_ts, SYSTIMESTAMP  );
                     
    debug_util.ending(vcaller , ' | Total: ' || v_total_time_ms || 's' ,v_traceId);

EXCEPTION 
    WHEN v_minimum_threshold_ex OR v_No_domain_with_Embeddings_ex OR v_embed_ex THEN
        p_response_Domain.Detect_status := 'FAIL';

    WHEN OTHERS THEN
        p_response_Domain.Detect_status := 'FAIL';
        v_msg := 'Unexpected Error: ' || SQLERRM;
        debug_util.error(v_msg, vcaller,v_traceId);
        
        -- Audit: System Health Failure (Infrastructure Crash)
        audit_util.log_failure('SYS_DEP', v_msg, p_context => 'Prompt: '||p_req.user_prompt, p_caller => vcaller, p_trace_id =>v_traceId);
END detect;


END cxd_classifier_semantic_pkg;

/
