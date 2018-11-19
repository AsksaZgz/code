#!/bin/bash

if [ -f pre-install.tgz ]; then
    rm pre-install.tgz
fi
tar -czvf pre-install.tgz CONFIG HTML INSTALL SCRIPTS
chown :atcanet pre-install.tgz
chmod g+w pre-install.tgz
