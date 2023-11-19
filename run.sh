#!/usr/bin/with-contenv bashio
API_KEY=$(bashio::config 'acme_api_key')
API_SECRET=$(bashio::config 'acme_api_secret')
DNSAPI=$(bashio::config 'acme_dnsapi')
EMAIL=$(bashio::config 'acme_email')
DOMAIN=$(bashio::config 'acme_domain')

apk add openssl
apk add socat
apk add git
apk add curl
apk add wget

while true
  do
    export GD_Key="${API_KEY}"
    export GD_Secret="${API_SECRET}"
    rm -rf acme.sh
    rm -rf /root/.acme.sh
    git clone "https://github.com/acmesh-official/acme.sh.git"
    cd acme.sh
    ./acme.sh --install --create-account-key -m "${EMAIL}"
    ./acme.sh --set-default-ca --server zerossl
    ./acme.sh --register-account -m "${EMAIL}"
    ./acme.sh --key-file "/ssl/key.pem" --cert-file "/ssl/cert.pem" --issue --dns "${DNSAPI}" -d "${DOMAIN}" --debug
     sleep 30d
  done
