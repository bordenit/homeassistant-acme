#!/usr/bin/with-contenv bashio
GD_KEY=$(bashio::config 'acme_api_key')
CF_Zone_ID=$(bashio::config 'acme_cf_zone_id')
CF_Token=$(bashio::config 'acme_cf_cf_token')
GD_SECRET=$(bashio::config 'acme_api_secret')
DNSAPI=$(bashio::config 'acme_dnsapi')
EMAIL=$(bashio::config 'acme_email')
DOMAIN=$(bashio::config 'acme_domain')
ISSUER=$(bashio::config 'acme_issuer')

#If using GoDaddy
export GD_Key="${GD_KEY}"
export GD_Secret="${GD_SECRET}"

#If using Cloudfare
export CF_Token="${CF_Token}"
export CF_Zone_ID="${CF_Zone_ID}"

#Certificate directory
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
