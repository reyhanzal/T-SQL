CREATE FUNCTION [tSQLs].[TestCaseSummary]()
RETURNS TABLE
AS
RETURN
BEGIN

  WITH A
  (
    xCount
   ,SuccessCount 
   ,FailCount 
   ,ErrorCount
  )
  AS
  (
    SELECT COUNT(1)
     ,ISNULL(SUM(CASE WHEN Result = 'Success' THEN 1 ELSE 0 END), 0)
     ,ISNULL(SUM(CASE WHEN Result = 'Failure' THEN 1 ELSE 0 END), 0)
     ,ISNULL(SUM(CASE WHEN Result = 'Error' THEN 1 ELSE 0 END), 0)
    FROM tSQLs.TestResult
  )

  SELECT 'Test Case Summary: ' + CAST(xCount AS NVARCHAR) + ' test case(s) executed, '+
    CAST(SuccessCount AS NVARCHAR) + ' succeeded, '+
    CAST(FailCount AS NVARCHAR) + ' failed, '+
    CAST(ErrorCount AS NVARCHAR) + ' errored.' Msg,*
  FROM A;

END
