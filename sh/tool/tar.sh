#!/usr/bin/env bash

function _tar()
{
    _tarTarget=$1
    _tarSource=$2

    tar --create --gzip --verbose --file=$_tarTarget $_tarSource
}
