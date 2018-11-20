#!/usr/bin/env bash

. /sh/collaborate-space/remote.sh

_remoteAction=$1

if [[ $_remoteAction = 'before-build' ]]
then
    actionBeforjeBuild
fi


if [[ $_remoteAction = 'build' ]]
then
    actionBuild
fi

if [[ $_remoteAction = 'test' ]]
then
    actionTest
fi
