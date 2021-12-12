CREATE FUNCTION [tSQLs].[ResolveFakeTableNamesForBackwardCompatibility]
(
     @TableName    NVARCHAR(MAX)
    ,@SchemaName   NVARCHAR(MAX)
)
RETURNS TABLE AS 
RETURN
BEGIN
  SELECT QUOTENAME(OBJECT_SCHEMA_NAME(object_id)) AS ClnSchemaName,
  QUOTENAME(OBJECT_NAME(object_id)) AS ClnTableName
  FROM (SELECT CASE
        WHEN @SchemaName IS NULL THEN OBJECT_ID(@TableName)
        ELSE COALESCE(OBJECT_ID(@SchemaName + '.' + @TableName),OBJECT_ID(@TableName + '.' + @SchemaName)) 
        END object_id
  ) A
END
