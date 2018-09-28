#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo 'pass fqdn'
    exit 0
fi

mkdir $1 && cd $1

echo "Create private key"
openssl genrsa -out $1.key 2048

echo "Create a CSR"
openssl req -new -key $1.key -out $1.csr

cat << 'END_OF_FILE' > $1.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = \$1
END_OF_FILE

openssl x509 -req -in $1.csr -CA /root/root_CA/myCA.pem -CAkey /root/root_CA/myCA.key -CAcreateserial \
-out $1.crt -days 1825 -sha256 -extfile $1.ext
