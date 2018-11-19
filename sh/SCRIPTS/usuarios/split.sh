#!/bin/bash

cat $1 | awk -F $2 ' BEGIN { f = 1 } { print NF; print FS; while (++f <= NF) print $f } '
