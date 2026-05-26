#!/bin/bash

mkdir certs

cd certs

#openssl req -new -config ../conf/ca.conf -out ca.csr -extensions req_ext
#openssl x509 -req -in ca.csr -signkey ca.key -out ca.pem -days 730 -passin pass:password -extensions req_ext -extfile ../conf/ca.conf

openssl req -new -config ../conf/server.conf -out server.csr -extensions req_ext
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.pem -days 730 -passin pass:password -extensions req_ext -extfile ../conf/server.conf

openssl pkcs8 -in server.key -topk8 -nocrypt -out server.decrypt.key -passin pass:password
#openssl pkcs8 -in ca.key -topk8 -nocrypt -out ca.decrypt.key -passin pass:password

cat server.pem server.key ca.pem > servercert.pem
