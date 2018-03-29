  -- =============================================================================
  -- DBMS Name      :    Any
  -- Script Name    :    ListTablesWithIndexes.sql
  -- Description    :    Custom report to list tables with data that have indexes
  -- Created on     :    Thursday, August 17, 2018
  -- Author         :    Jack Howard
  -- =============================================================================
  -- Notes
  -- 
  -- History
  -- 1.0 Initial Version release
  --
  --   
-- 8/14/2017  
-- List tables with Indexes where Table Row Count > 0

-- 8/14/2017  
-- List tables with Indexes where Table Row Count > 0

SELECT
  T.SRC_TABLE_NAME
  , COUNT(*) as IndexCount
  , T.SRC_TABLE_ROWCOUNT
  , I.SRC_INDEX_TYPE_INFORMATION
  , T.SRC_TABLE_SCHEMA
  , T.SRC_TABLE_DATABASE
  , T.SRC_TABLE_COMMENT
FROM
  WB_SRC_INDEX I
  INNER JOIN WB_SRC_TABLE T
    ON I.SRC_TABLE_KEY = T.SRC_TABLE_KEY
  INNER JOIN WB_SRC_SYSTEM
    ON T.SRC_KEY = WB_SRC_SYSTEM.SRC_KEY
    AND (WB_SRC_SYSTEM.SRC_VERSION_ID = 'version_name' OR 'version_name' = '')
  INNER JOIN WB_OBJ_OBJECT
    ON WB_SRC_SYSTEM.OBJ_KEY = WB_OBJ_OBJECT.OBJ_KEY
    AND WB_OBJ_OBJECT.OBJ_NAME = 'src_name'
  INNER JOIN WB_OBJ_CATEGORY
    ON WB_OBJ_OBJECT.OBJ_CAT_KEY = WB_OBJ_CATEGORY.OBJ_CAT_KEY
    AND WB_OBJ_CATEGORY.OBJ_CAT_ID = 'cat_name'
WHERE 
    T.SRC_TABLE_ROWCOUNT > 0  AND
    T.SRC_TABLE_ROWCOUNT is not null
GROUP BY
  T.SRC_TABLE_SCHEMA
, T.SRC_TABLE_DATABASE
, T.SRC_TABLE_NAME
, T.SRC_TABLE_COMMENT
,  T.SRC_TABLE_ROWCOUNT
, I.SRC_INDEX_TYPE_INFORMATION
ORDER BY
  T.SRC_TABLE_ROWCOUNT desc