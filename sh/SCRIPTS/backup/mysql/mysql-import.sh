#!/bin/bash

# $1 - Nombre de la base de datos
# $2 - Directorio donde estan las copias de seguridad

/opt/mysql/bin/mysql --defaults-file=/opt/mysql/data/my.cnf < $2/backup-mysql-$1.sql
