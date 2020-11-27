CREATE PROCEDURE [dbo].[usp_sys_CatchErrorInfo] (
    @DB_NAME NVARCHAR(100),
	@LOGTABLE NVARCHAR(50), 
	@COMPONENT NVARCHAR(50), 
	@NARRATIVE NVARCHAR(1500) = ''
)
AS
BEGIN
--================================
--Author       : M. Reyhan Zalbina
--Created Date : 2020-02-17
--Description  : Log Error
--================================
  SET NOCOUNT ON

  DECLARE @ME AS NVARCHAR(100)
	      ,@sql AS NVARCHAR(MAX)
		  ,@LOGTYPE AS NVARCHAR(50)
	      ,@ERR_CODE AS INT
		  ,@ERR_MSG AS NVARCHAR(1500)

  DECLARE @crlf AS CHAR(2)
  DECLARE @rowcount AS INT
			
  SET @ME = OBJECT_NAME(@@PROCID) + N' (1234.01)'
  PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + ', ' + @LOGTABLE + ', ' + @COMPONENT + ', ' + @NARRATIVE

  SET @crlf = CHAR(13) + CHAR(10)
		
  BEGIN TRY
	SET @ERR_MSG = N' Error(' + Cast(Error_Number() AS VARCHAR(10)) + '): ' + Error_Message() + @crlf
						+ N' Severity:  ' + Cast(Error_Severity() AS VARCHAR(10)) + @crlf
						+ N' State:     ' + Cast(Error_State() AS VARCHAR(10)) + @crlf
						+ N' Procedure: ' + IsNull(Error_Procedure(),N'None.') + @crlf
						+ N' Line #:    ' + Cast(Error_Line() AS VARCHAR(10))
	PRINT @ERR_MSG
	SELECT @ERR_MSG
  END TRY 
	
  BEGIN CATCH
	SELECT @ERR_CODE = @@error
	PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + N' failed. ' + Error_Message()
	RETURN @ERR_CODE
  END CATCH 

  SET @LOGTYPE = 'Error'

  SET @NARRATIVE = REPLACE(LTRIM(RTRIM(@NARRATIVE)), '''', '"')
  SET @NARRATIVE = REPLACE(@NARRATIVE, ',', ';')

  SET @ERR_MSG = LEFT(REPLACE(LTRIM(RTRIM(@ERR_MSG)), '''', '"'), 1500)
  SET @ERR_MSG = REPLACE(@ERR_MSG, ',', ';')

  SET @LOGTABLE = UPPER(@LOGTABLE)
  SET @LOGTYPE = UPPER(@LOGTYPE)
	
  BEGIN TRY		
		
		SET @sql = 'INSERT INTO [' + @DB_NAME + '].dbo.[' + @LOGTABLE + '] '
		SET @sql = @sql + N' ([DateTime],[TableName],[Component],[LogType],[Narrative],[ErrorMessage])'
		SET @sql = @sql + N' VALUES(GetDate(),N''' + @logtable + ''','
		SET @sql = @sql + ',N''' + LTRIM(RTRIM(@COMPONENT)) + ''',N''' + LTRIM(RTRIM(@LOGTYPE)) 
		                + ''',N''' + @NARRATIVE + ''',N''' + @ERR_MSG + ''')'
		
		EXEC sp_executesql @sql 
  END TRY
	
  BEGIN CATCH
	SELECT @ERR_CODE = @@error
	PRINT CONVERT(CHAR(24), GETDATE(),113) + N' ' + @ME + N' failed. ' + Error_Message()
	RETURN @ERR_CODE
  END CATCH
	
  RETURN 0
END


GO


