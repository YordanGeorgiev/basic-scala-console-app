#!/bin/bash 
#file: sfw/bash/basic-scala-console-app/funcs/play2/activator-build.func.sh

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
doActivatorCleanCompileVerbose(){

	test -z "$component_name" && component_name=$wrap_name
	# and clear the screen
	printf "\033[2J";printf "\033[0;0H"
	set +x	
	doLog "INFO == START == doSbtCleanCompile"
	cd $product_version_dir
	
	#remove all the autosplit.ix files 
	cd $product_version_dir/sfw/play2/$component_name

	#remove all the autosplit.ix files 
	java_path=$(which java)
	doLog "using the following java binary:: $java_path"
	java_version=$(java -version)
	doLog "using the following java version:: $java_version"


	doLog "using the following activator binary::"`which activator`
	doLog "using the following activator version "
	activator console
	activator about
	
	# src: http://www.play2-activator.org/0.13/docs/Inspecting-Settings.html
	doLog "inspect the libary dependancies"
	activator 'inspect libraryDependencies'

	doLog "print the exported classpath, consisting of build products"
	doLog "and unmanaged and managed, internal and external dependencies."
	activator 'inspect run' 'show runtime:fullClasspath'


	doLog "running activator clean"
	activator clean
	
	doLog "running activator compile"
	activator compile
	ret=$?
	test $ret -ne 0 && sleep 1 && doExit 4 "play2 syntax error" ; 
	cd $product_version_dir


	test $ret -eq 0 && doLog "INFO == STOP  == doSbtCleanCompile NO Errors !!!"
}
#eof func doSbtCleanCompile 


#
#----------------------------------------------------------
# Purpose:
# to compile a activator project 
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
#eof file: sfw/bash/basic-scala-console-app/basic-scala-console-app-incl-perl.sh v1.0.0
