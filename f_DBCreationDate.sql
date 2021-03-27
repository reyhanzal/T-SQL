CREATE FUNCTION dbo.f_DBCreationDate
( 
   @dbname SYSNAME 
)
RETURNS datetime
AS
BEGIN
  DECLARE @crdate datetime
  SELECT @crdate = crdate FROM master.dbo.sysdatabases
    WHERE name = @dbname
  RETURN ( @crdate )
END

GO
