CREATE FUNCTION [dbo].[pad_right]
(
    @PadChar CHAR(1),
    @PadToLen INT,
    @BaseString VARCHAR(100)
)
RETURNS VARCHAR(1000)
AS
BEGIN
DECLARE @Padded VARCHAR(1000)
DECLARE @BaseLen INT
	SET @BaseLen = LEN(@BaseString)
	IF @BaseLen >= @PadToLen
	BEGIN
		SET @Padded = @BaseString
	END
	ELSE
	BEGIN
		SET @Padded = @BaseString + REPLICATE(@PadChar, @PadToLen - @BaseLen)
	END
	RETURN @Padded
END
