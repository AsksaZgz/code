#!/usr/bin/env bash

_REMOTE_CREATE_TARBALL='tar czf COLLABORATE-Space-1.0.tar.gz COLLABORATE-Space-1'
_SPEC=COLLABORATE-Space.spec

cd /rpmSources

$_REMOTE_CREATE_TARBALL

cd /root/git/code/sh/collaborate-space/spec
cp $_SPEC /rpmSpecs

# BUILD RPM
cd ~/rpmbuild
rpmbuild -ba SPECS/$_SPEC