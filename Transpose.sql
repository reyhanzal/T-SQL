SELECT [1] AS 'DB_SOURCE', [2] AS 'DB_DESTINATION', [3] AS 'TABLE_SRC', [4] AS 'TABLE_DST'
    FROM (
		   SELECT *, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) Row_Num
		   FROM [dbo].[FnSplitString2]('[Your_DB_Name], [Your_DB_Name], [Your_Table_Name], [Your_Table_Name]', ',')
) A
PIVOT
(MIN(Item)
FOR Row_Num IN ([1],[2],[3],[4]))
AS B;