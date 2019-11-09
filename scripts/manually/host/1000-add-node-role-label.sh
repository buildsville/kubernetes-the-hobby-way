#!/bin/bash
### add node label on kubectl (for `kubectl get nodes`) ###
### see also https://github.com/kubernetes/kubernetes/issues/75457 ###

kubectl label nodes controller-{0,1,2} node-role.kubernetes.io/master=
kubectl label nodes worker-{0,1,2} node-role.kubernetes.io/worker=
