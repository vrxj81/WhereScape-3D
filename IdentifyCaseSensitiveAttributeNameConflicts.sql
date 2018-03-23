  -- =============================================================================
  -- DBMS Name      :    Any
  -- Script Name    :    IdentifyCaseSensitiveAttributeNameConflicts.sql
  -- Description    :    Custom report to Identify CaseSensitive Attribute Names
  -- Created on     :    Friday, March 23, 2018
  -- Author         :    Jack Howard
  -- =============================================================================
  -- Notes
  -- 
  -- History
  -- 1.0 Initial Version release
  --
  -- Advanced copy will fail without an explanation if there if a field named CUST_ID and a column named cust_id exists in 
  -- the same entity.
  -- As stupid as this sounds, it happens with XML and JSON ingestion because this is legal in their world.
  
SELECT upper(src_table_name), upper(src_column_name) 
FROM WB_SRC_COLUMN
   INNER JOIN WB_SRC_TABLE
      ON WB_SRC_COLUMN.SRC_TABLE_KEY = WB_SRC_TABLE.SRC_TABLE_KEY
   INNER JOIN WB_SRC_SYSTEM
      ON WB_SRC_TABLE.SRC_KEY = WB_SRC_SYSTEM.SRC_KEY
      AND (WB_SRC_SYSTEM.SRC_VERSION_ID = 'version_name' OR 'version_name' = '')
   INNER JOIN WB_OBJ_OBJECT
      ON WB_SRC_SYSTEM.OBJ_KEY = WB_OBJ_OBJECT.OBJ_KEY
      AND WB_OBJ_OBJECT.OBJ_NAME = 'src_name'
   INNER JOIN WB_OBJ_CATEGORY
      ON WB_OBJ_OBJECT.OBJ_CAT_KEY = WB_OBJ_CATEGORY.OBJ_CAT_KEY
      AND WB_OBJ_CATEGORY.OBJ_CAT_ID = 'cat_name'
GROUP BY upper(src_table_name), upper(src_column_name)
HAVING Count(*)>1
