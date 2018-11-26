#!/usr/bin/env bash
# 0.6.0 - COLLABORATE Space - RPM - Java - 1811231337

. /sh/collaborate-space/rpm/config.sh
. /csRpm/rpm.sh

_action=$1

if [[ $_action = 'main' ]]
then
    main
fi

if [[ $_action = 'java-download' ]]
then
    javaDownload
fi

if [[ $_action = 'test' ]]
then
    actionTest
fi