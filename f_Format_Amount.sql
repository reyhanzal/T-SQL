CREATE FUNCTION [dbo].[f_Format_Amount]
(
   @amount NUMERIC(23,8)
)
RETURN VARCHAR(23)
AS
BEGIN
  DECLARE @retAmount VARCHAR(23)
  SET @retAmount = CONVERT(VARCHAR(23), CAST(@amount AS MONEY), 1)
  RETURN @retAmount
END
