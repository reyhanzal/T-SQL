CREATE FUNCTION dbo.ObjCreationDate
(
   @objName SYSNAME
)
RETURNS DATETIME
AS
BEGIN
  DECLARE @crDate datetime
  SELECT @crDate = crdate FROM sysobjects WHERE name = @objName
  RETURN (@crDate)
END
