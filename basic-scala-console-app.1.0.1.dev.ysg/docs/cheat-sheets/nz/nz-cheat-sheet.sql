-- File: NetezzaCheatSheet.sql v.1.6.0 docs at the end 
 
SELECT * FROM _V_OBJECTS
; 
 
SELECT * FROM _V_QRYSTAT;
 
-- how-to list the columns of a table 
SELECT ' , ' || NAME || '.' || ATTNAME  from _V_RELATION_COLUMN
WHERE 1=1
AND NAME LIKE '%HIST%'
ORDER BY NAME , ATTNUM
;
 
--how-to get the fully-qualified list of columns of a table 
SELECT  ' , ' || DATABASE || '.' || OWNER || '.' || NAME || '.' || ATTNAME , *  from _V_RELATION_COLUMN
WHERE 1=1
AND NAME ='SOR_ORDER'
ORDER BY NAME , ATTNUM
;
 
 
-- Query to get a list of tables in a database:
SELECT TABLENAME,OWNER,CREATEDATE FROM _V_TABLE 
WHERE 1=1 
AND OBJTYPE='TABLE'
AND TABLENAME LIKE '%LASER%'
;
 
 
SELECT * FROM SYSTEM.._V_QRYHIST
WHERE 1=1
AND QH_TSUBMIT > CURRENT_DATE
-- AND QH_SQL LIKE '%DISK_DEFECTS_20121214%'
ORDER BY 
-- QH_SESSIONID DESC
-- QH_RESROWS DESC
QH_ESTCOST ASC
; 
 
 
 
-- how-to create a database 
CREATE DATABASE DatabaseName
;
-- how-to rename a database 
ALTER DATABASE OldDatabaseName RENAME TO NewDatabaseName 
;
-- how-to create a synomim 
CREATE SYNONYM synonym_name FOR DatabaseName.SchemaName.TableName 
;
-- how-to create a table 
 
CREATE TABLE SVOC_OWNER.ExampleTable
(
    ByteIntCol        byteint            NOT NULL    
  , SmallIntCol       smallint           NOT NULL    
  , IntegerCol        integer            NOT NULL    
  , BigIntCol         bigint             NOT NULL    
  , NumericPSCol      numeric(38,38)     NOT NULL    
  , NumericPCol       numeric(38,0)      NOT NULL    
  , NumericCol        numeric            NOT NULL    
  , DecimalCol        numeric            NOT NULL    
  , FloatCol          float(15)          NOT NULL    
  , RealCol           real               NOT NULL    
  , DoubleCol         double             NOT NULL    
  , CharCol           char(1)        NOT NULL    
  , VarcharCol        varchar(1)     NOT NULL    
  , NcharCol          nchar(1)       NOT NULL    
  , NvarcharCol       nvarchar(1)    NOT NULL    
  , BooleanCol        boolean            NOT NULL    
  , DateCol           date               NOT NULL    
  , TimeCol           time               NOT NULL    
  , TimeTzCol         timetz             NOT NULL    
  , TimestampCol      timestamp          NOT NULL    
 
 )
DISTRIBUTE ON RANDOM
;
 
-- how-to copy table 
CREATE TABLE NewTable AS SELECT * FROM TableToCopy ; 
 
 
-- how-to or insert data from non-current db to current db table
INSERT INTO TableName SELECT * FROM DatabaseName..TableName
;
-- how-to drop a table 
DROP TABLE DatabaseName..TableName 
; 
-- how-to change the ownership of a table 
ALTER TABLE TableName OWNER TO NewOwner 
;
-- how-to perform a simple select 
SELECT * FROM TableName 
WHERE 
AND 1=1 
AND WhereColumnName = 'WhereCondition' 
AND GreaterThanColumnName > 0.0
ORDER BY WhereColumnName
;
-- how-to delete from table 
DELETE FROM TableNameToDeleteFrom 
WHERE FilterColumnName = 'FilterValue'
;
-- how-to call a stored procedure 
CALL ProcName ; 
EXEC ProcName ; 
EXECUTE ProcName ; 
-- example stored procedure 
CREATE OR REPLACE PROCEDURE ProcName() 
RETURNS INT4 LANGUAGE NZPLSQL AS
BEGIN_PROC
  DECLARE
    StrVar varchar;
  BEGIN
    StrVar := 'This string is quoted';
  END;
END_PROC
; --END PROC
-- a single line comment
/*
a multi-line comment
*/
-- example proc with parameters
CREATE OR REPLACE PROCEDURE ProcName (int, varchar(ANY)) RETURNS int
LANGUAGE NZPLSQL AS
BEGIN_PROC
  DECLARE
    pId ALIAS FOR $1;
    pName ALIAS FOR $2;
  BEGIN
    INSERT INTO t1 SELECT * FROM t2 WHERE id = pId;
  END; 
END_PROC 
; 
-- Control structure
IF movies.genre = 'd' THEN
  film_genre := 'drama';
ELSIF movies.genre = 'c' THEN
  film_genre := 'comedy';
ELSIF movies.genre = 'a' THEN
  film_genre := 'action';
ELSIF movies.genre = 'n' THEN
  film_genre := 'narrative';
ELSE
-- An uncategorized genre form has been requested.
film_genre := 'Uncategorized';
END IF;
-- how-to list all stored procedures 
SHOW PROCEDURE ALL 
; 
-- how-to document a stored procedure
COMMENT ON PROCEDURE customer() IS 'Author: bsmith
Version: 1.0 Description: A procedure that writes a customer name to
the database log file.';
-- how-to list all stored procedures 
SHOW PROCEDURE ALL 
; 
 
-- how-to document a stored procedure
COMMENT ON PROCEDURE customer() IS 'Author: bsmith
Version: 1.0 Description: A procedure that writes a customer name to
the database log file.';
 
-- how-to convert date str into nzdate
select  to_date(substring(20090731 from 1 for 8),'YYYYMMDD') as NZDATE
 
-- how-to cast a nice date 
where date_column = to_date('2013-05-15 10:40:31' , 'YYYY-MM-DD HH24:MI:SS') 
 
-- how-to convert date 
SELECT * FROM TABLE_NAME WHERE 1=1 AND LOAD_TM > to_date ( '2013-04-16 00:00:00' , 'YYYY-MM-DD HH24:MI:SS'
 
-- select top 
select a.* from some_schema.some_table a limit 10
 
-- START how to remove duplicates =================================
CREATE TABLE TmpTableDuplicates as
    SELECT col11,col2,col3 from DuplicatesContainingTable 
    where FilterCol = 'FilterValue'
    group by 1.2.8
; 
DELETE FROM DuplicatesContainingTable where FilterCol = 'FilterValue'
; 
INSERT INTO Source_table select * from TmpTableDuplicates
; 
DROP TABLE TmpTableDuplicates
; 
-- STOP how to remove duplicates =================================
 
 
-- Query to get a list of views and thier definitions in a database:
SELECT VIEWNAME,OWNER,CREATEDATE,DEFINITION FROM _V_VIEW WHERE OBJTYPE='VIEW';
 
-- Query to get a list of tables in a database:
SELECT TABLENAME,OWNER,CREATEDATE FROM _V_TABLE WHERE OBJTYPE='TABLE';
 
-- Query to get a list of columns from a table or a view:
SELECT ATTNUM,ATTNAME FROM _V_RELATION_COLUMN WHERE NAME=UPPER('<TABLE NAME>')
 ORDER BY ATTNUM ASC;
 
-- Query to get list of user groups on the box:
SELECT GROUPNAME,OWNER,CREATEDATE,ROWLIMIT,SESSIONTIMEOUT,
 QUERYTIMEOUT,DEF_PRIORITY,MAX_PRIORITY FROM _V_GROUP;
 
-- Query to get list of users and the groups they are in, on the box:
 SELECT GROUPNAME,OWNER,USERNAME FROM _V_GROUPUSERS;
-- (Does not give any LDAP users in this query)
 
--Query to find the number of rows in a table without actually querying the table:
-- (Sometimes needed for some really huge tables of rowcount > 80 Billion)
 
SELECT RELNAME TABLE_NAME,
 CASE
 WHEN RELTUPLES < 0
 THEN ((2^32) * RELREFS) + ((2^32) + RELTUPLES )
 ELSE ((2^32) * RELREFS) + ( RELTUPLES )
 END NUM_ROWS
 FROM
 _T_CLASS,
 _T_OBJECT
 WHERE
 _T_OBJECT.OBJID=_T_CLASS.OID AND
 _T_OBJECT.OBJCLASS=4905  DISPLAY ONLY TABLES
 AND RELNAME = UPPER('<TABLE NAME>')
 ;
--Query to check if any of the SPU's are running slower than the rest:
--  (This actually gives the read-write speed of each SPU that is online)
SELECT HWID, BYTE_COUNT/TOTAL_MSEC
 FROM
 _VT_DISK_TIMING
 ORDER BY 2;
 
--- HOW-TO GET THE LIST OF TABLES AND THIER SKEW AND SIZE:
 SELECT TABLENAME,OBJTYPE,OWNER,CREATEDATE,USED_BYTES,SKEW
 FROM _V_TABLE_ONLY_STORAGE_STAT
 WHERE OBJCLASS = 4905 OR OBJCLASS = 4911
 ORDER BY TABLENAME;
 
-- START SELECT INTO
INSERT INTO DatabaseNameTarget.SchemaNameTarget.TableNameTarget 
SELECT ColumnName1 , ColumnName2
FROM DatabaseNameSource.SchemaNameSource.TableNameSource
;
-- STOP SELECT INTO 
 
-- how-to remove duplicates
delete from TableWithDuplicates 
where rowid not in 
(
  select min(rowid) from TableWithDuplicates 
  group by (DuplicateDefiningCol1 , DuplicateDefiningCol2 , DuplicateDefiningCol3) 
);
 
-- _V_USER : The user view gives information about the users in the netezza system.
select * from _v_user;
 
-- Returns a list of all groups of which the user is a member 
SELECT * FROM _v_usergroups
; 
 
--- Returns a list of all system datatypes
SELECT * FROM _v_datatype
; 
 
--- returns the list of all active sessions 
SELECT * FROM _v_session
;
 
 
 
-- _V_TABLE: The table view contains the list of tables created in the netezza performance system.
select * from _v_table;
 
 
-- _V_RELATION_COLUMN: The relation column system catalog view contains the columns available in a table.
select * from _v_relation_column;
 
-- _V_TABLE_INDEX: This system catalog contains the information about the indexes created on table. netezza does not support creating indexes on a table as of now.
select * from _v_table_index;
 
-- _V_OBJECTS: Lists the different objects like tables, view, functions etc available in the netezza.
select * from _v_objects;
 
-- what is running currently 
select * from _v_qrystat;
 
-- what has been running lately 
select * from _v_qryhist;
 
-- get the amount of locks on Netezza 
SELECT * FROM _t_pg_locks where username<>'ADMIN'
 
-- where the list of system tables is stored 
SELECT * FROM _v_sys_table
; 
-- Returns a list of all defined user privileges: \dpu <user>
_v_sys_user_priv 
 
 
nz_find_object_owners  [user]
 
select  o.objname,u.usename,oc.CLASSNAME,d.database,d.owner  from _t_object o 
 JOIN _t_user u
 ON o.objowner=u.usesysid
 JOIN _t_object_classes oc
 ON o.objclass=oc.objclass 
 JOIN _v_database d
 ON o.objdb=d.objid
 WHERE u.usename='KKONGAS'
 
; 
 
-- skew =  ((max_dataslice - min_dataslice) / avg_per_dataslice
select 
        t.tablename, 
        s.used_max, 
        s.used_min, 
        s.used_avg,
        round((used_max-used_min)/used_avg,2) skew,
        round(100*((used_max/used_avg)-1),2) scan_loss_pct, 
        round((used_max-used_avg)/104857600,4) scan_loss_seconds
from _v_sys_object_storage_sz2 s, _v_table t
where s.tblid = t.objid
  and scan_loss_seconds > 0
order by scan_loss_seconds desc;
 
 
-- 
SELECT
   _V_QRYHIST.QH_DATABASE
  , _V_QRYHIST.QH_TSTART
  , _V_QRYHIST.QH_TEND
  , EXTRACT (epoch from ( _V_QRYHIST.QH_TSTART - _V_QRYHIST.QH_TEND ))* INTERVAL '1 SECOND' AS DIFF_HHMMSS
  FROM _V_QRYHIST
where 1=1
AND QH_TSUBMIT > CURRENT_DATE
-- AND _V_QRYHIST.QH_DATABASE = 'SYSTEM'
-- AND _V_QRYHIST.QH_SQL LIKE '%INCR%'
-- ORDER BY QH_ESTCOST ASC
LIMIT 10
 
 
 
select * from _v_user;
select * from _v_table;
select * from _v_relation_column;
select * from _v_table_index;
select * from _v_objects;
 
 
-- get the time difference 
EXTRACT(epoch FROM DateCol1 -DateCol2)/3600 as difference_in_hours
EXTRACT(epoch FROM ( _V_QRYHIST.QH_TSTART - _V_QRYHIST.QH_TEND ))/3600 as difference_in_hours
 
 
-- Use \dt in nzsql session to get the list tables
/*
\dv to get list of views
 \dmv - list of materialized views
 \l - list of databases
 \dg - list of groups
 \du - list of users
 \dpu - permissions set to a user
 \dT - list of datatypes
 \d <tablename> - describes the table
 \act - show current active sessions
 \d - describe table(or view,sequence)
 \dt , \dv , \ds , \de - list tables,views,sequences,temp tables
 \dSt , \dSv - list system tables and views
 \df - list functions
 \l - list databases
 \dT - list data types
 \du - list users
 \dg - list groups
 \dpu - list permissions granted to a user
 \dpg - list permissions granged to a group
*/
 
-- GRANT THE PROPER OWNER TO IT
ALTER VIEW V_DB_GROOMER_HISTORY OWNER TO MAINTENANCE_OWNER 
;
 
/*
-- Purpose:
To provide a simple cheat sheet for netezza 
 
-- VersionHistory
 
1.6.0 --- YSG --- 2012-08-20 12:33:46 --- ADDED _v_usergroups
1.5.1 --- YSG --- 2012-06-18 13:30:16 --- locks 
1.5.0 --- YSG --- 2012-05-23 14:43:38 --- added important views
1.4.0 --- YSG --- 2012-05-18 15:26:35 --- how-to remove duplicates
1.3.0 --- YSG --- 2012-05-18 13:44:02 --- added how-to copy table 
1.2.0 --- ysg --- added list cols of a table 
1.1.1 --- ysg --- create table example
1.1.0 --- ysg --- added duplicates removal , date conversion
1.0.0 --- ysg --- Initial creation
*/