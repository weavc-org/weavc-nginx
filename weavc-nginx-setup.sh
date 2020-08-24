#!/bin/bash

# generate ssl certs if non are pre-generated or passed in as volumes
if [ ! -f "/certs/fullchain.pem" ] || [ ! -f "/certs/privkey.pem" ]; then
    openssl req -newkey rsa:2048 -new -nodes -x509 -days 3650 -keyout /defaults/certs/privkey.pem -out /defaults/certs/fullchain.pem -subj /C=$SSL_C/ST=$SSL_ST/L=$SSL_L/O=$SSL_O/OU=$SSL_OU/CN=$SSL_CN
fi

# generate dhparam if non is provided
# helps protect requests if someone was to get ahold of the private key
# by adding another layer of encryption
if [ ! -f "/certs/dhparam.pem" ]; then
    openssl dhparam -out /defaults/certs/dhparam.pem 2048
fi

# copy defaults ro root directory if they dont exist
# allows data to persist after bind mounts
cp -r -n /defaults/* /

