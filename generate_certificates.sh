#!/bin/bash

# cf https://codeburst.io/mutual-tls-authentication-mtls-de-mystified-11fa2a52e9cf

MY_ORG="my-org"
SERVER_NAME="localhost"
CLIENT_NAME="clienthost"

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
  -days 365 \
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
  -CAcreateserial \
  -days 365 \
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
