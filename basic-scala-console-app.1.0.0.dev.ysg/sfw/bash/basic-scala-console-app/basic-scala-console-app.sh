#!/bin/bash 
# file: sfw/bash/basic-scala-console-app.sh docs at the eof file

umask 022    ;

# print the commands
# set -x
# print each input line as well
# set -v
# exit the script if any statement returns a non-true return value. gotcha !!!
# set -e
trap 'doExit $LINENO $BASH_COMMAND; exit' SIGHUP SIGINT SIGQUIT

#v1.0.0 
#------------------------------------------------------------------------------
# the main function called
#------------------------------------------------------------------------------
main(){
   doInit

  	doParseCmdArgs

   case $1 in "-u"|"-usage"|"--usage") \
            doPrintUsage ; exit 0 ; esac
   case $1 in "-h"|"-help"|"--help") \
            doPrintHelp ; exit 0 ; esac
  	doParseCmdArgs "$@"

  	doSetVars
  	doCheckReadyToStart
	doRunActions "$@"
  	doExit 0 "# = STOP  MAIN = $wrap_name "

}
#eof main

get_function_list () {
    env -i bash --noprofile --norc -c '
    source "'"$1"'"
    typeset -f |
    grep '\''^[^{} ].* () $'\'' |
    awk "{print \$1}" |
    while read -r function_name; do
        type "$function_name" | head -n 1 | grep -q "is a function$" || continue
        echo "$function_name"
    done
'
}

#v1.0.0 
#------------------------------------------------------------------------------
# run all the actions
#------------------------------------------------------------------------------
doRunActions(){

	cd $product_version_dir
   test -z "$actions" && doPrintUsage && doExit 0 

	while read -d ' ' action ; do (
		doLog "action: \"$action\""
		while read -r func_file ; do (
			while read -r function_name ; do (

				action_name=`echo $(basename $func_file)|sed -e 's/.func.sh//g'`
				test "$action_name" != $action && continue
				
				doLog "running action :: $action_name":"$function_name"
				test "$action_name" == "$action" && $function_name


			);
			done< <(get_function_list "$func_file")
		); 
		done < <(find sfw/bash/basic-scala-console-app/funcs -type f -name '*.sh')

				
		test "$action" == 'to-dev'									&& doChangeEnvType 'dev'
		test "$action" == 'to-tst'									&& doChangeEnvType 'tst'
		test "$action" == 'to-qas'									&& doChangeEnvType 'qas'
		test "$action" == 'to-prd'									&& doChangeEnvType 'prd'
		[[ $action == to-ver=* ]]									&& doChangeVersion $action
		[[ $action == to-app=* ]]									&& doCloneToApp $action
		test "$action" == 'save-tmux-session'					&& doSaveTmuxSession
		test "$action" == 'restore-tmux-session'				&& doRestoreTmuxSession

	);
	done < <(echo "$actions")



}
#eof fun doRunActions


#v1.0.0 
#------------------------------------------------------------------------------
# register the run-time vars before the call of the $0
#------------------------------------------------------------------------------
doInit(){
   call_start_dir=`pwd`
   wrap_bash_dir=`dirname $(readlink -f $0)`
   tmp_dir="$wrap_bash_dir/tmp/.tmp.$$"
   mkdir -p "$tmp_dir"
   ( set -o posix ; set ) >"$tmp_dir/vars.before"
   my_name_ext=`basename $0`
   wrap_name=${my_name_ext%.*}
   test $OSTYPE = 'cygwin' && host_name=`hostname -s`
   test $OSTYPE != 'cygwin' && host_name=`hostname`
}
#eof doInit



#v1.0.0 
#------------------------------------------------------------------------------
# parse the single letter command line args
#------------------------------------------------------------------------------
doParseCmdArgs(){

   # traverse all the possible cmd args
   while getopts ":a:c:i:h:" opt; do
     case $opt in
      a)
         actions="$actions$OPTARG "
         ;;
      c)
         export component_name="$OPTARG "
         ;;
      i)
         include_file="$include$OPTARG "
         ;;
      h)
         doPrintHelp
         ;;
      \?)
         doExit 2 "Invalid option: -$OPTARG"
         ;;
      :)
         doExit 2 "Option -$OPTARG requires an argument."
         ;;
     esac
   done
}
#eof func doParseCmdArgs




#v1.0.0 
#------------------------------------------------------------------------------
# create an example host dependant ini file
#------------------------------------------------------------------------------
doCreateDefaultConfFile(){

	echo -e "#file: $conf_file \n\n" >> $conf_file
	echo -e "[MainSection] \n" >> $conf_file
	echo -e "#use simple var_name=var_value syntax \n">>$conf_file
	echo -e "#the name of this application ">>$conf_file
	echo -e "app_name=$wrap_name\n" >> $conf_file
	echo -e "#the e-mails to send the package to ">>$conf_file
	echo -e "Emails=some.email@company.com\n" >> $conf_file
	echo -e "#the name of this application's db" >> $conf_file
	echo -e "db_name=$env_type""_""$wrap_name\n\n" >> $conf_file
	echo -e "#eof file: $conf_file" >> $conf_file

}
#eof func doCreateDefaultConfFile


#v1.0.0 
#------------------------------------------------------------------------------
# perform the checks to ensure that all the vars needed to run are set
#------------------------------------------------------------------------------
doCheckReadyToStart(){

   test -f $conf_file || doCreateDefaultConfFile 

	# check http://stackoverflow.com/a/677212/65706
	# but which works for both cygwin and Ubuntu
	command -v zip 2>/dev/null || { echo >&2 "The zip binary is missing ! Aborting ..."; exit 1; }
	which perl 2>/dev/null || { echo >&2 "The perl binary is missing ! Aborting ..."; exit 1; }

}
#eof func doCheckReadyToStart


#v1.0.0 
#------------------------------------------------------------------------------
# prints the usage of this script
#------------------------------------------------------------------------------
doPrintUsage(){

   printf "\033[2J";printf "\033[0;0H"
   
	cat <<END_HELP

   #
   ## START --- USAGE `basename $0`
   #-----------------------------------------------------------------------------
      bash $0
      bash $0 -u
      bash $0 -usage
      bash $0 --usage

      bash $0 -h
      bash $0 -help
      bash $0 --help

      bash $0 -a sbt-clean-compile
      bash $0 -a sbt-compile
      bash $0 -a sbt-run
      bash $0 -a create-full-package
      bash $0 -a create-full-package -i <<path_to_include_file>>
      bash $0 -a create-full-package -i <<path_to_include_file>> -a gmail-package
		bash $0 -a create-deployment-package
		bash $0 -a create-deployment-package -i <<path_to_include_file>>
		bash $0 -a create-deployment-package -i <<path_to_include_file>> -a gmail-package
		bash $0 -a create-relative-package
		bash $0 -a create-relative-package -i <<path_to_include_file>>
		bash $0 -a create-relative-package -i <<path_to_include_file>> -a gmail-package

      bash $0 -a remove-package
      bash $0 -a remove-package -i <<path_to_include_file>>
      bash $0 -a remove-package-files
      bash $0 -a remove-package-files -i <<path_to_include_file>>

		bash $0 -a to-tst
		bash $0 -a to-dev
		bash $0 -a to-prd
      bash $0 -a to-ver=0.1.9
      bash $0 -a to-app=<<new_app_name>>
      bash $0 -a check-perl-syntax
      bash $0 -a run-perl-tests

      bash $0 -a save-tmux-session
      bash $0 -a restore-tmux-session
		

   #
   ## STOP  --- USAGE `basename $0`
   #------------------------------------------------------------------------------

END_HELP
}
#eof func doPrintUsage



#v1.0.0 
#------------------------------------------------------------------------------
# clean and exit with passed status and message
#------------------------------------------------------------------------------
doExit(){

   exit_code=0
   exit_msg="$*"

   case $1 in [0-9])
      exit_code="$1";
      shift 1;
   esac

   if [ "$exit_code" != 0 ] ; then
      exit_msg=" ERROR --- exit_code $exit_code --- exit_msg : $exit_msg"
      echo "$Msg" >&2
      #doSendReport
   fi

   doCleanAfterRun

   # if we were interrupted while creating a package delete the package
   test -z $flag_completed || test $flag_completed -eq 0 \
         && test -f $zip_file && rm -vf $zip_file

   #flush the screen
   #printf "\033[2J";printf "\033[0;0H"
   doLog "INFO $exit_msg"
   echo -e "\n\n"
	cd $call_start_dir
   exit $exit_code
}
#eof func doExit


#v1.0.0 
#------------------------------------------------------------------------------
# echo pass params and print them to a log file and terminal
# with timestamp and $host_name and $0 PID
# usage:
# doLog "INFO some info message"
# doLog "DEBUG some debug message"
#------------------------------------------------------------------------------
doLog(){
   type_of_msg=$(echo $*|cut -d" " -f1)
   msg="$(echo $*|cut -d" " -f2-)"
   [[ $type_of_msg == DEBUG ]] && [[ $do_print_debug_msgs -ne 1 ]] && return
   [[ $type_of_msg == INFO ]] && type_of_msg="INFO "

   # print to the terminal if we have one
   test -t 1 && echo " [$type_of_msg] `date +%Y.%m.%d-%H:%M:%S` [basic-scala-console-app][@$host_name] [$$] $msg "

   # define default log file none specified in conf file
   test -z $log_file && \
		mkdir -p $product_version_dir/data/log/bash && \
			log_file="$product_version_dir/data/log/bash/$wrap_name.`date +%Y%m`.log"
   echo " [$type_of_msg] `date +%Y.%m.%d-%H:%M:%S` [$wrap_name][@$host_name] [$$] $msg " >> $log_file
}
#eof func doLog


#v1.0.0
#------------------------------------------------------------------------------
# cleans the unneeded during after run-time stuff
# do put here the after cleaning code
#------------------------------------------------------------------------------
doCleanAfterRun(){
   # remove the temporary dir and all the stuff bellow it
   cmd="rm -fvr $tmp_dir"
   doRunCmdAndLog "$cmd"
   find "$wrap_bash_dir" -type f -name '*.bak' -exec rm -f {} \;
}
#eof func doCleanAfterRun


#v1.0.0 
#------------------------------------------------------------------------------
# run a command and log the call and its output to the log_file
# doPrintHelp: doRunCmdAndLog "$cmd"
#------------------------------------------------------------------------------
doRunCmdAndLog(){
  cmd="$*" ;
  doLog "DEBUG running cmd and log: \"$cmd\""

   msg=$($cmd 2>&1)
   ret_cmd=$?
   error_msg=": Failed to run the command:
		\"$cmd\" with the output:
		\"$msg\" !!!"

   [ $ret_cmd -eq 0 ] || doLog "$error_msg"
   doLog "DEBUG : cmdoutput : \"$msg\""
}
#eof func doRunCmdAndLog


#v1.0.0 
#------------------------------------------------------------------------------
# run a command on failure exit with message
# doPrintHelp: doRunCmdOrExit "$cmd"
# call by:
# set -e ; doRunCmdOrExit "$cmd" ; set +e
#------------------------------------------------------------------------------
doRunCmdOrExit(){
   cmd="$*" ;

   doLog "DEBUG running cmd or exit: \"$cmd\""
   msg=$($cmd 2>&1)
   ret_cmd=$?
   # if occured during the execution exit with error
   error_msg=": FATAL : Failed to run the command \"$cmd\" with the output \"$msg\" !!!"
   [ $ret_cmd -eq 0 ] || doExit "$ret_cmd" "$error_msg"

   #if no occured just log the message
   doLog "DEBUG : cmdoutput : \"$msg\""
}
#eof func doRunCmdOrExit


#v1.0.0 
#------------------------------------------------------------------------------
# set the variables from the $0.$host_name.conf file which has ini like syntax
#------------------------------------------------------------------------------
doSetVars(){
   cd $wrap_bash_dir
	set +x 
   for i in {1..3} ; do cd .. ; done ;
   export product_version_dir=`pwd`;
	# include all the func files to fetch their funcs 
	while read -r func_file ; do . "$func_file" ; done < <(find . -name "*func.sh")
	while read -r func_file ; do echo "$func_file" ; done < <(find . -name "*func.sh")

   # this will be dev , tst, prd
   env_type=$(echo `basename "$product_version_dir"`|cut --delimiter='.' -f5)
	product_version=$(echo `basename "$product_version_dir"`|cut --delimiter='.' -f2-4)
	environment_name=$(basename "$product_version_dir")

	cd ..
	product_dir=`pwd`;

	cd ..
	product_base_dir=`pwd`;

	org_dir=`pwd`
	org_name=$(echo `basename "$org_dir"`)

	cd ..
	org_base_dir=`pwd`;

	cd "$wrap_bash_dir/"
	doParseConfFile
	( set -o posix ; set ) >"$tmp_dir/vars.after"


	doLog "INFO # --------------------------------------"
	doLog "INFO # -----------------------"
	doLog "INFO # ===		 START MAIN   === $wrap_name"
	doLog "INFO # -----------------------"
	doLog "INFO # --------------------------------------"
		
		exit_code=1
		doLog "INFO using the following vars:"
		cmd="$(comm --nocheck-order -3 $tmp_dir/vars.before $tmp_dir/vars.after | perl -ne 's#\s+##g;print "\n $_ "' )"
		echo -e "$cmd"

		# and clear the screen
		printf "\033[2J";printf "\033[0;0H"
}
#eof func doSetVars


#v1.0.0
#------------------------------------------------------------------------------
# parse the ini like $0.$host_name.conf and set the variables
# cleans the unneeded during after run-time stuff. Note the MainSection
# courtesy of : http://mark.aufflick.com/blog/2007/11/08/parsing-ini-files-with-sed
#------------------------------------------------------------------------------
doParseConfFile(){
	# set a default configuration file
	conf_file="$wrap_bash_dir/$wrap_name.conf"

	# however if there is a host dependant conf file override it
	test -f "$wrap_bash_dir/$wrap_name.$host_name.conf" \
		&& conf_file="$wrap_bash_dir/$wrap_name.$host_name.conf"
	
	# if we have perl apps they will share the same configuration settings with this one
	test -f "$product_version_dir/$wrap_name.$host_name.conf" \
		&& conf_file="$product_version_dir/$wrap_name.$host_name.conf"

	# yet finally override if passed as argument to this function
	# if the the ini file is not passed define the default host independant ini file
	test -z "$1" || conf_file=$1;shift 1;
	#debug echo "@doParseConfFile conf_file:: $conf_file" ; sleep 6
	# coud be later on parametrized ... 
	INI_SECTION=MainSection

	eval `sed -e 's/[[:space:]]*\=[[:space:]]*/=/g' \
		-e 's/#.*$//' \
		-e 's/[[:space:]]*$//' \
		-e 's/^[[:space:]]*//' \
		-e "s/^\(.*\)=\([^\"']*\)$/\1=\"\2\"/" \
		< $conf_file \
		| sed -n -e "/^\[$INI_SECTION\]/,/^\s*\[/{/^[^#].*\=.*/p;}"`
   
		
}
#eof func doParseConfFile



#v1.0.0
#------------------------------------------------------------------------------
# zip all the files specified in the include file relatively 
# and uunzip them into ../basic-scala-console-app.<<version>>.<<new_environment>>.<<owner>>
#------------------------------------------------------------------------------
doChangeEnvType(){

	tgt_env="$1"
	tgt_environment_name=$(echo $environment_name | perl -ne "s/$env_type/$tgt_env/g;print")
	tgt_product_version_dir=$product_dir/$tgt_environment_name
	mkdir -p $tgt_product_version_dir	
	test $? -ne 0 && doExit 2 "Failed to create $tgt_product_version_dir !"

	test "$tgt_env" == "$env_type" && return
	# remove everything from the tgt product version dir - no extra files allowed !!!
	rm -fvr $tgt_product_version_dir/*
	test $? -eq 0  || doExit 2 "cannot write to $tgt_product_version_dir !"
	
	doCreateRelativePackage
	unzip -o $zip_file -d $tgt_product_version_dir
	cp -v $zip_file $tgt_product_version_dir

	# ensure that all the files in the target product version dir are indentical to the current ones
	for file in `cat $include_file`; do (
		cmd="diff $product_version_dir/$file $product_version_dir/$file"
		doRunCmdOrExit "$cmd"
	);
	done

}
#eof func doChangeEnvType



#v1.0.0 
#------------------------------------------------------------------------------
# increase or decrease the version of the product
# bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-ver=0.0.5
#------------------------------------------------------------------------------
doChangeVersion(){

	tgt_version="$1"
	shift 1;
	prefix='to-ver='
	tgt_version=${tgt_version#$prefix}
	tgt_environment_name=$(echo $environment_name | perl -ne "s/$product_version/$tgt_version/g;print")
	# yest the new version is always dev !!!
	tgt_environment_name=$(echo $tgt_environment_name | perl -ne "s/$env_type/dev/g;print")
	tgt_product_version_dir=$product_dir/$tgt_environment_name
	mkdir -p $tgt_product_version_dir	

	test "$tgt_product_version_dir" == "$product_version_dir" && return
	# remove everything from the tgt product version dir - no extra files allowed !!!
	rm -fvr $tgt_product_version_dir/*
	test $? -eq 0  || doExit 2 "cannot write to $tgt_product_version_dir !"
	
	doCreateRelativePackage
	unzip -o $zip_file -d $tgt_product_version_dir
	cp -v $zip_file $tgt_product_version_dir

	# ensure that all the files in the target product version dir are indentical to the current ones
	for file in `cat $include_file`; do (
		cmd="diff $product_version_dir/$file $product_version_dir/$file"
		doRunCmdOrExit "$cmd"
	);
	done

}
#eof doChangeVersion


#v1.0.0 
#------------------------------------------------------------------------------
# increase or decrease the version of the product
# clone the <<base_dir>>/app_name/a
# bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-app=<<new_app>>
#------------------------------------------------------------------------------
doCloneToApp(){
	set -x
	tgt_app="$1"
	prefix='to-app='
	tgt_app=${tgt_app#$prefix}
	tgt_environment_name=$(echo $environment_name | perl -ne "s/$wrap_name/$tgt_app/g;print")
	tgt_environment_name=$(echo $tgt_environment_name | perl -ne "s/$product_version/0.9.9/g;print")
	tgt_environment_name=$(echo $tgt_environment_name | perl -ne "s/$env_type/dev/g;print")
	tgt_product_dir=$product_base_dir/$tgt_app
	tgt_product_version_dir=$tgt_product_dir/$tgt_environment_name
	mkdir -p $tgt_product_version_dir 

	# remove everything from the tgt product version dir - no extra files allowed !!!
	rm -fvr $tgt_product_version_dir
	# if the removal failed exit with error msg
	[[ $? -eq 0 ]] || doExit 2 "ERROR --- cannot write to $tgt_product_version_dir !"

	doCreateRelativePackage
	unzip -o $zip_file -d $tgt_product_version_dir

	to_srch=$wrap_name
	to_repl=$tgt_app

	#-- search and replace in file names
	find "$tgt_product_version_dir/" -type d |\
		perl -nle '$o=$_;s#'"$to_srch"'#'"$to_repl"'#g;$n=$_;`mkdir -p $n` ;'
	find "$tgt_product_version_dir/" -type f |\
		perl -nle '$o=$_;s#'"$to_srch"'#'"$to_repl"'#g;$n=$_;rename($o,$n) unless -e $n ;'


	find $tgt_product_version_dir -exec file {} \; | grep text | cut -d: -f1| { while read -r file_to_edit ;
		do (
			perl -pi -e "s#$to_srch#$to_repl#g" "$file_to_edit"
		);
		done ;
	}
	
	# on cygwin the perl -pi leaves backup files => remove them
	find $tgt_product_version_dir -type f -name '*.bak' | xargs rm -fv 

	cp -v $zip_file $tgt_product_version_dir

}
#eof func doCloneToApp


#v1.0.0 
#------------------------------------------------------------------------------
# cleans the unneeded during after run-time stuff
#------------------------------------------------------------------------------
doPrintHelp(){

   printf "\033[2J";printf "\033[0;0H"

   test -z $target_dir && target_dir='<<target_dir>>'
	doSetVars

   cat <<END_HELP

   #------------------------------------------------------------------------------
   ## START HELP `basename $0`
   #------------------------------------------------------------------------------
      `basename $0` is a the minimalistic scala console stub app to start writing scala
      `basename $0` is is also an utility script with the goodies listed bellow:

      # go get this help, albeit you knew that already ...
      bash $0 -h
      or
      bash $0 --help


      #------------------------------------------------------------------------------
      ## USAGE:
      #------------------------------------------------------------------------------
      1. to clean compile your project
      #--------------------------------------------------------
      bash $0 -a sbt-clean-compile
		
		this is the same as run sbt clean compile in your project , but with couple of extras
		
      2. to compile your project
      #--------------------------------------------------------
      bash $0 -a sbt-compile
		
		this is the same as run sbt compile in your project , but with couple of extras
		
      3. to run your project
      #--------------------------------------------------------
      bash $0 -a sbt-run
		
		this is the same as run sbt run in your project , but with couple of extras

		
		-- the rest is non-scala ... bonus life cycle related stuff ... 

      4. to create a full zip package
      #--------------------------------------------------------
      bash $0 -a create-full-package

		this will create the full package into your production version dir: $product_dir
		if you have configured the network_backup_dir in conf file it will be also copied 
		to it -> $network_backup_dir
		You must specify the files to be be included in the full package from the meta/basic-scala-console-app.include 
		file

		
		5. this will create the deployment package into your production version dir: $product_dir
		if you have configured the network_backup_dir in conf file it will be also copied 
      #--------------------------------------------------------
		bash $0 -a create-deployment-package

		You must specify the files to be be included in the full package from the meta/basic-scala-console-app.include 
		file
      
		6. to create a relative package
		this will create the relative package into your production version dir: $product_dir
		if you have configured the network_backup_dir in conf file it will be also copied 
      #--------------------------------------------------------
		bash $0 -a create-relative-package

		You must specify the files to be be included in the full package from the meta/basic-scala-console-app.include 
		file
      
		4. to clone the same version of your product into dev,tst,prd enviroments
      #--------------------------------------------------------
      bash $0 -a to-dev
      bash $0 -a to-tst
      bash $0 -a to-qas
      bash $0 -a to-prd
      
		5. to clone the product into a different version
      #--------------------------------------------------------
      bash $0 -a to-ver=0.1.1
      
		6. to create the tags file in the \$product_dir : $product_dir
      #--------------------------------------------------------
      sh $0 -a create-ctags

		7. to check the perl syntax of all the perl files under the $product_dir/sfw/perl
      #--------------------------------------------------------
      sh $0 -a check-perl-syntax
		
		8. to run the perl tests issue the following commmand
      #--------------------------------------------------------
      sh $0 -a run-perl-tests
		
		9. to save your current tmux session run the following command
      #--------------------------------------------------------
      sh $0 -a save-tmux-session

      #------------------------------------------------------------------------------
      ## INSTALLATION
      #------------------------------------------------------------------------------

		Installation is as simple as unzip -o <<full_package>> -d <<desired_base_dir>>
		where <<full_package>> should look like: basic-scala-console-app.0.0.2.prd.20160702_181412.ysg-host-name.zip
		and <<disired_base_dir>> could be /tmp , /opt/ , /var , /even/longer/path
		The required binaries for the $wrap_name are:
		- perl
		If you want to use the vim's jump to tag function you would have to install also:
		- ctags
		

      #------------------------------------------------------------------------------
      ## FOR DEVELOPERS
      #------------------------------------------------------------------------------

      `basename $0` is an utility script having the following purpose
      to provide an easy installable starting template for any app
		based on the following philosofy:
		- there is a huge difference between a software product and a running instance
		- the running istance is properly configured it usually belongs to dev , tst 
		  prd environments 
		- different version of the same software product might or might not require 
		  different binaries 
		- if two instances of the same product having different versions can operate on 
		  the same host simultaniously 
		- in $wrap_name this ability to run multiple versions in multiple environments
        under even different *Nix users is in-built
		- any custom software should be installed and run from a base dir: $base_dir

      with  the following functionalities:
      - printing help with cmd switch -h ( verify with doTestHelp in test-sh )
      - prints the set in the script variables set during run-time
      - separation of host specific vars into separate configuration file :
       <<wrap_bash_dir>>/<<wrap_name>>.<<MyHost>>.conf
       $ini_file
      - thus easier enabling portability between hosts
      - logging on terminal and into configurable log file set now as:
       $log_file
      - for loop examples with head removal and inline find and replace
      - cmd args parsing
      - doSendReport func to the tail from the log file to pre-configured emails
      - support for parallel run by multiple processes - each process uses its own tmp dir

   #------------------------------------------------------------------------------
   ## STOP HELP `basename $0`
   #------------------------------------------------------------------------------

END_HELP
}
#eof doPrintHelp 


# Action !!!
main "$@"

#
#----------------------------------------------------------
# Purpose:
# a simplistic app stub with simplistic source control and 
# cloning or morphing functionalities ...
#----------------------------------------------------------
#
#----------------------------------------------------------
# Requirements: bash , perl , ctags
#
#----------------------------------------------------------
#
#----------------------------------------------------------
#  EXIT CODES
# 0 --- Successfull completion
# 1 --- required binary not installed 
# 2 --- Invalid options 
# 3 --- deployment file not found
# 4 --- perl syntax check error
#----------------------------------------------------------
#
# VersionHistory:
#------------------------------------------------------------------------------
# 1.0.0 --- 2016-09-11 12:24:15 -- init from basic-scala-console-app
#----------------------------------------------------------
#
#eof file: basic-scala-console-app.sh v1.0.0
