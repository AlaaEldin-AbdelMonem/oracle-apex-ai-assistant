--------------------------------------------------------
--  DDL for Package LLM_DEBUG_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "LLM_DEBUG_UTIL" AS
/*==============================================================================
  PACKAGE: LLM_DEBUG_UTIL
  PURPOSE:
    LLM-specific debug logging helpers on top of DEBUG_UTIL.

    Responsibilities:
      - Serialize llm_types.t_llm_request into JSON for DEBUG_LOG.extra_data
      - Serialize llm_types.t_llm_response into JSON for DEBUG_LOG.extra_data
      - Respect DEBUG_UTIL configuration:
          * Only build JSON when DEBUG is enabled
      - Tag all entries with a consistent module/procedure
      - Support TRACE_ID correlation across request/response logs

  TYPICAL USAGE (FROM PROVIDER PACKAGES):
    v_trace_id := 'LLM-' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

    llm_debug_util.log_request(p_req,  p_trace_id => v_trace_id);
    ...
    llm_debug_util.log_response(p_res, p_trace_id => v_trace_id);

    -- Optionally:
    debug_util.error('call_openai failed: ' || SQLERRM, v_trace_id);

==============================================================================*/
    c_version           CONSTANT VARCHAR2(10) := '1.0.0';
    c_package_name      CONSTANT VARCHAR2(30) := 'LLM_DEBUG_UTIL'; 
  ------------------------------------------------------------------------------
  -- LOG LLM REQUEST
  --
  -- PARAMETERS:
  --   p_req      - LLM request record (llm_types.t_llm_request)
  --   p_trace_id - Optional correlation ID for grouping logs
  --
  -- BEHAVIOR:
  --   - If debug_util.is_on(c_debug) = FALSE → returns immediately (no JSON).
  --   - Otherwise, builds JSON_OBJECT with key request fields and calls
  --     debug_util.log(...) at DEBUG level with:
  --       p_message     = 'LLM REQUEST ' || p_req.model
  --       p_module_name = 'LLM_ENGINE'
  --       p_procedure   = 'call_llm'
  --       p_extra_data  = JSON payload
  ------------------------------------------------------------------------------
  PROCEDURE log_request(
      p_req      IN llm_types.t_llm_request,
      p_trace_id IN VARCHAR2 DEFAULT NULL
  );

  ------------------------------------------------------------------------------
  -- LOG LLM RESPONSE
  --
  -- PARAMETERS:
  --   p_res      - LLM response record (llm_types.t_llm_response)
  --   p_trace_id - Optional correlation ID (should match request trace_id)
  --
  -- BEHAVIOR:
  --   - If debug_util.is_on(c_debug) = FALSE → returns immediately.
  --   - Otherwise, builds JSON_OBJECT with key response fields and calls
  --     debug_util.log(...) at DEBUG level with:
  --       p_message     = 'LLM RESPONSE ' || NVL(p_res.model_used, 'UNKNOWN')
  --       p_module_name = 'LLM_ENGINE'
  --       p_procedure   = 'call_llm'
  --       p_extra_data  = JSON payload
  ------------------------------------------------------------------------------
  PROCEDURE log_response(
      p_res      IN llm_types.t_llm_response,
      p_trace_id IN VARCHAR2 DEFAULT NULL
  );

END llm_debug_util;

/
