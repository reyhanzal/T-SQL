CREATE FUNCTION [dbo].[f_Format_Amount] (
    @amount NUMERIC(23,8)
)
RETURN VARCHAR(23)
AS
BEGIN
    DECLARE @ret_amount VARCHAR(23)
    SET @ret_amount = CONVERT(VARCHAR(23), CAST(@amount AS MONEY), 1)
    RETURN @ret_amount
END
