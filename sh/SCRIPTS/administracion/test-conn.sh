#!/bin/bash

# Copy this file to $HOME/bin
# Mkdir $HOME/logs/test-conn

connhopsold=0
if [ -f $HOME/logs/test-conn/conn-traceroute.log ]; then
    connhopsold=`cat $HOME/logs/test-conn/conn-traceroute.log | wc -l | head -2 | tail -1`
fi
traceroute -q 1 -w 2 $1 > $HOME/logs/test-conn/conn-traceroute.log 2>&1
ping -c 1 $1 > $HOME/logs/test-conn/conn-ping.log 2>&1
conndate=`date +%Y%m%d%H%M%S`
conndatemes=`date +%Y%m`
connhops=`cat $HOME/logs/test-conn/conn-traceroute.log | wc -l | head -2 | tail -1`
connping=`cat $HOME/logs/test-conn/conn-ping.log | head -2 | tail -1`
echo "(($conndate)) (($connhops)) (($connping))" >> $HOME/logs/test-conn/$conndatemes-conn-registry.log
if ! [ $connhops -eq $connhopsold ]; then
    cp $HOME/logs/test-conn/conn-traceroute.log $HOME/logs/test-conn/conn-traceroute-$conndate.log
fi
