CREATE FUNCTION [tSQL].[GetForeignKeyDefinition] (
    @SchemaName NVARCHAR(MAX),
    @ParentTableName NVARCHAR(MAX),
    @ForeignKeyName NVARCHAR(MAX)
)
RETURNS TABLE
AS
RETURN 

SELECT 'CONSTRAINT ' + name + ' FOREIGN KEY (' + parCol + 
  ') REFERENCES ' + refName + '(' + refCol + ')' cmd,
  CASE 
   WHEN RefTableIsFaked = 1 THEN 'CREATE UNIQUE INDEX ' + 
      tSQLt.Private::CreateUniqueObjectName() + ' ON ' + 
      refName + '(' + refCol + ');'
   ELSE '' 
  END STbl
FROM (
   SELECT QUOTENAME(SCHEMA_NAME(A.schema_id)) AS SchemaName,
	 QUOTENAME(A.name) AS name,
	 QUOTENAME(OBJECT_NAME(A.parent_object_id)) AS parName,
	 QUOTENAME(SCHEMA_NAME(E.schema_id)) + '.' + QUOTENAME(E.name) AS refName,
	 QUOTENAME(C.name) AS parCol,
	 QUOTENAME(D.name) AS refCol,
     CASE 
       WHEN F.name IS NULL THEN 0
     ELSE 1 
     END AS RefTableIsFaked
   FROM sys.foreign_keys A 
   JOIN sys.foreign_key_columns B ON A.object_id = B.constraint_object_id
   JOIN sys.columns C ON C.object_id = B.parent_object_id AND C.column_id = B.parent_column_id
   JOIN sys.columns D ON D.object_id = B.referenced_object_id AND D.column_id = B.referenced_column_id
   JOIN sys.tables E ON COALESCE(F.major_id,D.object_id) = E.object_id
   LEFT JOIN sys.extended_properties F ON F.name = 'tSQL.FakeTable_OrgTableName' AND F.value = OBJECT_NAME(B.referenced_object_id)
WHERE A.parent_object_id = OBJECT_ID(@SchemaName + '.' + @ParentTableName)
AND A.object_id = OBJECT_ID(@SchemaName + '.' + @ForeignKeyName)
) Z;