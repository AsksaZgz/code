#!/usr/bin/env bash

. ./setup.sh
. /csRpm/remote.sh

_remoteAction=$1

if [[ $_remoteAction = 'before-build' ]]
then
    actionBeforeBuild
fi

if [[ $_remoteAction = 'build' ]]
then
    actionBuild
fi

if [[ $_remoteAction = 'test' ]]
then
    actionTest
fi

if [[ $_remoteAction = 'proof' ]]
then
    actionProof
fi

#if [[ $_remoteAction = 'gatewayDefine' ]]
#then
#    gatewayDefine
#fi
#
#if [[ $_remoteAction = 'gatewayDefineBefore' ]]
#then
#    gatewayDefineBefore
#fi
#
#if [[ $_remoteAction = 'gatewayDefineLastVersion' ]]
#then
#    gatewayDefineLastVersion
#fi

if [[ $_remoteAction = 'repositoryDefine' ]]
then
    repositoryDefine
fi

if [[ $_remoteAction = 'dev' ]]
then
    _devAction=$2
    ($_devAction)
fi


