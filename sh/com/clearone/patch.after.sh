_client_version=310060
_downloader_version=010015
_gateway_video=''																# if not '' add video
################################################################################ 
#
#
#
#
################################################################################ 
_tomcat=/usr/local/tomcat
_spontania=/usr/local/Spontania
_patch_path=$_spontania/patch.$_version
_patch_log=$_patch_path/patch.$_version.log
_patch_error=$_patch_path/patch.$_version.error
_patch_server_new=webconferencebase.$_version_server
_patch_sql=$_patch_path/patch.$_version.sql
_patch_sever_backup=$_patch_path/patch.$_version.backup_server.tar.gz
_patch_backup_file=$_patch_path/patch.$_version.backup.tar.gz
_patch_backup_db=$_patch_path/patch.$_version.backup_db
_patch_backup_openfire=$_patch_path/patch.$_version.backup_openfire

_patch_include=patch.$_version.files_include
_patch_exclude=patch.$_version.files_exclude
_patch_patch=patch.$_version.tar.gz
################################################################################ 
#
#
#
#
################################################################################ 
clear
/usr/local/tomcat/bin/version.sh | grep "Server version:"
/usr/local/tomcat/bin/version.sh | grep "JVM Version:"

if [ ! -d $_spontania ];
then
	mkdir $_spontania
fi

if [ ! -d $_patch_path ];
then
	mkdir $_patch_path
fi
################################################################################ 
#
#
#
#
#############################################################################
echo -e "Version: $_version"													 >> $_patch_log 
echo -e "Version: $_version"	         										 >> $_patch_error 
echo -e "Errores:"				                    							 >> $_patch_error 
#tar -czvf 20150901.tar.gz  --after-date='30 days ago' --files-from=20150901.include --exclude-from=20150901.exclude
#tar -czvf patch.tar.gz  --files-from=patch_files_include --exclude-from=patch_files_exclude
#9.0# service catalina stop															 >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################ 
# Stop|Start - 9.0 ############################################################# 
/usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop               >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################ 
# backup files
tar -czvf $_patch_backup_file  --files-from=$_patch_include --exclude-from=$_patch_exclude >> $_patch_log 2>> $_patch_error


# exists backups
if [ -f $_patch_backup_file ]
then
	echo -e "backup files OK - $_patch_backup_file"								 >> $_patch_log 2>> $_patch_error
	echo -e "backup files OK - $_patch_backup_file"													
	
	service postgresql start 													 >> $_patch_log 2>> $_patch_error
	# backup database
	pg_dump webconference  > $_patch_backup_db									 			 	2>> $_patch_error

	if [ -f $_patch_backup_db ]
	then
		echo -e "backup db OK - $_patch_backup_db"								 >> $_patch_log 2>> $_patch_error
		echo -e "backup db OK - $_patch_backup_db"													
		
		# apply patch
		tar -xzvf $_patch_patch													 >> $_patch_log 2>> $_patch_error
		
		# queries
		if [ -f $_patch_sql ]
		then
			psql webconference < $_patch_sql									 >> $_patch_log 2>> $_patch_error
		fi
		# generate links
		ldconfig 																 >> $_patch_log 2>> $_patch_error
	fi
fi
################################################################################
################################################################################ 
#
#
#
#
################################################################################ 
# Stop|Start - 10.0 ############################################################ 
/usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop               >> $_patch_log 2>> $_patch_error 
################################################################################ 
#
#
#
#
################################################################################ 
# Backup Openfire 8.0 ##########################################################
echo -e "Backup Openfire"                                                       >> $_patch_log 2>> $_patch_error
echo -e "Backup Openfire" 
pg_dump openfire  > $_patch_backup_openfire									 	               2>> $_patch_error
if [ -f $_patch_backup_openfire ]
then
    echo -e "Backup ok - $_patch_backup_openfire"                               >> $_patch_log 2>> $_patch_error
    echo -e "Backup ok - $_patch_backup_openfire"
fi
echo -e "/Backup Openfire" 
echo -e "/Backup Openfire"                                                      >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################ 
# Stop|Start - 10.0 ############################################################ 
/usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop               >> $_patch_log 2>> $_patch_error 
################################################################################ 
#
#
#
#
################################################################################ 
# Delete SpontaniaResources-0.n 8.0 ############################################ 
echo -e "Delete SpontaniaResources-0.n"                                         >> $_patch_log 2>> $_patch_error
echo -e "Delete SpontaniaResources-0.n"
rm  --force $_tomcat/lib/SpontaniaResources-0.*                                 >> $_patch_log 2>> $_patch_error
echo -e "/Delete SpontaniaResources-0.n"
echo -e "/Delete SpontaniaResources-0.n"                                        >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################ 
#9.0# service catalina start															 >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################
#9.0# sleep 10 
###############################################################################
#
#
#
#
################################################################################ 
## Server ###################################################################### 
while :
do
	echo -n "Install the Server?[y|n]: " 
	read _sServer
	if [[ $_sServer = 'y' || $_sServer = 'n' || $_sServer = 'Y' || $_sServer = 'N' ]] 
	then
		break
	fi
done	

if [[ $_sServer = 'y' || $_sServer = 'Y' ]]
 then
 	tar -czvf $_patch_sever_backup /usr/local/bin/webconferencebase
 	
 	if [ -f $_patch_sever_backup ]
 	then
 		echo -e "backup SERVER OK"
		echo -e "Old Server:"
 		/usr/local/bin/webconferencebase -version
		
 		## Lib Server ################################################################## 
		cd $_patch_path															
		tar -zxvf $_patch_path/libserver.tar.gz 										
		install -c -o root $_patch_path/libserver/* /usr/local/lib                      
																						
		cp -r $_patch_path/libserver/libcryp.tar.gz /usr/local/lib/.					
		cd /usr/local/lib
		tar -zxvf /usr/local/lib/libcryp.tar.gz
		chmod 0755 /usr/local/lib/*

		ldconfig
		cd /usr/lib
		ln -s libodbc.so.2 libodbc.so.1																						
		ln -s libcurl.so.4 libcurl.so.3 																												
		ln -s libssl3.so libssl.so.4
		## Server #################################################################### 
		rm -f /usr/local/bin/webconferencebase
 		cd $_patch_path
 		cp -f $_patch_server_new /usr/local/bin
 		cd /usr/local/bin
 		ln -s $_patch_server_new webconferencebase
 		chmod 0755 /usr/local/bin/webconferencebase*								
 		
		echo -e "Server Installed:"
		/usr/local/bin/webconferencebase -version

	fi
fi   
################################################################################ 
#
#
#
#
################################################################################ 
# Stop|Start - 10.0 ############################################################ 
/usr/local/tomcat/webapps/webconference/scripts/spontania.sh stop               >> $_patch_log 2>> $_patch_error 
############################################################################# 
#
#
#
#
################################################################################
# Stop|Start - 9.0 ############################################################# 
/usr/local/tomcat/webapps/webconference/scripts/spontania.sh start              >> $_patch_log 2>> $_patch_error
################################################################################ 
#
#
#
#
################################################################################ 
sleep 10
wget http://localhost/comun/spontania.html
rm --force spontania.html
################################################################################ 
#
#
#
#
################################################################################ 
### Web Services ###############################################################
while :
do
	echo -n "Update Web Services?[y|n]: " 
	read _sUpdate
	if [[ $_sUpdate = 'y' || $_sUpdate = 'n' || $_sUpdate = 'Y' || $_sUpdate = 'N' ]] 
	then
		break
	fi
done	
if [[ $_sUpdate = 'y' || $_sUpdate = 'Y' ]]
  then
	 _ws_deploy='deploy*.wsdd'
	 _ws_undeploy='un'$_ws_deploy
	 _ws_config_path=/usr/local/tomcat/webapps/axis/WEB-INF
	 _ws_config=server-config.wsdd
	 _ws_backup=$(date +%Y%m%d)
	 _ws_backup_patch=server-config.wsdd
	 _ws_patch=$_patch_path/ws
	 _ws_spontania=/usr/local/Spontania/ws
	
	echo "Backup ------------------------------------------------------------------ "
	cd $_ws_patch
	cp $_ws_config_path/$_ws_config $_ws_config.$_ws_backup
	
	cd $_ws_config_path
	cp $_ws_config $_ws_config.$_ws_backup
	echo "Backup ------------------------------------------------------------------/"
	
	export AXISCLASSPATH=/usr/local/tomcat/webapps/axis/WEB-INF/lib/*
	export AXISCLASSPATH=$AXISCLASSPATH:/usr/local/tomcat/lib/*
	### To old version tomcat
	export AXISCLASSPATH=$AXISCLASSPATH:/usr/local/tomcat/common/lib/*
	
	for _service in Package User General InfoSession
	do
		echo -e "$_service"
		cd $_ws_patch/$_service
		/usr/local/java/bin/java -cp "$AXISCLASSPATH" org.apache.axis.client.AdminClient -p 80 undeploy.wsdd
		/usr/local/java/bin/java -cp "$AXISCLASSPATH" org.apache.axis.client.AdminClient -p 80 deploy.wsdd
	done
	
  fi 
	
################################################################################ 
#
#
#
#
################################################################################
## Gateway ##################################################################### 
# WebConferenceGateway_v3-3.2-0.7.i386.rpm
# WebConferenceGatewayLibs-2.0-3.0.i386.rpm

while :
do
	echo -n "Install the Gateway[y|n]: " 
	read _sGateway
	if [[ $_sGateway = 'y' || $_sGateway = 'n' || $_sGateway = 'Y' || $_sGateway = 'N' ]] 
	then
		break
	fi
done	

if [[ $_sGateway = 'y' || $_sGateway = 'Y' ]]
then
	cd $_patch_path
	install -c -o root $_patch_path/WebConferenceGateway* /root    
	cd /root                                                                                                                                        # rpm 012
	## rpm -Uvh WebConferenceGateway*.rpm                           
	## rpm -Uvh --force WebConferenceGateway*.rpm
	## Uninstall
	rpm -e WebConferenceGateway_v3 WebConferenceGatewayLibs
	rpm -ivh WebConferenceGateway*.rpm
	cp /usr/local/WebConferenceGateway_v3/config/GWServer.conf /etc/	
	rm WebConferenceGateway*                          
	if [[ ! $_gateway_video = '' ]]
	then
		echo "Installing Gateway Video"
		cd /	
		cp $_patch_path/GW_Videos_720p.tgz .	
		tar -xzvf GW_Videos_720p.tgz	
	fi
fi
################################################################################ 
#
#
#
#
################################################################################
## Client ###################################################################### 
### while :
### do
### 	echo -n "Install the client version $_client_version?[y|n]: " 
### 	read _sClient
### 	if [[ $_sClient = 'y' || $_sClient = 'n' || $_sClient = 'Y' || $_sClient = 'N' ]] 
### 	then
### 		break
### 	fi
### done	
### 
### if [[ $_sClient = 'y' || $_sClient = 'Y' ]]
### then
###     psql webconference --command="select module_client_add('$_client_version');"
### 	cd /$_patch_path
### 	cp spontania*$_client_version.* /usr/local/tomcat/webapps/comun/download
### fi 
################################################################################ 
#
#
#
#
################################################################################
## Downloader ################################################################## 
### while :
### do
### 	echo -n "Install the Downloader $_downloader_version?[y|n]: " 
### 	read _sDownloader
### 	if [[ $_sDownloader = 'y' || $_sDownloader = 'n' || $_sDownloader = 'Y' || $_sDownloader = 'N' ]] 
### 	then
### 		break
### 	fi
### done	
### 
### if [[ $_sDownloader = 'y' || $_sDownloader = 'Y' ]]
### then
###     psql webconference --command="select module_downloader_active ('$_downloader_version');"
### 	cp SpontaniaDownloader_$_downloader_version.* /usr/local/tomcat/webapps/comun/download
### fi  
################################################################################ 
#
#
#
#
################################################################################
### END ######################################################################## 
echo -e "Error:"
cat $_patch_error
#TODO: restore
################################################################################ 
#
#
#
#
################################################################################
# Patch Release notes ##########################################################
################################################################################ 
# 11.0.20160316 ################################################################ 
#   Update WebServices module
################################################################################ 
# 10.0.20160307 ################################################################ 
#   Add more stop all
################################################################################ 
# 9.0.20160226 ################################################################# 
#   Add Stop|Start
################################################################################ 
# 8.1.20160225 ################################################################# 
#   Add control dir Spontania
################################################################################ 
# 8.0.20160223 ################################################################# 
#     Quit install client
#     Quit install download
#     Add Backup Openfire
#     Add Delete SpontaniaResources-0.n
################################################################################ 
# 7.1.20160204 ################################################################# 
#     Add copy client and downloader to comun/download
################################################################################ 
# 7.0.20160203 ################################################################# 
#     Add module Downloader
################################################################################ 
# 6.0.20160203 ################################################################# 
#     Add module Client
################################################################################ 
# 5.0.20160203 ################################################################# 
# 	  Add Module Lib Server and remake module Server
################################################################################ 
# 4.0.20160203 ################################################################# 
#     Add Gateway installation
################################################################################ 
# 3.3.20160120 ################################################################# 
#     Add exclude files 
################################################################################ 
# 3.2 - 20151209 ############################################################### 
#     Quit controls exists services
################################################################################ 
# 3.1 - 20151130 ############################################################### 
#     Pause to start Catalina
# 3.0 - 20151127 ############################################################### 
#	  Change order of exec, exec service at the end
# 2.0 - 20151113 ############################################################### 
#     Add|quit web service
################################################################################ 
