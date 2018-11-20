#!/usr/bin/env bash

_REMOTE_CREATE_TARBALL=''
_SPEC=COLLABORATE-Space.spec
_SOURCES_FOLDER=COLLABORATE-Space-1

_remoteAction=$1

### Create tarball
function tarball()
{
    cd /rpmSources
    rm *.tar.gz -f
    tar cfvz COLLABORATE-Space-1.0.tar.gz $_SOURCES_FOLDER/
}


### Copy Spec
function spec()
{
    cd /rpmSpecs
    rm *.specs -f
    cd /root/git/code/sh/collaborate-space/spec
    cp $_SPEC /rpmSpecs
}


### BUILD RPM
function build()
{
    cd /rpmBuild
    rm * -rf
    rpmbuild -ba SPECS/$_SPEC
}


function actionBeforeBuild()
{
    cd /rpmSources
    rm * -rf
    mkdir $_SOURCES_FOLDER
}


function actionBuild()
{
    tarball
    spec
    build
}


if [[ $_remoteAction = 'before-build' ]]
then
    actionBeforeBuild
fi


if [[ $_remoteAction = 'build' ]]
then
    actionBuild
fi