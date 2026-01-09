--------------------------------------------------------
--  DDL for Package Body CXD_VECTOR_EMBEDDING_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CXD_VECTOR_EMBEDDING_PKG" AS

 /*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_text_to_embed(
        p_name        IN VARCHAR2,
        p_description IN VARCHAR2,
        p_keywords    IN VARCHAR2
    ) RETURN VARCHAR2 IS
       vcaller constant varchar2(70):= c_package_name ||'.get_text_to_embed';
    BEGIN
        RETURN p_name || '. ' ||   NVL(p_description, '') || ' ' ||  NVL(p_keywords,     '');
    END;
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE update_success(
        p_id      IN NUMBER,
        p_vector  IN VECTOR
    ) IS
          vcaller constant varchar2(70):= c_package_name ||'.update_success';
    BEGIN
        UPDATE context_domains
        SET domain_embedding_vector       = p_vector,
            embedding_generated_date = SYSDATE,
            embedding_status       = 'COMPLETED',
            embedding_model_version = c_model,
            embedding_error_message = NULL
        WHERE context_domain_id = p_id;

        COMMIT;
    END;

/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE update_failure(
        p_id   IN NUMBER,
        p_err  IN VARCHAR2
    ) IS
          vcaller constant varchar2(70):= c_package_name ||'.update_failure';
    BEGIN
        UPDATE context_domains
        SET embedding_status       = 'FAILED',
            embedding_error_message = SUBSTR(p_err, 1, 4000),
            embedding_generated_date = SYSDATE
        WHERE context_domain_id = p_id;

        COMMIT;
    END;


    --------------------------------------------------------------------------
    -- PUBLIC: Generate embedding for one domain
/*******************************************************************************
 *  
 *******************************************************************************/
    PROCEDURE generate_embedding_for_domain(
        p_context_domain_id IN NUMBER
    ) IS
          vcaller constant varchar2(70):= c_package_name ||'.generate_embedding_for_domain';
        rec                context_domains%ROWTYPE;
        v_text_to_embed    VARCHAR2(4000);
        v_embedding        VECTOR(c_vector_Dim, FLOAT32);
        v_model_name varchar2(100):= ai_vector_utx.C_MODEL_NAME;
     BEGIN
        SELECT *
        INTO rec
        FROM context_domains
        WHERE context_domain_id = p_context_domain_id;

        v_text_to_embed :=
            get_text_to_embed(
                rec.domain_name,
                rec.description,
                rec.context_domain_keywords
            );

        debug_util.info(  'Generating embedding for domain ID ' || p_context_domain_id ||
             ' (' || rec.context_domain_code || ')' ,vcaller);

        BEGIN
            v_embedding := chunk_embedding_pkg.generate_embedding(p_text=>v_text_to_embed,p_model=> v_model_name);
            update_success(p_context_domain_id, v_embedding);

            debug_util.ending(vcaller);

        EXCEPTION
            WHEN OTHERS THEN
                debug_util.error(  SQLERRM,vcaller);
                update_failure(p_context_domain_id, SQLERRM);
        END;

    END generate_embedding_for_domain;
/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- PUBLIC: Generate embeddings for all active domains
    ---------------------------------------------------- 
    PROCEDURE generate_all_embeddings IS
        vcaller constant varchar2(70):= c_package_name ||'.generate_all_embeddings';
        v_start_time     TIMESTAMP := SYSTIMESTAMP;
        v_success_count  NUMBER := 0;
        v_failure_count  NUMBER := 0;
 
    BEGIN
         debug_util.starting( vcaller);
 
        FOR rec IN (
            SELECT *
            FROM context_domains
            WHERE is_active = 'Y'
            ORDER BY context_domain_id
        )
        LOOP
            BEGIN
                generate_embedding_for_domain(rec.context_domain_id);
                v_success_count := v_success_count + 1;
            EXCEPTION
                WHEN OTHERS THEN
                    v_failure_count := v_failure_count + 1;
            END;
        END LOOP;

       
      
      
        debug_util.ending(vcaller,'  Total Time = ' ||
             ROUND(EXTRACT(SECOND FROM (SYSTIMESTAMP - v_start_time)), 2)
             || ' seconds'  );
      

    END generate_all_embeddings;
/*******************************************************************************
 *  
 *******************************************************************************/
    --------------------------------------------------------------------------
    -- PUBLIC: Retry only FAILED domains
    --------------------------------------------------------------------------
    PROCEDURE rebuild_failed_embeddings IS
          vcaller constant varchar2(70):= c_package_name ||'.rebuild_failed_embeddings';
     BEGIN
         debug_util.starting(vcaller);
 
        FOR rec IN (
            SELECT *
            FROM context_domains
            WHERE embedding_status = 'FAILED'
        )
        LOOP
            generate_embedding_for_domain(rec.context_domain_id);
        END LOOP;

         debug_util.ending(vcaller );
 
     END rebuild_failed_embeddings;
/*******************************************************************************
 *  
 *******************************************************************************/

END cxd_vector_embedding_pkg;

/
