SELECT PATH, B.*
FROM sys.traces A
CROSS APPLY fn_trace_gettable(T.path, DEFAULT) B
WHERE ObjectName LIKE '%TableNameorObject%';
