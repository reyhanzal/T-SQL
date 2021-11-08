CREATE FUNCTION [tSQLs].[GetOriginalTableInfo]
(
     @TableObjectId INT
)
RETURNS TABLE
AS
RETURN 
BEGIN

  SELECT CAST(value AS NVARCHAR(4000)) OrgTableName,
          OBJECT_ID(QUOTENAME(OBJECT_SCHEMA_NAME(@TableObjectId)) + '.' +
          QUOTENAME(CAST(value AS NVARCHAR(4000)))) OrgTableObjectId
  FROM sys.extended_properties
  WHERE class_desc = 'OBJECT_OR_COLUMN'
  AND major_id = @TableObjectId
  AND minor_id = 0
  AND name = 'tSQLs.FakeTable_OrgTableName';
  
END
