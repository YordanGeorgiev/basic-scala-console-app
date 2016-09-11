--file: OracleCheatCheet.sql v1.2.1 docs at the end
-- sources: http://ss64.com/ora/syntax.html
-- define nice date and number formatting 

-- ensure you are using the correect user and schema
ALTER SESSION SET CURRENT_SCHEMA ="INFAREPO_SYS" ;
ALTER SESSION SET NLS_TERRITORY = 'FINLAND' ; 
ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD HH24:MI:SS';
Alter Session Set Nls_Numeric_Characters=', ';
set feedback on ; 

-- accountant friendly number formatting 
SELECT to_char(cast('1234567890' as number(15,2)), '999G9999G999G999G999D99') AS AMOUNT 
FROM DUAL 
; 

-- mainframe cents number formatting
-- round to 2 decimals , trail with zeros to get 9 numbers width
SELECT LPAD((ROUND(TABLE_NAME."COLUMN_NAME" ,2)*100),9,0) FROM TABLE_NAME."COLUMN_NAME" 
;
,
   LPAD(
         (
            ROUND(
                     (
                        t.a + t.b
                     ) 
                  -- the num of decimals to round tou 
                  ,2)*100)
         -- the num of zeros to trail with
         ,9,0)
         AS "AMT_IN_CENTS"

STG_INTIME_COMMON
-- GENERATE A LIST FOR TABLE_NAME.COLUMN_NAME SEPARATED SELECTS FOR A TABLE
SELECT * FROM (
   ( 
      SELECT * FROM (
         Select  
         ' , ' 
         || Table_Name || '."' || 
         COLUMN_NAME 
         || '"'
         AS SELECT_CODE  
         FROM ALL_TAB_COLUMNS 
         Where 1=1 
         AND TABLE_NAME = 'STG_STK_COLLAT_CLASS'
         --AND OWNER = 'KOHD_TUKI_LE_TABLE'
         --AND COLUMN_NAME LIKE '%AMOUNT%'
         ORDER BY TABLE_NAME , COLUMN_NAME DESC
      )
   )
UNION 
   SELECT 'SELECT ROWNUM AS ROW_NUMBER' AS SELECT_CODE FROM DUAL   
)
ORDER BY SELECT_CODE ASC
;

show errors ; 


-- GENERATE A TABLE GROUP BY SELECTS 
   SELECT  ' SELECT ' 
   || TABLE_NAME || '.' || COLUMN_NAME 
   || ' FROM ' || TABLE_NAME  
   || ' GROUP BY ' || TABLE_NAME || '.' || COLUMN_NAME 
   || '; '
   
   AS SELECT_CODE  
   FROM ALL_TAB_COLUMNS 
   WHERE 1=1 
   AND TABLE_NAME = 'STG_INTIME_T24'
   --AND OWNER = 'KOHD_TUKI_LE_TABLE'
   --AND COLUMN_NAME LIKE '%AMOUNT%'
   ORDER BY TABLE_NAME , COLUMN_ID
     
;



  
-- FIND FIRST THE NAME OF THE TABLE 
SELECT OWNER , TABLE_NAME
FROM ALL_TABLES 
WHERE 1=1
AND LOWER( TABLE_NAME ) NOT LIKE '%$%'
AND LOWER( TABLE_NAME ) LIKE '%sec%'
; 

SELECT * FROM DW_CLA_COSECURITY
; 


-- GENERATE A TABLE_NAME.COLUMN_NAME SEPARATED LIST FOR SELECTS FOR A TABLE 
SELECT  CASE WHEN ROWNUM = 1 THEN '   ' ELSE ' , ' END || TABLE_NAME || '.' || COLUMN_NAME 
FROM ALL_TAB_COLUMNS WHERE 1=1 
and TABLE_NAME LIKE 'DW_CLA_PAYMENTS'
--AND OWNER = 'KOHD_TUKI_LE_TABLE'
ORDER BY TABLE_NAME , COLUMN_ID  
;

SELECT * FROM ALL_TAB_COLUMNS
; 

-- how-to select top or limit the result set in oracle 
select * from 
( select tmpTable.*, ROWNUM RowNumber from 
  ( -- this is the initial select clause
    SELECT * FROM MyTable
    ORDER BY MyTableId DESC
  ) tmpTable 
  where ROWNUM <= 100 
)
where RowNumber  >= 0
; 


-- GET THE COLUMN LIST FROM A TABLE 
SELECT ',' || COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE TABLE_NAME = 'FACT_SAP_HIS' ; 

-- convert ids to human readable values 
select 
  T2.WORKFLOW_NAME 
, T2.START_TIME
, T2.END_TIME
, decode (RUN_STATUS_CODE,
1 , 'Succeeded',
2,  'Disabled',
3,  'Failed',
4,  'Stopped',
5,  'Aborted',
6,  'Running',
15, 'Terminated')  Status
from OPB_WFLOW_RUN T2
WHERE 1=1
AND START_TIME >= to_date('2012-04-03 00:00:00','YYYY-MM-DD HH24:MI:SS')
AND END_TIME   <=   to_date('2012-04-04 00:00:00','YYYY-MM-DD HH24:MI:SS')

ORDER BY START_TIME DESC
; 


SELECT TABLE_NAME as TableName , COLUMN_NAME as ColumnName  FROM all_tab_columns ; 


SELECT a.table_name, a.column_name, a.constraint_name, c.owner, 
       -- referenced pk
       c.r_owner, c_pk.table_name r_table_name, c_pk.constraint_name r_pk
  FROM all_cons_columns a
  JOIN all_constraints c ON a.owner = c.owner
                        AND a.constraint_name = c.constraint_name
  JOIN all_constraints c_pk ON c.r_owner = c_pk.owner
                           AND c.r_constraint_name = c_pk.constraint_name
 WHERE c.constraint_type = 'R'
   -- AND a.table_name = 'OPB_CNX'
   -- and c_pk.table_name = 'OPB_CNX'
   AND c_pk.constraint_name LIKE '%%'
   AND OWNER='INFAPROD'
   ; 

-- FIND A COLUMN_NAME 
SELECT OWNER ||'.' ||  TABLE_NAME ||'.' || COLUMN_NAME FROM ALL_TAB_COLUMNS WHERE 1=1 
-- AND COLUMN_NAME LIKE '%OBJECT%' 
AND OWNER = 'INFAPROD'
-- AND TABLE_NAME LIKE 'REP_SESS_WIDGET_CNXS'
-- AND COLUMN_NAME LIKE '%OBJECT%'
ORDER BY OWNER , TABLE_NAME
;


-- get the short SID name 
select name from v$database;
-- get the global TNS Service name 
select * from global_name;
-- LIST THE INSTANCE NAME AND HOSTNAME 
select instance_number, instance_name, host_name from v$instance;


-- how-to copy table from another table from one schema to another 
create table SOURCE_SHEMA.TARGET_TABLE unrecoverable as SELECT * from TARGET_SCHEMA.SOURCE_TABLE
;

-- check the priveledges of your current session
select * from session_privs
; 

-- example stored procedure
CREATE OR REPLACE PROCEDURE procPrintHelloWorld
IS
BEGIN
 
  DBMS_OUTPUT.PUT_LINE('Hello World!');
 
END;
/


-- check the priveledges 
SELECT OWNER , OBJECT_NAME, OBJECT_TYPE FROM all_objects
where 1=1
; 

-- check oracle version 
select * from v$version where banner like 'Oracle%';


-- get h priveldeges 
select * from system_privilege_map
; 

SELECT GRANTEE , OWNER , TABLE_NAME , GRANTOR , PRIVILEGE ,  GRANTABLE ,  HIERARCHY  FROM all_tab_privs_made
; 

SELECT * FROM all_tab_privs_made
; 

-- LIST ALL THE PRIMARY KEYS 
SELECT * FROM ALL_CONS_COLUMNS A JOIN ALL_CONSTRAINTS C  ON A.CONSTRAINT_NAME = C.CONSTRAINT_NAME 
WHERE 1=1
AND C.TABLE_NAME =  'SOR_IM_MAP_TULOSLASKELMA_ENT'
-- AND C.OWNER='ServiceName_OWNER'
AND C.CONSTRAINT_TYPE = 'P'
 ; 
 
-- LIST ALL THE FOREIGH KEYS 
SELECT * FROM ALL_CONS_COLUMNS A JOIN ALL_CONSTRAINTS C  ON A.CONSTRAINT_NAME = C.CONSTRAINT_NAME 
WHERE 1=1 
-- AND A.OWNER='ServiceName_OWNER'
--AND C.TABLE_NAME = 'SOR_IM_MAP_TULOSLASKELMA_ENT'
AND C.CONSTRAINT_TYPE = 'R'

; 

COMMENT ON TABLE [schema.]table IS 'text'
COMMENT ON TABLE [schema.]view IS 'text'
COMMENT ON TABLE [schema.]materialized_view IS 'text'
COMMENT ON COLUMN [schema.]table.column IS 'text'
COMMENT ON COLUMN [schema.]view.column IS 'text'
COMMENT ON COLUMN [schema.]materialized_view.column IS 'text'

-- CHECK A TABLE FOR DUPLICATES ( A DUPLICATE IS DEFINED AS THE SAVE VALUES IN THE GROUP BY COL LIST)
SELECT       
   TableName.Col1 
 , TableName.Col2T
 FROM TableName
 WHERE 1=1
 AND FilterColumn='SomeFilterValue'
 group by    
   TableName.Col1 
 , TableName.Col2T
  having count (*) > 1;
 

select constraint_name from user_constraints 
where 1=1
and table_name = 'TABLE_NAME'
;  
 
-- GET ALL THE INDEXES FOR A TABLE 
select * from ALL_INDEXES
where 1=1
AND table_name = 'FACT_ORDER_HIS'
AND OWNER='ServiceName_OWNER'
;


-- how-to restore allready dropped table 
Flashback table "SchemaName"."TableName" to before drop;

-- the paths to the ora conf files 
/cygdrive/c/oracle/product/10.2.0/client_1/NETWORK/ADMIN/tnsnames.ora
/cygdrive/c/oracle/ora92/network/ADMIN/sqlnet.ora
/cygdrive/c/oracle/ora92/network/ADMIN/tnsnames.ora
/cygdrive/c/oracle/product/10.2.0/client_1/NETWORK/ADMIN/sqlnet.ora

-- move the synonyms from one db to another 
SELECT 'CREATE OR REPLACE SYNONYM ' || synonym_name || ' FOR ' || table_owner  || '.' ||  table_name || ';' FROM user_synonyms;
 
-- GET THE SIZE OF THE USER TABLES 
select TABLE_NAME, ROUND((AVG_ROW_LEN * NUM_ROWS / (1024*1024)), 3) SIZE_MB from USER_TABLES 
WHERE 1=1
AND TABLE_NAME NOT LIKE '%$%'
order by SIZE_MB DESC

; 

--how-to change oracle user password
alter user user_name identified by new_password replace old_password

-- HOW-TO copy table data 
INSERT into DIM_ORG_HIERARCHY_2012 SELECT * from DIM_ORG_HIERARCHY ; 

--how-to check table space usage: 
select df.tablespace_name "Tablespace",
totalusedspace "Used MB",
(df.totalspace - tu.totalusedspace) "Free MB",
df.totalspace "Total MB",
round(100 * ( (df.totalspace - tu.totalusedspace)/ df.totalspace))
"Pct. Free"
from
(select tablespace_name,
round(sum(bytes) / 1048576) TotalSpace
from dba_data_files 
group by tablespace_name) df,
(select round(sum(bytes)/(1024*1024)) totalusedspace, tablespace_name
from dba_segments 
group by tablespace_name) tu
where 1=1 
AND df.tablespace_name = tu.tablespace_name 
AND df.tablespace_name='table_space_name'
; 


--how-to get eh meta data of a db
SELECT ROWNUM , COLUMN_ID , OWNER , TABLE_NAME, COLUMN_NAME , DATA_TYPE , DATA_LENGTH , NULLABLE  
FROM ALL_TAB_COLUMNS
WHERE 1=1
AND OWNER NOT IN ( 'SYS', 'SYSTEM' , 'EXFSYS' , 'WMSYS')
ORDER BY ROWNUM, OWNER , TABLE_NAME , COLUMN_ID
;


declare
   c int; 
begin
   select count(*) into c from all_sequences where SEQUENCE_NAME = upper('SEQ_TBL_NAME'); 

   if c = 1 then
      execute immediate 'DROP SEQUENCE SEQ_TBL_NAME';
   end if; 
end; 
/


--CREATE A SEQUENCE
CREATE SEQUENCE  "SEQ_TBL_NAME"  
MINVALUE 1 MAXVALUE 999999999999999999999999999 
INCREMENT BY 1 START WITH 1 
CACHE 20 NOORDER  NOCYCLE ;

-- CREATE THE TRIGGER
CREATE OR REPLACE TRIGGER "TRG_TBL_NAME" 
BEFORE INSERT ON "TBL_NAME"
REFERENCING NEW AS New OLD AS Old
FOR EACH ROW
   DECLARE
   tmpVar NUMBER;

BEGIN
   tmpVar := 0;

   SELECT SEQ_TBL_NAME.NEXTVAL INTO tmpVar FROM dual;
   :NEW.TBL_NAME_ID:= tmpVar;

END TRG_TBL_NAME; 
/
ALTER TRIGGER "TRG_TBL_NAME" ENABLE;

COMMIT ; 

 
-- gets mins by id's
SELECT * FROM (
 Select 
   Row_Number() Over (Partition By  TableName.ColumnId Order By ColumnMin ASC ) RN
) v
where RN = 1
; 


-- CONVERT THE CURRENT DATE
TO_CHAR(SYSDATE, 'YYYYMMDD')
--YYYY  4-digit year
--YY 2-digit year
--MM Month (1 - 12)
--DD Day (1 - 31)
--HH24  Hour (0 - 23)
--MI Minutes (0 - 59)
--SS Seconds (0 - 59)

SELECT 
   <<COLUMNS LIST>>
 , Case
      When TABLE_NAME.COLUMN_NAME = 'Margin' Then 'M'
      When TABLE_NAME.COLUMN_NAME = 'Interest' Then 'I'
   Else 'D'
   End
FROM TABLE_NAME
; 

-- who , here and when 
   SELECT
    SYSDATE
  , SYS_CONTEXT('USERENV','CURRENT_USER')        AS "CURRENT_USER"
  , SYS_CONTEXT('USERENV','SESSION_USER')        AS "SESSION_USER"
  , SYS_CONTEXT('USERENV','PROXY_USER')          AS "PROXY_USER"
  , SYS_CONTEXT('USERENV','SERVER_HOST')         AS "SERVER_HOST"
  , SYS_CONTEXT('USERENV','DB_NAME')             AS "DB_NAME"
  , SYS_CONTEXT('USERENV','SERVICE_NAME')        AS "SERVICE_NAME"
  , SYS_CONTEXT('USERENV','CURRENT_SCHEMA')      AS "CURRENT_SCHEMA"
  , SYS_CONTEXT('USERENV','INSTANCE_NAME')       AS INSTANCE_NAME
  , SYS_CONTEXT('USERENV','OS_USER')             AS "OS_USER"
  , SYS_CONTEXT('USERENV','HOST')                AS "HOST"
  , SYS_CONTEXT('USERENV','IP_ADDRESS')          AS "IP_ADDRESS"
  
 from dual;   


   select
    SYSDATE

  , SYS_CONTEXT('USERENV','CURRENT_USER')        AS "CURRENT_USER"
  , SYS_CONTEXT('USERENV','CURRENT_USERID')      AS "CURRENT_USERID"
  , SYS_CONTEXT('USERENV','SESSION_USER')        AS "SESSION_USER"
  , SYS_CONTEXT('USERENV','PROXY_USER')          AS "PROXY_USER"
  , SYS_CONTEXT('USERENV','DB_NAME')             AS "DB_NAME"
  , SYS_CONTEXT('USERENV','SERVICE_NAME')        AS "SERVICE_NAME"
  , SYS_CONTEXT('USERENV','CURRENT_SCHEMA')      AS "CURRENT_SCHEMA"
  , SYS_CONTEXT('USERENV','OS_USER')             AS "OS_USER"
  , SYS_CONTEXT('USERENV','HOST')                AS "HOST"
  , SYS_CONTEXT('USERENV','EXTERNAL_NAME')       AS "EXTERNAL_NAME"
  , SYS_CONTEXT('USERENV','IP_ADDRESS')          AS "IP_ADDRESS"
  , SYS_CONTEXT('USERENV','NETWORK_PROTOCOL')    AS "NETWORK_PROTOCOL"
  , SYS_CONTEXT('USERENV','AUTHENTICATION_TYPE') AS "AUTHENTICATION_TYPE"
  , SYS_CONTEXT('USERENV','AUTHENTICATION_TYPE') AS "AUTHENTICATION_TYPE"
  , SYS_CONTEXT('USERENV','TERMINAL')            AS "TERMINAL"
  , SYS_CONTEXT('USERENV','SESSIONID')           AS "SESSIONID"
  , SYS_CONTEXT('USERENV','INSTANCE')            AS "INSTANCE"
  , SYS_CONTEXT('USERENV','ENTRYID')             AS "ENTRYID"
  , SYS_CONTEXT('USERENV','ISDBA')               AS "ISDBA" 
  , SYS_CONTEXT('USERENV','SESSION_USERID')      AS "SESSION_USERID"
  , SYS_CONTEXT('USERENV','PROXY_USERID')        AS "PROXY_USERID"
  
 , SYS_CONTEXT ('USERENV','ACTION')                   ACTION
 , SYS_CONTEXT ('USERENV','AUDITED_CURSORID')         AUDITED_CURSORID
 , SYS_CONTEXT ('USERENV','AUTHENTICATED_IDENTITY')   AUTHENTICATED_IDENTITY
 , SYS_CONTEXT ('USERENV','AUTHENTICATION_DATA')      AUTHENTICATION_DATA
 , SYS_CONTEXT ('USERENV','AUTHENTICATION_METHOD')    AUTHENTICATION_METHOD
 , SYS_CONTEXT ('USERENV','BG_JOB_ID')                BG_JOB_ID
 , SYS_CONTEXT ('USERENV','CLIENT_IDENTIFIER')        CLIENT_IDENTIFIER
 , SYS_CONTEXT ('USERENV','CLIENT_INFO')              CLIENT_INFO
 , SYS_CONTEXT ('USERENV','CURRENT_BIND')             CURRENT_BIND
 , SYS_CONTEXT ('USERENV','CURRENT_EDITION_ID')       CURRENT_EDITION_ID
 , SYS_CONTEXT ('USERENV','CURRENT_EDITION_NAME')     CURRENT_EDITION_NAME
 , SYS_CONTEXT ('USERENV','CURRENT_SCHEMA')           CURRENT_SCHEMA
 , SYS_CONTEXT ('USERENV','CURRENT_SCHEMAID')         CURRENT_SCHEMAID
 , SYS_CONTEXT ('USERENV','CURRENT_SQL')              CURRENT_SQL
 , SYS_CONTEXT ('USERENV','CURRENT_SQLn')             CURRENT_SQLn
 , SYS_CONTEXT ('USERENV','CURRENT_SQL_LENGTH')       CURRENT_SQL_LENGTH
 , SYS_CONTEXT ('USERENV','CURRENT_USER')             CURRENT_USER
 , SYS_CONTEXT ('USERENV','CURRENT_USERID')           CURRENT_USERID
 , SYS_CONTEXT ('USERENV','DATABASE_ROLE')            DATABASE_ROLE
 , SYS_CONTEXT ('USERENV','DB_DOMAIN')                DB_DOMAIN
 , SYS_CONTEXT ('USERENV','DB_NAME')                  DB_NAME
 , SYS_CONTEXT ('USERENV','DB_UNIQUE_NAME')           DB_UNIQUE_NAME
 , SYS_CONTEXT ('USERENV','DBLINK_INFO')              DBLINK_INFO
 , SYS_CONTEXT ('USERENV','ENTRYID')                  ENTRYID
 , SYS_CONTEXT ('USERENV','ENTERPRISE_IDENTITY')      ENTERPRISE_IDENTITY
 , SYS_CONTEXT ('USERENV','FG_JOB_ID')                FG_JOB_ID
 , SYS_CONTEXT ('USERENV','GLOBAL_CONTEXT_MEMORY')    GLOBAL_CONTEXT_MEMORY
 , SYS_CONTEXT ('USERENV','GLOBAL_UID')               GLOBAL_UID
 , SYS_CONTEXT ('USERENV','HOST')                     HOST
 , SYS_CONTEXT ('USERENV','IDENTIFICATION_TYPE')      IDENTIFICATION_TYPE
 , SYS_CONTEXT ('USERENV','INSTANCE')                 INSTANCE
 , SYS_CONTEXT ('USERENV','INSTANCE_NAME')            INSTANCE_NAME
 , SYS_CONTEXT ('USERENV','IP_ADDRESS')               IP_ADDRESS
 , SYS_CONTEXT ('USERENV','ISDBA')                    ISDBA
 , SYS_CONTEXT ('USERENV','LANG')                     LANG
 , SYS_CONTEXT ('USERENV','LANGUAGE')                 LANGUAGE
 , SYS_CONTEXT ('USERENV','MODULE')                   MODULE
 , SYS_CONTEXT ('USERENV','NETWORK_PROTOCOL')         NETWORK_PROTOCOL
 , SYS_CONTEXT ('USERENV','NLS_CALENDAR')             NLS_CALENDAR
 , SYS_CONTEXT ('USERENV','NLS_CURRENCY')             NLS_CURRENCY
 , SYS_CONTEXT ('USERENV','NLS_DATE_FORMAT')          NLS_DATE_FORMAT
 , SYS_CONTEXT ('USERENV','NLS_DATE_LANGUAGE')        NLS_DATE_LANGUAGE
 , SYS_CONTEXT ('USERENV','NLS_SORT')                 NLS_SORT
 , SYS_CONTEXT ('USERENV','NLS_TERRITORY')            NLS_TERRITORY
 
 , SYS_CONTEXT ('USERENV','POLICY_INVOKER')           POLICY_INVOKER
 , SYS_CONTEXT ('USERENV','PROXY_ENTERPRISE_IDENTITY') PROXY_ENTERPRISE_IDENTITY
 , SYS_CONTEXT ('USERENV','PROXY_USER')               PROXY_USER
 , SYS_CONTEXT ('USERENV','PROXY_USERID')             PROXY_USERID
 , SYS_CONTEXT ('USERENV','SERVER_HOST')              SERVER_HOST
 , SYS_CONTEXT ('USERENV','SERVICE_NAME')             SERVICE_NAME
 , SYS_CONTEXT ('USERENV','SESSION_EDITION_ID')       SESSION_EDITION_ID
 , SYS_CONTEXT ('USERENV','SESSION_EDITION_NAME')     SESSION_EDITION_NAME
 , SYS_CONTEXT ('USERENV','SESSION_USER')             SESSION_USER
 , SYS_CONTEXT ('USERENV','SESSION_USERID')           SESSION_USERID
 , SYS_CONTEXT ('USERENV','SESSIONID')                SESSIONID
 , SYS_CONTEXT ('USERENV','SID')                      SID
 , SYS_CONTEXT ('USERENV','STATEMENTID')              STATEMENTID
 , SYS_CONTEXT ('USERENV','TERMINAL')                 TERMINAL
  
 from dual;   

 
/* Purpose: 
To provide a cheat sheet for oracle sql 

VersionHistory: 
1.2.1 --- 2013-07-24 10:54:16 --- ysg --- added table space usage snippet
1.2.0 --- 2012-09-12 13:07:49 --- ysg --- Added get table sizes 
1.1.9 --- 2012-09-10 09:40:03 --- ysg --- added SYNONYMS GENERATION 
1.1.8 --- 2012-05-30 17:24:59 --- ysg --- Added order by for all_tab_columns !!! bug 
1.1.7 --- 2012-05-29 10:12:40 --- ysg --- how-to restore allready dropped table
1.1.6 --- 2012-05-28 16:39:22 --- ysg --- Added indexes 
1.1.5 --- 2012-05-16 14:01:57 --- ysg --- Added select top and select limit ora version
1.1.4 --- 2012.05.02 10:12:03 --- ysg --- Added check duplicates example
1.1.3 --- 2012-04-27 10:28:29 --- ysg --- Added check oracle version  
1.1.2 --- 2012-04-26 15:27:14 --- ysg --- Added current sessions privs query 
1.1.1 --- ysg --- Added how-to copy table 
1.1.0 --- ysg --- added generate col list 
1.0.0 --- ysg --- initial creation 

*/
