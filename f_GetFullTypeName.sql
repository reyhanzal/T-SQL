CREATE FUNCTION [tSQLs].[GetFullTypeName]
(
     @TypeId          INT
    ,@Length          INT
    ,@Precision       INT
    ,@Scale           INT
    ,@CollationName   NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN 
BEGIN

  SELECT SchemaName + '.' + Name + Suffix + Collation AS TypeName, SchemaName, Name, Suffix
  FROM(
    SELECT QUOTENAME(SCHEMA_NAME(schema_id)) SchemaName, QUOTENAME(name) Name,
        CASE WHEN max_length = -1
              THEN ''
             WHEN @Length = -1
              THEN '(MAX)'
             WHEN name LIKE 'n%char'
              THEN '(' + CAST(@Length / 2 AS NVARCHAR) + ')'
             WHEN name LIKE '%char' OR name LIKE '%binary'
              THEN '(' + CAST(@Length AS NVARCHAR) + ')'
             WHEN name IN ('decimal', 'numeric')
              THEN '(' + CAST(@Precision AS NVARCHAR) + ',' + CAST(@Scale AS NVARCHAR) + ')'
             ELSE ''
         END Suffix,
        CASE WHEN @CollationName IS NULL THEN ''
             ELSE ' COLLATE ' + @CollationName
         END Collation
    FROM sys.types WHERE user_type_id = @TypeId
  ) Z
  
END
