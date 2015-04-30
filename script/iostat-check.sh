#!/bin/bash

# Zabbix에서 넘겨받는 파라메타값 (2개)
# /etc/cron.d/iostat-
ZBX_REQ_DATA="$2"
ZBX_REQ_DATA_DEV="$1"

# 소스 데이터 저장 위치
SOURCE_DATA=/home/zabbix/log/iostat-data

# 에러 처리
#  - 아이템 타입은 "float" (allow negative + float)

ERROR_NO_DATA_FILE="-0.9900"
ERROR_OLD_DATA="-0.9901"
ERROR_WRONG_PARAM="-0.9902"
ERROR_MISSING_PARAM="-0.9903"

# No data file to read from
if [ ! -f "$SOURCE_DATA" ]; then
  echo $ERROR_NO_DATA_FILE
  exit 1
fi

# Missing device to get data from
if [ -z "$ZBX_REQ_DATA_DEV" ]; then
  echo $ERROR_MISSING_PARAM
  exit 1
fi

#
# 예전 데이터 처리
# 기본적으로 5일치 데이터를 보관처리

OLD_DATA=5
if [ $(stat -c "%Y" $SOURCE_DATA) -lt $(date -d "now -$OLD_DATA min" "+%s" ) ]; then
  echo $ERROR_OLD_DATA
  exit 1
fi


# cronjob에 설정을 하여 데이터를 수집하여 기록 하게 해야 됨.
device_count=$(grep -Ec "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA)
if [ $device_count -eq 0 ]; then
  echo $ERROR_WRONG_PARAM
  exit 1
fi

case $ZBX_REQ_DATA in
  rrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $2}';;
  wrqm/s)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $3}';;
  r/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $4}';;
  w/s)        grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $5}';;
  rkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $6}';;
  wkB/s)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $7}';;
  avgrq-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $8}';;
  avgqu-sz)   grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $9}';;
  await)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $10}';;
  r_awit)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $11}';;
  w_awit)     grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $12}';;
  svctm)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $13}';;
  %util)      grep -E "^$ZBX_REQ_DATA_DEV " $SOURCE_DATA | tail -1 | awk '{print $14}';;
  *) echo $ERROR_WRONG_PARAM; exit 1;;
esac

exit 0
