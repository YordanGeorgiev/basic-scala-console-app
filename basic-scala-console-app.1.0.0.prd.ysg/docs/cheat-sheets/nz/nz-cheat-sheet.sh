netezza cheat sheet
#File:netezza-cheat-sheet.sh  v1.2.5

# how-to get help
command -h
# how-to get commands' help
commmand -hc
# how-to create an user
nzpassword add -u username -pw password -host hostname

#how-to export sql result set into a file
nzsql -F ";" -d $db_name -c "SELECT * FROM $table WHERE 1=1 AND LOAD_TM > to_date ( '2013-04-16 00:00:00' , 'YYYY-MM-DD HH24:MI:SS') ORDER BY LOAD_TM DESC ;" -o /tmp/data/tmp.txt

nzsql -F " " -d SYSTEM -c "SELECT HW_HWID FROM SYSTEM.._V_SPU ;"

# how-to restore a db without the data
nzrestore -db DbNameToRestore -sourcedb BackUpSetDatabaseName -increment 3 -schema-only -dir /backup2

#drop session on some criteria ( use grep for filtering )
nzsession | grep idle | awk '/idle/ {print "nzsession abort -force -id "$1}' > /tmp/drop_sessions.sh

# show the disk usage
nzds show -detail | perl -ne 'split /\s+/;print $_[9] ." " ; print $_  ' | sort -nr

#backup
#where are stored the log files of the backup scripts
/export/home/nz/BackupScripts/log

#how-to view the latest 4 differential backups
for file in `ls -t1 /export/home/nz/BackupScripts/log/RunBackUpDiff* | head -n 4` ; do cat $file ; done ;

#how-to view the latest 10 backup files starting with the newest on top
ls -alt --time-style=long-iso /export/home/nz/BackupScripts/log/* | head -n 10

#how-to create an repot of the db and table sizes
sh /nz/support/nz_db_size >> /export/home/nz/Logs/nz-dbs-tables-sizes-report.txt

# how-to kill idle sessions
nzsession | grep SLOW_READER_ACCOUNT | awk '/idle/ {print "nzsession abort -force -id "$1}' > drop_sessions.sh

# check the swap space usage
/nz/kit/bin/nzstats -type spu

# show sub command help
/nz/kit/bin/nzstats -hc show

# check the number of active users per database
/nz/kit/bin/nzstats show -type database

/nz/support-TwinFin-5.0-100107-1556/bin/nz_view_references -h

nzhw -detail -type SPU

#how-to find out what where has been backed up
for i in {1..4}; do find "/backup${i}" -maxdepth 3 -mindepth 3 ; done ;

#check the exact errors from the last 1000 backup logs
for file in `ls -lrt /nz/kit.7.0.P4/log/backupsvr/*.log | perl -ne 'split /\s+/;print $_[8]."\n"' | tail -1000` ; do grep -nH Error $file ; done ;


#how-to check from odbc.ini the name of the db by the connection string
export IniFile=/informatica/9.1.0/ODBC6.1/odbc.ini
export IniSection=nz_etl_test
sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
      -e 's/;.*$//' \
      -e 's/[[:space:]]*$//' \
      -e 's/^[[:space:]]*//' \
      -e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
      < $IniFile \
      | sed -n -e "/^\[$IniSection\]/,/^\s*\[/{/^[^;].*\=.*/p;}" | grep -i database

#how-to search for "broken" views which need to be recreated
/nz/support-TwinFin-5.0-100107-1556/bin/nz_view_references
/nz/support/bin/nz_view_references

#how-to show the number of active users per db
/nz/kit/bin/nzstats -type database | sort -n -k8


#how-to check current system sfw version and revision
nzrev; nz_stats


#how-to check the current version of the netezza support scripts
nz_help -version

# show the utilization of the components
nzsqa proctbl -all | grep -i util

#how-to show hardware issues
nzhw show -issues

#important paths
#where are the netezza cli binaries
/nz/support/bin/
/nz/kit/bin/
/nz/kit/bin/adm/

#important logs
/var/log/nz/heartbeat_admin.log
/nz/kit.7.0.P4/log/postgres/pg.log

#important conf files
/etc/ha.d/ha.cf

# check the clustering and resource group status on NPS
crm_mon -i5

# report db sizes on
nz_db_size -summary

# Start the nzAdmin windows tool , start , run , type
"C:\Program Files\IBM Netezza Tools\Bin\NzAdmin.exe"

#how-to check for locks on netezza tables
nzsql -F ";" -d $db_name -c "SELECT * FROM _T_PG_LOCKS;" -a | grep -i TERRA

# how-to check which tables do need grooming
perl /nz/kit.7.0.P4/bin/adm/tools/cbts_needing_groom -db TERRA_STG_PROD

# now-to check for haning sessoins
export db_name=SYSTEM;nzsql -F ";" -d $db_name -c " select q.qs_planid, q.qs_sessionid, q.qs_clientid, s.dbname, s.username, q.qs_cliipaddr,
 q.qs_state, q.qs_tsubmit, q.qs_tstart, case when q.qs_tstart = 'epoch' then '0' else abstime 'now' - q.qs_tstart end,
initcap(q.qs_pritxt), case when qs_estcost >= 0 then ltrim(to_char(cast(qs_estcost as float)/1000,'99999999999999999.999'))
else ltrim(to_char(cast((18446744073709551616 + qs_estcost) as float)/1000, '99999999999999999.999')) end,
q.qs_estdisk, q.qs_estmem, q.qs_snippets, q.qs_cursnipt, q.qs_resrows, q.qs_resbytes , q.qs_sql from _v_qrystat q, _v_session s
where 1=1 and q.qs_sessionid = s.id and q.QS_STATE not in ( 2,3);" -a



# find out the heaviest queries today
export db_name=SYSTEM;nzsql -F ";" -d $db_name -c " SELECT * FROM _V_QRYHIST
where 1=1 AND QH_TSUBMIT > CURRENT_DATE ORDER BY QH_ESTCOST ASC" -a

export db_name=SYSTEM;
#how-to list the columns of a table
export sql=" SELECT ' , ' || NAME || '.' || ATTNAME  from _V_RELATION_COLUMN WHERE 1=1
AND NAME LIKE 'DIM_PAYER_ADDRESS'
ORDER BY NAME , ATTNUM
;";

nzsql -F ";" -d $db_name -c "$sql" -a


#how-to export a list of netezza tables into csv files :
export db_name=SET_HERE_YOUR_DB_NAME
export schema_owner=SET_HERE_YOUR_SCHEMA_OWNER


for table in `echo table_name1 table_name2 `; do (nzsql -F ";" -d $db_name -c "SELECT * FROM $db_name.$schema_owner.$table" -A -q -o /tmp/$db_name.$table.csv.tmp ) ; head --lines=-1 /tmp/$db_name.$table.csv.tmp > /tmp/$db_name.$table.csv; rm -fv /tmp/$db_name.$table.csv.tmp ; done ;



nz_responders

#
# Purpose:
# To provide a simple cheat sheet for netezza administration and command line utilities

# eof file: netezza-cheat-sheet.sh
