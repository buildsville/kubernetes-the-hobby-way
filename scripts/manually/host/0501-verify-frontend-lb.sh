#!/bin/bash
### verify apiserver via load balancer ###

KUBERNETES_PUBLIC_ADDRESS=10.240.0.40

curl --cacert ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version
