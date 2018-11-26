#!/usr/bin/env bash
. /sh/dev/log.sh

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
    remoteExec '/sh/collaborate-space/rpm/remote.action.sh before-build' >> $LOG
    sendSource /root/git/Admin/war/admin.war >> $LOG
    remoteExec '/sh/collaborate-space/rpm/remote.action.sh build' >> $LOG
    # 0.5.0 - COLLABORATE pace - RPM - Test Action - 1811201004 >> $LOG
    remoteExec '/sh/collaborate-space/remote.action.sh test' >> $LOG
    log "RPM - MAIN - END" --screen

}

function actionTest()
{
    remoteExec '/sh/collaborate-space/rpm/remote.action.sh before-build'
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

}

