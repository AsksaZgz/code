#!/bin/bash

MIDIR=`pwd`
cp ../CONFIG/mysql/my.cnf /opt/mysql$1/
cd /opt/mysql$1
chown -R root:mysql /opt/mysql$1/*
chown -R mysql:mysql /opt/mysql$1/data
mkdir -p /opt/mysql$1/logs
chown -R mysql:mysql /opt/mysql$1/logs
./scripts/mysql_install_db --defaults-file=/opt/mysql$1/my.cnf --user=mysql
cd $MIDIR

echo "PLEASE REMEMBER TO SET A PASSWORD FOR THE MySQL root USER !"
echo "To do so, start the server:"
echo "cd . ; ./bin/mysqld_safe &"
echo "then issue the following commands:"
echo "./bin/mysqladmin -u root password 'new-password'"
echo "./bin/mysqladmin -u root -h localhost password 'new-password'"
echo "See the manual for more instructions."
