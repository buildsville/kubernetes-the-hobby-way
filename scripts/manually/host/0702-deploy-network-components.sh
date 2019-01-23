#!/bin/bash
### deploy network componets ###

cd `dirname $0`
cd ../../../deploy

kubectl apply -f calico.yaml
kubectl apply -f kube-proxy.yaml
kubectl apply -f kube-dns.yaml
kubectl apply -f hosts-adder.yaml
