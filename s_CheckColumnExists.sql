CREATE PROCEDURE [dbo].[s_CheckColumnExists]
(
   @ColName AS NVARCHAR(50), 
   @TblName AS NVARCHAR(50), 
   @DBName  AS NVARCHAR(50)	
)
AS
BEGIN

SET NOCOUNT ON;
   
  DECLARE @SQL        NVARCHAR(2000)
  DECLARE @Me         NVARCHAR(100)
  DECLARE @Err_code   INT
  DECLARE @Err_msg    NVARCHAR(500)
		
  SET @err_code = 0
  SET @me = OBJECT_NAME(@@PROCID) + N' (1102.00) '

  BEGIN TRY
    SET @SQL = N'SELECT TOP 1 1 FROM [' + @DBName + '].information_schema.columns ' +
	            N'WHERE [Table_Name]=' + QUOTENAME(@TblName,'''') + N' AND [Column_Name]=' + QUOTENAME(@ColName, '''')
    EXEC (@SQL)
    
    IF @@ROWCOUNT = 1 RETURN 1
    ELSE RETURN 0
  END TRY
  BEGIN CATCH
    SELECT @err_code = @@error
    PRINT @me + N'SQL statement failed. ' + @SQL + N' ' + Error_Message()
    RETURN -1
  END CATCH
  
  RETURN 0
END
