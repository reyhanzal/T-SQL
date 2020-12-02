CREATE PROCEDURE [dbo].[s_Excel_Import] (
    @DB_NAME AS NVARCHAR(100),
    @FILE_PATH AS NVARCHAR(100),
    @TABLE_NAME AS NVARCHAR(100),
    @SHEET_NAME AS NVARCHAR(50)
)
AS
BEGIN

--=======================================
--Author       : M. Reyhan Zalbina
--Description  : Bulk Insert Excel File
--=======================================

SET NOCOUNT ON;

DECLARE @sql AS NVARCHAR(MAX)
        ,@ME AS NVARCHAR(100)
        ,@PARAMS AS NVARCHAR(500)
		,@ROW AS NVARCHAR(10)
		,@INFO AS NVARCHAR(150)
		,@ERR_MSG AS NVARCHAR(50)
		,@ERR_CODE AS INT

DECLARE @rowcount AS INT

SET @ME = OBJECT_NAME(@@PROCID) + N' (0001.00) '
SET @PARAMS = @TABLE_NAME + ', ' + @FILE_PATH + ', ' + @DB_NAME
PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + @PARAMS
  
EXEC [dbo].[s_sys_WriteImportLogEntry] @DB_NAME, @ME, @PARAMS, N'INIT', '', ''

SELECT @ERR_CODE = 0, @rowcount = 0

BEGIN TRY
SET @sql =  N'INSERT INTO ' + 'dbo.' + @TABLE_NAME + ' ' +
	        N'SELECT * ' + N'FROM OPENROWSET(''' +
	        N'Microsoft.ACE.OLEDB.12.0''' +',''Excel 12.0;Database=' + @FILE_PATH + ''',' +
			N'''SELECT * FROM ' + '[' +	@SHEET_NAME + '$]''' +
				N') ; SET @rowcount = @@ROWCOUNT'

EXEC sp_executesql @sql, 
	    N'@rowcount int output',
		@rowcount OUTPUT
END TRY

BEGIN CATCH
SELECT @ERR_CODE = @@ERROR
EXECUTE s_sys_CatchErrorInfo @DB_NAME, N'ErrorLog', @ME, @sql
SET @ERR_MSG='Excel insert statement failed.'
PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + @ERR_MSG + ' ' 
	+ @sql + ' ' + Cast(@ERR_CODE AS VARCHAR(10)) + '.' + Error_Message() 
END CATCH

SET @ROW = CAST(@rowcount AS VARCHAR(10))
SET @INFO = N'Row(s) inserted ' + @ROW + ' ' + @TABLE_NAME
EXEC s_sys_WriteImportLogEntry @DB_NAME, @ME, @PARAMS, N'INFO', @INFO, ''
  
RETURN @ERR_CODE   
END
GO
