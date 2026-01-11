--------------------------------------------------------
--  DDL for Package Body RAG_GOVERNANCE_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "RAG_GOVERNANCE_PKG" AS

    PROCEDURE enforce_access(
        p_user_id       IN NUMBER,
        p_doc_id        IN NUMBER,
        p_required_role IN VARCHAR2
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.log_event'; 
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
          FROM user_roles ur, roles r
         WHERE user_id = p_user_id
           and ur.role_id = r.role_id
           AND role_code = p_required_role;

        IF v_count = 0 THEN
            RAISE_APPLICATION_ERROR(
                -20031,
                'ACCESS DENIED: Missing role ' || p_required_role
            );
        END IF;
    END;



    -----------------------------------------------------------------------
    PROCEDURE enforce_classification(
        p_user_id            IN NUMBER,
        p_doc_id             IN NUMBER,
        p_user_clearance_lvl IN NUMBER
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.log_event'; 
        v_required_lvl NUMBER;
    BEGIN
        SELECT classification_level
        INTO v_required_lvl
        FROM docs
        WHERE doc_id = p_doc_id;

        IF p_user_clearance_lvl < v_required_lvl THEN
            RAISE_APPLICATION_ERROR(
                -20032,
                'ACCESS DENIED: Insufficient clearance level'
            );
        END IF;
    END;



    -----------------------------------------------------------------------
    PROCEDURE verify_pipeline_allowed(
        p_doc_id     IN NUMBER,
        p_stage_name IN VARCHAR2
    ) IS
        vcaller constant varchar2(70):= c_package_name ||'.log_event'; 
        v_flag VARCHAR2(1);
    BEGIN
        SELECT CASE p_stage_name
                   WHEN 'CHUNK' THEN allow_chunk
                   WHEN 'EMBED' THEN allow_embed
                   WHEN 'RAG'   THEN allow_rag
               END
        INTO v_flag
        FROM doc_pipeline_policies
        WHERE doc_id = p_doc_id;

        IF v_flag = 'N' THEN
            RAISE_APPLICATION_ERROR(
                -20033,
                'Pipeline stage not permitted: '||p_stage_name
            );
        END IF;
    END;

END rag_governance_pkg;

/
