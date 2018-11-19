#!/bin/bash

DIR=`pwd`
cd ../bazar
ls -Rla > LISTADO.TXT
chown :atcanet LISTADO.TXT
chmod g+w LISTADO.TXT
cd $DIR
