#!/bin/bash

# Needs to be run as root
# This script will add an entry to the hosts file

if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# POS_ARGS=()
ADD=FALSE
REMOVE=FALSE
HELP=TRUE

while [[ $# -gt 0 ]]; do
    case "$1" in
    -h|--h)
        HELP=TRUE
        shift
        ;;
    -a|--add)
        ADD=TRUE
        HELP=FALSE
        shift
        ;;
    -r|--remove)
        REMOVE=TRUE
        HELP=FALSE
        shift
        ;;
    -* | --*)
        echo "Error: Unknown option: $1" >&2
        exit 1
        ;;
    # *)
    #     POS_ARGS+=("$1")
    #     shift
    #     ;;
    esac
done
# set -- "${POS_ARGS[@]}"

# Option -r to remove an entry from the hosts file by given IP address or hostname
if [ REMOVE == TRUE ]; then
    echo "Enter the IP address or hostname of the host you want to remove from the hosts file:"
    read ip
    sed -i "/$ip/d" /etc/hosts
    echo "The following entry has been removed from the hosts file:"
    echo "$ip"
    exit 0
fi

# Option -a to add an entry to the hosts file
if [ $ADD == TRUE ]; then
    echo "Enter the IP address of the host you want to add to the hosts file:"
    read ip
    echo "Enter the hostname of the host you want to add to the hosts file:"
    read hostname
    echo "$ip $hostname" >> /etc/hosts
    echo "The following entry has been added to the hosts file:"
    echo "$ip $hostname"
    exit 0
fi



# Option -h to display help
if [ $HELP == TRUE ]; then
    echo "Usage: addhost.sh [OPTION]..."
    echo "Add or remove an entry to the hosts file"
    echo ""
    echo "Options:"
    echo "-a, --add           Add an entry to the hosts file"
    echo "-r, --remove        Remove an entry from the hosts file"
    echo "-h, --help          Display this help and exit"
    exit 0
fi
