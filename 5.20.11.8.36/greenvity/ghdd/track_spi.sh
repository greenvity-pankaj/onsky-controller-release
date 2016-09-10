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

MAX_SPI_NO_RES_CN=5
gvspi_rx=0
VERBOSE=0

if [ -n "$VERBOSE_TRACKER" ]; then
  if [ $VERBOSE_TRACKER -ge 1 ]; then
  	VERBOSE=$VERBOSE_TRACKER
  fi
fi

# Check ifconfig gvspi, RX packets count. If not updating then GVSPI hung. Trigget Watchdog 
while [ true ]; do
	sleep 1
	rx_cnt_1=0
	rx_cnt_2=0

	# Get RX packets count
	rx_cnt_1=$(ifconfig gvspi | grep "RX packets:" | cut -d: -f2 | awk '{ print $1 }')
	sleep 3
	# Get RX packets count after 1 sec
	rx_cnt_2=$(ifconfig gvspi | grep "RX packets:" | cut -d: -f2 | awk '{ print $1 }')
	
	#echo $rx_cnt_1
	#echo $rx_cnt_2

	# If No RX packets, then increment reset counter.
	if [ "$rx_cnt_1" != "$rx_cnt_2" ] 
	then
		# Reset this counter in case when any of GVSPI RX packet.
		gvspi_rx=0
	else
	        #echo $gvspi_rx
                echo -e "SPI Communication Failed!!!"
                ((gvspi_rx+=1))
	fi

	# If GVSPI no RX packets hits MAX_SPI_NO_RES_CNT, trigger watchdog
	if [ "$gvspi_rx" -gt "$MAX_SPI_NO_RES_CN" ]
	then
		echo -e "Wathcdog Reset"
		echo -e "SPI Hang Issue!!! Watchdog Trigger" >> /opt/greenvity/llp/HostSW.log
		date >> /opt/greenvity/llp/HostSW.log
		sleep 1
		echo "Watchdog reset" > /dev/watchdog; CNT=0; while true; do sleep 1; CNT=$((CNT+1)); done
		reboot
		break;
	fi	
done

