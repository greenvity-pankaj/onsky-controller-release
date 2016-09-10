interface="ABC"
line=0
it_flag=0

if [ ! -f /home/user/monkey/htdocs/settings.txt ]
then
	echo -e "${LRED} Missing Interface settings in Monkey Server ${RESET}"
        ifconfig eth0 up 10.0.0.253 netmask 255.255.255.0
        ifconfig eth0
        echo -e "${LGREEN} Starting Monkey Server ${RESET}"
        cd /home/user
        ./monkeyserver_setup.sh &
         sleep 20
        ./run_monkeyserver.sh &

else
        if_flag=0
        while read line
        do
	#echo $line
        interface=$(echo "$line" | grep "type," |cut -d, -f2 | awk '{ print $1 }')
	#echo $interface
        if [ "Ethernet" == "$interface" ]
        then
            echo "Ethernet Interface"
            ifconfig eth0 up 10.0.0.253 netmask 255.255.255.0
	    ifconfig eth0 up
	    echo "Stopping Monkey Server"
	    pkill -f monkey
	    it_flag=1
            /opt/greenvity/llp/run_eth.sh &
	    break
        fi

	if [ "Wi-Fi" == "$interface" ]
        then
            echo "Wifi Interface"
	    ifconfig eth0 10.0.0.253 netmask 255.255.255.0
            ifconfig eth0 up
	    echo "Stopping Monkey Server"
	    pkill -f monkey
	    if_flag=1
	    /opt/greenvity/llp/run_wifi.sh &
	    break
        fi
        done < /home/user/monkey/htdocs/settings.txt

	
        echo "if_flag" 
        echo $if_flag	

	if [ "$if_flag" == 0 ]; then
		ifconfig eth0 up 10.0.0.253 netmask 255.255.255.0
		ifconfig eth0
		echo -e "${LGREEN} Starting Monkey Server ${RESET}"
		cd /home/user
                ./monkeyserver_setup.sh &	
	        sleep 30	
		./run_monkeyserver.sh &	
	fi    
fi
