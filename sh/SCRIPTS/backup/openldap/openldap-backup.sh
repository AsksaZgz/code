#!/bin/bash

# $1 - Directorio destino para la copia de seguridad

service anet-openldap stop
if [ $? -eq 0 ]; then
    /opt/openldap/sbin/slapcat > /$1/backup-openldap.ldif
    service anet-openldap start
    tar -cjvf /$1/backup-openldap.ldif.tbz /$1/backup-openldap.ldif
    if [ $? -eq 0 ]; then
	rm /$1/backup-openldap.ldif
    fi
fi
