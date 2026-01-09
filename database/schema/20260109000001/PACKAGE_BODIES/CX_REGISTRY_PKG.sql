--------------------------------------------------------
--  DDL for Package Body CX_REGISTRY_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "AI8P"."CX_REGISTRY_PKG" AS
/*******************************************************************************
 *  
 *******************************************************************************/
    FUNCTION get_registry_sources(
        p_context_domain_id IN NUMBER,
        p_role_id           IN NUMBER
    ) RETURN t_registry_tab
    IS
        vcaller constant varchar2(70):= c_package_name ||'.get_registry_sources';
        v_tab t_registry_tab := t_registry_tab();
        v_idx NUMBER := 0;
    BEGIN

        FOR rec IN (
            SELECT
                r.context_registry_id,
                r.source_title,
                r.registry_source_type_code,
                r.source_name,
               -- r.security_level,
                r.mandatory_filters,
                rr.filter_template AS role_filter
            FROM context_registry r , context_domain_registry dr ,context_registry_roles rr

            WHERE 1=1
              AND dr.context_registry_id = r.context_registry_id
              AND rr.context_registry_id = r.context_registry_id
              AND dr.context_domain_id = p_context_domain_id
              AND rr.role_id          = p_role_id
              AND dr.is_active        = 'Y'
              AND rr.is_active        = 'Y'
              AND r.is_active         = 'Y'
        )
        LOOP
            v_idx := v_tab.COUNT + 1;
            v_tab.EXTEND;

            v_tab(v_idx).context_registry_id := rec.context_registry_id;
            v_tab(v_idx).source_title        := rec.source_title;
            v_tab(v_idx).source_type_code    := rec.registry_source_type_code;
            v_tab(v_idx).source_name         := rec.source_name;
           -- v_tab(v_idx).security_level      := rec.security_level;
            v_tab(v_idx).mandatory_filters   := rec.mandatory_filters;
            v_tab(v_idx).role_filter         := rec.role_filter;
        END LOOP;

        RETURN v_tab;

    END get_registry_sources;
/*******************************************************************************
 *  
 *******************************************************************************/
END cx_registry_pkg;

/
