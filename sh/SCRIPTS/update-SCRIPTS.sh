#!/bin/bash

if [ -f SCRIPTS.tgz ]; then
    rm SCRIPTS.tgz
fi
tar -czvf SCRIPTS.tgz SCRIPTS
chown :atcanet SCRIPTS.tgz
chmod g+w SCRIPTS.tgz
