/* Year */
CREATE FUNCTION [dbo].[f_CountChar]
( 
   @InputDate DATE
)
RETURNS DATE
BEGIN

  SELECT DATE_TRUNC('YEAR',@InputDate)
  
END

/* Month */
CREATE FUNCTION [dbo].[f_CountChar]
( 
   @InputDate DATE
)
RETURNS DATE
BEGIN
  
  SELECT DATEADD(MONTH, DATEDIFF(MONTH, 0, @InputDate)-1, 0)
  
END
