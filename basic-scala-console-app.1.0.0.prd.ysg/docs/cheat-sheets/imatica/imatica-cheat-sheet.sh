
export IMATICA_USER=KON0136
export IMATICA_FOLDER=3RD_PARTY
# xpath to get the target files
export to_srch="/POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/SESSIONEXTENSION/ATTRIBUTE[@NAME='Output filename']"
for file in `ls -1 sfw/imatica/$IMATICA_FOLDER/wfs/$IMATICA_USER/*.XML`; do echo -e "\n\nfound in file: $file:\n" ; xpath "$file" "$to_srch"; done ;
for file in `ls -1 $dir/*.XML`; do echo -e "\n\nfound in file: $file:\n" ; xpath "$file" "$to_srch"; done ;

#search for the error log files on session level
export to_srch="/POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/CONFIGREFERENCE/ATTRIBUTE[@NAME ='Error Log File Name']"
for file in `ls -1 sfw/imatica/$IMATICA_FOLDER/wfs/$IMATICA_USER/*.XML`; do echo -e "\n\nfound in file: $file:\n" ; xpath "$file" "$to_srch"; done ;


/cygdrive/c/Informatica/PowerCenter8.6.1/client/bin/pmrep.exe objectexport -n NETTIHYVAKSYNNAT_2_LK_DAILY -f AKTIA_AKF -o workflow -s -b -r -u <<name>>.XML

## xpath to get the connection references
/POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/SESSIONEXTENSION/CONNECTIONREFERENCE
srch: CONNECTIONTYPE ="Relational" VARIABLE =""
repl: CONNECTIONTYPE ="Relational" VARIABLE ="$DBConnectionSrc"
srch: "AAA_DUMMY"
repl: ""

# FILE: InformaticaCheatSheet.sh --- v1.2.0 docs at the end 

# Links
http://www.info-etl.com/course-materials/questions-informatica-community

# SET FIRST YOUR ENVIRONMENT VARS !!!

# list all the sources  of a workflow 
xpath wf_SAP_SD_ABP_WCOD.XML /POWERMART/REPOSITORY/FOLDER/SOURCE/@NAME 2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'

# list all the targets of a workflow 
xpath wf_SAP_SD_ABP_WCOD.XML /POWERMART/REPOSITORY/FOLDER/TARGET/@NAME 2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'


#list all the sessions in a workflow 
xpath  $file /POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/@NAME 2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'

#list all the mappings of a workflow 
xpath wf_SAP_SD_ABP_WCOD.XML /POWERMART/REPOSITORY/FOLDER/MAPPING/@NAME 2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'

# list all the workflow variables of a workflow 
xpath wf_SAP_SD_ABP_WCOD.XML /POWERMART/REPOSITORY/FOLDER/WORKFLOW/WORKFLOWVARIABLE  2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'

xpath $wf_name.XML /POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/SESSIONEXTENSION/CONNECTIONREFERENCE/@CONNECTIONNAME 2>> errors.log | perl -ne 'print join "\n" ,  (split /\s+/, $_) ;'



# print all the connections 
find . -type f -print -exec xpath {} /POWERMART/REPOSITORY/FOLDER/WORKFLOW/SESSION/SESSIONEXTENSION/CONNECTIONREFERENCE/@CONNECTIONNAME \; >> mankeli-imatica-connections-list.txt 2> /dev/null &




# Unix 
# dirBin=/informatica/powercenter/server/bin
# pmrep=$dirBin/pmrep
# pmcmd=$dirBin/pmcmd

# Windows
dirBin=/cygdrive/c/Informatica/PowerCenter8.6.1/client_8.6.1_HF0/bin
pmcmd=$dirBin/pmcmd.exe
pmrep=$dirBin/pmrep.exe


IMATICA_USER=$IMATICA_USER;export IMATICA_USER;
IMATICA_PW=$IMATICA_PW;export IMATICA_PW;
FOLDER_NAME=MANKELI;export FOLDER_NAME;
export REPOSITORY=rs_company_prod
export DOMAIN=Domain_company_prod
SERVICE_NAME=is_company_prod01;export SERVICE_NAME;
wf=SetAWorkFlowHere

# !!!
cd $dirBin
# OK connect with pmrep first 
$pmrep connect -r $REPOSITORY -d $DOMAIN -n $IMATICA_USER -s Native -x $IMATICA_PW

cd $dirBin
# OK Unix connect with pmcmd first 
$pmcmd connect -sv $SERVICE_NAME -domain $DOMAIN -timeout 5 -u $IMATICA_USER -p $IMATICA_PW -usd Native


# OK how-to stop workflows
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'| sort` ; do  echo $pmcmd stopworkflow -sv $SERVICE_NAME -u $IMATICA_USER -p $IMATICA_PW -f $FOLDER_NAME -nowait $wf ;done ; 

# how-to recover workflow only echo 
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'| sort` ; do  echo $pmcmd recoverworkflow -sv $SERVICE_NAME -u $IMATICA_USER -p $IMATICA_PW -f $FOLDER_NAME -nowait $wf \& ;done ; 


# how-to export all the workflow objects of one folder 
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -s -b -r -u $wf.xml  ;done ;


# how-to export all the mappings objects of one folder 
for mapping in `$pmrep listobjects -o mapping -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/mapping //'` ; do  $pmrep objectexport -n $mapping -f $FOLDER_NAME -o mapping -s -b -r -u $mapping.xml  ;done ;


# WIP
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'| sort` ; do  echo $pmcmd scheduleworkflow -sv $SERVICE_NAME -u $IMATICA_USER -p $IMATICA_PW -f $FOLDER_NAME $wf \& ;done ; 


$pmcmd stopworkflow  -f $FOLDER_NAME -nowait wf_$FOLDER_NAME
$pmcmd startworkflow  -f $FOLDER_NAME -nowait wf_$FOLDER_NAME


#OK how-to export an object 
objectexport -n $wf -f $FOLDER_NAME -o workflow -s -b -r -u  /tmp/$wf.xml

$pmrep connect -r $REPOSITORY -d $DOMAIN -n $IMATICA_USER -s Native -x $IMATICA_PW objectexport -n $wf -f $FOLDER_NAME -o workflow -s -b -r -u  /tmp/$wf.xml

for wf in `$pmrep listobjects -o workflow -f FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f FOLDER_NAME -o workflow -s -b -r -u  $wf.xml  ;done ;

# WIP 
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  echo $pmcmd stopworkflow -d $DOMAIN -u $IMATICA_USER -p $IMATICA_PW  -f $FOLDER_NAME -nowait $wf ;done ;




$pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -s -b -r -u  /tmp/$wf.xml
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -s -b -r -u  $wf.xml  ;done ;
cd $pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'
$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'
$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //' | sort
$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //' | sort
$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //' | sort | mail -s $FOLDER_NAME workflows ext-yordan.georgiev@company.fi
$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //' | sort | mail -t  ext-yordan.georgiev@company.fi
$pmrep listobjects -o Target -f $FOLDER_NAME | sed '1,8d;/successfully/,$d'
$pmrep listobjects -o Target -f $FOLDER_NAME
$pmrep listobjects -o Target -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/target //'
$pmrep listobjects -o Mapplet -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/mapplet //'
$pmrep listobjects -o Mapplet -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/mapplet //'
$pmrep listobjects -o Session -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/session //'
for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -s -b -r -u  $wf.xml  ;done ;
$pmrep listobjects -o workflow -f | sed '1,8d;/successfully/,$d'
$pmrep listobjects -o workflow | sed '1,8d;/successfully/,$d'
$pmrep listobjects -o folder
for folder in `$pmrep listobjects -o folder` ; do echo $FOLDER_NAME ; done ;
for folder in `$pmrep listobjects -o folder` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -s -b -r -u  $wf.xml  ;done ; ; done ;
for folder in `$pmrep listobjects -o folder` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -s -b -r -u  $wf.xml  ;done ; done ;
for folder in `$pmrep listobjects -o folder` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ; done ;
for FOLDER_NAME in `$pmrep listobjects -o folder` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ; done ;
$pmrep listobjects -o folder
$pmrep listobjects -o folder | sed '1,8d;/successfully/,$d'
for FOLDER_NAME in `$pmrep listobjects -o folder | sed '1,8d;/successfully/,$d'` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do  $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ; done ;
for FOLDER_NAME in `$pmrep listobjects -o folder | sed '1,8d;/successfully/,$d'` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do echo $wf ;done ; done ;
$pmrep objectimport -i /$FOLDER_NAME/data/imatica/import/wf_FACT_PLN_HR_BY_CC_COPY_PREV_TS.xml -c /$FOLDER_NAME/data/imatica/import/import_control.xml

$pmrep objectimport -i /$FOLDER_NAME/data/imatica/import/wf_FACT_PLN_HR_BY_CC_COPY_PREV_TS.xml -c /$FOLDER_NAME/data/imatica/import/import_control.xml

$pmrep objectimport -i /$FOLDER_NAME/data/imatica/import/wf_FACT_PLN_HR_BY_CC_COPY_PREV_TS.xml -c /$FOLDER_NAME/data/imatica/import/import_control.xml
-c /$FOLDER_NAME/data/imatica/import/import_control_to_test.xml
$pmrep
$pmrep connect -r rs_company_test01 -d Domain_company_test -n $IMATICA_USER -s Native -x $IMATICA_PW
$pmrep
for wf in `cat wf_list.txt`; do $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ;
$pmrep
$pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ;
$pmrep connect -r $REPOSITORY -d $DOMAIN -n $IMATICA_USER -s Native -x $IMATICA_PW
$pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ;
for wf in `cat wf_list.txt`; do $pmrep objectexport -n $wf -f $FOLDER_NAME -o workflow -m -s -b -r -u $wf.xml  ;done ;
for FOLDER_NAME in `$pmrep listobjects -o folder | sed '1,8d;/successfully/,$d'` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do echo $FOLDER_NAME --- $wf ;done ; done ;
for FOLDER_NAME in `$pmrep listobjects -o folder | sed '1,8d;/successfully/,$d'` ; do for wf in `$pmrep listobjects -o workflow -f $FOLDER_NAME | sed '1,8d;/successfully/,$d' | sed -e 's/workflow //'` ; do echo $FOLDER_NAME --- $wf ;done ; done ;

# where is tnsnames.ora
in the client ora bin 

PRDFINBE2.tellus.company.fi



do pmcmd.exe unscheduleworkflow -sv %INFA_SERVICE% -d %INFA_DEFAULT_DOMAIN% -uv INFA_PM_USER -pv INFA_PM_PASSWORD -f %%i %%j 


do pmcmd.exe unscheduleworkflow -sv %INFA_SERVICE% -d %INFA_DEFAULT_DOMAIN% -uv INFA_PM_USER -pv INFA_PM_PASSWORD -f %%i %%j 


# on Windows - how-to make a backup of my informatica repo settings : 
reg export "HKEY_CURRENT_USER\Software\Informatica\PowerMart Client Tools\9.1.0\Cache Repository List" company-repo-settings.reg 


https://infaprod.cc.company.fi:8443/administrator/s

# some frequently used 
#&#x5c; => \

# informatica parameter file
# http://blogs.hexaware.com/informatica-way/informatica-parameter-files/

# Purpose:
# To provide working set of commands to perform actions on Informatica cmd tools 

#
# VersionHistory: 
#
# 1.2.0 --- 2012-08-15 09:24:31 --- ysg --- added env vars setting 
# 1.1.0 --- 2012-08-10 15:31:18 --- ysg --- fixed $pmrep object export for recursive export 
# 1.0.0 --- 2012-07-11 10:26:07 --- ysg --- Initial creation , copied history 
# eof file : InformaticaCheatSheet.sh