CREATE FUNCTION [dbo].[f_Round_Down]
(
     @number NUMERIC(23,8)
    ,@digit INT
)
RETURNS NUMERIC(23,8)
AS
BEGIN
  DECLARE @roundnumber NUMERIC(23,8), @roundupnumber NUMERIC(23,8)

  SET @roundnumber = POWER(10, @digit)
  SET @roundupnumber = FLOOR(@number * @roundnumber) / @roundnumber
  RETURN @roundupnumber
END
