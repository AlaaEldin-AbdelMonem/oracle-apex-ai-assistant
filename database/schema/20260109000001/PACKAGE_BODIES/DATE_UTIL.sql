--------------------------------------------------------
--  DDL for Package Body DATE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "DATE_UTIL" IS

  ------------------------------------------------------------------------------
  -- Duration Conversions
  ------------------------------------------------------------------------------
  FUNCTION ms_to_seconds (p_ms NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_ms / c_ms_per_second;
  END;

  FUNCTION ms_to_minutes (p_ms NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_ms / c_ms_per_minute;
  END;

  FUNCTION ms_to_hours (p_ms NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_ms / c_ms_per_hour;
  END;

  FUNCTION seconds_to_ms (p_seconds NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_seconds * c_ms_per_second;
  END;

  FUNCTION minutes_to_ms (p_minutes NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_minutes * c_ms_per_minute;
  END;

  FUNCTION hours_to_ms (p_hours NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN p_hours * c_ms_per_hour;
  END;

  ------------------------------------------------------------------------------
  -- Timestamp Difference
  ------------------------------------------------------------------------------
  FUNCTION diff_ms (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
    v_interval INTERVAL DAY(9) TO SECOND(9); -- Increased precision
  BEGIN
    v_interval := p_end_ts - p_start_ts;

    RETURN
        EXTRACT(DAY    FROM v_interval) * c_ms_per_day +
        EXTRACT(HOUR   FROM v_interval) * c_ms_per_hour +
        EXTRACT(MINUTE FROM v_interval) * c_ms_per_minute +
        EXTRACT(SECOND FROM v_interval) * c_ms_per_second;
  END;

  FUNCTION diff_seconds (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
  BEGIN
    RETURN diff_ms(p_start_ts, p_end_ts) / c_ms_per_second;
  END;

  FUNCTION diff_minutes (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER IS
  BEGIN
    RETURN diff_ms(p_start_ts, p_end_ts) / c_ms_per_minute;
  END;

  ------------------------------------------------------------------------------
  -- Epoch (Unix Time)
  ------------------------------------------------------------------------------
  FUNCTION ts_to_epoch_ms (p_ts TIMESTAMP) RETURN NUMBER IS
    -- Constant for Epoch Start
    c_epoch_start CONSTANT TIMESTAMP := TIMESTAMP '1970-01-01 00:00:00';
  BEGIN
    -- Reuse diff_ms to ensure milliseconds are calculated correctly
    -- CAST(date) would lose milliseconds
    RETURN diff_ms(c_epoch_start, p_ts);
  END;

  FUNCTION epoch_ms_to_ts (p_epoch_ms NUMBER) RETURN TIMESTAMP IS
  BEGIN
    RETURN
      TIMESTAMP '1970-01-01 00:00:00'
      + NUMTODSINTERVAL(p_epoch_ms / 1000, 'SECOND');
  END;

  ------------------------------------------------------------------------------
  -- Date Helpers
  ------------------------------------------------------------------------------
  FUNCTION now_utc RETURN TIMESTAMP IS
  BEGIN
    RETURN SYS_EXTRACT_UTC(SYSTIMESTAMP);
  END;

  FUNCTION start_of_day (p_date DATE) RETURN DATE IS
  BEGIN
    RETURN TRUNC(p_date);
  END;

  FUNCTION end_of_day (p_date DATE) RETURN DATE IS
  BEGIN
    -- Returns 23:59:59
    RETURN TRUNC(p_date) + INTERVAL '1' DAY - INTERVAL '1' SECOND;
  END;

  FUNCTION start_of_hour (p_ts TIMESTAMP) RETURN TIMESTAMP IS
  BEGIN
    RETURN TRUNC(p_ts, 'HH');
  END;

  FUNCTION start_of_min (p_ts TIMESTAMP) RETURN TIMESTAMP IS
  BEGIN
    RETURN TRUNC(p_ts, 'MI');
  END;

  FUNCTION is_weekend(p_date DATE) RETURN BOOLEAN IS
    v_day_num NUMBER;
  BEGIN
    -- 1=Sunday ... 7=Saturday (Standard Oracle US format, adjust NLS if needed)
    -- Using TO_CHAR(d, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') is safer if NLS varies
    v_day_num := TO_NUMBER(TO_CHAR(p_date, 'D')); 
    -- Assuming default NLS where 1 is Sun or 7 is Sat. 
    -- Better generic approach: check if 'SAT' or 'SUN' explicitly
    RETURN TO_CHAR(p_date, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') IN ('SAT', 'SUN');
  END;

  ------------------------------------------------------------------------------
  -- Formatting
  ------------------------------------------------------------------------------
  FUNCTION to_iso8601 (p_ts TIMESTAMP) RETURN VARCHAR2 IS
  BEGIN
    -- T literal must be quoted
    RETURN TO_CHAR(p_ts, 'YYYY-MM-DD"T"HH24:MI:SS.FF3');
  END;

END date_util;

/
