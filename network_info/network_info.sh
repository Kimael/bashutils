#!/bin/bash
# 
# À appeler depuis un terminal, ou le composant Plasma "Command output".
# 
# Mandatory param $1: environment name, to load configuration from the corresponding file ('kubuntu', 'gentoo', etc.)
# Mandatory param $2: display mode ('echo' or 'kdialog')
# 
# Requires:
# - curl: to retrieve the public IP address.
# - ip: to retrieve the local IP address of the specified network interface.
# - awk: to parse the output of the `ip` command.
# - cut: to extract the IP address from the "ip | awk" output.
# - iw or ?
# 
# Use cases:
# ./network_info.sh gentoo echo 2> /dev/null
# ./network_info.sh kubuntu kdialog 2> /dev/null
# cd /home/msibelle/personnel/github/bashutils && ./network_info.sh kubuntu echo 2> /dev/null && cd - > /dev/null
# cd /home/msibelle/personnel/github/bashutils && ./network_info.sh gentoo kdialog 2> /dev/null && cd - > /dev/null

declare -r ENV_NAME=$1
declare -r DISPLAY_MODE=$2


####
# Configuration à charger :

# Valeurs par défaut : 
source 'network_info-env_default.sh'

# Configuration spécifique à l'environnement indiqué :
source 'network_info-env_'${ENV_NAME}'.sh'


####
# Configuration:

# Couleurs :
declare -r CONF_PUBLIC_COLOR_NAME='red'
declare -r CONF_PUBLIC_COLOR_CODE='\033[0;31m'
declare -r CONF_COLOR_CODE_END='\033[0m'
declare -r CONF_WIFI_LAN_COLOR_NAME='blue'
declare -r CONF_WIFI_LAN_COLOR_CODE='\033[0;34m'
declare -r CONF_ETH_LAN_COLOR_NAME=${CONF_WIFI_LAN_COLOR_NAME}
declare -r CONF_ETH_LAN_COLOR_CODE=${CONF_WIFI_LAN_COLOR_CODE}

# Affichage, divers :
declare -r CONF_FONT_SIZE='25'


####
# Récupération de votre adresse IP publique, v4 ou v6, selon votre infrastructure :
declare -r PUBLIC_IPV4=$(${ENV_HTTP_IPV4_CLIENT} -s ${ENV_PUBLIC_IP_PROVIDER_URL})
declare -r PUBLIC_IPV6=$(${ENV_HTTP_IPV6_CLIENT} -s ${ENV_PUBLIC_IP_PROVIDER_URL})

# Récupération de l'adresse IPv4 de vos interfaces LAN :
declare -r WIFI_LAN_IP=$(ip -4 addr show ${ENV_WIFI_LAN_INTERFACE} | awk '/inet / {print $2}' | cut -d/ -f1)
declare -r WIFI_LAN_SSID=$(eval "${ENV_WIFI_SSID_RETRIEVAL_COMMAND}")

declare -r  ETH_LAN_IP=$(ip -4 addr show ${ENV_ETH_LAN_INTERFACE}  | awk '/inet / {print $2}' | cut -d/ -f1)


####
# Préparation de l'affichage : 
declare -r   PUBLIC_IPV4_DISPLAY='[Public v4: '${PUBLIC_IPV4}']'
declare -r   PUBLIC_IPV6_DISPLAY='[Public v6: '${PUBLIC_IPV6}']'
declare -r WIFI_LAN_IP_DISPLAY='[WiFi "'${WIFI_LAN_SSID}'": '${WIFI_LAN_IP}']'
declare -r  ETH_LAN_IP_DISPLAY='[ETH "'${ENV_ETH_LAN_INTERFACE}'": '${ETH_LAN_IP}']'


####
# Afficher : 
case ${DISPLAY_MODE} in
  
  # ECHO !
  'echo')
      declare -r PUBLIC_IPV4_DISPLAY_COLORED=${CONF_PUBLIC_COLOR_CODE}${PUBLIC_IPV4_DISPLAY}${CONF_COLOR_CODE_END}
      declare -r PUBLIC_IPV6_DISPLAY_COLORED=${CONF_PUBLIC_COLOR_CODE}${PUBLIC_IPV6_DISPLAY}${CONF_COLOR_CODE_END}
      declare -r WIFI_LAN_IP_DISPLAY_COLORED=${CONF_WIFI_LAN_COLOR_CODE}${WIFI_LAN_IP_DISPLAY}${CONF_COLOR_CODE_END}
      declare -r ETH_LAN_IP_DISPLAY_COLORED=${CONF_ETH_LAN_COLOR_CODE}${ETH_LAN_IP_DISPLAY}${CONF_COLOR_CODE_END}

      ${ENV_ECHO_COMMAND} "${PUBLIC_IPV4_DISPLAY_COLORED}"
      ${ENV_ECHO_COMMAND} "${PUBLIC_IPV6_DISPLAY_COLORED}"
      ${ENV_ECHO_COMMAND} "${WIFI_LAN_IP_DISPLAY_COLORED}"
      ${ENV_ECHO_COMMAND} "${ETH_LAN_IP_DISPLAY_COLORED}"
    ;;

  # Ouvrir une popup dans KDE :
  'kdialog')
      declare MSGBOX_CONTENT="<font size='${CONF_FONT_SIZE}' color='${CONF_PUBLIC_COLOR_NAME}'><b> ${PUBLIC_IPV4_DISPLAY}</b></font>"
      MSGBOX_CONTENT=${MSGBOX_CONTENT}'<br />'
      MSGBOX_CONTENT=${MSGBOX_CONTENT}"<font size='${CONF_FONT_SIZE}' color='${CONF_PUBLIC_COLOR_NAME}'><b> ${PUBLIC_IPV6_DISPLAY}</b></font>"
      MSGBOX_CONTENT=${MSGBOX_CONTENT}'<br />'
      MSGBOX_CONTENT=${MSGBOX_CONTENT}"<font size='${CONF_FONT_SIZE}' color='${CONF_WIFI_LAN_COLOR_NAME}'><b>&nbsp;${WIFI_LAN_IP_DISPLAY}</b></font>"
      MSGBOX_CONTENT=${MSGBOX_CONTENT}'<br />'
      MSGBOX_CONTENT=${MSGBOX_CONTENT}"<font size='${CONF_FONT_SIZE}' color='${CONF_ETH_LAN_COLOR_NAME}'><b>&nbsp;${ETH_LAN_IP_DISPLAY}</b></font>"

      # 1. Lancer kdialog en arrière-plan et récupérer son PID pour le tuer plus tard après N secondes :
      kdialog --title "Network information (for ${ENV_KDIALOG_TIMEOUT} seconds)" --msgbox "${MSGBOX_CONTENT}" &
      declare -i KDIALOG_PID=$!
      # 2. Programmer la fermeture au bout de 5 secondes :
      (sleep ${ENV_KDIALOG_TIMEOUT} && kill "${KDIALOG_PID}" 2>/dev/null) &
    ;;
  
  # De base, rien.
  *)
      ${ENV_ECHO_COMMAND} 'Hmm?!'
    ;;
esac
