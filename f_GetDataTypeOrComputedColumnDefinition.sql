CREATE FUNCTION [tSQLs].[GetDataTypeOrComputedColumnDefinition]
(
     @UserTypeId      INT
    ,@MaxLength       INT
    ,@Precision       INT
    ,@Scale           INT
    ,@CollationName   NVARCHAR(MAX)
    ,@ObjectId        INT
    ,@ColumnId        INT
    ,@ReturnDetails   BIT
)
RETURNS TABLE
AS
RETURN 

SELECT COALESCE(IsComputedColumn, 0) AS IsComputedColumn,
 COALESCE(ComputedColumnDefinition, TypeName) AS ColumnDefinition
   FROM tSQLs.GetFullTypeName(@UserTypeId, @MaxLength, @Precision, @Scale, @CollationName)
     LEFT JOIN (SELECT 1 AS IsComputedColumn,' AS '+ definition + CASE WHEN is_persisted = 1 
		  THEN ' PERSISTED' ELSE '' 
		    END AS ComputedColumnDefinition,object_id,column_id
		FROM sys.computed_columns 
               ) A
ON A.object_id = @ObjectId
AND A.column_id = @ColumnId
AND @ReturnDetails = 1;
