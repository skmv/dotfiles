#!/bin/sh

function test_vpn() {
    if [[ ! -f /usr/local/var/run/openconnect.pid ]]; then
        echo "No VPN"
        return
    fi

    if ps -p $(cat /usr/local/var/run/openconnect.pid); then
        echo "VPN"
        return
    else
        echo "No VPN"
    fi
}

test_vpn
