-- file: mssql-cheat-sheet.sql
-- how-to get column meta data on sql server 2008

-- get a nice logging message print with timestamp and hostname 
print convert ( varchar , convert( datetime2 , getdate() , 121 )) + ' [' + @@servername + '] --- killing active connections'

-- how-to set a db offline 
ALTER DATABASE db_name SET OFFLINE WITH ROLLBACK IMMEDIATE ;

-- sql server 2012 -> 
SELECT FORMAT(GETDATE() , 'yyyy-MM-dd- HH:mm:ss')
SELECT convert (datetime , '2016-07-15 15:38:35' , 120) 

-- how-to get a date IN THE YYYY.MM.DD FORMAT
SELECT CONVERT ( VARCHAR , DATEADD(DAY, -1, GETDATE())  , 102 ) AS 'THE CURRENT DATE IN YYYY.MM.DD FORMAT '


-- who , where and when 
select  user as 'WHO', @@servername AS 'SERVER_NAME_AND_INSTANCE' , db_name() AS 'CURRENT_DB', GETDATE() AS 'WHEN' ; 

-- get columns meta data 
SELECT top 100000
 INFORMATION_SCHEMA.COLUMNS.TABLE_CATALOG              AS 'DataBaseName' 
,INFORMATION_SCHEMA.COLUMNS.TABLE_SCHEMA               AS 'SchemaName'
,SysObjects.NAME                                       AS 'TableName'
,sys.all_columns.NAME                                  AS 'ColumnName'
,INFORMATION_SCHEMA.COLUMNS.ORDINAL_POSITION           AS 'OrdinalPosition'
,sys.types.name                                        AS 'DataType' 
,sys.all_columns.is_nullable                           AS 'IsNullable' 
,sys.all_columns.is_identity                           AS 'IsPrimaryKey'  
,sys.all_columns.max_length                            AS 'MaxLength' 
,sys.all_columns.is_computed                           AS 'IsComputed' 
,syscomments.text                                      AS 'DefaultValue'
FROM dbo.sysobjects  
INNER JOIN sys.all_columns 
   ON ( SysObjects.id = sys.all_columns.object_id )
INNER JOIN sys.types 
   on ( sys.types.system_type_id = sys.all_columns.system_type_id )
LEFT JOIN syscomments  
   on ( SysObjects.id = syscomments.id ) 
-- LEFT JOIN sys.tables stb on sc.object_id = SysObjects.parent_obj
LEFT JOIN INFORMATION_SCHEMA.COLUMNS  
on  (     INFORMATION_SCHEMA.COLUMNS.TABLE_NAME=SysObjects.NAME 
      and sys.all_columns.NAME = INFORMATION_SCHEMA.COLUMNS.COLUMN_NAME ) 
 
--LEFT JOIN dbo.syscomments SM ON SC.cdefault = SM.id  
--inner join sys.types st
--on sc.xtype = st.system_type_id
WHERE 1=1 
AND SysObjects.xtype = 'U'  
and sys.types.name <> 'sysname' --to a bug with this one occurs if enabled 
and sys.all_columns.is_computed = 0 --todo a bug with this one occurs if enabled 
-- and SysObjects.name = @TableName --uncomment this line while debugging
-- AND sys.all_columns.name LIKE '%TABLE_NAME_TO_SRCH%'
ORDER BY DatabaseName , SchemaName , TableName , INFORMATION_SCHEMA.COLUMNS.ORDINAL_POSITION

; 

-- how-to search for a table 
select * from sys.tables
where 1=1

and name like '%consol%' 
; 

-- WHERE AM I ... 
SELECT
   SERVERPROPERTY('MachineName' )                  AS "ServerName"
 , SERVERPROPERTY('ServerName')                    AS "ServerInstanceName"
 , SERVERPROPERTY('InstanceName')                  AS "Instance"
 , SERVERPROPERTY('ProductVersion')                AS "ProductVersion"
 , Left(@@Version, Charindex('-', @@version) - 2)  As "VersionName"
 , db_name()                                       as "DB_NAME"
 -- , host_name()                                     AS "HOST_NAME"
 , SUSER_NAME()                                    AS "LOGGED_USER"
 ; 


-- HOW-MUCH FULL TEXT CATALOGS ARE IN THE CURRENT DB 
select count(*)                                    AS "FULLTEXT_CATALOGS_COUNT" 
From sys.fulltext_catalogs
; 




--how-to geneate select columns list from table
declare @TABLE_NAME VARCHAR(100)
SELECT @TABLE_NAME = 'CONSOLIDATE_ASST_LIAB_balance'
SELECT 
CASE 
   WHEN C.ORDINAL_POSITION = 1 then ' ; SELECT    
   ' ELSE ' , '
END
 + '[' + T.TABLE_NAME + ']'
 + '.' + '[' + C.COLUMN_NAME + ']'
 AS "SQL_CODE"
FROM INFORMATION_SCHEMA.TABLES T
INNER JOIN INFORMATION_SCHEMA.COLUMNS C 
  ON ( T.TABLE_NAME=C.TABLE_NAME )
WHERE  1=1
   AND T.TABLE_TYPE='BASE TABLE'
   AND T.TABLE_NAME = @TABLE_NAME
--ORDER BY C.ORDINAL_POSITION ASC
UNION ALL
SELECT
' FROM '+ @TABLE_NAME AS "SQL_CODE"
UNION ALL
SELECT
' WHERE 1=1 
' AS "SQL_CODE"
UNION ALL 
SELECT 
 + '-- AND [' + T.TABLE_NAME + ']'
 + '.' + '[' + C.COLUMN_NAME + ']'
 AS "SQL_CODE"
FROM INFORMATION_SCHEMA.TABLES T
INNER JOIN INFORMATION_SCHEMA.COLUMNS C 
  ON ( T.TABLE_NAME=C.TABLE_NAME )
WHERE  1=1
   AND T.TABLE_TYPE='BASE TABLE'
   AND T.TABLE_NAME = @TABLE_NAME
--ORDER BY C.ORDINAL_POSITION ASC
; 

-- VersionHistory
-- 1.0.0 -- 2015-03-18 09:31:31 -- ysg -- Init