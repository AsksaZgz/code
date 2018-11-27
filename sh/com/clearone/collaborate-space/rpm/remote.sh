#!/usr/bin/env bash
. ./setup.sh

_REMOTE_CREATE_TARBALL=''
_SPEC=COLLABORATE-Space.spec
_SOURCES_FOLDER=COLLABORATE-Space-1


_TEST_PASS=clearone!
_TEST_SERVER=root@192.168.0.37

_RPM=COLLABORATE-Space-1-0.noarch.rpm



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
    cd /csRpm/spec
    cp $_SPEC /rpmSpecs
}


### BUILD RPM
function build()
{
    cd /rpmRpms
    rm * -rf
    cd /rpmBuild
    rm * -rf

    cd /rpm
    rpmbuild -ba /rpmSpecs/$_SPEC
}

function testSend()
{
    _testSendFile=$1
    _testSendTarget=tmp

    sshpass -p $_TEST_PASS scp $_testSendFile $_TEST_SERVER:/$_testSendTarget

}


function testExec()
{
    _testExec=$1

    sshpass -p $_TEST_PASS ssh $_TEST_SERVER "$_testExec"

}

function actionBeforeBuild()
{
    cd /rpmSources
    rm * -rf
    mkdir $_SOURCES_FOLDER

    ### Tools
    ### Java
    cd $_SOURCES_FOLDER
    cp /rpmTool/* .
}

function actionBuild()
{
    tarball
    spec
    build
}

function actionTest()
{
    # 0.5.0 - COLLABORATE pace - RPM - Test Action - 1811201004
    testSend "/rpmRpms/noarch/$_RPM"
    testExec "rpm -ivh /tmp/$_RPM"

}