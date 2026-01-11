--------------------------------------------------------
--  DDL for Package Body CHUNK_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CHUNK_PKG" AS
 
  -------------------------------------- 
  -- Estimate token count (approximate)
  /*******************************************************************************
 *  
 *******************************************************************************/
  FUNCTION estimate_tokens(
      p_text        IN CLOB,
      p_model_type  IN VARCHAR2 DEFAULT 'GPT'
  ) RETURN NUMBER IS
       vcaller constant varchar2(70):= c_package_name ||'.estimate_tokens'; 
      v_char_count NUMBER;
      v_ratio      NUMBER := 4.0;
  BEGIN
      dbms_output.put_line('start>RAG_CHUNK_PKG>estimate_tokens');
      v_char_count := DBMS_LOB.GETLENGTH(p_text);
      CASE UPPER(p_model_type)
          WHEN 'CLAUDE' THEN v_ratio := 4.2;
          WHEN 'LLAMA'  THEN v_ratio := 3.8;
          WHEN 'CODE'   THEN v_ratio := 3.0;
          WHEN 'ARABIC' THEN v_ratio := 2.5;
      END CASE;
      RETURN CEIL(v_char_count / v_ratio);
  END estimate_tokens;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Normalize text (cleanup)
  ---------------------------------------------------------------------------
  FUNCTION normalize_text(
      p_text            IN CLOB,
      p_remove_special  IN BOOLEAN DEFAULT FALSE,
      p_lowercase       IN BOOLEAN DEFAULT FALSE
  ) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.normalize_text'; 
      v_text CLOB := p_text;
  BEGIN
       debug_util.starting(vcaller);
      v_text := REGEXP_REPLACE(v_text, '[[:cntrl:]]', ' ');
      v_text := REGEXP_REPLACE(v_text, ' +', ' ');
      v_text := TRIM(v_text);
      IF p_remove_special THEN
          v_text := REGEXP_REPLACE(v_text, '[^[:alnum:] \n\r\t.,;:!?-]', '');
      END IF;
      IF p_lowercase THEN
          v_text := LOWER(v_text);
      END IF;
      debug_util.ending(vcaller);
      RETURN v_text;
  END normalize_text;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Language detection (simple heuristic)
  ---------------------------------------------------------------------------
  FUNCTION detect_language(p_text IN CLOB) RETURN t_language IS
     vcaller constant varchar2(70):= c_package_name ||'.detect_language'; 
  BEGIN
    
      IF REGEXP_LIKE(p_text, '[\u0600-\u06FF]') THEN
          RETURN c_lang_ar;
      ELSE
          RETURN c_lang_en;
      END IF;
  END detect_language;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Fixed-size chunking
  ---------------------------------------------------------------------------
  FUNCTION chunk_by_fixed_size(
      p_text        IN CLOB,
      p_chunk_size  IN NUMBER DEFAULT 512,
      p_overlap     IN NUMBER DEFAULT 50
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_by_fixed_size'; 
      v_chunks   chunk_types.t_chunk_tab := chunk_types.t_chunk_tab();
      v_length   NUMBER := DBMS_LOB.GETLENGTH(p_text);
      v_start    NUMBER := 1;
      v_end      NUMBER;
      v_seq      NUMBER := 0;
      v_overlap  NUMBER := NVL(p_overlap, 0);
  BEGIN
       debug_util.starting(vcaller); 
      LOOP
          EXIT WHEN v_start > v_length;
          v_end := LEAST(v_start + p_chunk_size - 1, v_length);
          v_seq := v_seq + 1;

          v_chunks.EXTEND;
         -- v_chunks(v_seq).chunk_id
          v_chunks(v_seq).chunk_sequence    := v_seq;
          v_chunks(v_seq).chunk_text        := DBMS_LOB.SUBSTR(p_text, v_end - v_start + 1, v_start);
          v_chunks(v_seq).chunk_size        := v_end - v_start + 1;
          v_chunks(v_seq).start_pos    := v_start;
          v_chunks(v_seq).end_pos     := v_end;
          v_chunks(v_seq).chunk_tokens_count:= estimate_tokens(v_chunks(v_seq).chunk_text);
          v_chunks(v_seq).char_count := LENGTH( v_chunks(v_seq).chunk_text) ;    -- Character count (LENGTH(chunk_text))
          v_chunks(v_seq).word_count :='';        -- Word count (for better token estimation)
          v_chunks(v_seq).quality_score :='';   -- Quality metric (0.0 = poor, 1.0 = excellent)
          v_chunks(v_seq).strategy_used :='FIXED_SIZE';
         -- v_chunks(v_seq).chunk_metadata  := '{"strategy":"FIXED_SIZE","Chunk Level":"0"}';--Structured metadata (strategy, level, parent, etc.)

 

          v_start := v_end - v_overlap + 1;
      END LOOP;
     debug_util.ending(vcaller); 
      RETURN v_chunks;
  END chunk_by_fixed_size;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Sentence boundary chunking (wrapper)
  ---------------------------------------------------------------------------
  FUNCTION chunk_by_sentence(
      p_text              IN CLOB,
      p_target_size       IN NUMBER DEFAULT 512,
      p_max_chunk_size    IN NUMBER DEFAULT 1024,
      p_overlap_pct       IN NUMBER DEFAULT 15,
      p_language          IN t_language DEFAULT c_lang_auto
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_by_sentence'; 
      v_overlap NUMBER := ROUND(p_target_size * p_overlap_pct / 100);
  BEGIN
        debug_util.info('call',vcaller); 
      RETURN chunk_by_fixed_size(p_text, p_target_size, v_overlap);
  END chunk_by_sentence;
 /*******************************************************************************
 *  
 *******************************************************************************/

  ---------------------------------------------------------------------------
  -- Paragraph boundary chunking (wrapper)
  ---------------------------------------------------------------------------
  FUNCTION chunk_by_paragraph(
      p_text              IN CLOB,
      p_max_chunk_size    IN NUMBER DEFAULT 1024,
      p_min_chunk_size    IN NUMBER DEFAULT 100,
      p_overlap_pct       IN NUMBER DEFAULT 15
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_by_paragraph'; 
      v_overlap NUMBER := ROUND(p_max_chunk_size * p_overlap_pct / 100);
  BEGIN
       debug_util.info('call',vcaller); 
      RETURN chunk_by_fixed_size(p_text, p_max_chunk_size, v_overlap);
  END chunk_by_paragraph;
 /*******************************************************************************
 *  
 *******************************************************************************/

  ---------------------------------------------------------------------------
  -- Semantic sliding window (wrapper)
  ---------------------------------------------------------------------------
  FUNCTION chunk_semantic_sliding(
      p_text              IN CLOB,
      p_chunk_size        IN NUMBER DEFAULT 512,
      p_overlap_pct       IN NUMBER DEFAULT 30,
      p_language          IN t_language DEFAULT c_lang_auto
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_semantic_sliding'; 
      v_overlap NUMBER := ROUND(p_chunk_size * p_overlap_pct / 100);
  BEGIN
      debug_util.info('call',vcaller); 
      RETURN chunk_by_fixed_size(p_text, p_chunk_size, v_overlap);
  END chunk_semantic_sliding;
 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Hierarchical chunking (simplified)
  ---------------------------------------------------------------------------
  FUNCTION chunk_hierarchical(
      p_text              IN CLOB,
      p_level0_size       IN NUMBER DEFAULT 3072,
      p_level1_size       IN NUMBER DEFAULT 1536,
      p_level2_size       IN NUMBER DEFAULT 768
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_hierarchical'; 
      v_chunks chunk_types.t_chunk_tab;
  BEGIN
       debug_util.info('call',vcaller); 
      v_chunks := chunk_by_fixed_size(p_text, p_level2_size, 50);
      FOR i IN 1 .. v_chunks.COUNT LOOP
          v_chunks(i).chunk_level    := 2;
          v_chunks(i).chunk_metadata :=  json('{"strategy":"HIERARCHICAL"}');
      END LOOP;
      RETURN v_chunks;
  END chunk_hierarchical;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Token-based chunking
  ---------------------------------------------------------------------------
  FUNCTION chunk_by_tokens(
      p_text              IN CLOB,
      p_max_tokens        IN NUMBER DEFAULT 512,
      p_overlap_tokens    IN NUMBER DEFAULT 50,
      p_model_type        IN VARCHAR2 DEFAULT 'GPT'
  ) RETURN chunk_types.t_chunk_tab IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_by_tokens'; 
      v_ratio      NUMBER := 4.0;
      v_chunk_size NUMBER;
      v_overlap    NUMBER;
  BEGIN
      debug_util.info('call',vcaller); 
      CASE UPPER(p_model_type)
          WHEN 'CLAUDE' THEN v_ratio := 4.2;
          WHEN 'LLAMA'  THEN v_ratio := 3.8;
      END CASE;
      v_chunk_size := p_max_tokens * v_ratio;
      v_overlap    := p_overlap_tokens * v_ratio;
      RETURN chunk_by_fixed_size(p_text, v_chunk_size, v_overlap);
  END chunk_by_tokens;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Universal dispatcher
  ---------------------------------------------------------------------------
  FUNCTION chunk_text(
      p_text              IN CLOB,
      p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
      p_chunk_size        IN NUMBER DEFAULT 512,
      p_overlap_size      IN NUMBER DEFAULT 50,
      p_overlap_pct       IN NUMBER DEFAULT NULL,
      p_language          IN t_language DEFAULT c_lang_auto,
      p_max_chunk_size    IN NUMBER DEFAULT 2048,
      p_min_chunk_size    IN NUMBER DEFAULT 50,
      p_normalize         IN BOOLEAN DEFAULT TRUE,
      p_preserve_format   IN BOOLEAN DEFAULT FALSE,
      p_metadata          IN JSON DEFAULT NULL
  ) RETURN chunk_types.t_chunk_tab IS
    vcaller constant varchar2(70):= c_package_name ||'.chunk_text'; 
  BEGIN
             debug_util.info('call',vcaller); 
      CASE p_strategy
          WHEN c_fixed_size THEN
              RETURN chunk_by_fixed_size(p_text, p_chunk_size, p_overlap_size);
          WHEN c_sentence_boundary THEN
              RETURN chunk_by_sentence(p_text, p_chunk_size, p_max_chunk_size, NVL(p_overlap_pct,15), p_language);
          WHEN c_paragraph_boundary THEN
              RETURN chunk_by_paragraph(p_text, p_max_chunk_size, p_min_chunk_size, NVL(p_overlap_pct,15));
          WHEN c_semantic_sliding THEN
              RETURN chunk_semantic_sliding(p_text, p_chunk_size, NVL(p_overlap_pct,30), p_language);
          WHEN c_hierarchical THEN
              RETURN chunk_hierarchical(p_text, p_max_chunk_size, p_chunk_size, p_min_chunk_size);
          WHEN c_token_based THEN
              RETURN chunk_by_tokens(p_text, p_chunk_size, p_overlap_size, 'GPT');
          ELSE
              RETURN chunk_by_fixed_size(p_text, p_chunk_size, p_overlap_size);
      END CASE;
  END chunk_text;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Chunk statistics (safe JSON to CLOB)
  ---------------------------------------------------------------------------
  FUNCTION get_chunk_statistics(p_chunks IN chunk_types.t_chunk_tab) RETURN CLOB IS
      vcaller constant varchar2(70):= c_package_name ||'.get_chunk_statistics'; 
      v_total       NUMBER := p_chunks.COUNT;
      v_total_size  NUMBER := 0;
      v_min         NUMBER := NULL;
      v_max         NUMBER := 0;
      v_result      CLOB;
  BEGIN
         debug_util.info('call',vcaller); 
      FOR i IN 1 .. v_total LOOP
          v_total_size := v_total_size + p_chunks(i).chunk_size;
          v_min := LEAST(NVL(v_min, p_chunks(i).chunk_size), p_chunks(i).chunk_size);
          v_max := GREATEST(v_max, p_chunks(i).chunk_size);
      END LOOP;

      SELECT JSON_OBJECT(
                'total_chunks' VALUE v_total,
                'avg_chunk_size' VALUE ROUND(v_total_size / GREATEST(v_total,1),2),
                'min_size' VALUE v_min,
                'max_size' VALUE v_max
             RETURNING CLOB)
      INTO v_result
      FROM dual;

      RETURN v_result;
  END get_chunk_statistics;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Validate chunk quality (safe JSON to CLOB)
  ---------------------------------------------------------------------------
  FUNCTION validate_chunk_quality(p_chunks IN chunk_types.t_chunk_tab) RETURN CLOB IS
       vcaller constant varchar2(70):= c_package_name ||'.validate_chunk_quality'; 
      v_result CLOB;
  BEGIN
          debug_util.info('call',vcaller); 
      SELECT JSON_OBJECT(
                'status'  VALUE 'OK',
                'message' VALUE 'Validation placeholder'
             RETURNING CLOB)
      INTO v_result
      FROM dual;

      RETURN v_result;
  END validate_chunk_quality;

 /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- Batch processing placeholder
  ---------------------------------------------------------------------------
  FUNCTION chunk_document_batch(
      p_doc_ids       IN SYS.ODCINUMBERLIST,
      p_strategy      IN t_chunk_strategy DEFAULT c_sentence_boundary,
      p_chunk_size    IN NUMBER DEFAULT 512,
      p_overlap_pct   IN NUMBER DEFAULT 20,
      p_commit_batch  IN NUMBER DEFAULT 10
  ) RETURN NUMBER IS
    vcaller constant varchar2(70):= c_package_name ||'.chunk_document_batch'; 
  BEGIN
     debug_util.info('call',vcaller); 
      RETURN 0;
  END chunk_document_batch;

  /*******************************************************************************
 *  
 *******************************************************************************/
  ---------------------------------------------------------------------------
  -- One-step chunk + embed placeholder
  ---------------------------------------------------------------------------
  FUNCTION chunk_and_embed_document(
      p_doc_id            IN NUMBER,
      p_strategy          IN t_chunk_strategy DEFAULT c_sentence_boundary,
      p_chunk_size        IN NUMBER DEFAULT 512,
      p_embedding_model   IN VARCHAR2 DEFAULT 'all-MiniLM-L6-v2'
  ) RETURN NUMBER IS
      vcaller constant varchar2(70):= c_package_name ||'.chunk_pkg'; 
  BEGIN
      debug_util.info('call',vcaller); 
      RETURN 0;
  END chunk_and_embed_document;
 /*******************************************************************************
 *  
 *******************************************************************************/
END chunk_pkg;

/
