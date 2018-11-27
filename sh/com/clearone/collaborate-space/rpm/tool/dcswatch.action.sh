#!/usr/bin/env bash

function op_get_ip()
{
  echo $1
  v_res=`cat $1 | grep IPADDR | perl -pi -e s+"IPADDR="+""+g`
  echo -e "op_get_ip: $v_res" >> $2 2>>$2
  v_opGetIp=$v_res
  if [ -z $v_res ]
  then
    return 1
  fi
  return 0
}