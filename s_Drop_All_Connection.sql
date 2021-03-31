USE Master
GO

DECLARE @dbname SYSNAME

SET @dbname = 'name of database you want to drop connections from'

DECLARE @spid INT
SELECT @spid = MIN(spid) FROM master.dbo.sysprocesses
WHERE dbid = db_id(@dbname)
WHILE @spid IS NOT NULL
BEGIN
        EXECUTE ('KILL ' + @spid)
        SELECT @spid = min(spid) FROM master.dbo.sysprocesses
        WHERE dbid = db_id(@dbname) AND spid > @spid
END

GO
