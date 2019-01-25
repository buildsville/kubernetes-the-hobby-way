#!/bin/bash
### generate kubeconfig for extra ###

KUBERNETES_PUBLIC_ADDRESS=10.240.0.40

# for node-hosts-converter
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
  --kubeconfig=node-hosts-converter.kubeconfig

kubectl config set-credentials node-hosts-converter \
  --client-certificate=node-hosts-converter.pem \
  --client-key=node-hosts-converter-key.pem \
  --embed-certs=true \
  --kubeconfig=node-hosts-converter.kubeconfig

kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=node-hosts-converter \
  --kubeconfig=node-hosts-converter.kubeconfig

kubectl config use-context default --kubeconfig=node-hosts-converter.kubeconfig
