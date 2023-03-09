#!/bin/bash


# Organisation for CA Cert
MY_ORG="my-org"

# Server's hostname
SERVER_NAME="localhost"

# SAN Server Alternative Names
SERVER_ALT_NAME="DNS:localhost,IP:127.0.0.1,IP:192.168.200.1"

# client's name
CLIENT_NAME="clienthost"

# 100 ans
EXPIRATION_DELAY_DAYS=36500

CERTIFICATES_DIR=./certificates
CERTIFICATES_CA_DIR=$CERTIFICATES_DIR/ca
CERTIFICATES_SERVER_DIR=$CERTIFICATES_DIR/server
CERTIFICATES_CLIENT_DIR=$CERTIFICATES_DIR/client

rm -Rf CERTIFICATES_DIR
mkdir -p $CERTIFICATES_DIR
mkdir -p $CERTIFICATES_CA_DIR
mkdir -p $CERTIFICATES_SERVER_DIR
mkdir -p $CERTIFICATES_CLIENT_DIR


rm $CERTIFICATES_DIR/*

# generate CA certificate
openssl req \
  -new \
  -x509 \
  -nodes \
  -days $EXPIRATION_DELAY_DAYS \
  -subj "/CN=${MY_ORG}" \
  -keyout $CERTIFICATES_CA_DIR/ca.key \
  -out $CERTIFICATES_CA_DIR/caCrt.pem
  
# generate server key
openssl genrsa \
  -out $CERTIFICATES_SERVER_DIR/serverKey.pem 2048

# generate server.csr
openssl req \
  -new \
  -key $CERTIFICATES_SERVER_DIR/serverKey.pem \
  -subj "/CN=${SERVER_NAME}" \
  -out $CERTIFICATES_SERVER_DIR/server.csr

# generate server.crt (in PEM format)
openssl x509 \
  -req \
  -in $CERTIFICATES_SERVER_DIR/server.csr \
  -CA $CERTIFICATES_CA_DIR/caCrt.pem \
  -CAkey $CERTIFICATES_CA_DIR/ca.key \
  -extfile <(printf "subjectAltName=${SERVER_ALT_NAME}")  \
  -CAcreateserial \
  -days $EXPIRATION_DELAY_DAYS \
  -out $CERTIFICATES_SERVER_DIR/serverCrt.pem

# generate client key (in pem format)

openssl genrsa \
  -out $CERTIFICATES_CLIENT_DIR/clientKey.pem 2048

# generate a client csr file
openssl req \
  -new \
  -key $CERTIFICATES_CLIENT_DIR/clientKey.pem \
  -subj "/CN=${CLIENT_NAME}" \
  -out $CERTIFICATES_CLIENT_DIR/client.csr

# generate a client crt file (pem format)

openssl x509 \
  -req \
  -in $CERTIFICATES_CLIENT_DIR/client.csr \
  -CA $CERTIFICATES_CA_DIR/caCrt.pem \
  -CAkey $CERTIFICATES_CA_DIR/ca.key \
  -CAcreateserial \
  -days 365 \
  -out $CERTIFICATES_CLIENT_DIR/clientCrt.pem


echo "======== Check CA     PEM =========="
openssl x509 -in ./certificates/ca/caCrt.pem -text

echo "======== Check Server PEM =========="
openssl x509 -in ./certificates/server/serverCrt.pem -text

echo "======== Check Client PEM =========="
openssl x509 -in ./certificates/client/clientCrt.pem -text

echo "======== verify that Server or Client Certificate had been issued by the CA ========"
openssl verify -verbose -CAfile ./certificates/ca/caCrt.pem  ./certificates/server/serverCrt.pem
openssl verify -verbose -CAfile ./certificates/ca/caCrt.pem  ./certificates/client/clientCrt.pem