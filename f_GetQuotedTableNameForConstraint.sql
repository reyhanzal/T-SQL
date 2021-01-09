CREATE FUNCTION [tSQLs].[GetQuotedTableNameForConstraint] (
	@ConstraintObjectId INT
)
RETURNS TABLE
AS
RETURN

SELECT QUOTENAME(SCHEMA_NAME(C.schema_id)) + '.' + QUOTENAME(OBJECT_NAME(C.object_id)) QuotedTableName,
  SCHEMA_NAME(C.schema_id) SchemaName,
  OBJECT_NAME(C.object_id) TableName,
  OBJECT_NAME(A.parent_object_id) OrgTableName
FROM sys.objects AS A
JOIN sys.extended_properties AS B
JOIN sys.objects AS C
ON C.object_id = B.major_id
AND B.minor_id = 0 AND B.class_desc = 'OBJECT_OR_COLUMN' AND B.name = 'tSQL.FakeTable_OrgTableName'
ON OBJECT_NAME(A.parent_object_id) = CAST(B.value AS NVARCHAR(4000))
AND A.schema_id = C.schema_id
AND A.object_id = @ConstraintObjectId;