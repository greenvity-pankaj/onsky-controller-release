#!/bin/bash

#Text Colors - Accent type
BOLD='\033[1m'
DBOLD='\033[2m'
NBOLD='\033[22m'
UNDERLINE='\033[4m'
NUNDERLINE='\033[4m'
BLINK='\033[5m'
NBLINK='\033[5m'
INVERSE='\033[7m'
NINVERSE='\033[7m'
BREAK='\033[m'
NORMAL='\033[0m'

#Text Colors
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
GRAY='\033[0;37m'

#Text Colors - Brighter versions
DGRAY='\033[1;30m'
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LMAGENTA='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'

#Text Colors - Background colors
BGBLACK='\033[40m'
BGRED='\033[41m'
BGGREEN='\033[42m'
BGBROWN='\033[43m'
BGBLUE='\033[44m'
BGMAGENTA='\033[45m'
BGCYAN='\033[46m'
BGGRAY='\033[47m'
BGDEF='\033[49m'

#Text Colors - Reset to default
RESET='\033[0;0;39m'
LLP_DAEMON_PID=0
GVMESH_PID=0
LLP_HTTP_PID=0
MQTT_SSL_PID=0
TRACKER_PID=0

echo -e "${LGREEN} Starting run_eth.sh...${RESET}"

echo -e "${LGREEN} Setting up ETH0...${RESET}"
ifconfig eth0 down
while read line
do
ifconfig eth0 hw ether $line
done < /opt/config/gv_ethernet_macaddr_config.txt
ifconfig eth0 up
ifconfig eth0
#ifconfig eth0 down

echo -e "${LGREEN} Starting Monkey Server ${RESET}"
cd /home/user
./monkeyserver_setup.sh &
sleep 15
./run_monkeyserver.sh &


echo -e "${LGREEN} Starting WiFi...${RESET}"
if [ ! -f /root/wpa_supplicant.conf ]; then
	rm -f /root/wpa_supplicant.conf
	touch /root/wpa_supplicant.conf
	echo "ctrl_interface=/var/run/wpa_supplicant" >> /root/wpa_supplicant.conf
	echo "update_config=1" >> /root/wpa_supplicant.conf
	echo "" >> /root/wpa_supplicant.conf
	echo "network={" >> /root/wpa_supplicant.conf
	echo "	ssid=\"greenvity_demo\"" >> /root/wpa_supplicant.conf
	echo "	psk=\"0123456789\"" >> /root/wpa_supplicant.conf
	echo "}" >> /root/wpa_supplicant.conf
fi

#wpa_supplicant -ira0 -Dwext -c /root/wpa_supplicant.conf -B
udhcpc -i eth0 -t 5 -q
telnetd
sleep 1

echo -e "${LGREEN} Loading SPI network driver...${RESET}"
insmod /opt/greenvity/ghdd/gv701x_spi_intf.ko
sleep 1
insmod /opt/greenvity/ghdd/gv701x_spi_net.ko
sleep 1

echo -e "${LGREEN} Configure GVSPI MAC Address....${RESET}"
while read line 
do
ifconfig gvspi hw ether $line
done < /opt/config/gvspi_ethernet_macaddr_config.txt
ifconfig gvspi 10.0.1.1 netmask 255.255.0.0 up

rm -f /opt/greenvity/ghdd/ghdd_config.txt

echo -e "\n${LGREEN} Checking for GHDD Configuration file...${RESET}"
if [ ! -f /opt/greenvity/ghdd/ghdd_config.txt ] 
then
        touch /opt/greenvity/ghdd/ghdd_config.txt
	while read line
	do
	echo "macAddress = $line" >> /opt/greenvity/ghdd/ghdd_config.txt
	done < /opt/config/gvspi_ethernet_macaddr_config.txt

	echo "lineMode = DC" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "dcFreq = 50" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "txPowerMode = 255" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "erMode = enabled" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "busInterface = spi" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "deviceMode = CCO" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "netInterface = gvspi" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "psMode = PS_50" >> /opt/greenvity/ghdd/ghdd_config.txt
	echo "passwd = greenvity" >> /opt/greenvity/ghdd/ghdd_config.txt
else
        while read oldLine
	do
        while read line
        do
        grep "macAddress =" /opt/greenvity/ghdd/ghdd_config.txt
        if [ $? -ne 0 ]
        then
            echo "Missing MAC Address"
        else
	   newLine="macAddress = $line"
           sed -i "s/$oldLine/$newLine/" /opt/greenvity/ghdd/ghdd_config.txt
        fi
        done < /opt/config/gvspi_ethernet_macaddr_config.txt
        break
        done < /opt/greenvity/ghdd/ghdd_config.txt
fi

chmod 777 /opt/greenvity/ghdd/ghdd_config.txt

echo -e "${LGREEN} Loading GHDD Kernel Module...${RESET}"
insmod /opt/greenvity/ghdd/ghdd.ko

echo -e "${LGREEN} Checking for LLP Configuration file(s)...${RESET}"
if [ ! -f /opt/greenvity/llp/llp_config.txt ]; then
	rm -f llp_config.txt
	touch llp_config.txt

	echo "ethertype = 0x88e2" >> llp_config.txt
	echo "periodic_status_update_interval = 10"	>> llp_config.txt

	mv llp_config.txt /opt/greenvity/llp/llp_config.txt
fi

## if llp_NID.txt is not present, then create one.
if [ ! -f /opt/greenvity/llp/llp_NID.txt ]; then
	touch /opt/greenvity/llp/llp_NID.txt
fi

## if llp_MAC_Table.txt is not present, then create one.
if [ ! -f /opt/greenvity/llp/llp_MAC_Table.txt ]; then
	touch /opt/greenvity/llp/llp_MAC_Table.txt
fi

## if llp_dev_info.txt is not present, then create one.
if [ ! -f /opt/greenvity/llp/llp_dev_info.txt ]; then
	touch /opt/greenvity/llp/llp_dev_info.txt
fi

## if llp_Dev_Config.txt is present, then delete it and create new one.
## if it is not present, then just create one.
if [ -f /opt/greenvity/llp/llp_Dev_Config.txt ]; then
	rm /opt/greenvity/llp/llp_Dev_Config.txt
fi
/opt/greenvity/llp/llp_Dev_Config.sh 

echo -e "${LGREEN} Starting Discovery Daemon...${RESET}"
/opt/greenvity/llp/discovery.dat & > log.txt

if [ ! -f /opt/greenvity/llp/HostSW.log ]; then
	touch /opt/greenvity/llp/HostSW.log
fi

echo "=============================================" >> /opt/greenvity/llp/HostSW.log

echo -e "${LGREEN} Starting LLP Host Daemon...${RESET}"
/opt/greenvity/llp/llp_daemon.out & > llp_daemon.txt
export LLP_DAEMON_PID=$!
echo "LLP_DAEMON_PID - $LLP_DAEMON_PID" >> /opt/greenvity/llp/HostSW.log
sleep 3
echo -e "${LYELLOW} LLP daemon started (pid $LLP_DAEMON_PID) at ${RESET}"
date

echo -e "${LGREEN} Starting GVMESH Daemon ...${RESET}"
/opt/greenvity/llp/gvmesh.out & 
export GVMESH_PID=$!
echo "GVMESH_PID - $GVMESH_PID" >> /opt/greenvity/llp/HostSW.log

sleep 5
echo -e "${LYELLOW} GVMESH started (pid $GVMESH_PID) at ${RESET}"
date

echo -e "${LGREEN} Starting HTTP Interface Daemon...${RESET}"
/opt/greenvity/llp/llp_http.out &

#export LLP_HTTP_PID=$!
#echo "LLP_HTTP_PID - $LLP_HTTP_PID" >> /opt/greenvity/llp/HostSW.log
#sleep 3
#echo -e "${LYELLOW} HTTP started (pid $LLP_HTTP_PID) at ${RESET}"
date

echo -e "${LGREEN} Starting MQTT Interface Application for cloud...${RESET}"
/opt/greenvity/mqtt/mqtt_withSSL.out &  > /dev/null 2>&1 &

#export MQTT_SSL_PID=$!
#echo "MQTT_SSL_PID - $MQTT_SSL_PID" >> /opt/greenvity/llp/HostSW.log
#sleep 5
#echo -e "${LYELLOW} MQTT SSL started (pid $MQTT_SSL_PID) at ${RESET}"
#date

#sleep 3
#echo -e "${LGREEN} Starting Phillips Hue Hub Interface Application...${RESET}"
#/opt/greenvity/llp/net/phillips_hue/gv_phillipshue.out &

echo -e "${LGREEN} Starting Zigbee ...${RESET}"
/opt/greenvity/llp/net/zigbee/zll /dev/ttySP3 > /dev/null 2>&1 &
sleep 5
echo -e "${LGREEN} Starting Zigbee Application...${RESET}"
/opt/greenvity/llp/net/zigbee/zigbeeApp &

echo -e "${LGREEN} Starting TCP Server ...${RESET}"
/opt/greenvity/tcp/tcp_server.out &

# Update system time using ntpd
/opt/greenvity/llp/ntp_script.sh &

sleep 1
# start a daemon (just a shell script) that sends us SIGUSR2 if
# anybody dies
#pids="$LLP_DAEMON_PID $GVMESH_PID $LLP_HTTP_PID $MQTT_SSL_PID"
pids="$LLP_DAEMON_PID $GVMESH_PID"

# pass in our PID and a list of PIDs we care about
echo -e "${LMAGENTA} Starting Host SW tracker with our pid $0 and pid list $pids ${RESET}"
/opt/greenvity/llp/track_host.sh $$ "$pids" &
export TRACKER_PID=$!

#sleep 1

#echo -e "${LMAGENTA} Starting SPI Monitor ${RESET}"
#/opt/greenvity/ghdd/spi_monitor.sh &
 
#sleep 1

#echo -e "${LMAGENTA} Starting GVSPI Tracker ${RESET}"
#/opt/greenvity/ghdd/track_spi.sh &

# Changing the Netmask of the eth0 by checking the netmask of ra0
MASK=$(ifconfig ra0 | grep Mask | sed s/^.*Mask://)
echo $MASK
case "$MASK" in
   "255.255.255.0") 	echo "Netmask of ra0 is 255.255.255.0" 
			echo "Changing the netmask of eth0......."	
			ifconfig eth0 netmask 255.0.0.0
			echo "Now netmask of eth0 is 255.0.0.0"	
   			;;
   "255.255.0.0") 	echo "Netmask of ra0 is 255.255.0.0" 
			echo "Changing the netmask of eth0......."	
			ifconfig eth0 netmask 255.255.255.0
			echo "Now netmask of eth0 is 255.255.255.0"	
   			;;
   "255.0.0.0") 	echo "Netmask of ra0 is 255.0.0.0" 
			echo "Changing the netmask of eth0......."	
			ifconfig eth0 netmask 255.255.0.0
			echo "Now netmask of eth0 is 255.255.0.0"	
   			;;
esac