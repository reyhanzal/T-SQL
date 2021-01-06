CREATE FUNCTION [tSQL].[GetIdentityDefinition] (
	@ObjectId INT,
	@ColumnId INT,
	@ReturnDetails BIT
)
RETURNS TABLE
AS
RETURN
 
SELECT COALESCE(IsIdentity, 0) AS IsIdentityColumn,
 COALESCE(IdentityDefinition, '') AS IdentityDefinition
FROM (SELECT 1) X(X)
LEFT JOIN (SELECT 1 AS IsIdentity,
			' IDENTITY(' + CAST(seed_value AS NVARCHAR(MAX)) + ',' + 
			CAST(increment_value AS NVARCHAR(MAX)) + ')' AS IdentityDefinition, 
			OBJECT_ID, column_id
           FROM sys.identity_columns
          ) AS A
ON A.OBJECT_ID = @ObjectId
AND A.column_id = @ColumnId
AND @ReturnDetails = 1;