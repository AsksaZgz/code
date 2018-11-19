#! /bin/bash
# git-1.1.20160310
clear
################################################################################ 
#
#
#
#
################################################################################
# Param ######################################################################## 
_operation=$1
_compileServices=compileServices-2.0.xml

################################################################################ 
#
#
#
#
################################################################################ 
# Change Branch ################################################################
function gitBranchChange()
{
	# SELECT BRANCH ############################################################
	cd /root/git/SpontaniaWeb
	git branch
	echo -n "Select branch?: " 
	read _sBranch
	

	# STOP #####################################################################
	/usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop
	
	# DELETE WORK ##############################################################
	rm --recursive --force /usr/local/tomcat/work/Catalina
	
	# CHANGE ALL PROJECTS ######################################################
	for _project in SpontaniaWeb SpontaniaApi WebServicesPackage WebServicesGeneral WebServicesUser WebServicesInfoSession
	do
		cd /root/git/$_project
		pwd
		git branch
		git checkout $_sBranch
		git branch
	done
	
	# STAR #####################################################################
	/usr/local/tomcat/webapps/webconference/scripts/spontania.sh start
	sleep 10

	# TODO COMPILE
	cd /usr/local/Spontania/git
	ant -buildfile $_compileServices
	
	# STOP #####################################################################
	### /usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop
	
	# STAR #####################################################################
	### /usr/local/tomcat/webapps/webconference/scripts/spontania.sh start
}
################################################################################ 
#
#
#
#
################################################################################
# main
if [[ $1 = 'change' ]] 
then
	gitBranchChange
fi
################################################################################ 
#
#
#
#
################################################################################
#END
################################################################################ 
#
#
#
#
################################################################################
# Release Notes ################################################################ 
################################################################################ 
# 1.1.20160310
#  Add new projects: WebServicesUser, WebServicesInfoSession
################################################################################ 
# 1.0.20160302
#  Create
