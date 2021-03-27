CREATE FUNCTION [dbo].[f_CountChar]
( 
    @InputString VARCHAR(1000) 
   ,@SearchChar  CHAR(1)
)
RETURNS INT
BEGIN

DECLARE @InputLength  INT
DECLARE @Index        INT
DECLARE @Count        INT

SET @Count = 0
SET @Index = 1
SET @InputLength = LEN(@pInput)

WHILE @Index <= @InputLength
BEGIN
    IF SUBSTRING(@Input, @Index, 1) = @SearchChar
        SET @Count = @Count + 1

    SET @Index = @Index + 1
END

RETURN @Count

END

GO
