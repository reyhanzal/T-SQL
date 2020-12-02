CREATE PROCEDURE [dbo].[s_WriteImportLogEntry] (
	@COMPONENT   NVARCHAR(100),
	@PARAM       NVARCHAR(500) = N'(NONE)', 
	@LOGTYPE     NVARCHAR(50) = N'(UNKNOWN)',
	@NARRATIVE   NVARCHAR(1500), 	
	@ROWCOUNT    INT
)
AS
BEGIN

--===================================
--Author      : M. Reyhan Zalbina
--Description : Log Entry Import
--===================================

SET NOCOUNT ON

DECLARE @ME AS NVARCHAR(100)
        ,@sql AS NVARCHAR(MAX)
  
SET @LOGTYPE = UPPER(@LOGTYPE)
SET @ME = OBJECT_NAME(@@PROCID) + N' (1000.00) '
PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + ', ' + @COMPONENT + ', ' + @PARAM + 
                ', ' + @LOGTYPE + ', ' + @NARRATIVE + ', ' + CAST(@ROWCOUNT AS NVARCHAR(10))
  
SET @PARAM = REPLACE(LTRIM(RTRIM(@PARAM)), '''', '"')
SET @PARAM = REPLACE(@PARAM, ',', ';')
	
SET @NARRATIVE = REPLACE(LTRIM(RTRIM(@NARRATIVE)), '''', '"')
SET @NARRATIVE = REPLACE(@NARRATIVE, ',', ';')

SET @sql = N'INSERT INTO [YOUR_DATABASE_NAME].dbo.[PRODUCT_LOG]'
SET @sql = @sql + N' ([DateTime],[EntryParameters],[LogType],[Narrative],[RowInserted])'
SET @sql = @sql + N' VALUES(GetDate(),' + LTRIM(RTRIM(@COMPONENT)) + ''',N''' + @PARAM + ''',N''' 
	            + LTRIM(RTRIM(@LOGTYPE)) + ''',N''' + @NARRATIVE + ''',N''' + CAST(@ROWCOUNT AS NVARCHAR(10)) + ''')'
		
EXEC sp_executesql @sql

END
