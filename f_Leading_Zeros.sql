CREATE FUNCTION [dbo].[f_Leading_Zeros]
(
    @Value INT
) 
RETURNS VARCHAR(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue VARCHAR(8)

    SET @ReturnValue = CONVERT(VARCHAR(8), @Value)
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue

    RETURN (@ReturnValue)
END
