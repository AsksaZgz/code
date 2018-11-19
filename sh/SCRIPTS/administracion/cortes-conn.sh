#!/bin/bash

cat $1/$1-conn-registry.log | grep -v ttl > cortes/$1-cortes-duracion.txt

cat cortes/$1-cortes-duracion.txt | cut -c-12 | uniq > cortes/$1-cortes-duracion-abreviado.txt
