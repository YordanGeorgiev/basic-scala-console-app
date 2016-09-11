#!/bin/bash 
# file: sfw/bash/basic-scala-console-app/funcs/scala/sbt-run.func.sh

umask 022    ;

# print the commands
# set -x
# print each input line as well
# set -v
# exit the script if any statement returns a non-true return value. gotcha !!!
# set -e
trap 'doExit $LINENO $BASH_COMMAND; exit' SIGHUP SIGINT SIGQUIT



#v0.1.8
#------------------------------------------------------------------------------
# checks the perl syntax of the cgi perl modules
#------------------------------------------------------------------------------
doSbtRun(){

	test -z "$commponent_name" && component_name=$wrap_name
	# and clear the screen
	printf "\033[2J";printf "\033[0;0H"
	set +x	
	doLog "INFO == START == doSbtRun"
	cd $product_version_dir

	#remove all the autosplit.ix files 
	cd $product_version_dir/sfw/scala/$component_name
	java_path=$(which java)
	doLog "using the following java binary:: $java_path"
	java_version=$(java -version)
	doLog "using the following java version:: $java_version"

	doLog "using the following sbt version "
	sbt console
	sbt about
	sbt_path=$(which sbt)
	doLog "using the following sbt binary:: $sbt_path"
	doLog "using the following sbt version "
	sbt sbtVersion
	ret=$?

	doLog "print the class path"
	sbt 'inspect run' 'show runtime:fullClasspath'

	doLog "running: sbt run"
	sbt run

	ret=$?
	test $ret -ne 0 && sleep 1 && doExit 4 "Scala run error" ; 

	cd $product_version_dir

	test $ret -eq 0 && doLog "INFO == STOP  == sbt-run NO Errors !!!"
}
#eof func doSbtRun 


#
#----------------------------------------------------------
# Purpose:
# to compile a sbt project 
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
# 2 --- Invalid options 
# 3 --- deployment file not found
#----------------------------------------------------------
#
# VersionHistory:
#------------------------------------------------------------------------------
# 1.0.0 -- 2016-09-11 11:58:34 -- ysg -- init
#
# eof file: sfw/bash/basic-scala-console-app/funcs/scala/sbt-run.func.sh
