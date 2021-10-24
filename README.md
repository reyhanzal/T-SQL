# Useful links
https://stackoverflow.com/questions/121243/hidden-features-of-sql-server
https://github.com/microsoft/sql-server-samples/blob/master/samples/demos/query-tuning-assistant/qta-demo.zip
https://github.com/Thomas-S-B/SQLServerTools

# If you want to know the table structure, indexes and constraints:

* sp_help 'TableName'
* sp_who is documented and officially supported
* sp_who2 is undocumented and unsupported, but widely used and return same information as sp_who
* sp_helptext Iif you want the code of a stored procedure, view & UDF
* sp_tables return a list of all tables and views of database in scope
* sp_stored_procedures return a list of all stored procedures
* CREATE INDEX cte_table_name ON #table_name(id)
