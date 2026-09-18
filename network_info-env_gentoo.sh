####
# Configuration spécifique à l'environnement "Gentoo"

# OK avec les valeurs par défaut :
declare -r ENV_HTTP_IPV4_CLIENT=${ENV_DEFAULT_HTTP_IPV4_CLIENT_COMMAND}
declare -r ENV_HTTP_IPV6_CLIENT=${ENV_DEFAULT_HTTP_IPV6_CLIENT_COMMAND}
declare -r ENV_PUBLIC_IP_PROVIDER_URL=${ENV_DEFAULT_PUBLIC_IP_PROVIDER_URL}

declare -r ENV_ETH_LAN_INTERFACE=${ENV_DEFAULT_ETH_LAN_INTERFACE}


# Spécifique à Gentoo :
declare -r ENV_WIFI_LAN_INTERFACE='wifi0'

declare -r ENV_WIFI_SSID_RETRIEVAL_COMMAND="iw dev ${ENV_WIFI_LAN_INTERFACE} link | awk -F': ' '/SSID/ {print $2}'"


declare -r ENV_ECHO_COMMAND='echo'
