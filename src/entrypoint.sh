#!/bin/sh

set -e

# Domain #
if [ -z $DOMAIN ] ; then
  DOMAIN=localhost
fi

echo "Domain: $DOMAIN"
echo "TenantId: $AzureAd__TenantId"
echo "ClientId: $AzureAd__ClientId"

# Certificate Location #
CERT_PATH=/app/https

# Create self signed certificate (if it doesn't already exist) #
if [ ! -e $CERT_PATH/cert.pem ] ; then
  echo "Creating self signed certificate ($DOMAIN) in location ($CERT_PATH)..."
  openssl req -x509 -newkey rsa:4096 -sha256 -days 3650 -nodes \
    -out "$CERT_PATH/cert.pem" \
    -keyout "$CERT_PATH/key.pem" \
    -subj "/CN=$DOMAIN" \
    -addext "subjectAltName=DNS:$DOMAIN"
fi

cd ./bin
./Avalier.Test3