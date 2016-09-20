#!/bin/sh

a=0

while  [ $a -le 10 ]
do 
./gw_soc_fw_version_query.bin /dev/ttySP1
done
