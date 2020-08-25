#!/bin/bash

# set default key size
if [[ -z "$KEY_SIZE" ]]; then
    KEY_SIZE="2048"
fi
    
# generate ssl certs if non are pre-generated or passed in as volumes
if [[ ! -v "$SSL_GENERATE" ]] && [ "$SSL_GENERATE" == "yes" ]; then
    openssl req -newkey rsa:$KEY_SIZE -new -nodes -x509 -days 3650 -keyout /defaults/certs/privkey.pem -out /defaults/certs/fullchain.pem -subj /C=$SSL_C/ST=$SSL_ST/L=$SSL_L/O=$SSL_O/OU=$SSL_OU/CN=$SSL_CN
fi

# generate dhparam if non is provided
# helps protect requests if someone was to get ahold of the private key
# by adding another layer of encryption
if [[ ! -v "$DH_GENERATE" ]] && [ "$DH_GENERATE" == "yes" ]; then
    openssl dhparam -out /defaults/certs/dhparam.pem $KEY_SIZE
fi

# copy defaults ro root directory if they dont exist
# allows data to persist after bind mounts
cp -r -n /defaults/* /