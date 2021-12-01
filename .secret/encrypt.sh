#!/bin/sh

gpg --symmetric --cipher-algo AES256 .secret/AppStoreCertificate.p12
gpg --symmetric --cipher-algo AES256 .secret/AppStoreConnectAPIKey.json
