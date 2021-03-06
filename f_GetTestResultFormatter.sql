CREATE FUNCTION [tSQLs].[GetTestResultFormatter] ()
RETURNS NVARCHAR(MAX)
AS
BEGIN
  DECLARE @FormatterNm NVARCHAR(MAX)
  
  SELECT @FormatterNm = CAST(Val AS NVARCHAR(MAX))
  FROM sys.extended_properties
  WHERE name = N'tSQLs.ResultFormatter'
  AND major_id = OBJECT_ID('tSQLs.Private_OutputTestResults')
  
  SELECT @FormatterNm = COALESCE(@FormatterNm, 'tSQLt.DefaultResultFormatter')
  
  RETURN @FormatterNm
END
