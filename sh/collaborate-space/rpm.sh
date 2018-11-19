#!/usr/bin/env bash

_REMOTE_PASS=clearone!
_REMOTE_SERVER=root@192.168.0.17





function send()
{
    _sendTarget=$1
    _sendFile=$2

    sshpass -p $_REMOTE_PASS scp $_sendFile root@192.168.0.17:/$_sendTarget


}

function sendSource()
{
    _sendSourcesFile=$1
    send rpmSources/COLLABORATE-Space $_sendSourcesFile
}



function remoteExec()
{
    _remoteExec=$1

    sshpass -p $_REMOTE_PASS ssh $_REMOTE_SERVER "$_remoteExec"

}

function main()
{
#    sendSource /root/git/Admin/war/admin.war
    remoteExec '/root/git/code/sh/collaborate-space/remote.sh'

}

main