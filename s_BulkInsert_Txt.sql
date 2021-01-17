CREATE PROCEDURE [dbo].[s_BulkInsert_Txt] (
	@tblname           AS NVARCHAR(150),
	@importfilepath    AS NVARCHAR(150),
	@companydb  	   AS NVARCHAR(100) 
)
AS

--=================================
--Author      : M. Reyhan Zalbina
--Description : Txt Bulk Insert
--=================================

BEGIN

SET NOCOUNT ON

DECLARE @me 	       AS NVARCHAR(100)
DECLARE @myparms       AS NVARCHAR(500)
DECLARE @myinfo        AS NVARCHAR(50)	

DECLARE @bulkinsert    AS NVARCHAR(500)
DECLARE @err_msg       AS NVARCHAR(50)
DECLARE @err_code      AS INT
	
DECLARE @rowcount      AS INT
	
SET @me = OBJECT_NAME(@@PROCID) + N'(0001.01) '
PRINT @me + @tblname + ', ' + @importfilepath + ', ' + @companydb

SET @err_code = 0
	
SET @bulkinsert = N'BULK INSERT ' + @tblname + N' FROM ' + QUOTENAME(@importfilepath, '''') +
					N' WITH ( FIRSTROW=1, FIELDTERMINATOR=' + QUOTENAME(CHAR(254), '''') + ',' +
					N' ROWTERMINATOR=' + QUOTENAME(CHAR(10), '''') + N'); SET @rowcount = @@rowcount'
											
BEGIN TRY 
     EXEC sp_executesql 
        @bulkinsert,
        N'@rowcount int output', 
        @rowcount OUTPUT
END TRY 

BEGIN CATCH
     SELECT @err_code = @@error
     EXECUTE S_sys_CatchImportErrorInfo @companydb, @me, @bulkinsert
     SET @err_msg = N'BULK INSERT statement failed.'
     PRINT @me + @err_msg + ' ' + @bulkinsert + ' ' + Cast(@err_code AS NVARCHAR(10)) + '.' + Error_Message()
END CATCH
	
SET @myinfo = N'Rows inserted ' + Cast(@rowcount AS NVARCHAR(10))
EXEC s_sys_WriteImportLogEntry @companydb, @me, @myparms, N'INFO', @myInfo, ''
		
RETURN @err_code
END
