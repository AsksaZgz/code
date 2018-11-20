#!/usr/bin/env bash

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

    sshpass -p $_REMOTE_PASS ssh $_REMOTE_SERVER "$_remoteExec"

}


function main()
{
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh before-build'
    sendSource /root/git/Admin/war/admin.war
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh build'
    # 0.5.0 - COLLABORATE pace - RPM - Test Action - 1811201004
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh test'

}

main


