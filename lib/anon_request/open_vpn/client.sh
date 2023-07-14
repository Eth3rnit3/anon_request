#!/bin/bash

if [ $# -eq 0 ]; then
    echo "NO_ARGUMENT_ERROR"
    exit 1
fi

if [ ! -f $1 ]; then
    echo echo "INVALID_ARGUMENT_ERROR"
    exit 1
fi

echo $2 | sudo -S openvpn --config $1