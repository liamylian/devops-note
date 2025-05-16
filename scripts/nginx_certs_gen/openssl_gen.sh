#!/bin/bash

GEN_DIR=certs
CONF_FILE=openssl.cnf

mkdir $GEN_DIR

CA_CERT=${GEN_DIR}/ca-cert.pem
CA_KEY=${GEN_DIR}/ca-key.pem
SERVER_CERT=${GEN_DIR}/server-cert.pem
SERVER_KEY=${GEN_DIR}/server-key.pem
SERVER_CSR=${GEN_DIR}/server-csr.pem
CLIENT_CERT=${GEN_DIR}/client-cert.pem
CLIENT_KEY=${GEN_DIR}/client-key.pem
CLIENT_CSR=${GEN_DIR}/client-csr.pem

# 生成根证书
openssl req -x509                                            \
  -newkey rsa:4096                                           \
  -nodes                                                     \
  -days 3650                                                 \
  -keyout ${CA_KEY}                                          \
  -out ${CA_CERT}                                            \
  -subj /C=US/ST=CA/L=SVL/O=gRPC/CN=my-server_ca/    \
  -config $CONF_FILE                                         \
  -extensions config_ca                                  \
  -sha256


# 生成服务端证书
openssl genrsa -out ${SERVER_KEY} 4096
openssl req -new                                            \
  -key ${SERVER_KEY}                                        \
  -days 3650                                                \
  -out ${SERVER_CSR}                                        \
  -subj /C=US/ST=CA/L=SVL/O=gRPC/CN=my-server/      \
  -config $CONF_FILE                                        \
  -reqexts config_server
openssl x509 -req                 \
  -in $SERVER_CSR                 \
  -CAkey $CA_KEY                  \
  -CA $CA_CERT                    \
  -days 3650                      \
  -set_serial 1000                \
  -out $SERVER_CERT               \
  -extfile $CONF_FILE             \
  -extensions config_server   \
  -sha256
openssl verify -verbose -CAfile $CA_CERT  $SERVER_CERT


# 生成客户端证书
openssl genrsa -out $CLIENT_KEY 4096
openssl req -new                                           \
  -key $CLIENT_KEY                                         \
  -days 3650                                               \
  -out $CLIENT_CSR                                         \
  -subj /C=US/ST=CA/L=SVL/O=gRPC/CN=my-client/     \
  -config $CONF_FILE                                       \
  -reqexts config_client
openssl x509 -req                       \
  -in $CLIENT_CSR                       \
  -CAkey $CA_KEY                        \
  -CA $CA_CERT                          \
  -days 3650                            \
  -set_serial 1000                      \
  -out $CLIENT_CERT                     \
  -extfile $CONF_FILE                   \
  -extensions config_client         \
  -sha256
openssl verify -verbose -CAfile $CA_CERT $CLIENT_CERT

rm $GEN_DIR/*csr.pem