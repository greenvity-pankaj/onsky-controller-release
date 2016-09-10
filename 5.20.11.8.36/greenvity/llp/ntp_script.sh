#Text Colors - Brighter versions
LRED='\033[1;31m'
LGREEN='\033[1;32m'
LYELLOW='\033[1;33m'
LBLUE='\033[1;34m'
LMAGENTA='\033[1;35m'
LCYAN='\033[1;36m'
WHITE='\033[1;37m'

#Text Colors - Reset to default
RESET='\033[0;0;39m'

ntpd -q
echo -e "${LCYAN} Updating system time...${RESET}"
date
