#!/usr/bin/env bash

set -x

VALID="365"
KEY_SIZE="4096"
CA_KEY="ca.key"
CA_CERT="ca.cert"

CLIENT_KEY="client.key"
CLIENT_CSR="client.csr"
CLIENT_CERT="client.cert"
CLIENT_P12="client.p12"

# new self-signed CA
openssl req -newkey "rsa:$KEY_SIZE" \
    -new -nodes -x509 \
    -days "$VALID" \
    -out "$CA_CERT" \
    -keyout "$CA_KEY" \
    -subj "/C=TW/ST=Taiwan/L=FOO/O=FOO/OU=FOO/CN=localhost"

# new client key and certificate signing request
openssl req -newkey "rsa:$KEY_SIZE" \
    -new -nodes -keyout "$CLIENT_KEY" \
    -subj "/C=TW/ST=Taiwan/L=FOO/O=Foo/OU=Foo/CN=localhost" \
    -out "$CLIENT_CSR"

# sign the client certs
openssl x509 -req -in "$CLIENT_CSR" \
    -CA $CA_CERT -CAkey $CA_KEY \
    -CAcreateserial -out $CLIENT_CERT \
    -days "$VALID" -sha256

rm "$CLIENT_CSR"

# export to p12 file
openssl pkcs12 -export \
    -inkey "$CLIENT_KEY" \
    -in "$CLIENT_CERT" \
    -out "$CLIENT_P12"

mkdir certs
mv "$CA_KEY" "$CA_CERT" ca.srl certs/
mv "$CLIENT_KEY" "$CLIENT_CERT" "$CLIENT_P12" certs/
