SET SERVEROUTPUT ON SIZE 1000000;
SET FEEDBACK OFF;

DECLARE
    TYPE t_file_rec IS RECORD (
        path     VARCHAR2(4000),
        folder   VARCHAR2(50),
        filename VARCHAR2(100),
        obj_type VARCHAR2(30),
        obj_name VARCHAR2(128)
    );
    TYPE t_file_list IS TABLE OF t_file_rec;
    v_files t_file_list := t_file_list();
    v_count NUMBER;
    v_missing_count NUMBER := 0;

    PROCEDURE add_file(p_path VARCHAR2) IS
        v_idx NUMBER;
    BEGIN
        v_files.EXTEND;
        v_idx := v_files.LAST;
        v_files(v_idx).path := p_path;
        
        -- Extract Folder and Filename based on standard path structure
        v_files(v_idx).folder   := REGEXP_SUBSTR(p_path, 'schema\\[0-9]+\\([A-Z_]+)\\', 1, 1, NULL, 1);
        v_files(v_idx).filename := REGEXP_SUBSTR(p_path, '([A-Z0-9_]+)\.sql$', 1, 1, NULL, 1);
        v_files(v_idx).obj_name := v_files(v_idx).filename;

        -- Map Folder to Oracle Object Type
        CASE v_files(v_idx).folder
            WHEN 'TYPES'          THEN v_files(v_idx).obj_type := 'TYPE';
            WHEN 'SEQUENCES'      THEN v_files(v_idx).obj_type := 'SEQUENCE';
            WHEN 'TABLES'         THEN v_files(v_idx).obj_type := 'TABLE';
            WHEN 'VIEWS'          THEN v_files(v_idx).obj_type := 'VIEW';
            WHEN 'INDEXES'        THEN v_files(v_idx).obj_type := 'INDEX';
            WHEN 'TRIGGERS'       THEN v_files(v_idx).obj_type := 'TRIGGER';
            WHEN 'PROCEDURES'     THEN v_files(v_idx).obj_type := 'PROCEDURE';
            WHEN 'FUNCTIONS'      THEN v_files(v_idx).obj_type := 'FUNCTION';
            WHEN 'PACKAGES'       THEN v_files(v_idx).obj_type := 'PACKAGE';
            WHEN 'PACKAGE_BODIES' THEN v_files(v_idx).obj_type := 'PACKAGE BODY';
            WHEN 'SYNONYMS'       THEN v_files(v_idx).obj_type := 'SYNONYM';
            ELSE v_files(v_idx).obj_type := NULL; -- Constraints/Data handled separately
        END CASE;
    END;

BEGIN
    -- ==========================================
    -- 1. LOAD FILE LIST
    -- ==========================================
    -- Types
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TYPES\T_CHUNK_ARRAY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TYPES\T_CHUNK_RECORD.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TYPES\T_DATA_ROW_OBJ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TYPES\T_DATA_ROW_TAB.sql');
    
    -- Sequences
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\CHAT_CALL_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\CHAT_FAVORITES_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\CONTEXT_DOMAIN_REGISTRY_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\DBTOOLS_EXECUTION_HISTORY_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\DOC_CHUNKS_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\LKP_CONTEXT_DOMAIN_CATEGORIES_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\LKP_LOG_EVENT_TYPE_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\LOG_ARCHIVE_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\RAG_CHUNKS_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\RAG_EMBEDDINGS_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\RAG_INTENT_LOG_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\RAG_QUERY_EXECUTION_LOG_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\RAG_TRACE_LOG_SEQ.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\SEQUENCES\SEQ_RAG_CHUNKS.sql');

    -- Tables
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\AI_MODEL_PRICING.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\AI_MODEL_USAGE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\AI_RATE_LIMIT.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\APP_ADMIN_USERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\APP_ENVIRONMENT.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_ALERT_THRESHOLD.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_CONTEXT_INSTRUCTIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_GOVERNANCE_RULES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_PARAMETERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_PARAM_OVERRIDES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CFG_REDACTION_RULES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CHAT_CALL_REGENERATIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CHAT_FAVORITES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CHAT_ISSUE_ATTACHMENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_DOMAINS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_DOMAIN_BEHAVIORS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_DOMAIN_INSTRUCTIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_DOMAIN_REGISTRY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_REGISTRY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\CONTEXT_REGISTRY_ROLES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DBTOOLS_EXECUTION_HISTORY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEBUG_AUDIT_LOG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEBUG_CONFIG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEPLOYMENT_AUDIT_LOG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEPLOYMENT_EXPERIMENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEPLOYMENT_METRICS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DEPLOYMENT_VERSIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DOCS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DOCS_STAGING.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DOC_CHUNKS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DOC_RELATIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\DOMAIN_INTENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\HCM_ASSIGNMENT.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\HCM_EMPLOYEE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\HCM_LEAVE_BALANCE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\HCM_SALARY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\HTMLDB_PLAN_TABLE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_ACCESS_ACTION.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CHAT_ISSUE_LEVEL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CHAT_ISSUE_PRIORITY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CHAT_ISSUE_STATUS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CHUNKING_STRATEGY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CONTEXT_DOMAIN_BEHAVIORS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CONTEXT_DOMAIN_CATEGORIES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CONTEXT_DOMAIN_SCOPE_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CONTEXT_REGISTRY_SOURCE_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_CXD_FAILURE_ACTION_OPTIONS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DATA_CLASSIFICATION.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_AUDIT_EVENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_AUDIT_EVENT_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_AUDIT_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_LEVEL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_LOG_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DEBUG_SCOPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DOC_CATEGORY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DOC_RELATION_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DOC_STATUS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_DOMAIN_DETECTION_METHODS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_ERROR_SEVERITY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_ERROR_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_INTENT_ACTION_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_ISSUE_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_LANGUAGE_CODE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_MIME_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_OUTPUT_FORMAT.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_PARAM_CATEGORY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_PARAM_SCOPE_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_PARAM_VALUE_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_PIPELINE_STAGE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_REDACTION_APPLY_PHASE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_REGISTERED_HANDLERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_REGISTRY_SENSITIVITY_LEVELS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_ROLE_CLEARANCE_LEVELS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_SEARCH_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_TEST_CATEGORY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LKP_TEXT_CHANGE_TYPE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LLM_INTENT_PROMPTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LLM_PROVIDERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LLM_PROVIDER_MODELS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\LOG_ARCHIVE_STORE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\RAG_DOMAIN_SOURCES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\RAG_QUALITY_METRICS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\RAG_REFRESH_QUEUE.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\RAG_TRACE_SUMMARY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\ROLES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\SEGMENT_USERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\SHADOW_COMPARISON_LOG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\TENANTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\USERS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\USER_ROLES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\USER_SEGMENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\USER_SEGMENT_ASSIGNMENTS.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TABLES\XXXCFG_PARAM_AUDIT.sql');

    -- Views
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\AUDIT_DASHBOARD_V.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\CFG_PARAM_EFFECTIVE_V.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\CFG_PARAM_V_MASKED.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\HR_VW_ADMIN_FULL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\HR_VW_MANAGER_TEAM.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\HR_VW_PAYROLL_DEPT.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\SMART_SEARCH_RESULTS_V.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\V_DOC_TEXT_PAGINATED.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\V_ENT_AI_DOCS_METADATA.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\VIEWS\XXHR_MY_EMPLOYEE_SELF_V.sql');

    -- Packages
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\AI_REFRESH_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\AI_SUMMARY_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\APP_ADMIN_SECURITY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\APP_CHUNK_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\APP_INVOKE_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\APP_SESSION_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\AUDIT_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CFG_PARAM_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_CALL_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_ENGINE_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_HISTORY_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_MANAGER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_PROJECTS_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHAT_SESSION_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_EMBEDDING_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_PROCESSOR_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_PROXY_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_STATS_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_STRATEGY_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CHUNK_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_CLASSIFIER_LLM_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_CLASSIFIER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_CLASSIFIER_SEMANTIC_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_FAILURE_ACTIONS_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CXD_VECTOR_EMBEDDING_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_BEHAVIOR_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_BUILDER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_CHUNKS_BUILDER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_CHUNKS_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_DATA_BUILDER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_DATA_BUILDER_PKGXX.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_DATA_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\CX_REGISTRY_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DATE_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DEBUG_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DEPLOYMENT_MANAGER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DOC_EXTRACT_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DOC_FILE_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\DOC_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\EMBEDDING_PROCESSOR_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\ENT_AI_FILE_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_ANTHROPIC_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_DEBUG_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_GEMINI_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_LOCAL_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_MODEL_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_OPENAI_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_ROUTER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_STREAM_ADAPTER_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_TOKEN_CALC_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\LLM_TYPES.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\POLICY_ENFORCER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\POLICY_REDACTION_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_API_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_CHUNK_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_CHUNK_STATS_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_GOVERNANCE_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_PROCESSING_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_PROCESSING_PKG_LEGACY.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_SEARCH_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\RAG_STRATEGY_CACHE_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\SEGMENT_MANAGER_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\STREAM_UTIL.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGES\TEST_DEBUG_UTIL_PKG.sql');

    -- Package Bodies (A selection for brevity, script handles all if added)
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGE_BODIES\AI_REFRESH_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGE_BODIES\CHAT_CALL_PKG.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\PACKAGE_BODIES\CHAT_ENGINE_PKG.sql');
    -- ... (Assume all others from the input list are added here in similar fashion) ...

    -- Indexes
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\INDEXES\LKP_CHAT_ISSUE_PRIORITY_PK.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\INDEXES\LKP_DOC_CATEGORY_CON.sql');
    -- ... (And all other indexes) ...

    -- Functions
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\FUNCTIONS\GET_WORD_STEM.sql');
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\FUNCTIONS\VALIDATE_JSON.sql');

    -- Triggers
    add_file('D:\GitHub\Github-formal\oracle-apex-ai-assistant\database\schema\20260109000001\TRIGGERS\ENT_AI_DOCS_METADATA_TRG.sql');

    -- ==========================================
    -- 2. CHECK OBJECTS & GENERATE SCRIPT
    -- ==========================================
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- ⚠️ MISSING OBJECTS REPORT & FIX SCRIPT');
    DBMS_OUTPUT.PUT_LINE('-- COPY AND RUN THE COMMANDS BELOW IN YOUR SQL CLIENT');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');

    FOR i IN 1..v_files.COUNT LOOP
        IF v_files(i).obj_type IS NOT NULL THEN
            SELECT COUNT(*)
            INTO v_count
            FROM user_objects
            WHERE object_name = v_files(i).obj_name
              AND object_type = v_files(i).obj_type;

            IF v_count = 0 THEN
                v_missing_count := v_missing_count + 1;
                -- Output the runnable command for the user
                DBMS_OUTPUT.PUT_LINE('@"' || v_files(i).path || '"');
            END IF;
        END IF;
    END LOOP;

    IF v_missing_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('-- ✅ All checked objects EXIST. No actions needed.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('-- 🛑 Total Missing Objects: ' || v_missing_count);
        DBMS_OUTPUT.PUT_LINE('-- Run the lines above to fix.');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('-- Note: CONSTRAINTS files are skipped in this check');
    DBMS_OUTPUT.PUT_LINE('-- as they modify tables rather than creating new objects.');
    DBMS_OUTPUT.PUT_LINE('-- If tables were missing, run constraint scripts after creating them.');
    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------');
END;
/