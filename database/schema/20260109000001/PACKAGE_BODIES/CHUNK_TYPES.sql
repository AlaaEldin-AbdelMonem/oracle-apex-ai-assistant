--------------------------------------------------------
--  DDL for Package Body CHUNK_TYPES
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CHUNK_TYPES" AS

    FUNCTION calculate_quality_score(
        p_char_count IN NUMBER,
        p_word_count IN NUMBER,
        p_strategy   IN VARCHAR2
    ) RETURN NUMBER IS
        vcaller constant varchar2(70):= c_package_name ||'.calculate_quality_score';
        v_score NUMBER := 1.0;
    BEGIN
        IF p_char_count BETWEEN 100 AND 1000 THEN v_score := 1.0;
        ELSIF p_char_count BETWEEN 50 AND 100 OR p_char_count BETWEEN 1000 AND 1500 THEN v_score := 0.8;
        ELSIF p_char_count < 50 THEN v_score := 0.5;
        ELSE v_score := 0.7;
        END IF;

        IF p_word_count > 0 AND (p_char_count / p_word_count) NOT BETWEEN 3 AND 12 THEN
            v_score := v_score * 0.9;
        END IF;

        IF UPPER(p_strategy) = c_semantic_sliding THEN v_score := v_score * 1.1;
        ELSIF UPPER(p_strategy) = c_hierarchical THEN v_score := v_score * 1.05;
        END IF;

        RETURN LEAST(1.0, GREATEST(0.0, v_score));
    EXCEPTION
        WHEN OTHERS THEN RETURN 0.5;
    END calculate_quality_score;

    FUNCTION estimate_token_count(
        p_char_count IN NUMBER,
        p_word_count IN NUMBER
    ) RETURN NUMBER IS
          vcaller constant varchar2(70):= c_package_name ||'.estimate_token_count';
    BEGIN
        RETURN CASE WHEN p_word_count > 0 THEN ROUND(p_word_count * 1.3) ELSE ROUND(p_char_count / 4.0) END;
    END estimate_token_count;

    FUNCTION build_metadata(
        p_strategy              IN VARCHAR2,
        p_chunk_level           IN NUMBER DEFAULT 0,
        p_parent_seq            IN NUMBER DEFAULT NULL,
        p_additional_metadata   IN JSON DEFAULT NULL
    ) RETURN JSON IS
          vcaller constant varchar2(70):= c_package_name ||'.build_metadata';
    BEGIN
        RETURN JSON('{"strategy":"' || p_strategy || '","chunk_level":' || NVL(TO_CHAR(p_chunk_level),'0') || ',"parent_seq":' || NVL(TO_CHAR(p_parent_seq),'null') || '}');
    EXCEPTION
        WHEN OTHERS THEN
            RETURN JSON('{"strategy":"' || p_strategy || '"}');
    END build_metadata;

    FUNCTION is_valid_chunk(p_chunk IN t_chunk_rec) RETURN BOOLEAN IS
          vcaller constant varchar2(70):= c_package_name ||'.is_valid_chunk';
    BEGIN
        RETURN p_chunk.chunk_text IS NOT NULL 
           AND NVL(p_chunk.char_count,0) > 0
           AND NVL(p_chunk.chunk_sequence,0) > 0
           AND p_chunk.start_pos IS NOT NULL
           AND p_chunk.end_pos IS NOT NULL
           AND p_chunk.start_pos <= p_chunk.end_pos;
    EXCEPTION
        WHEN OTHERS THEN RETURN FALSE;
    END is_valid_chunk;

----------------------------
PROCEDURE print_chunks (  p_chunks IN chunk_types.t_chunk_tab )
IS
      vcaller constant varchar2(70):= c_package_name ||'.print_chunks';
      v_msg varchar2(3200);
BEGIN
    IF p_chunks IS NULL OR p_chunks.COUNT = 0 THEN
           debug_util.warn('⚠️ No chunks found.',vcaller);
        RETURN;
    END IF;

        debug_util.info('📄 CHUNK SUMMARY (' || p_chunks.COUNT || ' total chunks)',vcaller);
 
    FOR i IN 1 .. p_chunks.COUNT LOOP
        v_msg:= 'Chunk #' || p_chunks(i).chunk_sequence ||  ' [ID=' || p_chunks(i).chunk_id || ']';
         debug_util.info(v_msg,vcaller);
        v_msg:= 'Text: ' || DBMS_LOB.SUBSTR(p_chunks(i).chunk_text, 4000, 1); -- Avoids CLOB overflow
        debug_util.info(v_msg,vcaller);
        v_msg:=  'Start-End : ' || p_chunks(i).start_pos || ' - ' || p_chunks(i).end_pos|| 
                                  'Chars     : ' || p_chunks(i).char_count ||
                             ', Words: ' || p_chunks(i).word_count ||
                             ', Tokens: ' || p_chunks(i).chunk_tokens_count;
         debug_util.info(v_msg,vcaller);
         v_msg:='Size      : ' || p_chunks(i).chunk_size ||
                             ', Level: ' || NVL(p_chunks(i).chunk_level,0);
          debug_util.info(v_msg,vcaller);
         v_msg:='Strategy  : ' || p_chunks(i).strategy_used ||
        'Quality   : ' || NVL(TO_CHAR(p_chunks(i).quality_score, '0.00'), 'N/A') ||
        'Metadata  : ' || JSON_SERIALIZE( p_chunks(i).chunk_metadata) ;
         debug_util.info(v_msg,vcaller);
    END LOOP;

 
     debug_util.ending(vcaller);
 EXCEPTION
    WHEN OTHERS THEN
     debug_util.error(SQLERRM,vcaller);
     
END print_chunks;
--------------------
PROCEDURE print_chunk_text (  p_chunks IN chunk_types.t_chunk_tab )
IS
      vcaller constant varchar2(70):= c_package_name ||'.print_chunk_text';
      v_msg varchar2(32000);
BEGIN
    IF p_chunks IS NULL OR p_chunks.COUNT = 0 THEN
        debug_util.info('⚠️ No chunks found.',vcaller);
        RETURN;
    END IF;

 
    v_msg:= '📄 CHUNK SUMMARY (' || p_chunks.COUNT || ' total chunks)';
      debug_util.info(v_msg,vcaller);
 
    FOR i IN 1 .. p_chunks.COUNT LOOP
          v_msg:= 'Chunk #' || p_chunks(i).chunk_sequence || ' [ID=' || p_chunks(i).chunk_id || ']';
           debug_util.info(v_msg,vcaller);
       v_msg:= DBMS_LOB.SUBSTR(p_chunks(i).chunk_text, 4000, 1); -- Avoids CLOB overflow
        debug_util.info(v_msg,vcaller);
    END LOOP;

          debug_util.ending( vcaller); 
 EXCEPTION
    WHEN OTHERS THEN
            debug_util.error(SQLERRM,vcaller);
END print_chunk_text;
-----------------
END chunk_types;

/
