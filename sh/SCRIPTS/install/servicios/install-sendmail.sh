#!/bin/bash

cd $1

CONFIG=../../CONFIG/sendmail

# Hacemos copia de seguridad de las configuraciones de sendmail
rm cs00009.tar.gz
mv cs00008.tar.gz cs00009.tar.gz
mv cs00007.tar.gz cs00008.tar.gz
mv cs00006.tar.gz cs00007.tar.gz
mv cs00005.tar.gz cs00006.tar.gz
mv cs00004.tar.gz cs00005.tar.gz
mv cs00003.tar.gz cs00004.tar.gz
mv cs00002.tar.gz cs00003.tar.gz
mv cs00001.tar.gz cs00002.tar.gz
tar cvzf cs00001.tar.gz -C /  etc/mail  etc/sendmail.cf  usr/share/sendmail-cf  usr/sbin/sendmail  

# Copiamos las configuraciones del dominio de atcanet
cp $CONFIG/atcanet.com.mc cf/cf
cp $CONFIG/atcanet.com.m4 cf/domain
ln -svf /usr/share/man /usr/man

# Compilamos e instalamos sendmail
pushd .
cd cf/cf
./Build install-cf CF=atcanet.com
popd
cd sendmail
./Build
./Build install

