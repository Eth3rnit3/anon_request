#!/bin/bash

if [[ $# -lt 1 || $# -gt 4 ]]; then
    echo "ARGUMENT_ERROR: Invalid number of arguments"
    echo "Usage: $0 <OpenVPN Config File> [Sudo Password] [--auth-user-pass <Credentials File>]"
    exit 1
fi

config_file=$1
sudo_password=$2
credentials_arg=$3
credentials_file=$4

if [ ! -f "$config_file" ]; then
    echo "NO_CONFIG_FILE_ERROR: OpenVPN config file does not exist or is not a file"
    exit 1
fi

command="openvpn --config $config_file"

if [[ $credentials_arg == "--auth-user-pass" && -n $credentials_file ]]; then
    if [ ! -f "$credentials_file" ]; then
        echo "NO_CREDENTIALS_FILE_ERROR: Credentials file does not exist or is not a file"
        exit 1
    fi
    command="$command --auth-user-pass $credentials_file"
fi

if [[ -n $sudo_password ]]; then
    echo "$sudo_password" | sudo -S $command
else
    $command
fi
