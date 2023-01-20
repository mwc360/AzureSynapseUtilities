/*
Author: Miles Cole
Purpose: Used to simplify the process of altering table distributions
Sample Usage: EXEC dbo.AlterTableDistribution 'dbo', 'table1', 'HASH(column1)'
*/

CREATE PROC dbo.AlterTableDistribution @schemaName VARCHAR(128)
    , @tableName VARCHAR(128)
    , @newDistribution VARCHAR(150)
AS
BEGIN
    DECLARE @fullyQualifiedTableName VARCHAR(400) = '[' + @schemaName + '].[' + @tableName + ']'
    DECLARE @index VARCHAR(200) = (
            SELECT CASE i.type
                    WHEN 0
                        THEN 'HEAP'
                    WHEN 1
                        THEN CONCAT (
                                'CLUSTERED INDEX ('
                                , STRING_AGG(CONVERT(VARCHAR(MAX), c.name), ', ') WITHIN GROUP (
                                        ORDER BY ic.key_ordinal ASC
                                        )
                                    , ')'
                                )
                    WHEN 5
                        THEN 'CLUSTERED COLUMNSTORE INDEX'
                    END AS TableIndex
            FROM sys.tables t
            LEFT JOIN sys.indexes i
                ON t.object_id = i.object_id
                    AND i.type IN (0, 1, 5)
            LEFT JOIN sys.index_columns ic
                ON i.index_id = ic.index_id
                    AND i.object_id = ic.object_id
            LEFT JOIN sys.columns c
                ON ic.column_id = c.column_id
                    AND ic.object_id = c.object_id
            WHERE t.object_id = object_id(@fullyQualifiedTableName)
            GROUP BY i.type
            )
    DECLARE @sql NVARCHAR(1000) = '
CREATE TABLE [' + @schemaName + '].[' + @tableName + '_new]
WITH (
            ' + @index + '
            , DISTRIBUTION = ' + @newDistribution + '
            )
AS SELECT * FROM [' + @schemaName + '].[' + @tableName + ']

RENAME OBJECT [' + @schemaName + '].[' + @tableName + '] to [' + @tableName + '_old]
RENAME OBJECT [' + @schemaName + '].[' + @tableName + '_new] to [' + @tableName + ']
DROP TABLE [' + @schemaName + '].[' + @tableName + '_old]'

    PRINT (@sql)

    EXEC sp_executesql @sql
END
