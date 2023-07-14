#!/bin/bash

if [ $# -lt 2 ]; then
    echo "ARGUMENT_ERROR: Two arguments required: 1) OpenVPN Config File 2) Sudo Password"
    exit 1
fi

if [ ! -f $1 ]; then
    echo "NO_CONFIG_FILE_ERROR: OpenVPN config file does not exist or is not a file"
    exit 1
fi

echo $2 | sudo -S openvpn --config $1
