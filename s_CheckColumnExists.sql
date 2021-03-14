CREATE PROCEDURE [dbo].[s_CheckColumnExists]
(
	  @ColName AS NVARCHAR(50), 
	  @TblName AS NVARCHAR(50), 
	  @DBName  AS NVARCHAR(50)	
)
AS
BEGIN
   SET NOCOUNT ON
   
   DECLARE @SQL       AS NVARCHAR(2000)
   DECLARE @Me		    AS NVARCHAR(100)
   DECLARE @Err_code  AS INT
   DECLARE @Err_msg   AS NVARCHAR(500)
		
   SET @Err_code = 0
   SET @Me = OBJECT_NAME(@@PROCID) + N' (1102.00) '

	BEGIN TRY
		 SET @SQL = N'SELECT TOP 1 1 FROM [' + @DBName + '].information_schema.columns ' +
				        N'WHERE [Table_Name]=' + QUOTENAME(@TblName,'''') + N' AND [Column_Name]=' + QUOTENAME(@ColName, '''')
		 EXEC (@SQL)
		 IF @@ROWCOUNT = 1
			   RETURN 1
		 ELSE
			   RETURN 0
	END	TRY
	
	BEGIN CATCH
		 SELECT @Err_code = @@error
		 PRINT @Me + N'SQL statement failed. ' + @SQL + N' ' + Error_Message()
		 RETURN -1
	END CATCH
	
	RETURN 0
END
