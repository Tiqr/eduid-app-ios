#!/bin/sh

# Decrypt the files
# --batch to prevent interactive command --yes to assume "yes" for questions

gpg --quiet --batch --yes --decrypt --passphrase="$CERTIFICATE_PASSWORD" --output .secret/AppStoreCertificate.p12 .secret/AppStoreCertificate.p12.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$CERTIFICATE_PASSWORD" --output .secret/AppStoreConnectAPIKey.json .secret/AppStoreConnectAPIKey.json.gpg
