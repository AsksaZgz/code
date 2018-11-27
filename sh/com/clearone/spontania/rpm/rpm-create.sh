#! /bin/bash
clear
echo "rpm-create-5.0.20160616"
################################################################################ 
_version=$1
_tomcat_version=$2
_server_version=$3
_gateway_version=$4

if [[ $1 = '' || $2 = '' || $3 = ''  || $4 = '' ]] 
then
	echo -e "Faltan parametros"
	echo -e "rpm-create.sh version version-tomcat(now only 7.0.57) version-server version-GW"
	echo -e "Example: ./rpm-create.sh 3.1.20160413 7.0.57 6.8.2.9 3.2.0.7"
	exit
fi  

_tomcat=/usr/local/tomcat/webapps
_rpm=/usr/local/Spontania/rpm
_rpm_etc=$_rpm/etc
_rpm_version=$_rpm/$_version
_rpm_log=$_rpm_version/$_version.log
_rpm_tar=$_rpm_version/Spontania-6
_rpm_web=$_rpm_tar/SpontaniaWeb6
_rpm_actualizaciones=$_rpm_web/actualizaciones
_rpm_instalaciones=$_rpm_web/instalaciones
_rpm_exclude=$_rpm_tar/rpm.files_exclude
# project svn ################################################################## 
_project=/root/git/SpontaniaWeb
# config buildrpm ##############################################################
_buildrpm_server=rpmbuild
_buildrpm_spec=Spontania-6.spec
_rpm_repository='/home/jesus/current_releases/TESTING/NEW_RPMS'
################################################################################
#
#
#
#
################################################################################
# config
mkdir $_rpm_version
echo "Version: "$_version
echo -e "Version: "$_version >$_rpm_log

################################################################################
#
#
#
#
################################################################################
if [ -f $_rpm_tar ]
then
    rm $_rpm_tar
fi
mkdir $_rpm_actualizaciones --parents
mkdir $_rpm_instalaciones --parents
################################################################################
#
#
#
#
################################################################################
# create and modules ###########################################################
_sql=$_project/sql
_sql_create=$_sql/createTablesPostgres.sql
_sql_modules=$_sql/modules
_sql_updaters=$_sql/updaters
_rpm_sql_create=$_rpm/$_version/createTablesPostgres.sql
_webconference_sql=$_project/webconference/scripts

echo -e "Add modules and updaters to create"
cp $_sql_create $_rpm_sql_create
cd $_sql_modules
_modules=`find * -name "*.sql"`
for _module in $_modules ;
do
    cat $_module >> $_rpm_sql_create
done

cd $_sql_updaters
_updaters=`find * -name "*.sql"`
for _update in $_updaters ;
do
    cat $_update >> $_rpm_sql_create
done

cp $_rpm_sql_create $_webconference_sql
echo -e "/Add modules and updaters to create"
################################################################################
#
#
#
#
################################################################################
# soft versions ################################################################
echo -e "soft versions"
cp $_sql/soft_version.sql $_webconference_sql
echo -e "/soft versions"
################################################################################
#
#
#
#
################################################################################
# parametros generales #########################################################
echo -e "parametros generales"
cp $_sql/parametros_generales.sql $_webconference_sql
echo -e "/parametros generales"
################################################################################
#
#
#
#
################################################################################
# normalize sql
dos2unix $_webconference_sql/*.sql
################################################################################
#
#
#
#
################################################################################
# files-exclude ################################################################
echo "files-exclude"
if [ -f $_rpm_exclude ]
then
    rm $_rpm_exclude
fi
echo nbproject >> $_rpm_exclude 

# files-exclude entities #######################################################
cd $_tomcat/webconference/entidades
# files=`find * -name "*"`
_directories=`find * -maxdepth 0 -name "*"`
for _directory in $_directories ;
do
  if [[ ! $_directory = 'DEFAULT' ]]
  then
	echo "entidades/$_directory" >> $_rpm_exclude
  fi
done
# files-exclude partners #######################################################
cd $_tomcat/webconference/partners
# files=`find * -name "*"`
_directories=`find * -maxdepth 0 -name "*"`
for _directory in $_directories ;
do
  if [[ ! $_directory = 'DEFAULT' && ! $_directory = '1' ]] 
  then
	echo "partners/$_directory" >> $_rpm_exclude
  fi
done
# files-exclude ROOT ###########################################################
cd $_tomcat/ROOT
# files=`find * -name "*"`
_directories=`find * -maxdepth 0 -name "*"`
for _directory in $_directories ;
do
  if [[ ! $_directory = 'index.html'  ]] 
  then
	echo "ROOT/$_directory" >> $_rpm_exclude
  fi
done
echo "/files-exclude"
################################################################################
#
#
#
#
################################################################################
# client #######################################################################
echo "# Get clients echo "# Get clients ########################################"
rm /usr/local/tomcat/webapps/comun/download/*.exe -rf
rm /usr/local/tomcat/webapps/comun/download/*.dmg -rf
rm /usr/local/tomcat/webapps/comun/download/*.zip -rf
rm /usr/local/tomcat/webapps/comun/download/*.releasenotes-en -rf
cp /usr/local/Spontania/clients/* /usr/local/tomcat/webapps/comun/download
echo "/ Get clients echo "# Get clients ########################################"
################################################################################
#
#
#
#
################################################################################
# contexts ##################################################################### 
echo "contexts"
cd $_project
for _context in admin axis comun eServices portal ROOT saas spn spn-common webconference
do
    echo $_context
	tar --create --gzip --verbose --file=$_rpm_actualizaciones/$_context.tar.gz $_context --exclude-from=$_rpm_exclude >>$_rpm_log
done
echo "/contexts"
################################################################################
#
#
#
#
################################################################################
# Api ##########################################################################
cp /usr/local/tomcat/lib/xmlrpcapi.jar $_rpm_actualizaciones
################################################################################
#
#
#
#
################################################################################
# Config #######################################################################
cp $_rpm_etc/config.xml $_rpm_actualizaciones
################################################################################
#
#
#
#
################################################################################
# log4j ########################################################################
cp $_rpm_etc/log4j.properties $_rpm_actualizaciones
################################################################################
#
#
#
#
################################################################################
# release notes ################################################################
cp $_rpm_etc/release.notes $_rpm_actualizaciones
################################################################################
#
#
#
#
################################################################################
# intalaciones #################################################################
_tomcat_lib=/usr/local/tomcat/lib
_install_tomcat=$_rpm_etc/tomcat-$_tomcat_version
_install_tomcat_lib=$_install_tomcat/usr/local/tomcat/lib
rm -rf $_rpm_etc/instalaciones/tomcat.tar.gz
# copy Spontania*.jar
cp $_tomcat_lib/Spontania* $_install_tomcat_lib
# copy xmlrcpapi*.jar
cp $_tomcat_lib/xmlrpcapi* $_install_tomcat_lib
# create tar
cd $_install_tomcat
tar --create --gzip --verbose --file=$_rpm_etc/instalaciones/tomcat.tar.gz usr

cp $_rpm_etc/instalaciones $_rpm_web --recursive
################################################################################
#
#
#
#
################################################################################
# SpontaniaWeb6.tar ############################################################
cd $_rpm_tar
tar --create --gzip --verbose --file=$_rpm_tar/SpontaniaWeb6.tar.gz SpontaniaWeb6
################################################################################
#
#
#
#
################################################################################
# Clean contexts ###############################################################
rm $_rpm_exclude
rm $_rpm_web --recursive
################################################################################
#
#
#
#
################################################################################
# Server 4.0.20160413 ##########################################################
_server_repository=/usr/local/Spontania/server
_server_distribution=$_rpm_etc/server

# Copy server
rm -fr $_server_distribution/webconference.tar.gz
cd $_server_repository
cp webconferencebase.$_server_version $_server_distribution/webconferencebase
cd $_server_distribution
tar --create --gzip --verbose --file=$_server_distribution/webconferencebase.tar.gz webconferencebase
rm -fr webconferencebase

# Copy libserver
rm -fr $_server_distribution/libserver.tar.gz
cd $_server_repository
cp libserver.$_server_version.tar.gz $_server_distribution/libserver.tar.gz

# Copy config
rm -fr $_server_distribution/webconference-config.xml
cd $_server_repository
cp webconference-config.$_server_version.xml $_server_distribution/webconference-config.xml
################################################################################
#
#
#
#
################################################################################
# Gateway 4.0.20160413 ######################################################### 
echo -e "Gateway"
# gateway 
### cp /$_patch_utils/webconference-config.xml /$_patch_path/webconference-config.xml
_gateway_repo=/home/jesus/versions/VAS/Gateways/H323_SIP_v3/Version_$_gateway_version
_gateway_dist=$_rpm_etc/server

rm -rf $_gateway_dist/rpm.tar.gz
rm -rf $_gateway_dist/GW_Videos_720p.tgz

# rpms
cp $_gateway_repo/RPMS/WebConferenceGateway* $_gateway_dist
cd $_gateway_dist
tar --create --gzip --verbose --file=rpm.tar.gz WebConferenceGateway*
rm -rf WebConferenceGateway*

# videos
cp $_gateway_repo/Videos/GW_Videos_720p.tgz $_gateway_dist/GW_Videos_720p.tgz
echo -e "/Gateway"
################################################################################  
################################################################################
#
#
#
#
################################################################################
# rpm directories ##############################################################
echo -e "RPM directories"
for _directory in aws license scripts server temp
do
	echo -e "Directory: "$_directory
    cp $_rpm_etc/$_directory $_rpm_tar --recursive
done
################################################################################
#
#
#
#
################################################################################
# Spontania-6 ##################################################################
cd $_rpm_version
tar --create --gzip --verbose --file=$_rpm_version/Spontania-6.tar.gz Spontania-6
################################################################################
#
#
#
#
################################################################################
# Clean Spontania-6 ############################################################
###DEBUG### rm $_rpm_version/Spontania-6 --recursive
################################################################################
#
#
#
#				
################################################################################
# Generate spec ################################################################
echo -e "Generate spec"
cp $_rpm_etc/$_buildrpm_spec.head $_rpm_version/$_buildrpm_spec
## Release: 3.1
cat >> $_rpm_version/$_buildrpm_spec  2>/dev/null  <<!
Release: $_version
!

cat $_rpm_etc/$_buildrpm_spec.foot >> $_rpm_version/$_buildrpm_spec
################################################################################
#
#
#
#
################################################################################
# rpm prepare ##################################################################
echo "rpm prepare"
sshpass -p build ssh build@$_buildrpm_server '/home/build/rpmbuild/rpm_prepare.sh'
echo "/rpm prepare"
################################################################################
#
#
#
#
################################################################################
# rpm scp ######################################################################
echo -e "rpm scp"
sshpass -p build scp $_rpm_tar.tar.gz build@$_buildrpm_server:/home/build/rpmbuild/SOURCES/
sshpass -p build scp $_rpm_tar.spec build@$_buildrpm_server:/home/build/rpmbuild/SPECS/
echo -e "/rpm scp"
################################################################################
#
#
#
#
################################################################################
# rpm rpmbuild #################################################################
echo -e "rpm building ..."
sshpass -p build ssh build@$_buildrpm_server 'rpmbuild -ba /home/build/rpmbuild/SPECS/Spontania-6.spec'
echo -e "/rpm building ..."
################################################################################
#
#
#
#
################################################################################
# get rpm ######################################################################
echo "get rpm #################################################################"
sshpass -p build scp build@$_buildrpm_server:/home/build/rpmbuild/RPMS/i386/Spontania-6-$_version.i386.rpm $_rpm_version
echo "/get rpm ################################################################"
################################################################################
#
#
#
#
################################################################################
# put rpm to rpm ###############################################################
# echo "# put rpm to rpm ########################################################"
# sshpass -p clearone! scp $_rpm_version/Spontania-6-$_version.i386.rpm root@rpm:/root
# echo "#/put rpm to rpm ########################################################"
################################################################################
#
#
#
#
################################################################################
# put rpm to repository ########################################################
echo "# put rpm to repository ##################################################"
cp $_rpm_version/Spontania-6-$_version.i386.rpm $_rpm_repository/
echo "#/put rpm to repository ##################################################"
################################################################################
#
#
#
#
################################################################################
# iso prepare ##################################################################
echo "# iso prepare ###########################################################"
sshpass -p clearone ssh root@isobuild '/kickstart_build/iso-prepare.sh'
echo "#/iso prepare ###########################################################"
################################################################################
#
#
#
#
################################################################################
# put rpm to iso ###############################################################
echo "# put rpm to iso ########################################################"
sshpass -p clearone scp $_rpm_version/Spontania-6-$_version.i386.rpm root@isobuild:/kickstart_build/isolinux/Packages
echo "#/put rpm to iso ########################################################"
################################################################################
#
#
#
#
################################################################################
# iso create ###################################################################
echo "# iso create ############################################################"
sshpass -p clearone ssh root@isobuild '/kickstart_build/createISO6.sh '$_version
echo "#/iso create ############################################################"
################################################################################
#
#
#
#
################################################################################
# iso copy vSphere #############################################################
echo "# iso copy vSphere ######################################################"
sshpass -p clearone ssh root@isobuild '/kickstart_build/iso-copy.sh'
echo "#/iso copy vSphere ######################################################"

# Release Notes ################################################################ 
################################################################################ 
# 4.1.20160415 #################################################################
#   Update exlude files with ROOT
################################################################################ 
# 4.0.20160413 #################################################################
#   Add param server and lib server
#   Add gateway param and install
################################################################################ 
# 3.0.20160211 #################################################################
#    Add get and put .rpm 
################################################################################ 
# 2.1.20160211 #################################################################
#    Add _project to contexts
################################################################################ 
# 2.0.20160211 #################################################################
#    Add new options
################################################################################ 
# 1.0.20160209 #################################################################
#    Create rpm
