DECLARE @cmd VARCHAR(1000)
SELECT @cmd
     ='USE [?] SELECT ''[?]'', db_id(parsename(base_object_name, 3)) DB_ID
    ,object_id(base_object_name) OBJ_ID
    ,base_object_name
FROM sys.synonyms;'

EXEC sys.sp_MSforeachdb @cmd
