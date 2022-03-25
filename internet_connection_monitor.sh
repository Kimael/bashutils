#!/bin/bash

#Copied from: https://askubuntu.com/questions/522505/script-to-monitor-internet-connection-stability

#***************************************
# Requirements:
# * SpeedTest CLI: sudo apt  install speedtest-cli
# * AWK (might be replaced by 'cut')
#***************************************

#***************************************
# For CRONTAB
# */10 * * * * /location/of/my-internet-test.sh
#***************************************

#LOG_FILE='/var/log/internet_test_'$(HOSTNAME)'.csv'
LOG_FILE='/tmp/log/internet_test_'${HOSTNAME}'.csv'

mkdir -p $(dirname ${LOG_FILE})

DT=$(date '+%Y-%m-%dT%H:%M:%S')

#sudo apt  install speedtest-cli
SPEED_TEST_RES=$(speedtest-cli --simple 2>/dev/null)

#set -o xtrace
DL=$(echo ${SPEED_TEST_RES}   | awk '{print $5}')
UL=$(echo ${SPEED_TEST_RES}   | awk '{print $8}')
PING=$(echo ${SPEED_TEST_RES} | awk '{print $2}')

#set -x
#echo "Ping: '$PING' DL:'${DL}' UL:'${UL}'"
[[ -z "${DL}" ]] && { DL=0; UL=0; PING=0; }
echo ${DT}','${PING}','${DL}','${UL} >> ${LOG_FILE}


#For tests:
#tail ${LOG_FILE}
