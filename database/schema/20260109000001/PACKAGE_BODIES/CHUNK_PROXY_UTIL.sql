--------------------------------------------------------
--  DDL for Package Body CHUNK_PROXY_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHUNK_PROXY_UTIL" AS
 
 /*******************************************************************************
 *  
 *******************************************************************************/
  PROCEDURE run_chunk(
    p_doc_id                IN NUMBER,
    p_recommend_strategy    IN CHAR DEFAULT 'N',
    p_force_rechunk         IN BOOLEAN DEFAULT FALSE,
    p_commit_after          IN BOOLEAN DEFAULT TRUE

) IS
    vcaller constant varchar2(70):= c_package_name ||'.run_chunk';
    -- Document metadata from ent_ai_docs
    v_doc_title             docs.doc_title%TYPE;
    v_text_content          docs.text_extracted%TYPE;
    v_text_length           NUMBER;
    v_language_code         docs.language_code%TYPE;
    v_classification_level  docs.classification_level%TYPE;
    
    -- Chunking parameters
    v_strategy              VARCHAR2(50);
    v_chunk_size            NUMBER;
    v_overlap_pct           NUMBER;
    v_max_chunk_size        NUMBER := 2048;
    v_min_chunk_size        NUMBER := 50;
    
    -- Chunking results
    v_chunks                chunk_types.t_chunk_tab;
    v_chunk_count           NUMBER := 0;
    v_existing_chunks       NUMBER := 0;
    
    -- Status tracking
    v_start_time            TIMESTAMP := SYSTIMESTAMP;
    v_elapsed_ms            NUMBER;
    
    -- Exception handling
    e_doc_not_found         EXCEPTION;
    e_no_content            EXCEPTION;
    e_invalid_strategy      EXCEPTION;
    v_msg   VARCHAR2(4000);
    
BEGIN
   
    BEGIN
        SELECT 
            doc_title,
            text_extracted,
            DBMS_LOB.GETLENGTH(text_extracted),
            NVL(language_code, 'AUTO'),
            classification_level,
            NVL(chunking_strategy, 'SENTENCE_BOUNDARY'),
            NVL(chunk_size_override, 512),
            NVL(overlap_pct_override, 20)
        INTO 
            v_doc_title,
            v_text_content,
            v_text_length,
            v_language_code,
            v_classification_level,
            v_strategy,
            v_chunk_size,
            v_overlap_pct
        FROM docs
        WHERE doc_id = p_doc_id
          AND is_active = 'Y';
          
         debug_util.info(' Document found: ' || v_doc_title ||'Text length: ' || v_text_length || ' characters',vcaller);
        
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             debug_util.error(' Document not found or inactive',vcaller);
            RAISE e_doc_not_found;
    END;
    
    -- Validate content exists
    IF v_text_content IS NULL OR v_text_length < 50 THEN
        debug_util.error('Document has no content or too short',vcaller);
        RAISE e_no_content;
    END IF;
    
 
   --PHASE 2: STRATEGY RECOMMENDATION (Optional)
 
    
    IF UPPER(p_recommend_strategy) = 'Y' THEN
 
        debug_util.info(' Phase 2: Recommending chunking strategy...',vcaller);
        
      
            -- Call strategy recommendation package
            v_strategy := chunk_strategy_pkg.recommend_strategy(p_doc_id);
            
           
    ELSE

        v_msg:= 'Phase 2: Using stored strategy...' 
        ||'   Strategy: ' || v_strategy 
        ||'   Chunk Size: ' || v_chunk_size 
        ||'   Overlap: ' || v_overlap_pct || '%';
       debug_util.info(v_msg,vcaller);  
    END IF;
    
    -- Validate strategy
    IF v_strategy IS NULL THEN
        v_strategy := 'SENTENCE_BOUNDARY';
          debug_util.warn(' No strategy set, using default: SENTENCE_BOUNDARY',vcaller);  
     
    END IF;
    
 
     -- PHASE 3: CHECK EXISTING CHUNKS
  
    
 
      debug_util.info('Phase 3: Checking existing chunks...',vcaller);
    
    SELECT COUNT(*)
    INTO v_existing_chunks
    FROM DOC_CHUNKS
    WHERE doc_id = p_doc_id;
    
    IF v_existing_chunks > 0 THEN
         debug_util.info('  Found ' || v_existing_chunks || ' existing chunks',vcaller);
        
        IF p_force_rechunk THEN
              debug_util.info('Deleting existing chunks (force_rechunk=TRUE)...',vcaller);
            
            DELETE FROM DOC_CHUNKS 
            WHERE doc_id = p_doc_id;
            
               debug_util.info('Deleted ' || SQL%ROWCOUNT || ' chunks',vcaller);
            v_existing_chunks := 0;
        ELSE
              debug_util.warn(' Document already chunked. Use p_force_rechunk=TRUE to re-chunk. ⏹️  Chunking skipped.',vcaller);
            RETURN;
        END IF;
    ELSE
        debug_util.info('No existing chunks found',vcaller);
    END IF;
    
   --* PHASE 4: EXECUTE CHUNKING
 
    v_msg:= '⚙️  Phase 4: Executing chunking...'||
    '   Strategy: ' || v_strategy||
     '   Chunk Size: ' || v_chunk_size || ' chars'||
     '   Overlap: ' || v_overlap_pct || '%'||
     '   Language: ' || v_language_code;
 
     debug_util.info(v_msg,vcaller);
    BEGIN
        -- Call chunking utility
        v_chunks := chunk_Proxy_Util.chunk_text(
            p_text              => v_text_content,
            p_strategy          => v_strategy,
            p_chunk_size        => v_chunk_size,
            p_overlap_pct       => v_overlap_pct,
            p_language          => v_language_code,
            p_max_chunk_size    => v_max_chunk_size,
            p_min_chunk_size    => v_min_chunk_size,
            p_normalize         => TRUE,
            p_preserve_format   => FALSE,
            p_metadata          => NULL
        );
        
        v_chunk_count := v_chunks.COUNT;
        
         debug_util.ending(vcaller,'Chunking complete: ' || v_chunk_count || ' chunks created');
        
    EXCEPTION
        WHEN OTHERS THEN
        v_msg :=SQLERRM;
        debug_util.error(v_msg,vcaller);   
        RAISE;
    END;
    
    
   -- PHASE 5: STORE CHUNKS IN DATABASE
 
     debug_util.info('💾 Phase 5: Storing chunks in database...',vcaller);
    
    IF v_chunk_count > 0 THEN
        BEGIN
            -- Insert chunks into DOC_CHUNKS table
            FOR i IN 1..v_chunks.COUNT LOOP
                INSERT INTO DOC_CHUNKS (
                    doc_chunk_id,
                    doc_id,
                    chunk_sequence,
                    chunk_text,
                    chunk_size,
                    chunk_token_count,
                    chunking_strategy,
                    created_at,
                    created_by
                ) VALUES (
                    DOC_CHUNKS_SEQ.NEXTVAL,
                    p_doc_id,
                    v_chunks(i).chunk_sequence,
                    v_chunks(i).chunk_text,
                    v_chunks(i).chunk_size,
                    v_chunks(i).chunk_tokens_count,
                    v_strategy,
                    SYSTIMESTAMP,
                    USER
                );
            END LOOP;
            
            debug_util.info(' Stored ' || SQL%ROWCOUNT || ' chunks',vcaller);
            
        EXCEPTION
            WHEN OTHERS THEN
               debug_util.error(' storing chunks: ' || SQLERRM ,vcaller);
                RAISE;
        END;
    ELSE
        debug_util.warn('WARNING: No chunks generated',vcaller);
    END IF;
    
  
   -- PHASE 6: UPDATE DOCUMENT STATUS
     debug_util.info(' Phase 6: Updating document status...',vcaller);
    
    BEGIN
        UPDATE docs
        SET 
            rag_ready_flag = 'Y',
            last_chunked_at = SYSTIMESTAMP,
            last_chunking_strategy = v_strategy,
            embedding_count = v_chunk_count,
            updated_at = SYSTIMESTAMP,
            updated_by = USER
        WHERE doc_id = p_doc_id;
        
       debug_util.info('Document marked as RAG-ready',vcaller);
        
    EXCEPTION
        WHEN OTHERS THEN
             debug_util.warn('WARNING: Failed to update document status',vcaller);
             debug_util.error( SQLERRM,vcaller);
    END;
    
   
     -- PHASE 7: COMMIT (Optional)

    
    IF p_commit_after THEN
        COMMIT;
 
         debug_util.info('Changes committed',vcaller);
    END IF;
    
 
    v_elapsed_ms := EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)) * 1000;
    
 
    debug_util.ending(vcaller);
 
EXCEPTION
    WHEN e_doc_not_found THEN
        v_msg:=  'Document ID ' || p_doc_id || ' not found or inactive';
          debug_util.error(v_msg, vcaller);
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20001, v_msg);
        
    WHEN e_no_content THEN
       v_msg:= 'Document has no content or is too short (<50 chars)' ;
        debug_util.error(v_msg ||',raise -20002', vcaller);
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, v_msg);
        
    WHEN e_invalid_strategy THEN
       v_msg:='Invalid chunking strategy: ' || v_strategy  ;
        debug_util.error(v_msg||',rasie -20003', vcaller);
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20003, v_msg);
        
    WHEN OTHERS THEN
         v_msg:= 'CRITICAL ERROR - All changes rolled back >' || SQLERRM ;
         debug_util.error(v_msg, vcaller);
         v_msg:='Backtrace: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
         debug_util.error(v_msg, vcaller);
        v_msg:= 'Stack: ' || DBMS_UTILITY.FORMAT_ERROR_STACK;
        debug_util.error(v_msg, vcaller);
        ROLLBACK;
        RAISE;
END run_chunk;
 /*******************************************************************************
 *  
 *******************************************************************************/
FUNCTION chunks_count(p_doc_id in number) RETURN NUMBER is 
    vcaller constant varchar2(70):= c_package_name ||'.chunks_count';
    v_existing_chunks number:=0;

begin
  SELECT COUNT(*)
    INTO v_existing_chunks
    FROM DOC_CHUNKS
    WHERE doc_id = p_doc_id;
   return v_existing_chunks;
end chunks_count;   
 /*******************************************************************************
 *  
 *******************************************************************************/
    /**
     * Read implementation preference from configuration
     */
    FUNCTION Oracle_Seeded_fnc_Used RETURN VARCHAR2 IS
        vcaller constant varchar2(70):= c_package_name ||'.Oracle_Seeded_fnc_Used';
        v_is_Oracle_Seeded_fnc_Used char(1);
    BEGIN
        SELECT param_value
        INTO v_is_Oracle_Seeded_fnc_Used
        FROM cfg_parameters
        WHERE param_key = 'IS_ORACLE_CHUNKING_USED'
          AND is_active = 'Y';

        RETURN NVL(v_is_Oracle_Seeded_fnc_Used, 'Y'); -- Default to Oracle native

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'Y';
    END Oracle_Seeded_fnc_Used;
 /*******************************************************************************
 *  
 *******************************************************************************/
    -- =================================================
    -- MAIN CHUNKING FUNCTION
    -- =================================================

    FUNCTION chunk_text(
        p_text                  IN CLOB,
        p_strategy              IN VARCHAR2 DEFAULT chunk_types.c_sentence_boundary,
        p_chunk_size            IN NUMBER DEFAULT 512,
        p_overlap_size          IN NUMBER DEFAULT 50,
        p_overlap_pct           IN NUMBER DEFAULT NULL,
        p_language              IN VARCHAR2 DEFAULT 'AUTO',
        p_max_chunk_size        IN NUMBER DEFAULT 2048,
        p_min_chunk_size        IN NUMBER DEFAULT 50,
        p_normalize             IN BOOLEAN DEFAULT TRUE,
        p_preserve_format       IN BOOLEAN DEFAULT FALSE,
        p_metadata              IN JSON DEFAULT NULL,
        p_force_implementation  IN VARCHAR2 DEFAULT NULL
    ) RETURN chunk_types.t_chunk_tab IS
          vcaller constant varchar2(70):= c_package_name ||'.chunk_text';
          v_Strategy VARCHAR2(40);
          v_chunks chunk_types.t_chunk_tab;
          v_Oracle_Chunk_Fnc_Is_Used char(1);--Y/N
          v_msg varchar2(4000);
          v_prc constant  varchar2(40):= 'chunk_text';
    BEGIN
        IF p_strategy is null then
         v_Strategy:=CFG_PARAM_UTIL.get_value(p_param_key=>'CHUNKING_STRATEGY' ,p_tenant_id=>  NVL(v('G_TANENT_ID'),1)  ,p_app_id=> v('APP_ID')) ;
       
         ELSE 
         v_Strategy:= p_strategy;
        END IF;

         --Use Oracle functions or Custom functions
         v_Oracle_Chunk_Fnc_Is_Used:=CFG_PARAM_UTIL.get_value(p_param_key=>'IS_ORACLE_CHUNKING_USED' ,p_tenant_id=> NVL(v('G_TANENT_ID'),1) ,p_app_id=> v('APP_ID')) ;
        

        -- Route to  implementation  ,Not "HIERARCHICAL" is not implemented using oracle functions
     
            IF v_Oracle_Chunk_Fnc_Is_Used = 'N' OR v_Strategy='HIERARCHICAL' THEN
                -- Use custom implementation
 
                v_chunks := chunk_pkg.chunk_text(
                    p_text => p_text,
                    p_strategy       => v_Strategy,
                    p_chunk_size     => p_chunk_size,
                    p_overlap_size   => p_overlap_size,
                    p_overlap_pct   => p_overlap_pct,
                    p_language => p_language,
                    p_max_chunk_size => p_max_chunk_size,
                    p_min_chunk_size => p_min_chunk_size,
                    p_normalize => p_normalize,
                    p_preserve_format => p_preserve_format,
                    p_metadata => p_metadata
                );

            ELSE
                --Oracle seeded functions will be used from "rag_chunk_util" package
                v_chunks := chunk_util.chunk_text(
                    p_text => p_text,
                    p_strategy => p_strategy,
                    p_chunk_size => p_chunk_size,
                    p_overlap_size => p_overlap_size,
                    p_overlap_pct => p_overlap_pct,
                    p_language => p_language,
                    p_max_chunk_size => p_max_chunk_size,
                    p_min_chunk_size => p_min_chunk_size,
                    p_normalize => p_normalize,
                    p_preserve_format => p_preserve_format,
                    p_metadata => p_metadata
                );

             END IF;
     
        --print using dbms_output
        chunk_types.print_chunks(v_chunks);  --chunk_types.print_chunk_text(v_chunks);
        
        RETURN v_chunks;

    EXCEPTION
        WHEN OTHERS THEN
            v_msg := 'ERROR>'||c_pkg||'.'||v_prc||'>>'||sqlerrm;
            dbms_output.put_line(v_msg);             
        RETURN v_chunks;
           
    END chunk_text;
 /*******************************************************************************
 *  
 *******************************************************************************/
  
  PROCEDURE Add_Doc_Chunks( p_doc_id   IN NUMBER,
                            p_chunks   IN chunk_types.t_chunk_tab ,
                            P_strategy IN varchar2
  ) IS
      vcaller constant varchar2(70):= c_package_name ||'.Add_Doc_Chunks';
      v_chunk_seq NUMBER := 1;
      v_text_length NUMBER;
      v_start_pos NUMBER := 1;
      v_chunk_text CLOB;
  BEGIN
     DELETE FROM DOC_CHUNKS WHERE doc_id = p_doc_id;

      --loop and insert chunks
                 -- Insert all chunks for this document
            -- Individual chunk errors are logged but don't stop batch
            FOR j IN 1..p_chunks.COUNT LOOP
                BEGIN
                    -- Insert chunk with all metadata
                    INSERT INTO DOC_CHUNKS (
                        doc_chunk_id,           -- Generated from sequence
                        doc_id,             -- Source document
                        chunk_sequence,     -- Order within document
                        chunk_text,         -- Actual chunk content
                        chunk_size,         -- Character count
                        chunk_token_count,  -- Estimated token count
                        chunking_strategy   -- Strategy used
                    ) VALUES (
                        DOC_CHUNKS_SEQ.NEXTVAL,
                        p_doc_id,
                        p_chunks(j).chunk_sequence,
                        p_chunks(j).chunk_text,
                        p_chunks(j).chunk_size,
                        p_chunks(j).chunk_tokens_count,
                        p_strategy
                    );
                    
                    -- Increment total chunk counter
                 --   v_total := v_total + 1;
                    
                EXCEPTION
                    WHEN OTHERS THEN
                        -- Log chunk insertion error and continue
                        -- Allows batch to proceed despite individual failures
                        DBMS_OUTPUT.PUT_LINE('Error inserting chunk: ' || SQLERRM);
                END;
            END LOOP;

      UPDATE docs
         SET last_chunked_at = SYSTIMESTAMP,
             last_chunking_strategy = 'SEMANTIC'
       WHERE doc_id = p_doc_id;

      COMMIT;
  END Add_Doc_Chunks; 

 /*******************************************************************************
 *  
 *******************************************************************************/
 
  FUNCTION evaluate_chunk_quality(p_doc_id IN NUMBER) RETURN NUMBER IS
      vcaller constant varchar2(70):= c_package_name ||'.evaluate_chunk_quality';
      v_avg_chunk_size NUMBER;
      v_chunk_count NUMBER;
      v_size_variance NUMBER;
      v_quality_score NUMBER;
  BEGIN
      SELECT COUNT(*), AVG(chunk_size), VARIANCE(chunk_size)
        INTO v_chunk_count, v_avg_chunk_size, v_size_variance
        FROM DOC_CHUNKS
       WHERE doc_id = p_doc_id AND is_active = 'Y';

      IF v_chunk_count = 0 THEN RETURN 0; END IF;

      v_quality_score :=
          CASE WHEN v_avg_chunk_size BETWEEN 500 AND 2000 THEN 50
               WHEN v_avg_chunk_size BETWEEN 300 AND 3000 THEN 30
               ELSE 10 END +
          CASE WHEN v_size_variance < 100000 THEN 30
               WHEN v_size_variance < 500000 THEN 20
               ELSE 10 END +
          CASE WHEN v_chunk_count BETWEEN 5 AND 50 THEN 20 ELSE 10 END;

      RETURN LEAST(100, v_quality_score);
  END evaluate_chunk_quality;
 
 /*******************************************************************************
 *   Get strategy configuration (returns JSON as CLOB)
 *******************************************************************************/
 
  FUNCTION get_strategy_config(
      p_doc_id        IN NUMBER,
      p_strategy_code IN VARCHAR2
  ) RETURN JSON IS
      vcaller constant varchar2(70):= c_package_name ||'.get_strategy_config';
      v_result CLOB;
  BEGIN
      SELECT JSON_OBJECT(
               'doc_id' VALUE p_doc_id,
               'strategy_code' VALUE p_strategy_code,
               'default_chunk_size' VALUE 512,
               'default_overlap_pct' VALUE 20
             RETURNING CLOB)
      INTO v_result
      FROM dual;

      RETURN JSON(v_result);
  END get_strategy_config;
 /*******************************************************************************
 *  
 *******************************************************************************/
 

END chunk_proxy_util;

/
