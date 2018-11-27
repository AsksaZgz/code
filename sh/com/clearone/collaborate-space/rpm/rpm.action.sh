#!/usr/bin/env bash
# 0.7.0 - COLLABORATE Space - RPM - Tomcat - 181811270949

. ./setup.sh
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
