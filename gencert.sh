#!/bin/bash

mkdir certificates

cd certificates

SKIP_CA=false

# Parse optional switch (-s)
while getopts "s" opt; do
  case $opt in
    s) SKIP_CA=true ;;
    *) echo "Usage: $0 [-c] to reprovision the ca cert together with the server cert" && exit 1 ;;
  esac
done

echo "Starting script..."

if [ "$SKIP_CA" = false ]; then
	echo "Provisioning CA cert"
	openssl req -new -config ../conf/ca.conf -out ca.csr -extensions req_ext
	openssl x509 -req -in ca.csr -signkey ca.key -out ca.pem -days 730 -passin pass:password -extensions req_ext -extfile ../conf/ca.conf
	openssl pkcs8 -in ca.key -topk8 -nocrypt -out ca.decrypt.key -passin pass:password
fi

echo "Provisioning server cert"
openssl req -new -config ../conf/server.conf -out server.csr -extensions req_ext
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -days 730 -passin pass:password -extensions req_ext -extfile ../conf/server.conf
openssl pkcs8 -in server.key -topk8 -nocrypt -out server.decrypt.key -passin pass:password

echo "Concating server and CA cert"
cat server.pem server.key ca.pem > servercert.pem

