#!/usr/bin/env bash

set -x

CA="ca"
CA_CSR="$PWD/$CA-csr.json"
CA_CONFIG="$PWD/$CA-config.json"

CLIENT="client"
CLIENT_CONFIG="$PWD/$CLIENT.json"

mkdir -p cfssl-certs
pushd cfssl-certs || exit

# new self-signed CA
cfssl gencert -initca "$CA_CSR" | cfssljson -bare "$CA"
cp "$CA.pem" "$CA.cert"

# sign the client certs
cfssl gencert -ca="$CA.pem" -ca-key="$CA-key.pem" \
    -config="$CA_CONFIG" -profile=client "$CLIENT_CONFIG" |
    cfssljson -bare "$CLIENT"

# export to p12 file (empty password)
openssl pkcs12 -export \
    -inkey "$CLIENT-key.pem" \
    -in "$CLIENT.pem" \
    -password "pass:" \
    -out "$CLIENT.p12"
