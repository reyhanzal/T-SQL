CREATE FUNCTION [tSQLs].[GetDefaultConstraintDefinition]
(
     @ObjectId        INT
    ,@ColumnId        INT
    ,@ReturnDetails   BIT
)
RETURNS TABLE
AS
RETURN

SELECT COALESCE(IsDefault, 0) AS IsDefault,
  COALESCE(DefaultDefinition, '') AS DefaultDefinition
    FROM (SELECT 1) X(X)
       LEFT JOIN (SELECT 1 AS IsDefault,' DEFAULT ' + 
                    definition AS DefaultDefinition,
                      parent_object_id, parent_column_id
		  FROM sys.default_constraints
                 ) A
ON A.parent_object_id = @ObjectId
AND A.parent_column_id = @ColumnId
AND @ReturnDetails = 1;
