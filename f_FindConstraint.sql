CREATE FUNCTION [tSQLs].[FindConstraint]
(
   @TableObjectId  INT
  ,@ConstraintName NVARCHAR(MAX)
)
RETURNS TABLE
AS
BEGIN
RETURN
  SELECT TOP(1) constraints.object_id AS ConstraintObjectId, type_desc AS ConstraintType
  FROM sys.objects constraints
  CROSS JOIN tSQLs.GetOriginalTableInfo(@TableObjectId) orgTbl
  WHERE @ConstraintName IN (constraints.name, QUOTENAME(constraints.name))
  AND constraints.parent_object_id = orgTbl.OrgTableObjectId
  ORDER BY LEN(constraints.name) ASC;
END
