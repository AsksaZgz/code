#!/bin/bash

#genbasedir --flat --bloat --bz2only --partial --progress /tallerlocal/datos/apt/fc3 atcanet
genbasedir --flat --bloat --bz2only --partial --progress $1 $2
