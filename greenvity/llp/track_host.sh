#! /bin/bash
#
# track Host SW  - send a signal if any server dies other than NWKMGR
#
# arg1 - pid of guy we should send a signal to
# arg2 - list of PIDs we should track

#Text Colors - Brighter versions
LGREEN='\033[1;32m'
LRED='\033[1;31m'
LMAGENTA='\033[1;35m'
#Text Colors - Reset to default
RESET='\033[0;0;39m'

export requestor=$1
export PIDS="$2"

VERBOSE=0
if [ -n "$VERBOSE_TRACKER" ]; then
  if [ $VERBOSE_TRACKER -ge 1 ]; then
  	VERBOSE=$VERBOSE_TRACKER
  fi
fi

total=0
for pid in $PIDS; do
	total=$((total + 1))
done
echo -e "${LMAGENTA} Tracking $total pids, $PIDS ${RESET}"
echo -e "${LMAGENTA} When Host SW Tracker sees any process missing, it will send a SIGUSR2 to pid $requestor ${RESET}"

nameof()
{
if [ -e /proc/$1/cmdline ]; then
	export NAME=`cat /proc/$1/cmdline | awk -F "\0" ' { print $1 }' | head -1 | tr -d "\n"`
	return 1;
else
	export NAME="pid $1"
	return 0;
fi
}

# poll pids to see if anyone died 
while [ true ]; do
	sleep 30
	count=0
	if [ $VERBOSE -ge 1 ]; then
		echo ================================================
		date
	fi
	for pid in $PIDS; do
		nameof $pid
		if [ $? -eq 1 ]; then
			if [ $VERBOSE -ge 1 ]; then
				echo -e "${LRED} pid $pid ($NAME) is alive ${RESET}"
			fi
			count=$((count + 1))
		else
			echo -e "${LRED} pid $pid stopped!!! ${RESET}"
			break;
		fi
	done
	if [ $count -ne $total ]; then
		echo -e "${LRED} Host Reset ${RESET}"
		break;	
	fi
done

cp -f /opt/greenvity/bkup/*.out /opt/greenvity/llp/
cd /opt/greenvity/llp/
chmod 777 *
cp -f /opt/greenvity/bkup/tcp/tcp_server.out /opt/greenvity/tcp/
cd /opt/greenvity/tcp/
chmod 777 *
cp -f /opt/greenvity/bkup/mqtt/mqtt_withSSL.out /opt/greenvity/mqtt/
cd /opt/greenvity/mqtt/
chmod 777 *
cd /opt/greenvity/llp/
echo kill -SIGUSR2 $requestor
echo -e "${LRED} HOST SW tracker exiting ${RESET}"
sleep 1
echo -e "HOST SW Rebbot :Failed PID - $pid" >> /opt/greenvity/llp/HostSW.log
date >> /opt/greenvity/llp/HostSW.log
echo "=============================================" >> /opt/greenvity/llp/HostSW.log
reboot