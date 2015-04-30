#!/bin/bash

IOSTAT_DATA=/home/zabbix/log/iostat-data
TMP_DATA=/home/zabbix/log/iostat-data.tmp

# 10초 단위로 2번의 데이터를 수집
iostat -kx 10 2 > $TMP_DATA
mv -f $TMP_DATA $IOSTAT_DATA
