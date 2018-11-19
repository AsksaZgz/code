#!/bin/bash

#cd $1
#mysql -u root -p < db_setup.sql
/opt/mysql/bin/mysql --defaults-file=/opt/mysql/data/my.cnf -u root -p < install-alfresco.sql
