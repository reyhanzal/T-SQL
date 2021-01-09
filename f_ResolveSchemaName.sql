CREATE FUNCTION [tSQLs].[ResolveSchemaName] (
	@Name NVARCHAR(MAX)
)
RETURNS TABLE 
AS
RETURN

WITH abc (
	schemaId
)
AS
(
	SELECT tSQLs.GetSchemaId(@Name)
),

abcWithNames (
	schemaId,
	quotedSchemaName
) 
AS
(
	SELECT schemaId, QUOTENAME(SCHEMA_NAME(schemaId))
    FROM abc
)
  

SELECT schemaId, 
       quotedSchemaName,
       CASE WHEN EXISTS(SELECT 1 FROM tSQLt.TestClasses WHERE TestClasses.SchemaId = abcWithNames.schemaId)
         THEN 1
       ELSE 0
       END AS isTestClass, 
         CASE WHEN schemaId IS NOT NULL THEN 1 ELSE 0 END AS isSchema
FROM abcWithNames;