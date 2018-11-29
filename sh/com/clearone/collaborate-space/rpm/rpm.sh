#!/usr/bin/env bash
. /sh/dev/log.sh
. ./setup.sh

_REMOTE_PASS=clearone!
_REMOTE_SERVER=root@192.168.0.17




function send()
{
    _sendTarget=$1
    _sendFile=$2

    sshpass -p $_REMOTE_PASS scp $_sendFile $_REMOTE_SERVER:/$_sendTarget


}


function sendSource()
{
    _sendSourcesFile=$1
    send rpmSources/COLLABORATE-Space-1 $_sendSourcesFile
}


function remoteExec()
{
    _remoteExec=$1
    echo RPM - REMOTE EXEC - INIT
    echo PARAM - _remoteExec: $_remoteExec

    sshpass -p $_REMOTE_PASS ssh $_REMOTE_SERVER "$_remoteExec"
    echo RPM - REMOTE EXEC - END

}


function main()
{

    logSet /tmp/COLLABORATE-Space-rpm
    log "RPM - MAIN - INIT" --screen
    remoteExec '/csRpm/remote.action.sh before-build' >> $LOG
    sendSource /root/git/Admin/war/admin.war >> $LOG
    remoteExec '/csRpm/remote.action.sh build' >> $LOG
    # 0.5.0 - COLLABORATE pace - RPM - Test Action - 1811201004 >> $LOG
    remoteExec '/csRpm/remote.action.sh test' >> $LOG
    log "RPM - MAIN - END" --screen

}

function actionTest()
{
    remoteExec '/csRpm/remote.action.sh proof'
}

function actionTest()
{
    remoteExec '/csRpm/remote.action.sh before-build'
}

### https://access.redhat.com/solutions/10154
function javaDownload()
{
    yum install --downloadonly --downloaddir=/tmp/java java
}

# 0.6.0 - COLLABORATE Space - RPM - Java - 1811231337
function javaInstallLocal()
{
    yum --nogpgcheck localinstall java-1.8.0-openjdk-1.8.0.191.b12-0.el7_5.x86_64.rpm
}

## 0.7.0 - COLLABORATE Space - RPM - Tomcat - 181811270949
function dcsWatchToolsDownload() {
    yum install --downloadonly --downloaddir=/tmp/dcswatch net-tools perl psmisc glibc libgcc libstdc++ nss-softikn-freebl
}

function dcsWatchInstallLocal()
{
    yum --nogpgcheck localinstall net-tools-2.0-0.22.20131004git.el7.x86_64.rpm perl-5.16.3-292.el7.x86_64.rpm psmisc-22.20-15.el7.x86_64.rpm

    yum --nogpgcheck localinstall libgcc-4.8.5-28.el7_5.1.x86_64.rpm libstdc++-4.8.5-28.el7_5.1.x86_64.rpm
}

#0.9.0 - COLLABORATE Space - RPM - Postgresql - 1811271651
function postgresqlDownload() {
    yum install --downloadonly --downloaddir=/tmp/post2 libtool-ltdl perl-Data-Dumper
    wget https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
    yum --nogpgcheck localinstall pgdg-centos10-10-2.noarch.rpm
    yum install --downloadonly --downloaddir=/tmp/post10 postgresql10 postgresql10-server
#    yum install --downloadonly --downloaddir=/tmp/post postgresql-libs postgresql postgresql-odbc postgresql-server net-snmp net-snmp-libs net-snmp-perl net-snmp-utils unixODBC lm_sensors
}

#0.9.0 - COLLABORATE Space - RPM - Postgresql - 1811271651
function postgresql-InstallLocal()
{
    yum --nogpgcheck localinstall libicu* postgresql10*
}

#0.10.0 - COLLABORATE Space - RPM - xmlrpc - 1811271803
function xmlrpc-download() {
    yum install --downloadonly --downloaddir=/tmp/xmlrpc xmlrpc-c*
}

#0.10.0 - COLLABORATE Space - RPM - xmlrpc - 1811271803
function xmlrpc-installLocal() {
    yum --nogpgcheck localinstall xmlrpc-c*
}


#function gateway() {
#    sshpass -p $_REMOTE_PASS
#
#}


