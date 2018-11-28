#!/usr/bin/env bash



function test() {

    _gatewayDefineSource=\\\\192.168.1.253\\Versions\\VAS\\Gateways\\SpontaniaGateway\\x64
    _gatewayDefineTarget=/rpmGateway
    _gatewayDefineParam="user=jesus.bernad,uid=5000,gid=6000,pass=clearone2015!"
    umount $_gatewayDefineTarget
    # --parents No error if existing
    mkdir $_gatewayDefineTarget --parents
    mount.cifs $_gatewayDefineSource $_gatewayDefineTarget -o $_gatewayDefineParam
    cd $_gatewayDefineTarget

    _gatewayDefineVersions=(`ls --sort=time --format=single-column /rpmGateway`)

    _gatewayDefineLastVersion=${_gatewayDefineVersions[0]}
    echo $_gatewayDefineLastVersion
    cd $_gatewayDefineLastVersion/RPMS
    ls
}

test