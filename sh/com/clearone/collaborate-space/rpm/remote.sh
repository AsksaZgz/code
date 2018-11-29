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

#0.8.0 - COLLABORATE Space - RPM - DcsWatch - 1811271135
function repositoryDefine()
{
    _repositoryDefineFileName=repository.tar.gz
    cd /rpmRepository
    tar --create --gzip --verbose --file=/rpmSources/$_SOURCES_FOLDER/$_repositoryDefineFileName *
}

function gatewayDefineLastVersion()
{
    _gatewayDefineLastVersionSource=\\\\192.168.1.253\\Versions\\VAS\\Gateways\\SpontaniaGateway\\x64
    _gatewayDefineLastVersionTarget=/rpmGateway
    _gatewayDefineLastVersionParam="user=jesus.bernad,uid=5000,gid=6000,pass=clearone2015!"
    umount $_gatewayDefineLastVersionTarget
    # --parents No error if existing
    mkdir $_gatewayDefineLastVersionTarget --parents
    mount.cifs $_gatewayDefineLastVersionSource $_gatewayDefineLastVersionTarget -o $_gatewayDefineLastVersionParam
    cd $_gatewayDefineLastVersionTarget

    _gatewayDefineLastVersionList=(`ls --sort=time --format=single-column /rpmGateway`)

    _gatewayDefineLastVersionLast=${_gatewayDefineLastVersionList[0]}
    echo $_gatewayDefineLastVersionLast

    return $_gatewayDefineLastVersionLast
}

#0.11.0 - COLLABORATE Space - RPM - Gateway - 1811280852
function gatewayDefinePrepare()
{
    # delete previous versions
    cd /rpmRepository
    rm SpontaniaGateway* -f
}

#0.11.0 - COLLABORATE Space - RPM - Gateway - 1811280852
function gatewayDefine()
{
    # delete previous versions
    gatewayDefinePrepare

#    _gatewayDefineSource=\\\\192.168.1.253\\Versions\\VAS\\Gateways\\SpontaniaGateway\\x64
#    _gatewayDefineTarget=/rpmGateway
#    _gatewayDefineParam="user=jesus.bernad,uid=5000,gid=6000,pass=clearone2015!"
#    umount $_gatewayDefineTarget
#    # --parents No error if existing
#    mkdir $_gatewayDefineTarget --parents
#    mount.cifs $_gatewayDefineSource $_gatewayDefineTarget -o $_gatewayDefineParam
#    cd $_gatewayDefineTarget
#
#    _gatewayDefineVersions=(`ls --sort=time --format=single-column /rpmGateway`)

#    _gatewayDefineLastVersion=${_gatewayDefineVersions[0]}
#    echo $_gatewayDefineLastVersion

    _gatewayDefineLastVersion=(gatewayDefineLastVersion)
    cd $_gatewayDefineLastVersion/RPMS

    cp *.rpm /rpmRepository
}

#0.12.0 - COLLABORATE Space - RPM - SpontaniaApi - 1811281514
function collaborateJarDefine()
{
    _collaborateJarDefineFileName=jar.tar.gz

    cd /rpmJar
    rm * -f
    sshpass -p One2015! scp jesus@im.collaboratespace.net:/home/jesus/tomcat/lib/collaborate/* .
    tar --create --gzip --verbose --file=/rpmSources/$_SOURCES_FOLDER/$_collaborateJarDefineFileName *
}


function actionBeforeBuild()
{
    cd /rpmSources
    rm * -rf
    mkdir $_SOURCES_FOLDER

    ### Tools
    gatewayDefine
    repositoryDefine

    collaborateJarDefine

    cd /rpmSources/$_SOURCES_FOLDER
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

function actionProof()
{
    echo "actionProof"
#    cd /rpmSources
#    rm * -rf
#    mkdir $_SOURCES_FOLDER

#    collaborateJarDefine
}

function actionDev()
{
    _devAction=$1
    ($_devAction)
}

function ok()
{
    echo "OK"
}
