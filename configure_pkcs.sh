#!/usr/bin/env bash
# Add pkcs11 configuration to openssl.cnf
sed  -i '1i openssl_conf = openssl_init' /etc/ssl/openssl.cnf
cat /etc/aws-kms-pkcs11/openssl-pkcs11.conf >> /etc/ssl/openssl.cnf
# Generate x509 certificate from AWS KMS Token
sed -i "s/MY_KMS_ID/$AWS_KMS_TOKEN/g" /etc/aws-kms-pkcs11/config.json
openssl req -config /etc/aws-kms-pkcs11/x509.genkey -x509 -key "pkcs11:model=0;manufacturer=aws_kms;serial=0;token=$AWS_KMS_TOKEN" -keyform engine -engine pkcs11 -out /etc/aws-kms-pkcs11/mycert.pem -days 36500
