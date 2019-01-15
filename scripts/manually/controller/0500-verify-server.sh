#!/bin/bash
### verify apiserver on each nodes ###

kubectl get componentstatuses --kubeconfig admin.kubeconfig
