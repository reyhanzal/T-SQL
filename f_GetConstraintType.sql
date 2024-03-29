CREATE FUNCTION [tSQLs].[GetConstraintType]
(
   @TableObjectId INT 
  ,@ConstraintName NVARCHAR(MAX)
)
RETURNS TABLE
AS
BEGIN
RETURN
  SELECT object_id,type,type_desc
  FROM sys.objects 
  WHERE object_id = OBJECT_ID(SCHEMA_NAME(schema_id)+'.'+@ConstraintName)
  AND parent_object_id = @TableObjectId;
END
