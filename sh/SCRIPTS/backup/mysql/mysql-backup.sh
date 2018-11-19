#!/bin/bash

# $1 - Nombre de la base de datos
# $2 - Directorio destino para la copia de seguridad

echo "Haciendo copia de seguridad de ($1) en ($2)"
#tar -cjhpvf $2/backup-mysql-$1.tmp.tbz /opt/mysql/data/$1
#if [ $? -eq 0 ]; then
#    mv -f $2/backup-mysql-$1.tbz $2/backup-mysql-$1-old.tbz
#    mv $2/backup-mysql-$1.tmp.tbz $2/backup-mysql-$1.tbz
#fi
/opt/mysql/bin/mysqldump --defaults-file=/opt/mysql/data/my.cnf --databases --opt $1 > $2/backup-mysql-$1.sql
tar -cjpvf $2/backup-mysql-$1.sql.tbz $2/backup-mysql-$1.sql
if [ $? -eq 0 ]; then
    rm $2/backup-mysql-$1.sql
fi
