#!/bin/bash

openssl genrsa -out key.pem 2048

openssl req -x509 -days 365 -new -out cert.pem -key key.pem -config ssl.conf

openssl x509 -in cert.pem -out cert.der -outform DER