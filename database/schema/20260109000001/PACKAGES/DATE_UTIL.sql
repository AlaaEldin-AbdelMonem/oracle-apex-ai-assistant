--------------------------------------------------------
--  DDL for Package DATE_UTIL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "DATE_UTIL" IS
/**
 * date_util
 *
 * A generic utility package for high-precision date and timestamp manipulation.
 * Handles conversions between Units, Epochs, and ISO formats.
 *
 * @author  Development Team
 * @version 1.1
 */

  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  c_ms_per_second CONSTANT NUMBER := 1000;
  c_ms_per_minute CONSTANT NUMBER := 60000;
  c_ms_per_hour   CONSTANT NUMBER := 3600000;
  c_ms_per_day    CONSTANT NUMBER := 86400000;

  ------------------------------------------------------------------------------
  -- Duration Conversions
  ------------------------------------------------------------------------------
  /**
   * Converts milliseconds to seconds.
   * @param p_ms Number of milliseconds.
   * @return Number of seconds.
   */
  FUNCTION ms_to_seconds (p_ms NUMBER) RETURN NUMBER;
  FUNCTION ms_to_minutes (p_ms NUMBER) RETURN NUMBER;
  FUNCTION ms_to_hours   (p_ms NUMBER) RETURN NUMBER;

  FUNCTION seconds_to_ms (p_seconds NUMBER) RETURN NUMBER;
  FUNCTION minutes_to_ms (p_minutes NUMBER) RETURN NUMBER;
  FUNCTION hours_to_ms   (p_hours   NUMBER) RETURN NUMBER;

  ------------------------------------------------------------------------------
  -- Timestamp Difference
  ------------------------------------------------------------------------------
  /**
   * Calculates the difference between two timestamps in milliseconds.
   *
   * Example:
   * v_diff := date_util.diff_ms(v_start_time, SYSTIMESTAMP);
   *
   * @param p_start_ts The starting timestamp.
   * @param p_end_ts   The ending timestamp (Default: SYSTIMESTAMP).
   * @return Difference in milliseconds.
   */
  FUNCTION diff_ms (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  FUNCTION diff_seconds (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  FUNCTION diff_minutes (
      p_start_ts IN TIMESTAMP,
      p_end_ts   IN TIMESTAMP DEFAULT SYSTIMESTAMP
  ) RETURN NUMBER;

  ------------------------------------------------------------------------------
  -- Epoch (Unix Time)
  ------------------------------------------------------------------------------
  /**
   * Converts a Timestamp to Unix Epoch (milliseconds since 1970-01-01).
   * PRESERVES millisecond precision.
   *
   * @param p_ts Input timestamp (assumed to be relevant to UTC if not specified).
   * @return Number representing epoch milliseconds.
   */
  FUNCTION ts_to_epoch_ms (p_ts TIMESTAMP) RETURN NUMBER;

  /**
   * Converts Unix Epoch milliseconds back to a Timestamp.
   *
   * @param p_epoch_ms Epoch milliseconds.
   * @return Timestamp.
   */
  FUNCTION epoch_ms_to_ts (p_epoch_ms NUMBER) RETURN TIMESTAMP;

  ------------------------------------------------------------------------------
  -- Date Helpers
  ------------------------------------------------------------------------------
  /** Returns current timestamp in UTC (useful for consistent logging). */
  FUNCTION now_utc RETURN TIMESTAMP;

  FUNCTION start_of_day (p_date DATE) RETURN DATE;
  
  /** * Returns the very last second of the day (23:59:59). 
   * Note: For high precision timestamps, compare using < start_of_next_day instead.
   */
  FUNCTION end_of_day   (p_date DATE) RETURN DATE;

  FUNCTION start_of_hour (p_ts TIMESTAMP) RETURN TIMESTAMP;
  FUNCTION start_of_min  (p_ts TIMESTAMP) RETURN TIMESTAMP;

  /** Returns TRUE if the date falls on Saturday or Sunday. */
  FUNCTION is_weekend(p_date DATE) RETURN BOOLEAN;

  ------------------------------------------------------------------------------
  -- Formatting
  ------------------------------------------------------------------------------
  /**
   * Formats timestamp as ISO8601 string (YYYY-MM-DDTHH:MI:SS.FF3).
   * Example: '2023-10-05T14:30:00.123'
   */
  FUNCTION to_iso8601 (p_ts TIMESTAMP) RETURN VARCHAR2;

END date_util;

/
