#!/bin/bash

cd $1/jk/native
./configure --with-apxs=/opt/apache$2/bin/apxs
make
