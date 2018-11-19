#!/bin/bash

cd $1

./configure --prefix=/opt/openldap \
	    --enable-ldbm \
	    --enable-sql \
	    --enable-ldap \
	    --enable-meta \
	    --enable-slurpd

make depend
make
make test
make install

cd ..
