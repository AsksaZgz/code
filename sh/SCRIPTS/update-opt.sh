#!/bin/bash

DIR=`pwd`
if [ -f opt.tar ]; then
    rm opt.tar
fi
cd /opt
tar -cvf $DIR/opt.tar *
cd $DIR
chown :atcanet opt.tar
chmod g+w opt.tar
