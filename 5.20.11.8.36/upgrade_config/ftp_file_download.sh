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
 
# Echo the input parameters to script got in connect response
echo "0- $0" 
echo "1- $1" 
echo "2- $2"
echo "3- $3"
echo "4- $4"
echo "5- $5"

#Check the FTP connection for the input parameters
echo -e "${LGREEN} Starting FTP Session...${RESET}"
wget -s ftp://$3:$4@$2/$5 
if [ $? != 0 ] 	
then
	echo -e "${LMAGENTA} File does not exist ${RESET}"
else
	echo -e "${LGREEN} File exist...${RESET}"
fi

#Fetch the executables and copy locally on board
echo -e "${LGREEN} Fetch the executables and copy locally on board...${RESET}"
wget -cP /opt/config/upgrade_config ftp://$3:$4@$2/$5
wget -cP /opt/config/upgrade_config $1
if [ $? != 0 ] 	
then
	echo -e "${LMAGENTA} Failed to download ${RESET}"
else
	echo -e "${LGREEN} File Download Complete...${RESET}"
fi
