#!/bin/bash

cd $1
./configure --prefix=/opt/apache$2 \
	    --enable-so \
	    --enable-mods-shared=all
#	    --enable-dav=shared \
#	    --enable-ldap=shared \
#	    --enable-rewrite=shared \
#	    --enable-speling=shared \
#	    --enable-ssl=shared
#	    --enable-dav-fs
#	    --enable-ssl

make
make install
cd ..
cp ../CONFIG/apache/* /opt/apache$2/conf