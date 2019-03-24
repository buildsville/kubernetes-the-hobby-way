#!/bin/bash
### create necessary directories and install binaries ###

sudo apt-get update
sudo apt-get -y install socat conntrack ipset

wget -q --show-progress --https-only --timestamping \
  https://storage.googleapis.com/kubernetes-release/release/v1.13.2/bin/linux/amd64/kubelet \
  https://github.com/kubernetes-incubator/cri-tools/releases/download/v1.13.0/crictl-v1.13.0-linux-amd64.tar.gz \
  https://storage.googleapis.com/kubernetes-the-hard-way/runsc \
  https://github.com/opencontainers/runc/releases/download/v1.0.0-rc6/runc.amd64 \
  https://github.com/containerd/containerd/releases/download/v1.2.2/containerd-1.2.2.linux-amd64.tar.gz \

sudo mkdir -p \
  /etc/cni/net.d \
  /opt/cni/bin \
  /var/lib/kubelet \
  /var/lib/kubernetes \
  /var/run/kubernetes \
  /etc/containerd

chmod +x kubelet runc.amd64 runsc
sudo mv runc.amd64 runc
sudo mv kubelet runc runsc /usr/local/bin/
sudo tar -xvf crictl-v1.13.0-linux-amd64.tar.gz -C /usr/local/bin/
sudo tar -xvf containerd-1.2.2.linux-amd64.tar.gz -C /
