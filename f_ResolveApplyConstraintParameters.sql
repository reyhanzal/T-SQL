CREATE FUNCTION [tSQLs].[ResolveApplyConstraintParameters] (
	@A NVARCHAR(MAX),
	@B NVARCHAR(MAX),
	@C NVARCHAR(MAX)
)
RETURNS TABLE
AS 
RETURN
BEGIN
  SELECT ConstraintObjectId, ConstraintType
  FROM tSQLs.FindConstraint(OBJECT_ID(@A), @B)
  WHERE @C IS NULL
  UNION ALL
  SELECT *
  FROM tSQLs.FindConstraint(OBJECT_ID(@A + '.' + @B), @C)
  UNION ALL
  SELECT *
  FROM tSQLs.FindConstraint(OBJECT_ID(@C + '.' + @A), @B)
END
