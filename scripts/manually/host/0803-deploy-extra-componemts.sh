#!/bin/bash
### deploy network componets ###

cd `dirname $0`
cd ../../../deploy

kubectl apply -f metrics-server.yaml
kubectl apply -f tiller.yaml
