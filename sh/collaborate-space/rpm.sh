#!/usr/bin/env bash

_REMOTE_PASS=clearone!
_REMOTE_SERVER=root@192.168.0.17

_TEST_PASS=clearone!
_TEST_SERVER=root@192.168.0.37

_RPM=COLLABORATE-Space-1-0.noarch.rpm



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


function testSend()
{
    _testSendFile=$1
    _testSendTarget=tmp

    sshpass -p $_TEST_PASS scp $_testSendFile $_TEST_SERVER:/$_testSendTarget

}



function remoteExec()
{
    _remoteExec=$1

    sshpass -p $_REMOTE_PASS ssh $_REMOTE_SERVER "$_remoteExec"

}

function testExec()
{
    _testExec=$1

    sshpass -p $_TEST_PASS ssh $_TEST_SERVER "$_remoteExec"

}

function main()
{
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh before-build'
    sendSource /root/git/Admin/war/admin.war
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh build'

    testSend '/rpmRpms/noarch/$_RPM'
    testExec '/tmp/rpm -ivh /tmp/$_RPM'
}

main


