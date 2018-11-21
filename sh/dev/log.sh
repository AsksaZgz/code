#!/usr/bin/env bash

LOG=/tmp/$(date +%Y%m%d%H%M%S).log


function logSet()
{
    _logSet=$1
    LOG=$_logSet-$(date +%Y%m%d%H%M%S).log;
}

function log()
{
    _logPrefix="$(date +%Y/%m/%d) $(date +%H:%M:%S)"
    _logText="$_logPrefix $1"
#    _logText=$1
#    _logText=$(date +%Y%m%d%H%M%S) $1
    _logParam=$2

    echo -e $_logText >> $LOG

    if [[ $_logParam = '--screen' ]]
    then
        echo -e $_logText
    fi

    if [[ $_logParam = '-s' ]]
    then
        echo -e $_logText
    fi

}

