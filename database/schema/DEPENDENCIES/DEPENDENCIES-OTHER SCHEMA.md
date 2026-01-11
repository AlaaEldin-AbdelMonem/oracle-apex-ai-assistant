

# AI_VECTOR_UTIL

- contains a complete, production-ready solution for centralizing AI model access across multiple Oracle schemas. Instead of loading ONNX models in each schema, you have one central AI schema that provides embedding and vector services to all consumer schemas.
  

CREATE OR REPLACE PUBLIC SYNONYM AI_VECTOR_UTIL 
FOR [Your_schema].AI_VECTOR_UTIL;



--They refer to ai engine schema for Chunking , I didnot install here , I did it in a separate schema to be centralized to all application schemas
-- https://github.com/alaaeldin-abdelmonem/oracle-db-ai-vector-wrapper

GRANT Execute on AI.AI_VECTOR_UTIL to  [Your_schema]

CREATE OR REPLACE  SYNONYM AI_VECTOR_UTIL 
FOR AI.AI_VECTOR_UTIL;