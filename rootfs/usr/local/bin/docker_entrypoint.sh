#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R transmission:transmission /config

# First-run setup
if
    [ ! -e "/config/settings.json" ]
then
    cat <<'EOF' > /config/settings.json
    {
    "bind-address-ipv4": "0.0.0.0",
    "bind-address-ipv6": "::",
    "blocklist-enabled": false,
    "download-dir": "/downloads/complete",
    "incomplete-dir": "/downloads/incomplete",
    "incomplete-dir-enabled": true,
    "message-level": 2,
    "pidfile": "/config/transmission.pid",
    "rename-partial-files": true,
    "rpc-authentication-required": false,
    "rpc-bind-address": "0.0.0.0",
    "rpc-enabled": true,
    "rpc-host-whitelist": "",
    "rpc-host-whitelist-enabled": true,
    "rpc-port": 9091,
    "rpc-whitelist": "127.0.0.1,::1",
    "rpc-whitelist-enabled": true,
    "watch-dir-enabled": false
    }
    EOF
fi

# Delete pre-existing PID
if
    [ -e "/config/transmission.pid" ]
then
    rm -f /config/transmission.pid
fi

# Override location of curl SSL certificates
export CURL_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

#=========================================================================================

# Start transmission in console mode
exec gosu transmission \
    /usr/bin/transmission-daemon \
    --config-dir /config \
    --pid-file /config/transmission.pid \
    --no-watch-dir \
    --incomplete-dir /downloads/incomplete \
    --download-dir /downloads/complete \
    --foreground
