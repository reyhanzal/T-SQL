CREATE FUNCTION [dbo].[f_CountDay]
(
   @DateStart DATETIME
  ,@DateEnd   DATETIME
)
RETURN INT
AS
BEGIN
  DECLARE @CountDay INT
  SET @CountDay = -1
	
  WHILE @DateStart <= @DateEnd 
  BEGIN
    SET @CountDay = @CountDay + 1
  END

  RETURN (@CountDay)
END
