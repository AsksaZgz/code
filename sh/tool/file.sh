#!/usr/bin/env bash

### https://ss64.com/bash/syntax-variables.html

function _fileDelete()
{
    _deleteExitCode=$?
    _deleteTarget=$1
    if [ "$_deleteExitCode" = "0" ]; then
      rm $_deleteTarget --force
    else
      echo File Not found
    fi
}
