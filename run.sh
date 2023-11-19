#!/usr/bin/with-contenv bashio
API_KEY=$(bashio::config 'acme_api_key')
API_SECRET=$(bashio::config 'acme_api_secret')
DNSAPI=$(bashio::config 'acme_dnsapi')
EMAIL=$(bashio::config 'acme_email')
DOMAIN=$(bashio::config 'acme_domain')
ISSUER=$(bashio::config 'acme_issuer')

export GD_Key="${API_KEY}"
export GD_Secret="${API_SECRET}"
export LE_WORKING_DIR=/ssl/acme

mkdir -p /ssl/acme

git clone "https://github.com/acmesh-official/acme.sh.git"

./acme.sh/acme.sh --install --create-account-key -m "${EMAIL}"
./acme.sh/acme.sh --set-default-ca --server "${ISSUER}"
./acme.sh/acme.sh --register-account -m "${EMAIL}"

function issue {
    local RENEW_SKIP=2
    ./acme.sh/acme.sh --key-file "/ssl/key.pem" --cert-file "/ssl/cert.pem" --issue -d ${DOMAIN} --dns ${DNSAPI} || { ret=$?; [ $ret -eq ${RENEW_SKIP} ] && return 0 || return $ret ;}
}

while true
  do
     issue
     sleep 24h
  done
