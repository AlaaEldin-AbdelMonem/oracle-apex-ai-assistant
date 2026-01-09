--------------------------------------------------------
--  DDL for Type T_CHUNK_RECORD
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE TYPE "AI8P"."T_CHUNK_RECORD" AS OBJECT (
  chunk_id        NUMBER,
  chunk_sequence  NUMBER,
  chunk_text      CLOB,
  chunk_size      NUMBER,
  start_position  NUMBER,
  end_position    NUMBER,
  metadata_json   CLOB
)

/
