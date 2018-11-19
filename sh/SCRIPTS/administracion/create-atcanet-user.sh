#!/bin/bash

useradd -d /atcanet/usuarios/$1 -g atcanet $1
passwd $1
cd /var/yp
make
