CREATE PROCEDURE [dbo].[Server_GetRound]
(  
    @a NUMERIC(23,8)
   ,@n INTEGER
   ,@b NUMERIC(23,8) OUTPUT
)
AS
BEGIN
   SELECT @b = ISNULL(ROUND(@a,@n),0)
END
