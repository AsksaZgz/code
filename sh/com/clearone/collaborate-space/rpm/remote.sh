#!/usr/bin/env bash
. /sh/com/clearone/collaborate-space/rpm/setup.sh
. /sh/tool/tar.sh
. /sh/tool/file.sh


_REMOTE_CREATE_TARBALL=''
_SPEC=COLLABORATE-Space.spec
_SOURCES_FOLDER=COLLABORATE-Space-1


_TEST_PASS=clearone!
_TEST_SERVER=root@192.168.0.37

_RPM=COLLABORATE-Space-1-0.noarch.rpm

_GATEWAY_VERSION=


function prodCopy()
{
    _prodCopyTarget=$1

    echo -e "PROD COPY - INIT"
    echo -e "Target: $_prodCopyTarget"
    sshpass -p One2015! scp jesus@im.collaboratespace.net:$_prodCopyTarget .
    echo -e "PROD COPY - INIT"

}

### Create tarball
function tarball()
{
    cd /rpmSources
    fileDelete "*.tar.gz"
    fileTar "COLLABORATE-Space-1.0.tar.gz" "$_SOURCES_FOLDER/"
}


### Copy Spec
function spec()
{
    cd /rpmSpecs
    fileDelete "*.specs"
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

function repositoryDefine()
{
    _repositoryDefineFileName=repository.tar.gz
    cd /rpmRepository
    fileTar "/rpmSources/$_SOURCES_FOLDER/$_repositoryDefineFileName" "*"
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

    _GATEWAY_VERSION=${_gatewayDefineLastVersionList[0]}
    echo $_GATEWAY_VERSION
    

}

function webDefineWar()
{
    echo "WEB DEFINE WAR - INIT"
    cd /rpmWeb
    fileDelete "*.war"
    prodCopy "/home/jesus/webapps/*.war"
    echo "WEB DEFINE WAR - END"
}


function webDefine()
{
    webDefineWar

    cd /rpmWeb
    fileTar "/rpmSources/$_SOURCES_FOLDER/web.tar.gz" "*"
}


function gatewayDefinePrepare()
{
    # delete previous versions
    cd /rpmRepository
    fileDelete "SpontaniaGateway*"
}

function gatewayDefine()
{
    # delete previous versions
    gatewayDefinePrepare

    gatewayDefineLastVersion
    cd $_GATEWAY_VERSION/RPMS

    cp *.rpm /rpmRepository
}

function collaborateJarDefine()
{
    _collaborateJarDefineFileName=jar.tar.gz

    cd /rpmJar
    fileDelete "*"
    prodCopy "/home/jesus/tomcat/lib/collaborate/*"
    fileTar "/rpmSources/$_SOURCES_FOLDER/$_collaborateJarDefineFileName" "*"
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
    testSend "/rpmRpms/noarch/$_RPM"
    testExec "rpm -ivh /tmp/$_RPM"

}

function actionProof()
{
    echo "actionProof"
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
