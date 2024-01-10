#!/usr/bin/env bash
# Generate x509 certificate from AWS KMS Token
sed "s/MY_KMS_ID/$AWS_KMS_TOKEN/g" /etc/aws-kms-pkcs11/config.json
openssl req -config x509.genkey -x509 -key "pkcs11:model=0;manufacturer=aws_kms;serial=0;token=$AWS_KMS_TOKEN" -keyform engine -engine pkcs11 -out /etc/aws-kms-pkcs11/mycert.pem -days 36500
