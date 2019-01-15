#!/bin/bash
### create necessary directories and install binaries ###

wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubelet

sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kube-proxy \
  /var/lib/kubernetes \
  /var/run/kubernetes

chmod +x kubelet
sudo mv kubelet /usr/local/bin/
sudo mv kube-proxy.kubeconfig /var/lib/kube-proxy/kubeconfig
