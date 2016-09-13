#!/bin/bash 

#file: sfw/bash/basic-scala-console-app-test.sh docs at the eof file

umask 022    ;

# print the commands
# set -x
# print each input line as well

	start_dir=`pwd` 
	# it should be possible to call this from anywhere
   wrap_bash_dir=`dirname $(readlink -f $0)`
	cd $wrap_bash_dir ; cd .. ; cd .. ; cd ..

main(){

	doTestUsage
	doTestHelp
	doTestCtagsCreation
	doTestCloneToEnvTypes	
	doTestVersionChanges '1.0.0'
	doTestFullPackageCreation
	doTestDeploymentPackageCreation
	doTestRelativePackageCreation
	doTestRelativePackageCreationOfContainedApp
	doTestFullPackageCreationOfContainedApp
	doTestRemovePackageFiles
	doTestRemovePackage
	doTestToAppCloning
	doTestCheckPerlSyntax
	doTestSavingOfTmuxSession
	doTestGmailSending

	cd $start_dir
}

#
#----------------------------------------------------------
# test the compiling of the perl code
#----------------------------------------------------------
doTestCheckPerlSyntax(){
	echo START TEST perl-syntax-checking
	cat docs/txt/features/perl/01.perl-syntax-checking.txt
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a check-perl-syntax
	echo after the completion all the perl files should be checked for syntax errors
	
	echo STOP TEST perl-syntax-checking

	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}

#
#----------------------------------------------------------
# test the sending of a package by gmail
#----------------------------------------------------------
doTestGmailSending(){
	echo START TEST full-package-creation with gmail 
	cat docs/txt/features/shell/08.gmail-package.txt
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package -a gmail-package
	echo after the completion of the script you should have received an e-mail 
	echo from the configured account 
	
	echo test sending of a deploymet package
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-deployment-package -a gmail-package

	echo test sending the latest zip file if no full OR deployment package has been created	
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a gmail-package
	echo STOP  TEST full-package-creation with gmail

	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}


#
#----------------------------------------------------------
# test the saving of the current tmux session
#----------------------------------------------------------
doTestSavingOfTmuxSession(){
	echo START TEST save-tmux-session
	echo check the ~/.tmux-session file before the save
	cat ~/.tmux-session
	mv -v ~/.tmux-session ~/.tmux-session.`date +%Y%m%d_%H%M%S`
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a save-tmux-session
	
	echo now check the ~/.tmux-session file after the save
	ls -al ~/.tmux-session
	cat ~/.tmux-session
	
	echo -e "\n"
	test -f ~/.tmux-session && echo "TEST save-tmux-session passed"
	test -f ~/.tmux-session || echo "TEST save-tmux-session FAILED !!!"
	echo -e "\n\n"
	echo STOP  TEST save-tmux-session

	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}

#
#----------------------------------------------------------
# test the version changes
#----------------------------------------------------------
doTestToAppCloning(){
	echo START TEST clone to app=rt-ticket
	sleep 3
	new_app=rt-ticket
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-app=$new_app
	echo "now the whole new app should be under this dir"
	echo search for the basic-scala-console-app string occurence
	find /opt/csitea/$new_app -exec file {} \; | grep text | cut -d: -f1| { while read -r file ;
			do (
				grep -nHP basic-scala-console-app "$file"
			);
			done ;
	}
	echo STOP  TEST clone to app=rt-ticket
	sleep 3
}


#
#----------------------------------------------------------
# test the creation of relative package of a contained app
#----------------------------------------------------------
doTestRelativePackageCreationOfContainedApp(){
	echo START TEST relative-package-creation of contained app
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package -i meta/.deploy.ysg-cheat-sheets
	echo there should be a zip file containing all the relative 
	echo from the base dir files in the product version dir 
	echo should you have a file specified in the .include file which 
	echo does not really exist the script should exit with error specifying the 
	echo missing file
	stat -c "%y %n" *rel.zip | sort -nr
	echo STOP  TEST relative-package-creation of contained app
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}

#
#----------------------------------------------------------
# test the creation of relative package of a contained app
#----------------------------------------------------------
doTestFullPackageCreationOfContainedApp(){
	echo START TEST full-package-creation of contained app
	echo running : bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package -i meta/.deploy.ysg-cheat-sheets
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package -i meta/.deploy.ysg-cheat-sheets
	echo there should be a zip file containing all the relative 
	echo from the base dir files in the product version dir 
	echo "should you have a file specified in the .include.<<app-name>> file which"
	echo does not really exist the script should exit with error specifying the 
	echo missing file
	stat -c "%y %n" *.zip | sort -nr
	echo STOP  TEST full-package-creation of contained app
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}


#
#----------------------------------------------------------
# test the removal of all the files in a package:w
#----------------------------------------------------------
doTestRemovePackageFiles(){
	echo START testing the removal of package files
	sleep 3
	echo create first a version to be able to delete from 
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-ver=0.0.1
	echo Action !!
	echo running : bash ../basic-scala-console-app.0.0.1.dev.ysg/sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a remove-package-files
	sleep 2
	bash ../basic-scala-console-app.0.0.1.dev.ysg/sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a remove-package-files
	echo STOP  TEST for remove-package-files
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}
#eof func doTestRemovePackageFiles


#
#----------------------------------------------------------
# test the removal of all the files in a package:w
#----------------------------------------------------------
doTestRemovePackage(){
	echo START TEST remove-package
	sleep 3
	echo create first a version to be able to delete from 
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-ver=0.0.1
	echo Action !!
	echo running : bash ../basic-scala-console-app.0.0.1.dev.ysg/sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a remove-package
	sleep 2
	bash ../basic-scala-console-app.0.0.1.dev.ysg/sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a remove-package
	echo STOP  TEST for remove-package
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}
#eof func doTestRemovePackageFiles

#
#----------------------------------------------------------
# 
#----------------------------------------------------------
doTestFullPackageCreation(){
	echo START TEST full-package-creation
	sleep 3
	echo running : 
	echo bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package
	sleep 1
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-full-package
	echo there should be a zip file containing all the relative 
	echo from the base dir files in the product version dir 
	echo should you have a file specified in the .include file which 
	echo does not really exist the script should exit with error specifying the 
	echo missing file
	stat -c "%y %n" *.zip | sort -nr
	echo STOP  TEST full-package-creation
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}

#
#----------------------------------------------------------
# test the creation of the relative package
#----------------------------------------------------------
doTestRelativePackageCreation(){
	echo START TEST relative-package-creation
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package
	echo there should be a zip file containing all the relative 
	echo from the product version dir files
	echo should you have a file specified in the .include-basic-scala-console-app file which 
	echo does not really exist the script should exit with error specifying the 
	echo missing file
	stat -c "%y %n" *.rel.zip | sort -nr
	echo "test also the creation of the relative file paths package with "
	echo "overrided include file, which is the deploy file in this case"
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-relative-package -i meta/.deploy.basic-scala-console-app
	echo STOP  TEST relative-package-creation
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}

#
#----------------------------------------------------------
# test the version changes
#----------------------------------------------------------
doTestDeploymentPackageCreation(){
	echo START test the deployment package creation
	sleep 3
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-deployment-package
	echo there should be a zip file containing  the relative specified
	echo in the .deploy file files 
	echo from the base dir files in the product version dir 
	echo should you have a file speccified in the .deploy file which 
	echo does not really exist the script should exit with error specifying the 
	echo missing file
	stat -c "%y %n" *.zip | grep depl | sort -nr
	echo STOP  test the deployment package creation
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}


#
#----------------------------------------------------------
# test the version changes
#----------------------------------------------------------
doTestVersionChanges(){
	version="$1"
	shift 1;
	echo "feature specs:"
	sleep 4
	echo START TEST clone-to-versions
	sleep 1
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-ver=$version
	find . -maxdepth 2 | grep $version
	echo STOP  TEST clone-to-versions
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}



#
#----------------------------------------------------------
# The ctags in the product version dir provides the jump 
# to keyword functionality in vim with the Ctrl + AltGr + 9
#----------------------------------------------------------
doTestCtagsCreation(){
	rm -fv tags
	echo START TEST create-ctags
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a create-ctags
	echo there should be a tags file
	test -f tags && echo "test passed - tags file exists"
	test -f tags || echo "test failed - tags file does ot exist"
	sleep 1
	cat tags
	echo STOP  TEST create-ctags
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
}


#
#----------------------------------------------------------
# If you value your time you should develop in the dev enviroments
# test in your test ( tst ) environments 
# use , operate or run the apps in your prod ( prd ) environments
#----------------------------------------------------------
doTestCloneToEnvTypes(){
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-dev
	stat -c "%y %n" *.zip | sort -rn
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
	
	echo test the movement to the tst environment
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-tst
	stat -c "%y %n" *.zip | sort -rn
	sleep 3
	printf "\033[2J";printf "\033[0;0H"

	echo test movement to quality assurance
	echo test the movement to the qas environment
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-qas
	stat -c "%y %n" *.zip | sort -rn
	sleep 3
	printf "\033[2J";printf "\033[0;0H"
	
	echo test the movement to the prd environment
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -a to-prd
	stat -c "%y %n" *.zip | sort -rn
	sleep 3
	printf "\033[2J";printf "\033[0;0H"

	find ../ -maxdepth 1| sort -nr
}
#eof doTestCloneToEnvTypes


doTestUsage(){

	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -u
	sleep 1 
	printf "\033[2J";printf "\033[0;0H"
	
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -usage
	sleep 1 
	printf "\033[2J";printf "\033[0;0H"
	
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --usage
	sleep 1
	printf "\033[2J";printf "\033[0;0H"
	
	echo "if the usage was displayed 2 times the test has passed"

		
}
#eof doTestUsage



doTestHelp(){

	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -h
	sleep 1 
	printf "\033[2J";printf "\033[0;0H"
	
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh --help
	sleep 1 
	printf "\033[2J";printf "\033[0;0H"
	
	echo test the help
	bash sfw/bash/basic-scala-console-app/basic-scala-console-app.sh -help
	sleep 1 
	printf "\033[2J";printf "\033[0;0H"

	echo "if the help was displayed 3 times the test has passed"
}
#eof doTestHelp



# Action !!!
main

#
#----------------------------------------------------------
# Purpose:
# to test the simplistic app stub with simplistic source control and 
# cloning or morphing functionalities ...
# to package the basic-scala-console-app app
#----------------------------------------------------------
#
#----------------------------------------------------------
#
#
# VersionHistory:
#----------------------------------------------------------
# 0.1.0 --- 2016-07-15 19:59:08 -- ysg -- packages gmailing added
# 0.0.8 --- 2016-07-09 20:17:01 -- ysg -- deployment package testing
# 0.0.4 --- 2016-07-02 23:33:48 -- ysg -- added version increase
# 0.0.3 --- 2016-07-01 22:04:33 -- ysg -- init
#----------------------------------------------------------
#
#eof file: basic-scala-console-app.sh v1.0.0
