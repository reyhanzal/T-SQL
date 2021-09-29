SELECT TOP(10)
     A.object_id OBJECT_ID
    ,B.name DB_NAME
    ,OBJECT_NAME(A.object_id, A.database_id) PROC_NAME
    ,A.cached_time CACHED_TIME
    ,A.last_execution_time LAST_EXECUTION_TIME
    ,A.total_elapsed_time TOTAL_ELAPSED_TIME
    ,A.total_elapsed_time / ps.execution_count AVG_ELAPSED_TIME
    ,A.last_elapsed_time LAST_ELAPSED_TIME
    ,A.execution_count EXECUTION_COUNT
    ,A.total_worker_time TOTAL_WORKER_TIME
FROM sys.dm_exec_procedure_stats A
INNER JOIN sys.databases B ON B.database_id = A.database_id
ORDER BY AVG_ELAPSED_TIME DESC;
