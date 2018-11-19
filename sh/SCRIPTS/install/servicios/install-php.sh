#!/bin/bash

cd $1

./configure --build=i386-redhat-linux \
	    --host=i386-redhat-linux \
	    --target=i386-redhat-linux-gnu \
	    --prefix=/opt/php$2 \
	    --disable-debug \
	    --with-pic \
	    --disable-rpath \
	    --with-bz2 \
	    --with-curl \
	    --enable-gd-native-ttf \
	    --without-gdbm \
	    --with-gettext \
	    --with-gmp \
	    --with-iconv \
	    --with-openssl \
	    --with-png \
	    --with-pspell \
	    --with-zlib \
	    --with-layout=GNU \
	    --enable-exif \
	    --enable-ftp \
	    --enable-magic-quotes \
	    --enable-sockets \
	    --enable-sysvsem \
	    --enable-sysvshm \
	    --enable-sysvmsg \
	    --enable-track-vars \
	    --enable-trans-sid \
	    --enable-yp \
	    --enable-wddx \
	    --with-kerberos \
	    --enable-ucd-snmp-hack \
	    --enable-memory-limit \
	    --enable-shmop \
	    --enable-calendar \
	    --enable-dbx \
	    --enable-dio \
	    --without-sqlite \
	    --with-xml \
	    --with-apxs2=/opt/apache$3/bin/apxs \
	    --with-mysql=/opt/mysql$4 \
	    --with-mysql-sock=/opt/mysql$4/data/mysql.sock \
	    --with-ldap=/opt/openldap$5 \
	    --without-odbc \
	    --disable-dom \
	    --disable-dba
#	    --without-gd \
#	    --with-mysqli=/opt/mysql$4 \

make
make install
libtool --finish `pwd`/libs
chmod 755 /opt/apache$3/modules/libphp*.so
cd ..
echo "You may want to add: /opt/php$2/share/pear to your php.ini include_path"
