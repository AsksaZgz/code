#!/usr/bin/env bash
#0.11.0 - COLLABORATE Space - RPM - Gateway - 1811280852
#mount.cifs \\\\192.168.1.253\\Current_Releases   /home/jesus/current_releases -o user=jesus.bernad,uid=5000,gid=6000
#mount.cifs \\\\192.168.1.253\\Versions   /home/rpm253Versions -o user=jesus.bernad,uid=5000,gid=6000
mount.cifs \\\\192.168.1.253\\Versions\\VAS\\Gateways\\SpontaniaGateway\\x64   /rpmGateway -o pass=clearone2015!,user=jesus.bernad,uid=5000,gid=6000
#mount.cifs \\\\192.168.1.253\\Versions   /home/j./comesus/versions -o user=jesus.bernad,uid=5000,gid=6000