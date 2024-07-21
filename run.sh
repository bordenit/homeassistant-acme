#!/usr/bin/with-contenv bashio
GD_KEY=$(bashio::config 'acme_gd_key')
CF_ZONE_ID=$(bashio::config 'acme_cf_zone_id')
CF_TOKEN=$(bashio::config 'acme_cf_token')
GD_SECRET=$(bashio::config 'acme_gd_secret')
DNS_PROVIDER=$(bashio::config 'acme_dns_provider')
EMAIL=$(bashio::config 'acme_email')
DOMAIN=$(bashio::config 'acme_domain')
ISSUER=$(bashio::config 'acme_issuer')

#If using GoDaddy. Use dns_gd DNS_PROVIDER
export GD_Key="${GD_KEY}"
export GD_Secret="${GD_SECRET}"

#If using Cloudfare
export CF_Token="${CF_TOKEN}"
export CF_Zone_ID="${CF_ZONE_ID}"
export MAX_RETRY_TIMES=90

#Certificate directory
export LE_WORKING_DIR=/ssl/acme
mkdir -p /ssl/acme

git clone "https://github.com/acmesh-official/acme.sh.git"

./acme.sh/acme.sh --install --create-account-key -m "${EMAIL}"
./acme.sh/acme.sh --set-default-ca --server "${ISSUER}"
./acme.sh/acme.sh --register-account -m "${EMAIL}"

function issue {
    local RENEW_SKIP=2
    ./acme.sh/acme.sh --key-file "/ssl/key.pem" --cert-file "/ssl/cert.pem" --full-chain "/ssl/certchain.pem" --issue -d ${DOMAIN} --dns ${DNS_PROVIDER} || { ret=$?; [ $ret -eq ${RENEW_SKIP} ] && return 0 || return $ret ;}
}

while true
  do
     issue
     sleep 24h
  done
  
