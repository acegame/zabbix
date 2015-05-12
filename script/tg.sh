#!/bin/bash
now=$(date)
to=$1
subject=$2
body=$3

TGPATH=/home/telegramd/tg
CFGPATH="/home/telegramd/.telegram-cli/"
LOGFILE="/var/log/zabbix/tg.log"

cd $TGPATH

# telegram key certification message sending.
echo "msg $to $subject" | $TGPATH/bin/telegram-cli -k $TGPATH/tg-server.pub -W -C 1>>${LOGFILE} 2>&1

echo "-------------------------------------------------------" >> ${LOGFILE}
echo "$now Recipient=$to Message=$subject" >> ${LOGFILE}
echo "$body " >> ${LOGFILE}
echo "Finished" >> ${LOGFILE}
echo "-------------------------------------------------------" >> ${LOGFILE}
