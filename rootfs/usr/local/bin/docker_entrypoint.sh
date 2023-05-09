#!/bin/bash

#=========================================================================================

# Fix user and group ownerships for '/config'
chown -R transmission:transmission /config

# First-run setup
if
    [ ! -e "/config/settings.json" ]
then
    cp /etc/transmission-daemon/settings.json /config/settings.json
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
