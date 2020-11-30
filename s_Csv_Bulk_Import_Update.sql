CREATE PROCEDURE [dbo].[s_Csv_Bulk_Import_Update] (
		@PathName VARCHAR(500)
)
AS

--=================================
--Author      : M. Reyhan Zalbina
--Description : Bulk Import CSV
--=================================

--Simple Usage
--EXEC [dbo].[s_Csv_Bulk_Import_Update] 'D:\IMPORT\PATH\SUBPATH\' 

DECLARE  @sql NVARCHAR(MAX)
		,@tablename VARCHAR(2000)
		,@columnname VARCHAR(2000)
		,@filename VARCHAR(2000)
		,@errormsg VARCHAR(MAX)
		,@FirstFileName VARCHAR(100)
		,@ThreadCount INT = 0

BEGIN TRY
SET @sql = ''
	SELECT @sql = @sql + ' DROP TABLE [' + SCHEMA_NAME(schema_id) + '].[' + name + '] ; '  
	FROM sys.tables  WHERE name LIKE 'BNK[_]%' AND schema_name(schema_id) <> 'BS'
	EXEC (@sql) 
END TRY
BEGIN CATCH
	SET @errormsg = 'Error ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
	RAISERROR (@errormsg,
		11,
		1);
	RETURN
END CATCH

BEGIN TRY
	CREATE TABLE BNK_HASH_TOTAL
	(YOUR_COLUMN_NAME NVARCHAR(2000), TOTAL_RECORDS INT, START_TIME TIME, END_TIME TIME, ELAPSED_TIME TIME, HASH_TOT_FLD NVARCHAR(2000), HASH_TOTAL NVARCHAR(2000)) 

	SET @sql = N'BULK INSERT [BNK_HASH_TOTAL] FROM ' + QUOTENAME( @PathName + '\CSV_FILE_SAMPLE.csv' , '''') +
			    N' WITH ( FIRSTROW=2, FIELDTERMINATOR=' + QUOTENAME(CHAR(126), '''') + ',' +
				 N' ROWTERMINATOR=' + QUOTENAME(CHAR(13) + CHAR(10), '''') + N',CODEPAGE=''Row'' , DATAFILETYPE=''WideChar'' , Tablock );'
	PRINT(@sql)
	EXEC (@sql)
END TRY
BEGIN CATCH
	SET @errormsg = 'Error - BNK_HASH_TOTAL csv file is not available ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
	RAISERROR (@errormsg,
		11,
		1);
	RETURN
END CATCH
		
IF OBJECT_ID('tempdb..#ListOfColumns') IS NOT NULL
DROP TABLE #ListOfColumns

CREATE TABLE #ListOfColumns (columnname NVARCHAR(2000) , Columnorder NVARCHAR(2000))

BEGIN TRY
SELECT @sql = N'SELECT @filename = max(YOUR_COLUMN_NAME) FROM BNK_HASH_TOTAL WHERE YOUR_COLUMN_NAME LIKE ''BNK_VERSION%'''
EXEC sp_ExecuteSql @sql, N'@filename varchar (2000) output', @filename OUTPUT
			
SET @sql = N'BULK INSERT #listOfColumns FROM ' + QUOTENAME( @PathName + '\' + @filename + '.txt', '''')  +
						N' WITH ( FIRSTROW=1, FIELDTERMINATOR=' + QUOTENAME(CHAR(254), '''') + ',' +
						N' ROWTERMINATOR=' + QUOTENAME(CHAR(10), '''') + N');'
				
EXEC(@sql)
END TRY
BEGIN CATCH
	SET @errormsg = 'Error - last expected csv file is not available ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
	RAISERROR (@errormsg,
		10,
		1);
	RETURN
END CATCH

DELETE FROM #listOfColumns

DECLARE TableList CURSOR FOR 
SELECT LEFT(YOUR_COLUMN_NAME, LEN(YOUR_COLUMN_NAME) -5 ) AS TableName , MIN(YOUR_COLUMN_NAME ) AS FirstFileName 
FROM YOUR_TABLE_NAME
WHERE total_records > 0
group by LEFT(YOUR_COLUMN_NAME , len (YOUR_COLUMN_NAME) -5 )
ORDER BY TableName ASC

OPEN TableList 
FETCH NEXT FROM TableList INTO @tableName, @FirstFileName

WHILE (@@FETCH_STATUS = 0)
BEGIN
	IF OBJECT_ID(@tablename) IS NULL
	BEGIN 
		BEGIN TRY
			SET @sql = N'BULK INSERT #listOfColumns FROM ' + QUOTENAME( @PathName + '\' + @FirstFileName + '.txt', '''')  +
									N' WITH ( FIRSTROW=1, FIELDTERMINATOR=' + QUOTENAME(CHAR(254), '''') + ',' +
									N' ROWTERMINATOR=' + QUOTENAME(CHAR(10), '''') + N');'
			EXEC (@sql)
		END TRY
		BEGIN CATCH
			SET @errormsg = 'Error ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
			RAISERROR (@errormsg,
				11,
				1);
			RETURN	
		END CATCH
		BEGIN TRY			
			SET @sql = ''
			SELECT @sql = @sql + ', [' + columnname + '] NVARCHAR(MAX)' FROM #listOfColumns
			
			SET @sql = 'CREATE TABLE [' + @tablename + '] ( [YOUR_COLUMN_NAME] VARCHAR(MAX), [YOUR_COLUMN_NAME] VARCHAR(MAX), [YOUR_COLUMN_NAME] VARCHAR(MAX) '  + @sql   + '); '
			EXEC (@sql)
		END TRY
		BEGIN CATCH
			SET @errormsg = 'Error ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
			RAISERROR (@errormsg,
				11,
				1);
			RETURN					
		END CATCH
	END 

	DECLARE FileList CURSOR FOR 
	SELECT YOUR_COLUMN_NAME
	FROM YOUR_TABLE_NAME
	WHERE total_records > 0 AND LEFT(YOUR_COLUMN_NAME , LEN(YOUR_COLUMN_NAME) -5 ) = @Tablename 
	ORDER BY YOUR_COLUMN_NAME DESC

	SET @sql = 'USE [YOUR_DB_NAME]; ' 

	OPEN fileList 
	FETCH NEXT FROM FileList INTO @FileName

	WHILE (@@FETCH_STATUS = 0)
	BEGIN
		SET @sql = @sql + N' if @NumThreads = '+ cast(@ThreadCount AS VARCHAR(50)) + '
                            BEGIN
							BULK INSERT [' + @tablename + '] FROM ' + QUOTENAME( @PathName + '\' + @filename + '.csv', '''')  +
								N' WITH ( FIRSTROW=2, FIELDTERMINATOR=' + QUOTENAME(CHAR(126), '''') + ',' +
								N' ROWTERMINATOR=' + QUOTENAME(CHAR(13) + CHAR(10), '''') + N',CODEPAGE=''Row'' , DATAFILETYPE=''WideChar'' , Tablock );
							END '

		SET @ThreadCount = @ThreadCount + 1 
		FETCH NEXT FROM FileList INTO @FileName
	END 

		BEGIN TRY
			EXEC [YOUR_DB_NAME].dbo.s_ExecuteInParallel @sql , @ThreadCount
		END TRY
		BEGIN CATCH
			SET @errormsg = 'Error ('+ERROR_MESSAGE()+ ') Executing: ' + @sql + ' '
			RAISERROR (@errormsg,
				11, -- Severity,
				1); -- State,	
			RETURN			
		END CATCH

	SET @ThreadCount = 0 
	DELETE FROM #listOfColumns
	CLOSE FileList 
	DEALLOCATE FileList
	FETCH NEXT FROM TableList  INTo  @tableName, @FirstFileName

END 
CLOSE TableList 
DEALLOCATE TableList
