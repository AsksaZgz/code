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


