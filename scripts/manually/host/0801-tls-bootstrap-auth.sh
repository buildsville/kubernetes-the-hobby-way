#!/bin/bash
### set auth for TLS bootstrapping ###

TOKEN_ID=`cat token-id.txt`
TOKEN_SECRET=`cat token-secret.txt`

cd `dirname $0`
cd ../../../deploy

if [ `uname` = "Darwin" ]; then
  sed -i "" -e "s/bootstrap-token-.\{6\}$/bootstrap-token-${TOKEN_ID}/g" ./tls-bootstrap-auth.yaml
  sed -i "" -e "s/token-id: \".\{6\}\"$/token-id: \"${TOKEN_ID}\"/g" ./tls-bootstrap-auth.yaml
  sed -i "" -e "s/token-secret: \".\{16\}\"$/token-secret: \"${TOKEN_SECRET}\"/g" ./tls-bootstrap-auth.yaml
else
  sed -i -e "s/bootstrap-token-.\{6\}$/bootstrap-token-${TOKEN_ID}/g" ./tls-bootstrap-auth.yaml
  sed -i -e "s/token-id: \".\{6\}\"$/token-id: \"${TOKEN_ID}\"/g" ./tls-bootstrap-auth.yaml
  sed -i -e "s/token-secret: \".\{16\}\"$/token-secret: \"${TOKEN_SECRET}\"/g" ./tls-bootstrap-auth.yaml
fi

kubectl apply -f tls-bootstrap-auth.yaml
kubectl apply -f kapprove.yaml
