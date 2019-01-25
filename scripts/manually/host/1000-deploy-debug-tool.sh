#!/bin/bash
### deploy any pods for verify network ###

cd `dirname $0`
cd ../../../deploy

kubectl apply -f nginx.yaml
kubectl apply -f netshoot.yaml
