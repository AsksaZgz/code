#!/usr/bin/env bash

### https://ss64.com/bash/syntax-variables.html

function fileDelete()
{
    _deleteExitCode=$?
    _deleteTarget=$1
    if [ "$_deleteExitCode" = "0" ]; then
      rm $_deleteTarget --force
    else
      echo File Not found
    fi
}


function fileTar()
{
    _tarTarget=$1
    _tarSource=$2

    tar --create --gzip --verbose --file=$_tarTarget $_tarSource
}