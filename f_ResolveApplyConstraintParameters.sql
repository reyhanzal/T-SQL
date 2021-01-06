CREATE FUNCTION [tSQL].[ResolveApplyConstraintParameters] (
	@A NVARCHAR(MAX),
	@B NVARCHAR(MAX),
	@C NVARCHAR(MAX)
)
RETURNS TABLE
AS 
RETURN

SELECT ConstraintObjectId, ConstraintType
FROM tSQLs.FindConstraint(OBJECT_ID(@A), @B)
WHERE @C IS NULL

UNION ALL

SELECT *
FROM tSQLs.FindConstraint(OBJECT_ID(@A + '.' + @B), @C)

UNION ALL

SELECT *
FROM tSQLs.FindConstraint(OBJECT_ID(@C + '.' + @A), @B);