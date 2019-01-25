#!/bin/bash
### set RBAC for kubelet ###

cd `dirname $0`
cd ../../../deploy

kubectl apply -f kubelet-auth.yaml
