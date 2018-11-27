package=Spontania
version=`rpm -q --queryformat %{VERSION} $package`
release=`rpm -q --queryformat %{RELEASE} $package`

#!/bin/sh
v_ipOne=""
v_ipTwo=""

function op_get_ip()
{
  v_res=`cat $1 | grep IPADDR | perl -pi -e s+"IPADDR="+""+g`
  echo -e "op_get_ip: $v_res" >> $2 2>>$2
  v_opGetIp=$v_res

  if [ -z $v_res ]
  then
    return 255
  fi

  return 0
}

function op_get_ip_multiple()
{
  v_counter=0
  v_pathNetwork=/etc/sysconfig/network-scripts/ifcfg-eth*
  for i in  $v_pathNetwork
  do
    op_get_ip $i $1
    if [ $? -eq 0 ]
    then
      case $v_counter in
        0)
          v_ipOne=$v_opGetIp
          v_ipTwo=$v_ipOne
          v_counter=1
          ;;
        1)
          v_ipTwo=$v_opGetIp
          v_counter=2
          ;;
        *)
          ;;
      esac
    fi
  done

  if [ "$v_ipOne" = "" ]
  then
    v_pathNetwork=`/sbin/ifconfig $ACTIVE_INTERFACE | grep 'inet addr' | awk '{print $2}' | sed 's/addr://'`
    echo -e "$v_pathNetwork" >> $1 2>>$1
    v_counter=0
    for i in  $v_pathNetwork
    do
      case $v_counter in
        0)
          v_ipOne=$i
          v_ipTwo=$v_ipOne
          v_counter=1
          ;;
        1)
          v_ipTwo=$v_ipOne
          v_counter=2
          ;;
        *)
          ;;
      esac
    done
  fi

  echo -e "op_get_ip_multiple, ip 1: $v_ipOne - ip 2: $v_ipTwo" >> $1 2>> $1
}


function op_get_ip_spontania()
{
  v_confFile="/etc/.ConfPrivatePublicIP"
  if [ -f $v_confFile ]
  then
    v_counter=0
    for i in `cat /etc/.ConfPrivatePublicIP`
    do
      op_get_ip "/etc/sysconfig/network-scripts/ifcfg-"$i $1
      if [ $? -eq 0 ]
      then
        case $v_nCounter in
          0)
            v_ipOne=$v_opGetIp
            v_ipTwo=$v_ipOne
            v_nCounter=1
            ;;
          1)
            v_ipTwo=$v_opGetIp
            v_nCounter=2
            ;;
          *)
            ;;
        esac
      fi
    done

    if [ "$v_ipOne" = "" ]
    then
      v_pathNetwork=`/sbin/ifconfig $ACTIVE_INTERFACE | grep 'inet addr' | awk '{print $2}' | sed 's/addr://'`
      echo -e "$v_pathNetwork" >> $1 2>> $1
      v_counter=0
      for i in `cat /etc/.ConfPrivatePublicIP`
      do
        case $v_counter in
          0)
            v_ipOne=`/sbin/ifconfig $i | grep 'inet addr' | awk '{print $2}' | sed 's/addr://'`
            v_ipTwo=$v_ipOne
            v_counter=1
            ;;
          1)
            v_ipTwo=`/sbin/ifconfig $i | grep 'inet addr' | awk '{print $2}' | sed 's/addr://'`
            v_counter=2
            ;;
          *)
            ;;
        esac
      done
    fi
  else
    echo -e "INFO: $v_confFile is not available, let's starting another proccess to get an ip address" >> $1 2>> $1
    op_get_ip_multiple $1
  fi

  echo -e "op_get_ip_spontania, ip 1: $v_ipOne - ip 2: $v_ipTwo" >> $1 2>> $1
}

changeIps()
{
  updateSql=`psql webconference -t -c "UPDATE parametros_generales SET valor='${2}:5222' WHERE nombre='PRIVATE_OPENFIRE_IP'"`  updateSql=`psql webconference -t -c "UPDATE parametros_generales SET valor='${1}:5222' WHERE nombre='PUBLIC_OPENFIRE_IP'"`
  updateSql=`psql webconference -t -c "UPDATE servidor set nombre='$1', ip='$1', nombre_privada='$2', ip_privada='$2'"`
  updateSql=`psql webconference -t -c "UPDATE parametros_generales set valor='http://$1' where nombre = 'PUBLIC_WEB_URL'"`
  updateSql=`psql webconference -t -c "UPDATE parametros_generales set valor='http://$2' where nombre = 'PRIVATE_WEB_URL'"`
  updateSql=`psql webconference -t -c "UPDATE parametros_generales set valor='$1:5222' where nombre = 'PUBLIC_OPENFIRE_IP'"`
  updateSql=`psql webconference -t -c "UPDATE parametros_generales set valor='$2:5222' where nombre = 'PRIVATE_OPENFIRE_IP'"`
  updateSql=`psql webconference -t -c "UPDATE configuration_services set value = '$2' where name='DISTRIBUTION_SERVER'"`
  updateSql=`psql webconference -t -c "UPDATE llamada_entrante set telefono = '$1'"`
  updateSql=`psql webconference -t -c "UPDATE incoming_call_info set ip = '$1' and phone = '$1'"`
}

function checkRpm()
{
  v_res=`rpm -qa | grep $1 | wc -l`
  return $v_res
}


function posgtresql_version_8()							 # rpm 008
{                                                        # rpm 008
	version=$(psql --version | grep 8.1)                 # rpm 008
	if [ -z $version ]                                   # rpm 008
		then return 0                                    # rpm 008
		else return 1                                    # rpm 008
	fi                                                   # rpm 008
}                                                        # rpm 008


###########################################################################
#COMPROBANDO POSTGRESQL
###########################################################################
v_now=`date +'%F_%H%M%S'`
#v_logFile=/root/setup51-${v_now}.log	# rpm 002 
v_logFile=/root/setup6-${v_now}.log
echo -e "Checking packages ..."
echo -e "Checking packages ..." >> $v_logFile

#OTROS RPMS QUE SE PUEDEN COMPROBAR
#lm_sensors-2.8.7-2.40.5.i386.rpm 
#net-snmp-5.1.2-18.el4.i386.rpm         
#net-snmp-libs-5.1.2-18.el4.i386.rpm   
#net-snmp-perl-5.1.2-18.el4.i386.rpm
#net-snmp-utils-5.1.2-18.el4.i386.rpm
#unixODBC-2.2.11-1.RHEL4.1.i386.rpm
#xmlrpc-c-1.04-2.RHEL4.i386.rpm
#xmlrpc-c-apps-1.04-2.RHEL4.i386.rpm

#v_packagesCheck="sudo postgresql-libs-8 postgresql-8 postgresql-odbc-08 postgresql-server-8 cronie"	# rpm 007
#64bits#v_packagesCheck="sudo postgresql-libs-8 postgresql-8 postgresql-odbc-08 postgresql-server-8 net-snmp net-snmp-libs net-snmp-perl net-snmp-utils unixODBC lm_sensors"            # rpm 007
v_packagesCheck="sudo postgresql-libs postgresql postgresql-odbc postgresql-server net-snmp net-snmp-libs net-snmp-perl net-snmp-utils unixODBC lm_sensors" #64bits#
for i in $v_packagesCheck ;
do
  checkRpm $i
  if [ $? -eq 0 ]
  then
    echo -e "$i RPM is not Available. Please install it"
    rpm -e ${package}-${version}-${release} >> $v_logFile 2>> $v_logFile
    exit -1
  fi
done
################################################################################
#
#
#
#
################################################################################
# xmlrpc-c ##################################################################### 
#64 bits# echo -e "Checking xmlrpc-c ..."
#64 bits# echo -e "Checking xmlrpc-c ..." >> $v_logFile
#64 bits# install -c -o root /usr/local/Spontania/server/xmlrpc-c*.rpm /root/*
#64 bits# cd /root                                                                                                                     >> $v_logFile 2>> $v_logFile  		# rpm 007
#64 bits# rpm -ivh xmlrpc-c*.rpm
################################################################################
#
#
#
#
################################################################################
###########################################################################
#COMPROBAMOS QUE ESTA ARRANCADA LA BASE DE DATOS
###########################################################################
echo -e "Checking postgresql ..."
echo -e "Checking postgresql ..." >> $v_logFile

if [ $? -eq 0 ]
then
  v_numLines=`ps ax | grep postgres | grep /usr/bin | wc -l`
  if [ 0 -eq $v_numLines ]
  then
    echo -e "Postgresql process is not running. Please restart it"
    rpm -e ${package}-${version}-${release} >> $v_logFile 2>> $v_logFile
    exit -1
  fi
else
  echo -e "Not checking postgresql ..." >> $v_logFile
fi

###########################################################################                                                                                     # rpm 007
# INSTALL DcsWatch-0.6-0.3r1                                                                                                                                    # rpm 007
###########################################################################                                                                                     # rpm 007
echo -e "Installing DcsWatch-0.6-0.3r1 --------------------------------------------------------------------------------"                                        # rpm 007
echo -e "Installing DcsWatch-0.6-0.3r1 --------------------------------------------------------------------------------" 	 >> $v_logFile 2>> $v_logFile  		# rpm 007
install -c -o root /usr/local/Spontania/server/DcsWatch-0.6-0.3r1.i386.rpm /root/DcsWatch-0.6-0.3r1.i386.rpm                 >> $v_logFile 2>> $v_logFile  		# rpm 007
cd /root                                                                                                                     >> $v_logFile 2>> $v_logFile  		# rpm 007
rpm -ivh DcsWatch-0.6-0.3r1.i386.rpm                                                                                         >> $v_logFile 2>> $v_logFile  		# rpm 007
echo -e "Installing DcsWatch-0.6-0.3r1 --------------------------------------------------------------------------------/" 	 >> $v_logFile 2>> $v_logFile  		# rpm 007
echo -e "Installing DcsWatch-0.6-0.3r1 --------------------------------------------------------------------------------/" 										# rpm 007



###########################################################################   																					# rpm 007                                            
# INSTALL openfire-3.6.4-1.i386.rpm                                                                                                                             # rpm 007
###########################################################################                                                                                     # rpm 007
echo -e "Installing openfire-3.6.4-1 --------------------------------------------------------------------------------"                                          # rpm 007
echo -e "Installing openfire-3.6.4-1 --------------------------------------------------------------------------------" 		 >> $v_logFile 2>> $v_logFile	    # rpm 007
install -c -o root /usr/local/Spontania/server/openfire-3.6.4-1.i386.rpm /root/openfire-3.6.4-1.i386.rpm                     >> $v_logFile 2>> $v_logFile       # rpm 007
cd /root                                                                                                                     >> $v_logFile 2>> $v_logFile       # rpm 007
rpm -ivh openfire-3.6.4-1.i386.rpm                                                                                           >> $v_logFile 2>> $v_logFile       # rpm 007
echo -e "Installing openfire-3.6.4-1 --------------------------------------------------------------------------------/"      >> $v_logFile 2>> $v_logFile       # rpm 007
echo -e "Installing openfire-3.6.4-1 --------------------------------------------------------------------------------/"                                         # rpm 007




###########################################################################
#INSTALANDO SERVIDOR Y LIBRERIAS
###########################################################################
echo -e "Installing libs ..."
echo -e "Installing libs ..." >> $v_logFile
#64bits# cd /usr/local/Spontania																																# rpm 011
#64bits# tar -zxvf /usr/local/Spontania/server/libserver.tar.gz 													    >> $v_logFile 2>> $v_logFile			# rpm 011
#install -c -o root /usr/local/Spontania/lib/* /usr/local/lib                                                                                       # rpm 011
#64bits# install -c -o root /usr/local/Spontania/libserver/* /usr/local/lib                                                                                  # rpm 011
#cp -r /usr/local/Spontania/lib/libcryp.tar.gz /usr/local/lib/.                                                                                     # rpm 011
#64bits# cp -r /usr/local/Spontania/libserver/libcryp.tar.gz /usr/local/lib/.																				# rpm 011
#64bits# cd /usr/local/lib
#64bits# tar -zxvf /usr/local/lib/libcryp.tar.gz
#64bits# chmod 0755 /usr/local/lib/*

#64bits# cat >> /etc/ld.so.conf  2>/dev/null  <<!
#64bits# /usr/local/lib
#64bits# /usr/local
#64bits# /usr/lib
#64bits# !

#64bits# ldconfig >> $v_logFile 2>> $v_logFile
#64bits# cd /usr/lib # rpm 006					
# rpm 005
echo -e "Linking libodbc --------------------------------------------------------------------------------" 	>> $v_logFile 2>> $v_logFile			
#64bits# ln -s libodbc.so.2 libodbc.so.1																				>> $v_logFile 2>> $v_logFile			
echo -e "Linking libodbc --------------------------------------------------------------------------------/" >> $v_logFile 2>> $v_logFile			
echo -e "Linking libcurl --------------------------------------------------------------------------------" 	>> $v_logFile 2>> $v_logFile			
#64bits# ln -s libcurl.so.4 libcurl.so.3 																			>> $v_logFile 2>> $v_logFile										
echo -e "Linking libcurl --------------------------------------------------------------------------------/" >> $v_logFile 2>> $v_logFile	
echo -e "Linking libssl --------------------------------------------------------------------------------" 	>> $v_logFile 2>> $v_logFile	
#64bits# ln -s libssl3.so libssl.so.4  																				>> $v_logFile 2>> $v_logFile	
echo -e "Linking libssl --------------------------------------------------------------------------------/" 	>> $v_logFile 2>> $v_logFile	
# rpm 005 /

#64bits# echo -e "Installing server ..."
#64bits# echo -e "Installing server ..." >> $v_logFile
#64bits# cd /usr/local/Spontania/server
#64bits# tar -zxvf /usr/local/Spontania/server/webconferencebase.tar.gz
#64bits# install -c -o root /usr/local/Spontania/server/webconferencebase /usr/local/bin/
#64bits# chmod 0755 /usr/local/bin/webconferencebase

###########################################################################
#INSTALANDO FICHERO DE CONFIGURACION DEL SERVIDOR
###########################################################################
#64bits# echo -e "Installing server configuration file ..."
#64bits# echo -e "Installing server configuration file ..." >> $v_logFile
#64bits# install -c -o root /usr/local/Spontania/server/webconference-config.xml /etc/webconference-config.xml 			 # rpm 008
echo -e "Installing server.pem file ..." >> $v_logFile
install -c -o root /usr/local/Spontania/server/server.pem /etc/server.pem
chown root /etc/webconference-config.xml >> $v_logFile 2>> $v_logFile
chown root /etc/server.pem >> $v_logFile 2>> $v_logFile
install -c -o root /usr/local/Spontania/server/puntoodbc.ini /root
install -c -o root /usr/local/Spontania/server/odbcinst.ini /etc
mv /root/puntoodbc.ini /root/.odbc.ini 2>> $v_logFile
chmod 0644 /root/.odbc.ini



###########################################################################
#INSTALANDO LICENCIA
###########################################################################
mkdir -p /tmpwebconference
echo -e "Installing license ..."
echo -e "Installing license ..." >> $v_logFile
cd /usr/local/Spontania/license
./SerialGenerator > /tmpwebconference/serial.gen 2>> $v_logFile
# rmp 004 ################################################################
#cp -f /usr/local/Spontania/license/Spontania6.lic /etc/license.lic 2>> $v_logFile
cp -f /usr/local/Spontania/license/Spontania51.lic /etc/license.lic 2>> $v_logFile
# Set executable
chmod 0755 /tmpwebconference/serial.gen
# rmp 004 ################################################################/

##########################################################################
#AMAZON CREDENTIALS - rpm 003
##########################################################################
echo -e 
echo -e 
echo -e "Amazon credentials --------------------------------------------------------------------------------"
echo -e "Amazon credentials --------------------------------------------------------------------------------" >> $v_logFile
mkdir /root/.aws 2>> $v_logFile
cp -f /usr/local/Spontania/aws/* /root/.aws/ 2>> $v_logFile
echo -e "Amazon credentials --------------------------------------------------------------------------------/" >> $v_logFile
echo -e "Amazon credentials --------------------------------------------------------------------------------/"

###########################################################################
#GENERANDO DIRECTORIOS DE GRABACION DE SESIONES Y BACKUPS
###########################################################################
echo -e "Generating sesiones and backups directories ..."
echo -e "Generating sesiones and backups directories ..." >> $v_logFile
mkdir -p /tmpwebconference/sesiones 2>> $v_logFile
mkdir /tmpwebconference/backups 2>> $v_logFile

########################################################################
#OBTENER IPS DE LA MAQUINA
#########################################################################
echo -e "Getting ips ..."
echo -e "Getting ips ..." >> $v_logFile
op_get_ip_spontania $v_logFile

###########################################################################
#INSTALANDO WEB
###########################################################################
echo -e "Installing web administration ..."
echo -e "Installing web administration ..." >> $v_logFile
cd /usr/local/Spontania/temp/
chown root:root SpontaniaWeb6.tar.gz 2>> $v_logFile
tar xzf SpontaniaWeb6.tar.gz 2>> $v_logFile
cd /usr/local/Spontania/temp/SpontaniaWeb6/instalaciones
files=`find * -name "*.tar.gz"`
for f in $files ;
do
  echo "Extracting $f..." 
  echo "Extracting $f..." >> $v_logFile
  cp -f /usr/local/Spontania/temp/SpontaniaWeb6/instalaciones/${f} / 2>> $v_logFile
  cd / 2>> $v_logFile
  tar zxf $f >> $v_logFile 2>> $v_logFile
  rm -f $f 2>> $v_logFile
done

if [ -f /usr/local/Spontania/temp/SpontaniaWeb6/instalaciones/ssup ]
then
  cp /usr/local/Spontania/temp/SpontaniaWeb6/instalaciones/ssup /etc/init.d/ 2>> $v_logFile

  if [ ! -f /etc/rc3.d/S70SSup ]
  then
    ln -s /etc/init.d/ssup /etc/rc3.d/S70SSup 2>> $v_logFile
  fi

  if [ ! -f  /etc/rc4.d/S70SSup ]
  then
    ln -s /etc/init.d/ssup /etc/rc4.d/S70SSup 2>> $v_logFile
  fi

  if [ ! -f /etc/rc5.d/S70SSup ]
  then
    ln -s /etc/init.d/ssup /etc/rc5.d/S70SSup 2>> $v_logFile
  fi
fi

#cp -f /usr/local/tomcat/bin/catalina.sh /etc/init.d/catalina 2>> $v_logFile
ln -s /usr/local/tomcat/catalina /etc/init.d/catalina 2>> $v_logFile
chmod 777 /etc/init.d/catalina 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc0.d/K19tomcat 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc1.d/K19tomcat 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc2.d/K19tomcat 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc3.d/S90tomcat 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc4.d/S90tomcat 2>> $v_logFile
ln -fs /etc/init.d/catalina /etc/rc5.d/S90tomcat 2>> $v_logFile


cp -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/*.tar.gz /usr/local/tomcat/webapps/ >> $v_logFile 2>> $v_logFile
cd /usr/local/tomcat/webapps/
files=`find  -name "*.tar.gz"`

for f in $files ;
do
  echo -e "Extracting $f..."
  echo -e "Extracting $f..." >> $v_logFile
  tar zxf $f >> $v_logFile 2>> $v_logFile
  rm -f $f 2>> $v_logFile
done

if [ -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/xmlrpcapi.jar ]
then
  cp /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/xmlrpcapi.jar /usr/local/tomcat/lib/ 2>> $v_logFile
fi

if [ -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/config.xml ]
then
  cp -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/config.xml /usr/local/tomcat/lib/ 2>> $v_logFile
fi

if [ -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/log4j.properties ]
then
  cp -f /usr/local/Spontania/temp/SpontaniaWeb6/actualizaciones/log4j.properties /usr/local/tomcat/lib/ 2>> $v_logFile
fi

cd /usr/local/tomcat/webapps/spn 2>> $v_logFile
ln -s ../webconference/entidades entidades 2>> $v_logFile

cd /usr/local/tomcat/webapps/portal 2>> $v_logFile
ln -s ../webconference/entidades entidades 2>> $v_logFile
cd /usr/local/tomcat/webapps/comun/download
ln -s /tmpwebconference/sesiones sesiones
ln -s /tmpwebconference/backups backups

if [ -f /usr/local/tomcat/webapps/webconference/scripts/changeIps.sh ]
then
  cp -f /usr/local/tomcat/webapps/webconference/scripts/changeIps.sh /etc 2>> $v_logFile
fi

cd /usr/local/tomcat/webapps/comun/download/updater 2>> $v_logFile
if [ -f selfupdate.xml ]
then
	    cp -f selfupdate.xml selfupdate.xml."`date +'%F_%H%M%S'`".bak 2>> $v_logFile
    sed -e 's/\[ip_private_server\]/'$v_ipTwo'/g' selfupdate.xml > aux.xml 2>> $v_logFile
    sed -e 's/\[ip_public_server\]/'$v_ipOne'/g' aux.xml > selfupdate.xml 2>> $v_logFile
fi
# executable - rpm 005 
chmod 0755 /usr/local/tomcat/webapps/webconference/scripts/*.sh
# executable - rpm 005 /
################################################################################ 
#
#
#
#
################################################################################ 
#PREPARANDO BASE DE DATOS
##########################################################################
echo -e
echo -e "Stopping posgtresql ..."
echo -e "Stopping posgtresql ..." >> $v_logFile
# rpm 004 
echo -e "Solution: error: net.bridge.bridge-nf-call-ip6tables is an unknown key "
sysctl -e -p >> $v_logFile 2>> $v_logFile
# rpm 004 / 
#64bits# service postgresql stop >> $v_logFile 2>> $v_logFile
#64bits# echo " kernel.shmmax = 536870912" >> /etc/sysctl.conf 2>> $v_logFile
#64bits# sysctl -p >> $v_logFile 2>> $v_logFile
#POR SEGURIDAD CONFIGURAMOS EL ARRANQUE DE POSTGRESQL AUNQUE ES POSIBLE
#QUE YA ESTE
#64bits# chkconfig postgresql on 2>> $v_logFile
#64bits# echo -e "Preparing database ..."
#64bits# echo -e "Preparing database ..." >> $v_logFile
#64bits# cp /var/lib/pgsql/data/postgresql.conf /var/lib/pgsql/data/postgresql.conf.ori 						  >> $v_logFile 2>> $v_logFile 		 # rpm 007
#cp -f /usr/local/Spontania/bin/postgresql.conf /var/lib/pgsql/data/ 2>> $v_logFile
#64bits# posgtresql_version_8                                                                                                 					 # rpm 008
#64bits# if [ $? -eq 0 ]                                                                                                      					 # rpm 008
#64bits# 	then    cp -f /usr/local/Spontania/bin/postgresql.conf.spontania.8_4 /var/lib/pgsql/data/postgresql.conf 2>> $v_logFile              # rpm 008                                                                                           # rpm 008
#64bits# 	else	cp -f /usr/local/Spontania/bin/postgresql.conf.spontania.8_1 /var/lib/pgsql/data/postgresql.conf 2>> $v_logFile 			 # rpm 008
#64bits# fi                                                                                                                   					 # rpm 008
# rpm 005
# sed -e 's/127.0.0.1\/32.*/127.0.0.1  255.255.255.255   trust/g' /var/lib/pgsql/data/pg_hba.conf > /var/lib/pgsql/data/aux.xml 2>> $v_logFile
# host    all         all         ::1/128              trust
#64bits# sed -e 's/ident/trust/g' /var/lib/pgsql/data/pg_hba.conf > /var/lib/pgsql/data/aux.xml 2>> $v_logFile
# rpm 005/
#64bits# mv -f /var/lib/pgsql/data/aux.xml /var/lib/pgsql/data/pg_hba.conf 2>> $v_logFile
#64bits# echo "host    all         all         $v_ipOne         255.255.255.255   trust" >> /var/lib/pgsql/data/pg_hba.conf
#64bits# if [ "$v_ipOne" !=  "$v_ipTwo" ]
#64bits# then
#64bits#   echo "host    all         all         $v_ipTwo         255.255.255.255   trust" >> /var/lib/pgsql/data/pg_hba.conf
#64bits# fi
#64bits# echo -e "Starting postgresql ..."
#64bits# echo -e "Starting postgresql ..." >> $v_logFile
#64bits# service postgresql start >> $v_logFile 2>> $v_logFile
#64bits# sleep 30
echo -e "Creating user root in database ..."
echo -e "Creating user root in database ..." >> $v_logFile
sudo -u postgres createuser root -d -a >> $v_logFile 2>> $v_logFile
sudo -u postgres psql -d template1 -c "alter user root with password 'dialcom!';" >> $v_logFile 2>> $v_logFile

echo -e "Generating webconference database ..."
echo -e "Generating webconference database ..." >> $v_logFile

createdb webconference >> $v_logFile 2>> $v_logFile
psql webconference < /usr/local/tomcat/webapps/webconference/scripts/createTablesPostgres.sql >> /dev/null 2>> $v_logFile
psql webconference < /usr/local/tomcat/webapps/webconference/scripts/soft_version.sql >> /dev/null 2>> $v_logFile
psql webconference < /usr/local/tomcat/webapps/webconference/scripts/parametros_generales.sql >> /dev/null 2>> $v_logFile
changeIps $v_ipOne $v_ipTwo

###########################################################################
#CONFIGURANDO SNMP
###########################################################################
echo -e ""
checkRpm "net-snmp"
if [ $? -eq 0 ]
then
  echo -e "WARNING!!! Snmp service is not installed. This process cannot configure it."
  echo -e "WARNING!!! Snmp service is not installed. This process cannot configure it." >> $v_logFile
else
  service snmpd stop >> $v_logFile 2>> $v_logFile
  echo -e "Configurating snmp service ..."
  echo -e "Configurating snmp service ..." >> $v_logFile
  install -c -o root /usr/local/Spontania/bin/DCS-MIB.txt /usr/share/snmp/mibs/
  cp -f /etc/snmp/snmp.conf /etc/snmp/snmp.conf."`date +'%F_%H%M%S'`".bak 2>> $v_logFile
  cp -f /etc/snmp/snmpd.conf /etc/snmp/snmpd.conf."`date +'%F_%H%M%S'`".bak 2>> $v_logFile
  cp -f /usr/local/Spontania/bin/snmp.conf /etc/snmp/ 2>> $v_logFile
  cp -f /usr/local/Spontania/bin/snmpd.conf /etc/snmp/ 2>> $v_logFile
  service snmpd start >> $v_logFile 2>> $v_logFile
fi 

############################################################################
#MANTENIMIENTO DE BASE DE DATOS
############################################################################
echo -e "Programming cron for database ..."
echo -e "Programming cron for database ..." >> $v_logFile
echo "0 3 * * * root /usr/local/tomcat/webapps/webconference/scripts/prepareDB.sh" >> /etc/crontab 2>> $v_logFile

service crond restart >> $v_logFile 2>> $v_logFile


###########################################################################
#INSTALANDO SCRIPTS DE ARRANQUE
###########################################################################

echo -e "Installing scripts ..."
echo -e "Installing scripts ..." >> $v_logFile
install -c -o root /usr/local/Spontania/server/dcs /etc/init.d
chmod 0744 /etc/init.d/dcs
ln -fs /etc/init.d/dcs /etc/rc0.d/K19webconference
ln -fs /etc/init.d/dcs /etc/rc1.d/K19webconference
ln -fs /etc/init.d/dcs /etc/rc2.d/K19webconference
ln -fs /etc/init.d/dcs /etc/rc3.d/S90webconference
ln -fs /etc/init.d/dcs /etc/rc4.d/S90webconference
ln -fs /etc/init.d/dcs /etc/rc5.d/S90webconference

###########################################################################
#COMPROBANDO SI ESTA INSTALADO EL DCSWATCH
###########################################################################
echo -e ""

checkRpm "DcsWatch"
if [ $? -eq 0 ]
then
  echo -e "WARNING!!! Dcswatch is not installed."
  echo -e "WARNING!!! Dcswatch is not installed." >> $v_logFile
  echo -e "Starting server ..."
  echo -e "Starting server ..." >> $v_logFile
  service dcs start >> $v_logFile 2>> $v_logFile
else
  echo -e "Starting dcswatch ..."
  echo -e "Starting dcswatch ..." >> $v_logFile
  service dcswatch restart >> $v_logFile 2>> $v_logFile
fi

###########################################################################
#OPENFIRE - rpm 005
###########################################################################
echo -e "Installing openfire configuration --------------------------------------------------------------------------------"
echo -e "Installing openfire configuration --------------------------------------------------------------------------------" >> $v_logFile 2>> $v_logFile			
#64bits#install -c -o root /usr/local/Spontania/server/openconfiguration.tgz /openconfiguration.tgz                    >> $v_logFile 2>> $v_logFile		
#64bits#cd /
#64bits# /bin/tar -xzvf /openconfiguration.tgz                                                                          >> $v_logFile 2>> $v_logFile		

cd /usr/local/Spontania/server
mkdir openfire
mv openconfiguration.tgz openfire/openconfiguration.tgz
cd openfire
tar -xzvf openconfiguration.tgz
cp etc/init.d/* /etc/init.d/
mv /etc/security/limits.conf /etc/security/limits.conf.old
cp etc/security/limits.conf /etc/security/limits.conf
mv /etc/sysconfig/openfire /etc/sysconfig/openfire.old
cp etc/sysconfig/openfire /etc/sysconfig/openfire
mv /opt/openfire /opt/openfire.old
mv opt/openfire /opt
cp root/* /root
cd /opt/openfire/
mv jre jre_old

/usr/bin/createdb openfire                                                                                     >> $v_logFile 2>> $v_logFile		
/usr/bin/psql openfire</root/openfire_postgresql.sql
/usr/bin/psql openfire</root/changeProperties.sql
echo -e "Installing openfire configuration --------------------------------------------------------------------------------/">> $v_logFile 2>> $v_logFile		
echo -e "Installing openfire configuration --------------------------------------------------------------------------------/"


###########################################################################
#COMENZANDO SPONTANIA
###########################################################################
echo -e "Starting validator ..."
echo -e "Starting validator ..." >> $v_logFile
service ssup start >> $v_logFile 2>> $v_logFile
echo -e "Starting catalina ..."
echo -e "Starting catalina ..." >> $v_logFile
service catalina start >> $v_logFile 2>> $v_logFile
###########################################################################
#
#
#
#
###########################################################################                                                                     # rpm 012
# GATEWAYS - RPM 12                                                                                                                             # rpm 012
###########################################################################                                                                     # rpm 012
                                                                                                                                                # rpm 012
#64bits# echo -e "Gateway begin ----------------------------------------------------"                                                                    # rpm 012
#64bits# echo -e "Gateway begin ----------------------------------------------------" 									 >> $v_logFile 2>> $v_logFile	# rpm 012		
#64bits# cd /usr/local/Spontania/server
#64bits# tar -zxvf rpm.tar.gz 																							 >> $v_logFile 2>> $v_logFile	# rpm 012	
#64bits# install -c -o root /usr/local/Spontania/server/WebConferenceGateway* /root                                       >> $v_logFile 2>> $v_logFile	# rpm 012	
#64bits# cd /root                                                                                                                                        # rpm 012
#64bits# rpm -ivh WebConferenceGateway*.rpm                                                                               >> $v_logFile 2>> $v_logFile	# rpm 012
#64bits# cp /usr/local/WebConferenceGateway_v3/config/GWServer.conf /etc/						 >> $v_logFile 2>> $v_logFile   # rpm 013
#64bits# cd /														 >> $v_logFile 2>> $v_logFile   # rpm 013
#64bits# cp /usr/local/Spontania/server/GW_Videos_720p.tgz .								 >> $v_logFile 2>> $v_logFile   # rpm 013
#64bits# tar -xzvf GW_Videos_720p.tgz											 >> $v_logFile 2>> $v_logFile   # rpm 013
#64bits# echo -e "Gateway end ------------------------------------------------------"                                     >> $v_logFile 2>> $v_logFile	# rpm 012	
#64bits# echo -e "Gateway end ------------------------------------------------------"                                                                    # rpm 012
                                                                                                                                                # rpm 012
###########################################################################                                                                     # rpm 012
#
#
#
#
###########################################################################										  								# rpm 007
# Configure Dcswatch                                                                                                                            # rpm 007
###########################################################################                                                                     # rpm 007
echo -e "Configure Dcswatch --------------------------------------------------------------------------------" 	                                # rpm 007
echo -e "Configure Dcswatch --------------------------------------------------------------------------------"	 >> $v_logFile 2>> $v_logFile   # rpm 007
rm /usr/local/DcsWatch/bin/dcswatchinstall																		 >> $v_logFile 2>> $v_logFile   # rpm 007
install -c -o root /usr/local/Spontania/bin/dcswatchinstall /usr/local/DcsWatch/bin/dcswatchinstall          	 >> $v_logFile 2>> $v_logFile   # rpm 007
cd /usr/local/DcsWatch/bin                                                                                       >> $v_logFile 2>> $v_logFile   # rpm 007
chmod 0755 dcswatchinstall                                                                                       >> $v_logFile 2>> $v_logFile   # rpm 007
./dcswatchinstall                                                                                                >> $v_logFile 2>> $v_logFile   # rpm 007
dcswatch -s                                                                                                      >> $v_logFile 2>> $v_logFile   # rpm 007
echo -e "Configure Dcswatch --------------------------------------------------------------------------------/"   >> $v_logFile 2>> $v_logFile   # rpm 007
echo -e "Configure Dcswatch --------------------------------------------------------------------------------/"                                  # rpm 007
###########################################################################                                                                     # rpm 012
#
#
#
#
###########################################################################										  								# rpm 007
# Install Session Cleaner
###########################################################################                                                                     # rpm 007
echo -e "Session Cleaner ------------------------------------------------------- "
echo -e "Session Cleaner ------------------------------------------------------- " >> $v_logFile
cd /usr/local/bin																   >> $v_logFile	2>> $v_logFile
tar -zxvf /usr/local/Spontania/server/clean.tar.gz                                 >> $v_logFile    2>> $v_logFile
chown root:root clean                                                              >> $v_logFile    2>> $v_logFile
chmod 0755 /usr/local/bin/clean/clean.sh                                           >> $v_logFile    2>> $v_logFilie
mkdir /usr/local/bin/clean/log                                                      >> $v_logFile    2>> $v_logFilie
echo -e "Session Cleaner -------------------------------------------------------/" >> $v_logFile    2>> $v_logFile
echo -e "Session Cleaner -------------------------------------------------------/"

###########################################################################										  							
#
#
#
#
################################################################################
echo -e ""
echo -e "See more in $v_logFile"
exit 0
