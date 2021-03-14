CREATE PROCEDURE [dbo].[s_Drop_Indexes]
(
   @SchemaName NVARCHAR(255) = 'dbo', 
   @TableName NVARCHAR(255) = NULL
)
AS
BEGIN

  SET NOCOUNT ON;

  CREATE TABLE #CmdTbl
  (
      Id  INT IDENTITY(1,1) PRIMARY KEY CLUSTERED, 
      Cmd NVARCHAR(2000)
  )

  DECLARE @CurrentCommand NVARCHAR(2000)

  INSERT INTO #CmdTbl (Cmd)
  SELECT 'DROP INDEX [' + i.name + '] ON [' + SCHEMA_NAME(t.schema_id) + '].[' + t.name + ']'
  FROM sys.tables t INNER JOIN sys.indexes i ON t.object_id = i.object_id
  WHERE i.type = 2
  AND SCHEMA_NAME(t.schema_id) = COALESCE(@SchemaName, SCHEMA_NAME(t.schema_id))
  AND t.name = COALESCE(@TableName, t.name);

  INSERT INTO #CmdTbl (Command)
  SELECT 'DROP STATISTICS ' + SCHEMA_NAME(t.schema_id) + '.'  + OBJECT_NAME(s.object_id) + '.' + s.name
  FROM sys.stats AS s INNER JOIN sys.tables AS t ON s.object_id = t.object_id
  WHERE NOT EXISTS (SELECT * FROM sys.indexes AS i WHERE i.name = s.name) 
  AND SCHEMA_NAME(t.schema_id) = COALESCE(@SchemaName, SCHEMA_NAME(t.schema_id))
  AND t.name = COALESCE(@TableName, t.name)
  AND OBJECT_NAME(s.object_id) NOT LIKE 'sys%'
  DECLARE result_cursor CURSOR FOR
  SELECT Cmd FROM #CmdTbl

  OPEN result_cursor
  FETCH NEXT FROM result_cursor into @CurrentCommand
  WHILE @@FETCH_STATUS = 0
  BEGIN
     PRINT @CurrentCommand;
     EXEC(@CurrentCommand)

     FETCH NEXT FROM result_cursor into @CurrentCommand
  END

  CLOSE result_cursor
  DEALLOCATE result_cursor
END
