#!/usr/bin/env bash

. /sh/collaborate-space/rpm/remote.sh

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
