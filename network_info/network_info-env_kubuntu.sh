####
# Configuration spécifique à l'environnement "KUbuntu":

# OK avec les valeurs par défaut :
declare -r ENV_HTTP_IPV4_CLIENT=${ENV_DEFAULT_HTTP_IPV4_CLIENT_COMMAND}
declare -r ENV_HTTP_IPV6_CLIENT=${ENV_DEFAULT_HTTP_IPV6_CLIENT_COMMAND}
declare -r ENV_PUBLIC_IP_PROVIDER_URL=${ENV_DEFAULT_PUBLIC_IP_PROVIDER_URL}

declare -r ENV_ETH_LAN_INTERFACE=${ENV_DEFAULT_ETH_LAN_INTERFACE}

declare -i ENV_KDIALOG_TIMEOUT=${ENV_DEFAULT_KDIALOG_TIMEOUT}


# Spécifique à KUbuntu :
declare -r ENV_WIFI_LAN_INTERFACE='wlp0s20f3'

declare -r ENV_WIFI_SSID_RETRIEVAL_COMMAND='iwgetid -r'
#TODO: find a way to indicate the concerned interface from 'ENV_WIFI_LAN_INTERFACE' variable...

declare -r ENV_ECHO_COMMAND='echo -e'
