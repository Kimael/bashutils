#!/bin/bash

#Copied from: https://askubuntu.com/questions/522505/script-to-monitor-internet-connection-stability

#***************************************
# REQUIREMENTS
# * SpeedTest CLI: sudo apt  install speedtest-cli
# * AWK (might be replaced by 'cut')
#***************************************

#***************************************
# CRONTAB
# For Ubuntu, add to file '/etc/crontab':
# */10 *  * * *   root    /home/msibelle/internet_connection_monitor.sh
# and check with: grep -i cron /var/log/syslog
#***************************************

#LOG_FILE='/var/log/internet_test_'$(HOSTNAME)'.csv'
LOG_FILE='/tmp/log/internet_test_'${HOSTNAME}'.csv'

mkdir -p $(dirname ${LOG_FILE})

DT=$(date '+%Y-%m-%dT%H:%M:%S')

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
