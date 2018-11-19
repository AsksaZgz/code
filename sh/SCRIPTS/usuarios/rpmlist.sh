#!/bin/bash

rpm -qai > $1
cat $1 | awk 'BEGIN { name = "" } /^Name/ { name = $3 } /^Size/ { printf "%s %s\n", $3, name }' | sort -nr > $2

