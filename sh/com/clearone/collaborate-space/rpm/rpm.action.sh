#!/usr/bin/env bash
# 0.7.0 - COLLABORATE Space - RPM - Tomcat - 181811270949

. ./setup.sh
. /csRpm/rpm.sh

_action=$1

if [[ $_action = 'main' ]]
then
    main
fi


if [[ $_action = 'test' ]]
then
    actionTest
fi

if [[ $_action = 'proof' ]]
then
    actionProof
fi

if [[ $_action = 'dev' ]]
then
    echo "ACTION - DEV - INIT --------------------------------------------------"
    _devAction=$2
    ($_devAction)
    echo "ACTION - DEV - END ---------------------------------------------------"
fi


if [[ $_action = 'rem' ]]
then
    echo "ACTION - REM - INIT --------------------------------------------------"
    _devRem=$2
    actionRem $_devRem
    echo "ACTION - REM - END ---------------------------------------------------"
fi